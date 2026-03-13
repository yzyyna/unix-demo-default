// 引用 uts 基础库
import DCloudUTSFoundation
// 引用原生系统库
import Foundation
import Network

// Data安全下标扩展
extension Data {
    subscript(safe index: Int) -> UInt8? {
        return indices.contains(index) ? self[index] : nil
    }
}
/// 原生 Swift 语言实现封装类
public class FPSSModbusTcpNative {
    // MARK: - Modbus TCP属性
    static private var connection: NWConnection?
    static private let modbusQueue = DispatchQueue(label: "com.fpss.modbus.tcp")
    static private var isConnected = false
    static private var transactionId = 1
    // 记录上一次的任务id
    static private var lastTaskId = -1

    // MARK: - Modbus TCP通讯方法

    static func myApiNa() {
        console.log("swift:my api")
    }
    /**
     * 连接Modbus TCP服务器
     * - Parameters:
     *   - host: 服务器IP地址
     *   - port: 服务器端口号
     *   - completion: 连接结果回调
     */
    static func connectToModbusServer(
        host: String, port: UInt16, completion: @escaping (Bool, Error?) -> Void
    ) {
        let hostEndpoint = NWEndpoint.Host(host)
        let portEndpoint = NWEndpoint.Port(rawValue: port)!
        let connection = NWConnection(host: hostEndpoint, port: portEndpoint, using: .tcp)

        self.connection = connection

        // 设置连接超时
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            if !FPSSModbusTcpNative.isConnected {
                connection.cancel()
                completion(
                    false,
                    NSError(
                        domain: "ModbusTCP",
                        code: -6,
                        userInfo: [NSLocalizedDescriptionKey: "连接超时"]
                    ))
            }
        }

        connection.stateUpdateHandler = {
            state in
            switch state {
            case .ready:
                FPSSModbusTcpNative.isConnected = true
                completion(true, nil)
            case .failed(let error):
                FPSSModbusTcpNative.isConnected = false
                completion(false, error)
            case .cancelled:
                FPSSModbusTcpNative.isConnected = false
                completion(
                    false,
                    NSError(
                        domain: "ModbusTCP", code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "连接已取消"]))
            default:
                break
            }
        }

        connection.start(queue: modbusQueue)
    }

    /**
     * 读取保持寄存器
     * - Parameters:
     *   - startAddress: 起始地址
     *   - count: 寄存器数量
     *   - completion: 读取结果回调
     */
    static func readHoldingRegisters(
        startAddress: UInt16, count: UInt16, completion: @escaping ([UInt16]?, String?) -> Void
    ) {
        var isCompleted = false
        func safeCompletion(_ registers: [UInt16]?, _ error: String?) {
            guard !isCompleted else { return }
            isCompleted = true
            completion(registers, error)
        }
        // 验证寄存器数量是否在有效范围内 (1-125个寄存器)
        guard count > 0 && count <= 125 else {
            DispatchQueue.main.async {
                safeCompletion(
                    nil,
                    "[请求参数错误] 寄存器数量必须在1-125之间，当前请求：\(count)个")
            }
            return
        }
        // 验证起始地址是否合法 (0-65535)
        guard startAddress <= 0xFFFF else {
            DispatchQueue.main.async {
                safeCompletion(
                    nil,
                    "[请求参数错误] 起始地址必须在0-65535之间，当前请求：\(startAddress)")
            }
            return
        }
        modbusQueue.async {
            guard Self.isConnected, let connection = Self.connection else {
                DispatchQueue.main.async {
                    safeCompletion(
                        nil,
                        "[连接阶段] 未建立连接，请先调用connectToModbusServer建立连接")
                }
                return
            }

            // 添加请求超时处理
            let timeoutTask = DispatchWorkItem {
                DispatchQueue.main.async {
                    safeCompletion(
                        nil,
                        "[超时阶段] 读取保持寄存器超时(10秒)")
                }
            }
            Self.modbusQueue.asyncAfter(deadline: .now() + 10, execute: timeoutTask)

            // 构建Modbus TCP请求 (功能码0x03 读取保持寄存器)
            let requestData = Self.createReadHoldingRegistersRequest(
                startAddress: startAddress, count: count)

            // 发送请求
            connection.send(
                content: requestData,
                completion: .contentProcessed({ error in
                    if let error = error {
                        DispatchQueue.main.async {
                            safeCompletion(
                                nil,
                                "[发送阶段] 发送保持寄存器读取请求失败: \(error.localizedDescription)")
                        }
                        return
                    }

                    // 接收响应
                    Self.receiveModbusResponse(connection: connection) { responseData, error in
                        timeoutTask.cancel()
                        if let error = error {
                            DispatchQueue.main.async {
                                safeCompletion(
                                    nil,
                                    "[接收阶段] 接收保持寄存器响应失败: \(error.localizedDescription)")
                            }
                            return
                        }

                        // 解析响应
                        guard let responseData = responseData else {
                            DispatchQueue.main.async {
                                safeCompletion(
                                    nil,
                                    "[解析阶段] 无效响应数据: 响应数据为空")
                            }
                            return
                        }

                        let (registers, parseError) = Self.parseHoldingRegistersResponse(
                            data: responseData)
                        guard let registers = registers, parseError == nil else {
                            DispatchQueue.main.async {
                                safeCompletion(
                                    nil,
                                    "[解析阶段] 解析保持寄存器数据失败: \(parseError ?? "未知错误")")
                            }
                            return
                        }

                        DispatchQueue.main.async {
                            safeCompletion(registers, nil)
                        }
                    }
                }))
        }
    }

    /**
     * 写入保持寄存器
     * - Parameters:
     *   - startAddress: 起始地址 (0-65535)
     *   - values: 要写入的16位寄存器值数组 (1-123个元素)
     *   - completion: 写入结果回调
     */
    static func writeHoldingRegisters(
        startAddress: UInt16, values: [UInt16], completion: @escaping (Bool, String?) -> Void
    ) {
        var isCompleted = false
        func safeCompletion(_ success: Bool, _ error: String?) {
            guard !isCompleted else { return }
            isCompleted = true
            completion(success, error)
        }

        // 参数验证
        guard !values.isEmpty, values.count <= 123 else {
            DispatchQueue.main.async {
                safeCompletion(false, "[请求参数错误] 写入寄存器数量必须在1-123之间，当前请求：\(values.count)个")
            }
            return
        }

        guard startAddress <= 0xFFFF else {
            DispatchQueue.main.async {
                safeCompletion(false, "[请求参数错误] 起始地址必须在0-65535之��，当前请求：\(startAddress)")
            }
            return
        }

        modbusQueue.async {
            guard Self.isConnected, let connection = Self.connection else {
                DispatchQueue.main.async {
                    safeCompletion(false, "[连接阶段] 未建立连接，请先调用connectToModbusServer建立连接")
                }
                return
            }

            // 添加请求超时处理
            let timeoutTask = DispatchWorkItem {
                DispatchQueue.main.async {
                    safeCompletion(false, "[超时阶段] 写入保持寄存器超时(10秒)")
                }
            }
            Self.modbusQueue.asyncAfter(deadline: .now() + 10, execute: timeoutTask)

            // 构建Modbus TCP请求 (功能码0x10 写入多个保持寄存器)
            guard
                let requestData = Self.createWriteHoldingRegistersRequest(
                    startAddress: startAddress, values: values
                )
            else {
                DispatchQueue.main.async {
                    safeCompletion(false, "[请求构建] 无法构建写入请求数据")
                }
                return
            }

            // 发送请求
            connection.send(
                content: requestData,
                completion: .contentProcessed({ error in
                    if let error = error {
                        DispatchQueue.main.async {
                            safeCompletion(
                                false, "[发送阶段] 发送保持寄存器写入请求失败: \(error.localizedDescription)")
                        }
                        return
                    }

                    // 接收响应
                    Self.receiveModbusResponse(connection: connection) { responseData, error in
                        timeoutTask.cancel()
                        if let error = error {
                            DispatchQueue.main.async {
                                safeCompletion(
                                    false, "[接收阶段] 接收保持寄存器写入响应失败: \(error.localizedDescription)")
                            }
                            return
                        }

                        // 解析响应
                        guard let responseData = responseData else {
                            DispatchQueue.main.async {
                                safeCompletion(false, "[解析阶段] 无效响应数据: 响应数据为空")
                            }
                            return
                        }

                        let (success, parseError) = Self.parseWriteHoldingRegistersResponse(
                            data: responseData, expectedStartAddress: startAddress,
                            expectedCount: UInt16(values.count)
                        )
                        DispatchQueue.main.async {
                            if success {
                                safeCompletion(true, nil)
                            } else {
                                safeCompletion(
                                    false, "[解析阶段] 解析保持寄存器写入响应失败: \(parseError ?? "未知错误")")
                            }
                        }
                    }
                }))
        }
    }

    /**
     * 断开Modbus TCP连接
     */
    static func disconnectModbusServer() {
        connection?.cancel()
        isConnected = false
        connection = nil
    }

    // MARK: - Modbus协议工具方法
    private static func createWriteHoldingRegistersRequest(startAddress: UInt16, values: [UInt16])
        -> Data?
    {
        var data = Data()

        // MBAP头部 (7字节)
        var currentTransactionId = UInt16(FPSSModbusTcpNative.transactionId).bigEndian
        data.append(Data(bytes: &currentTransactionId, count: 2))  // 事务标识符
        var protocolIdentifier = UInt16(0).bigEndian
        data.append(Data(bytes: &protocolIdentifier, count: 2))  // 协议标识符 (0表示ModbusTCP)
        let byteCount = UInt16(values.count * 2)
        let pduLength = UInt16(5 + byteCount)  // 功能码(1) + 起始地址(2) + 数量(2) + 字节计数(1) + 数据(n*2)
        var length = pduLength.bigEndian
        data.append(Data(bytes: &length, count: 2))
        data.append(UInt8(1))  // 单元标识符

        // PDU (协议数据单元)
        data.append(UInt8(0x10))  // 功能码: 写入多个保持寄存器
        let startAddressData = withUnsafeBytes(of: startAddress.bigEndian) {
            (body: UnsafeRawBufferPointer) -> Data in Data(body)
        }
        data.append(startAddressData)  // 起始地址
        let countData = withUnsafeBytes(of: UInt16(values.count).bigEndian) {
            (body: UnsafeRawBufferPointer) -> Data in Data(body)
        }
        data.append(countData)  // 寄存器数量
        data.append(UInt8(byteCount))  // 字节计数

        // 写入数据
        for value in values {
            let valueData = withUnsafeBytes(of: value.bigEndian) {
                (body: UnsafeRawBufferPointer) -> Data in Data(body)
            }
            data.append(valueData)
        }

        // 更新事务ID
        FPSSModbusTcpNative.transactionId += 1
        if FPSSModbusTcpNative.transactionId > 65535 {
            FPSSModbusTcpNative.transactionId = 1
        }

        return data
    }

    private static func createReadHoldingRegistersRequest(startAddress: UInt16, count: UInt16)
        -> Data
    {
        var data = Data()

        // MBAP头部 (7字节)
        var currentTransactionId = UInt16(FPSSModbusTcpNative.transactionId).bigEndian
        data.append(Data(bytes: &currentTransactionId, count: 2))  // 事务标识符
        var protocolIdentifier = UInt16(0).bigEndian
        data.append(Data(bytes: &protocolIdentifier, count: 2))  // 协议标识符 (0表示ModbusTCP)
        var length = UInt16(6).bigEndian  // 后续字节长度
        data.append(Data(bytes: &length, count: 2))
        data.append(UInt8(1))  // 单元标识符

        // PDU (协议数据单元)
        data.append(UInt8(0x03))  // 功能码: 读取保持寄存器
        let startAddressData = withUnsafeBytes(of: startAddress.bigEndian) {
            (body: UnsafeRawBufferPointer) -> Data in Data(body)
        }
        data.append(startAddressData)  // 起始地址
        let countData = withUnsafeBytes(of: count.bigEndian) {
            (body: UnsafeRawBufferPointer) -> Data in Data(body)
        }
        data.append(countData)  // 寄存器数量

        // 更新事务ID
        FPSSModbusTcpNative.transactionId += 1
        if FPSSModbusTcpNative.transactionId > 65535 {
            FPSSModbusTcpNative.transactionId = 1
        }

        return data
    }

    private static func receiveModbusResponse(
        connection: NWConnection, completion: @escaping (Data?, Error?) -> Void
    ) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 1024) {
            data, _, isComplete, error in
            if let error = error {
                completion(nil, error)
                return
            }

            if let data = data, !data.isEmpty {
                completion(data, nil)
            } else if isComplete {
                completion(
                    nil,
                    NSError(
                        domain: "ModbusTCP", code: -4,
                        userInfo: [NSLocalizedDescriptionKey: "连接已关闭"]))
            } else {
                completion(
                    nil,
                    NSError(
                        domain: "ModbusTCP", code: -5,
                        userInfo: [NSLocalizedDescriptionKey: "未接收到数据"]))
            }
        }
    }

    private static func parseWriteHoldingRegistersResponse(
        data: Data, expectedStartAddress: UInt16, expectedCount: UInt16
    ) -> (success: Bool, error: String?) {
        // MBAP头部7字节，PDU至少6字���������：功能码(1) + 起始地址(2) + 数量(2) + CRC(2)
        guard data.count >= 13 else { return (false, "响应数据长度不��������(至少13字节)") }
        let pduData = data.suffix(from: 7)
        guard pduData.count >= 6 else { return (false, "PDU数据长度不足(至少6字节)") }

        let functionCode = pduData.first ?? 0
        guard functionCode == 0x10 else {
            if functionCode == 0x90 {
                let exceptionCode = Int(pduData[1])
                let hexData = pduData.map { String(format: "%02X", $0) }.joined(separator: ",")
                return (
                    false,
                    "从机返回错误响应: 功能码0x\(String(format: "%02X", functionCode)), 异常码\(exceptionCode)\nPDU数据: [\(hexData)]"
                )
            }
            return (
                false,
                "功能码不匹配(期望0x10, 实际0x\(String(format: "%02X", functionCode)))\nPDU数据: [\(pduData.map { String(format: "%02X", $0) }.joined(separator: ":"))]"
            )
        }

        // 解析起始地址
        let responseStartAddressData = pduData.subdata(in: 1..<3)
        let responseStartAddress = responseStartAddressData.withUnsafeBytes {
            (body: UnsafeRawBufferPointer) -> UInt16 in
            return UInt16(bigEndian: body.load(as: UInt16.self))
        }
        guard responseStartAddress == expectedStartAddress else {
            return (
                false,
                "起始地址不匹配(期望0x\(String(format: "%04X", expectedStartAddress)), 实际0x\(String(format: "%04X", responseStartAddress)))"
            )
        }

        // 解析写入数量
        let responseCountData = pduData.subdata(in: 3..<5)
        let responseCount = responseCountData.withUnsafeBytes {
            (body: UnsafeRawBufferPointer) -> UInt16 in
            return UInt16(bigEndian: body.load(as: UInt16.self))
        }
        guard responseCount == expectedCount else {
            return (false, "写入数量不匹配(期望\(expectedCount)个, 实际\(responseCount)个)")
        }

        return (true, nil)
    }

    private static func parseHoldingRegistersResponse(data: Data) -> (
        registers: [UInt16]?, error: String?
    ) {

        MBAP头部7字节，PDU至少2字节：功能码 + 字节计数
        guard data.count >= 9 else { return (nil, "响应数据长度不足(至少9字节)") }
        let pduData = data.suffix(from: 7)
        guard pduData.count >= 2 else { return (nil, "PDU数据长度不足(至少2字节)") }
        console.log("pdu data", pduData)
        let functionCode = pduData.first ?? 0
        guard functionCode == 0x03 else {
            if functionCode == 0x83 {
                let exceptionCode = Int(pduData[1])
                return (
                    nil,
                    "从机返回错误响应: 功能码0x\(String(format: "%02X", functionCode)), 异常码\(exceptionCode)"
                )
            }
            return (nil, "功能码不匹配(期望0x03, 实际0x\(String(format: "%02X", functionCode)))")
        }
        // 功能码是下标7，byteCount应该是下标8
        let byteCount = Int(pduData[safe: 8] ?? 0)
        // 确保byteCount是偶数
        guard byteCount % 2 == 0 else {
            return (nil, "byteCount必须为偶数，当前值: \(byteCount)")
        }
        let startIndex = pduData.startIndex
        var registers = [UInt16]()
        // 计算可以解析的寄存器数量
        let registerCount = byteCount / 2
        // 从pduData的第3个字节开始解析（索引为startIndex + 2）
        // 因为下标7是功能码，下标8是byteCount
        let dataStartIndex = startIndex + 2
        /// S
        ///   在 Swift 中，Data.endIndex 是 Data 类型的一个属性，表示数据集合的结束索引。
        ///   它指向集合中最后一个元素之后的位置，而非最后一个元素本身。
        ///   理解 endIndex 的正确含义和用法对于安全地操作 Data 至关重要。
        /// E
        for i in 0..<registerCount {
            // 计算当前寄存器的起始索引
            let startIndex = dataStartIndex + i * 2
            let endIndex = startIndex + 1

            // 检查索引是否在有效范围内
            guard endIndex <= pduData.endIndex else {
                return (nil, "寄存器数据索引越界(i=\(i), start=\(startIndex), end=\(endIndex))")
            }

            // 安全地获取两个字节
            guard let byte1 = pduData[safe: startIndex], let byte2 = pduData[safe: endIndex] else {
                return (nil, "无法获取寄存器\(i)的字节数据")
            }

            // 组合两个字节为16位无符号整数（大端序）
            let registerValue = UInt16(byte1) << 8 | UInt16(byte2)
            registers.append(registerValue)
        }
        return (registers, nil)
    }

}

// 引用 uts 基础库
import DCloudUTSFoundation
// 引用原生系统库
import Foundation
import Network

/// 原生 Swift 语言实现封装类
// public class FPSSModbusTcpNative {
//     static func connectToModbusServer() {
//     }
//     static func myApi() {
//     }
// }
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
        startAddress: UInt16, count: UInt16, completion: @escaping ([UInt16]?, Error?) -> Void
    ) {
        guard isConnected, let connection = connection else {
            completion(
                nil,
                NSError(
                    domain: "ModbusTCP", code: -2, userInfo: [NSLocalizedDescriptionKey: "未建立连接"]))
            return
        }

        // 构建Modbus TCP请求 (功能码0x03 读取保持寄存器)
        let requestData = createReadHoldingRegistersRequest(
            startAddress: startAddress, count: count)

        // 发送请求
        connection.send(
            content: requestData,
            completion: .contentProcessed({
                error in
                if let error = error {
                    completion(nil, error)
                    return
                }

                // 接收响应
                self.receiveModbusResponse(connection: connection) { responseData, error in
                    if let error = error {
                        completion(nil, error)
                        return
                    }

                    // 解析响应
                    if let responseData = responseData {
                        let registers = self.parseHoldingRegistersResponse(data: responseData)
                        completion(registers, nil)
                    } else {
                        completion(
                            nil,
                            NSError(
                                domain: "ModbusTCP", code: -3,
                                userInfo: [NSLocalizedDescriptionKey: "无效响应数据"]))
                    }
                }
            }))
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
        let startAddressData = withUnsafeBytes(of: startAddress.bigEndian) { Data($0) }
        data.append(startAddressData)  // 起始地址
        let countData = withUnsafeBytes(of: count.bigEndian) { Data($0) }
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

    private static func parseHoldingRegistersResponse(data: Data) -> [UInt16]? {
        // 检查数据长度是否有效 (至少包含MBAP头部+功能码+字节计数)
        guard data.count >= 9 else {
            return nil
        }

        // 解析MBAP头部后的数据
        let pduData = data.suffix(from: 7)

        // 检查功能码和错误状态
        guard pduData[0] == 0x03 else {
            return nil
        }

        // 获取字节计数
        let byteCount = Int(pduData[1])
        guard byteCount % 2 == 0 else {
            return nil
        }

        // 解析寄存器值
        var registers = [UInt16]()
        for i in 0..<byteCount / 2 {
            let startIndex = 2 + i * 2
            let endIndex = startIndex + 2
            guard endIndex <= pduData.count else {
                break
            }
            let registerBytes = pduData.subdata(in: startIndex..<endIndex)
            let registerValue = UInt16(
                bigEndian: registerBytes.withUnsafeBytes { $0.load(as: UInt16.self) })
            registers.append(registerValue)
        }

        return registers
    }

}

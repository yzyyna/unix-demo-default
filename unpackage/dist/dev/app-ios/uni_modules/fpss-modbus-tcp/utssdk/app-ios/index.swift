import DCloudUTSFoundation
import DCloudUniappRuntime
import Swift
public typealias connectType = () -> Void
public var connect: connectType = {
() -> Void in
FPSSModbusTcpNative.connectToModbusServer(host: "192.168.150.224", port: 502, completion: {
(_ Bool: Bool, _ UTSError: Any) -> Void in
console.log(Bool ? "链接成功" : "连接失败", " at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:11")
if (Bool) {
    var startA: UInt16 = 0x00
    var countA: UInt16 = 5
    console.log("""
开始读取起始地址:\(startA)寄存器数量:\(countA)
""", " at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:15")
    FPSSModbusTcpNative.readHoldingRegisters(startAddress: startA, count: countA, completion: {
    (_ UInt161: Any, _ UTSError: Any) -> Void in
    console.log("读取结束", " at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:17")
    console.log(UInt161, JSON.stringify(UTSError), " at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:18")
    disConnect()
    })
} else {
    console.log(UTSError, " at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:23")
}
})
}
public var disConnect: connectType = {
() -> Void in
console.log("断开连接", " at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:29")
FPSSModbusTcpNative.disconnectModbusServer()
}
public var myApi: connectType = {
() -> Void in
console.log("%c ✨ myApi??? ✨ ", "color:#0ff;", " at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:33")
FPSSModbusTcpNative.myApiNa()
}
public func connectByJs() -> Void {
    return connect()
}
public func disConnectByJs() -> Void {
    return disConnect()
}
public func myApiByJs() -> Void {
    return myApi()
}
@objc(UTSSDKModulesFpssModbusTcpIndexSwift)
@objcMembers
public class UTSSDKModulesFpssModbusTcpIndexSwift : NSObject {
    public static func s_connectByJs() -> Void {
        return connectByJs()
    }
    public static func s_disConnectByJs() -> Void {
        return disConnectByJs()
    }
    public static func s_myApiByJs() -> Void {
        return myApiByJs()
    }
}

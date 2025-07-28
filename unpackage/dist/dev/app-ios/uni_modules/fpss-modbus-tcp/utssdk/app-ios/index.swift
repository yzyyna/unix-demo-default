import DCloudUTSFoundation
import DCloudUniappRuntime
public typealias connectType = () -> Void
public var connect: connectType = {
() -> Void in
FPSSModbusTcpNative.connectToModbusServer(host: "192.168.150.224", port: 502, completion: {
(_ Bool: Bool, _ UTSError: Any) -> Void in
console.log(Bool ? "链接成功" : "连接失败", " at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:10")
if (Bool) {
    console.log("开始读取", " at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:12")
    FPSSModbusTcpNative.readHoldingRegisters(startAddress: 0, count: 5, completion: {
    (_ UInt16: Any, _ UTSError: Any) -> Void in
    console.log("读取结束", " at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:14")
    console.log(UInt16, JSON.stringify(UTSError), " at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:15")
    disConnect()
    })
} else {
    console.log(UTSError, " at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:20")
}
})
}
public var disConnect: connectType = {
() -> Void in
console.log("断开连接", " at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:26")
FPSSModbusTcpNative.disconnectModbusServer()
}
public var myApi: connectType = {
() -> Void in
console.log("%c ✨ myApi??? ✨ ", "color:#0ff;", " at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:30")
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

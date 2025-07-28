import DCloudUTSFoundation
import DCloudUniappRuntime
public typealias connectType = () -> Void
public var connect: connectType = {
() -> Void in
FPSSModbusTcpNative.connectToModbusServer(host: "192.168.130.30", port: 502, completion: {
(_ Bool: Bool, _ UTSError: Any) -> Void in
console.log(Bool, UTSError)
console.log(Bool ? "链接成功" : "连接失败")
if (Bool) {
    FPSSModbusTcpNative.readHoldingRegisters(startAddress: 0, count: 5, completion: {
    (_ UInt16: Any, _ UTSError: Any) -> Void in
    console.log("读取结束")
    console.log(UInt16, UTSError)
    })
}
})
}
public var disConnect: connectType = {
() -> Void in
FPSSModbusTcpNative.disconnectModbusServer()
}
public var myApi: connectType = {
() -> Void in
console.log("%c ✨ myApi??? ✨ ", "color:#0ff;")
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

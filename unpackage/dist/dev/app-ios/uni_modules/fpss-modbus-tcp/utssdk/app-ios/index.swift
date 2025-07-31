import DCloudUTSFoundation
import DCloudUniappRuntime
import Swift
public typealias connectType = () -> Void
public typealias WriteRegisterCallback = (_ success: Bool, _ error: String?) -> Void
public typealias WriteRegisterType = (_ startAddress: NSNumber, _ values: [NSNumber], _ callback: @escaping WriteRegisterCallback) -> Void
public var connect: connectType = {
() -> Void in
FPSSModbusTcpNative.connectToModbusServer(host: "192.168.150.224", port: 502, completion: {
(_ Bool: Bool, _ UTSError: Any) -> Void in
console.log("uts:连接成功", " at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:11")
if (Bool) {
    var startA: UInt16 = 0x00
    var countA: UInt16 = 20
    FPSSModbusTcpNative.readHoldingRegisters(startAddress: startA, count: countA, completion: {
    (_ registers: Any, _ UTSError: Any) -> Void in
    console.log("uts:读取成功", registers, UTSError, " at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:17")
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
FPSSModbusTcpNative.myApiNa()
}
public var writeHoldingRegisters: WriteRegisterType = {
(_ _startAddress: NSNumber, _ _values: [NSNumber], _ callback:@escaping WriteRegisterCallback) -> Void in
var startAddr: UInt16 = 0x00
var regValues = [
    0xFF,
    0x10,
    0x11
] as! [UInt16]
FPSSModbusTcpNative.writeHoldingRegisters(startAddress: startAddr, values: regValues, completion: {
(_ success: Bool, _ error: String?) -> Void in
callback(success, error)
})
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
public func writeHoldingRegistersByJs(_ startAddress: NSNumber, _ values: [NSNumber], _ callback: UTSCallback) -> Void {
    return writeHoldingRegisters(startAddress, values, {
    (success: Bool, error: String?) -> Void in
    callback(success, error)
    })
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
    public static func s_writeHoldingRegistersByJs(_ startAddress: NSNumber, _ values: [NSNumber], _ callback: UTSCallback) -> Void {
        return writeHoldingRegistersByJs(startAddress, values, callback)
    }
}

import DCloudUTSFoundation
import DCloudUniappRuntime
public typealias GetMemoryInfo = () -> Array<NSNumber>
public typealias OnMemoryInfoChange = (_ callback: @escaping (_ res: Array<NSNumber>) -> Void) -> Void
public typealias OffMemoryInfoChange = () -> Void
public var getMemoryInfo: GetMemoryInfo = {
() -> Array<NSNumber> in
console.log("get mmmmmmmmmm.....", " at uni_modules/uni-MemoryInfo/utssdk/app-ios/index.uts:8")
var numberArray = MemoryInfoNative.getMemInfoSwift().map({
(_ value: Int, _ index: NSNumber) -> NSNumber in
return NSNumber.from(value)
})
return numberArray
}
public var onMemoryInfoChange: OnMemoryInfoChange = {
(_ callback:@escaping (_ res: Array<NSNumber>) -> Void) -> Void in
MemoryInfoNative.onMemoryInfoChangeSwift({
(_ res: Array<Int>) -> Void in
var numberArray = res.map({
(_ value: Int, _ index: NSNumber) -> NSNumber in
return NSNumber.from(value)
})
callback(numberArray)
})
}
public var offMemoryInfoChange: OffMemoryInfoChange = {
() -> Void in
MemoryInfoNative.offMemoryInfoChangeSwift()
}
public func getMemoryInfoByJs() -> Array<NSNumber> {
    return getMemoryInfo()
}
public func onMemoryInfoChangeByJs(_ callback: UTSCallback) -> Void {
    return onMemoryInfoChange({
    (res: Array<NSNumber>) -> Void in
    callback(res)
    })
}
public func offMemoryInfoChangeByJs() -> Void {
    return offMemoryInfoChange()
}
@objc(UTSSDKModulesUniMemoryInfoIndexSwift)
@objcMembers
public class UTSSDKModulesUniMemoryInfoIndexSwift : NSObject {
    public static func s_getMemoryInfoByJs() -> Array<NSNumber> {
        return getMemoryInfoByJs()
    }
    public static func s_onMemoryInfoChangeByJs(_ callback: UTSCallback) -> Void {
        return onMemoryInfoChangeByJs(callback)
    }
    public static func s_offMemoryInfoChangeByJs() -> Void {
        return offMemoryInfoChangeByJs()
    }
}

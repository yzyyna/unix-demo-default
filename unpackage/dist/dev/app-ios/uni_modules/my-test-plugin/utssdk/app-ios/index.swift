import DCloudUTSFoundation
import DCloudUniappRuntime
import Network
@objc(UTSSDKModulesMyTestPluginModbusTCPClient)
@objcMembers
public class ModbusTCPClient : NSObject, IUTSSourceMap {
    private var host: String
    private var port: NSNumber
    public func __$getOriginalPosition() -> UTSSourceMapPosition? {
        return UTSSourceMapPosition("ModbusTCPClient", "uni_modules/my-test-plugin/utssdk/app-ios/index.uts", 4, 14)
    }
    private var connection: NWConnection
    private var isConnected: Bool = false
    public init(_ host: String, _ port: NSNumber){
        self.host = host
        self.port = port
        var endpoint = NWEndpoint.Host(self.host)
        var portEndpoint = NWEndpoint.Port(self.port)
        self.connection = NWConnection(endpoint, port, portEndpoint, using, tcp)
        self.connection.stateUpdateHandler = {
        (_ newState: NWConnectionState) -> Void in
        if (newState == "ready") {
            self.isConnected = true
            console.log("Connected to Modbus TCP server", " at uni_modules/my-test-plugin/utssdk/app-ios/index.uts:17")
        } else if (newState == "failed") {
            self.isConnected = false
            console.log("Connection failed", " at uni_modules/my-test-plugin/utssdk/app-ios/index.uts:20")
        }
        }
    }
    public func connect() {
        self.connection.start(DispatchQueue.global())
    }
    public func readHoldingRegisters(_ address: NSNumber, _ count: NSNumber, _ callback:@escaping (_ data: [NSNumber]?, _ error: String?) -> Void) {
        if (!self.isConnected) {
            callback(nil, "Not connected")
            return
        }
        var transactionId = Math.floor(Math.random() * 65535)
        var request = [
            (transactionId >> 8) & 0xFF,
            transactionId & 0xFF,
            0,
            0,
            0,
            6,
            1,
            3,
            (address >> 8) & 0xFF,
            address & 0xFF,
            (count >> 8) & 0xFF,
            count & 0xFF
        ]
        self.connection.send(request, completion, contentProcessed({
        (error) -> Void in
        if (error) {
            callback(nil, error.localizedDescription)
        } else {
            self.connection.receive(1, maximumLength, 65536, completion, {
            (data: Uint8Array, _, _, receiveError) -> Void in
            if (receiveError) {
                callback(nil, receiveError.localizedDescription)
            } else if (data && data.length > 9 && data[7] == 3) {
                var byteCount = data[8]
                var values: [NSNumber] = []
                do {
                    var i: NSNumber = 0
                    while(i < byteCount / 2){
                        values.push((data[9 + i * 2] << 8) | data[9 + i * 2 + 1])
                        i++
                    }
                }
                callback(values, nil)
            } else {
                callback(nil, "Invalid response")
            }
            })
        }
        }))
    }
    public func writeRegister(_ address: NSNumber, _ value: NSNumber, _ callback:@escaping (_ success: Bool, _ error: String?) -> Void) {
        if (!self.isConnected) {
            callback(false, "Not connected")
            return
        }
        var transactionId = Math.floor(Math.random() * 65535)
        var request = [
            (transactionId >> 8) & 0xFF,
            transactionId & 0xFF,
            0,
            0,
            0,
            6,
            1,
            6,
            (address >> 8) & 0xFF,
            address & 0xFF,
            (value >> 8) & 0xFF,
            value & 0xFF
        ]
        self.connection.send(request, completion, contentProcessed({
        (error) -> Void in
        if (error) {
            callback(false, error.localizedDescription)
        } else {
            self.connection.receive(1, maximumLength, 12, completion, {
            (data: Uint8Array, _, _, receiveError) -> Void in
            if (receiveError) {
                callback(false, receiveError.localizedDescription)
            } else if (data && data.length == 12 && data[7] == 6) {
                callback(true, nil)
            } else {
                callback(false, "Invalid response")
            }
            })
        }
        }))
    }
}
@objc(UTSSDKModulesMyTestPluginModbusTCPClientByJs)
@objcMembers
public class ModbusTCPClientByJs : ModbusTCPClient {
    public func connectByJs() {
        return self.connect()
    }
    public func readHoldingRegistersByJs(_ address: NSNumber, _ count: NSNumber, _ callback: UTSCallback) {
        return self.readHoldingRegisters(address, count, {
        (data: [NSNumber]?, error: String?) -> Void in
        callback(data, error)
        })
    }
    public func writeRegisterByJs(_ address: NSNumber, _ value: NSNumber, _ callback: UTSCallback) {
        return self.writeRegister(address, value, {
        (success: Bool, error: String?) -> Void in
        callback(success, error)
        })
    }
}

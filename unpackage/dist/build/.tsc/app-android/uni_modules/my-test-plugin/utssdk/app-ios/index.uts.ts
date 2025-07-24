// import { UTSModule } from 'uts';
import { NWConnection, NWEndpoint, NWConnectionState, DispatchQueue } from "Network";

// @UTSModule
export class ModbusTCPClient {
    private connection: NWConnection;
    private isConnected: boolean = false;

    constructor(private host: string, private port: number) {
        const endpoint = NWEndpoint.Host(this.host);
        const portEndpoint = NWEndpoint.Port(this.port);
        this.connection = NWConnection(endpoint, port: portEndpoint, using: .tcp);
        
        this.connection.stateUpdateHandler = (newState: NWConnectionState) => {
            if (newState == 'ready') {
                this.isConnected = true;
                console.log("Connected to Modbus TCP server");
            } else if (newState == 'failed') {
                this.isConnected = false;
                console.log("Connection failed");
            }
        };
    }

    connect() {
        this.connection.start(DispatchQueue.global());
    }

    readHoldingRegisters(address: number, count: number, callback: (data: number[] | null, error: string | null) => void) {
        if (!this.isConnected) {
            callback(null, "Not connected");
            return;
        }
        const transactionId = Math.floor(Math.random() * 65535);
        const request = [
            (transactionId >> 8) & 0xFF, transactionId & 0xFF,
            0, 0, // Protocol ID
            0, 6, // Length
            1, // Unit ID
            3, // Function Code
            (address >> 8) & 0xFF, address & 0xFF,
            (count >> 8) & 0xFF, count & 0xFF
        ];
        this.connection.send(request, completion: .contentProcessed((error) => {
            if (error) callback(null, error.localizedDescription);
            else this.connection.receive(1, maximumLength: 65536, completion: (data: Uint8Array, _, _, receiveError) => {
                if (receiveError) callback(null, receiveError.localizedDescription);
                else if (data && data.length > 9 && data[7] == 3) {
                    const byteCount = data[8];
                    const values: number[] = [];
                    for (let i = 0; i < byteCount / 2; i++) {
                        values.push((data[9 + i * 2] << 8) | data[9 + i * 2 + 1]);
                    }
                    callback(values, null);
                } else callback(null, "Invalid response");
            });
        }));
    }

    writeRegister(address: number, value: number, callback: (success: boolean, error: string | null) => void) {
        if (!this.isConnected) {
            callback(false, "Not connected");
            return;
        }
        const transactionId = Math.floor(Math.random() * 65535);
        const request = [
            (transactionId >> 8) & 0xFF, transactionId & 0xFF,
            0, 0, // Protocol ID
            0, 6, // Length
            1, // Unit ID
            6, // Function Code
            (address >> 8) & 0xFF, address & 0xFF,
            (value >> 8) & 0xFF, value & 0xFF
        ];
        this.connection.send(request, completion: .contentProcessed((error) => {
            if (error) callback(false, error.localizedDescription);
            else this.connection.receive(1, maximumLength: 12, completion: (data: Uint8Array, _, _, receiveError) => {
                if (receiveError) callback(false, receiveError.localizedDescription);
                else if (data && data.length == 12 && data[7] == 6) {
                    callback(true, null);
                } else callback(false, "Invalid response");
            });
        }));
    }
}
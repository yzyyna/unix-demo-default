import { connectType, connectType2, WriteRegisterType, WriteRegisterCallback } from '../interface.uts'
import { UInt16 } from 'Swift';



// FPSSModbusTcpNative.connectToModbusServer(host = '192.168.130.30', port = 502,
// FPSSModbusTcpNative.connectToModbusServer(host = '192.168.150.224', port = 502,
export const connect : connectType = function () {
	FPSSModbusTcpNative.connectToModbusServer(host = '192.168.150.224', port = 502,
		completion = (Bool : Boolean, Error : any) => {
			__f__('log','at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:11',Bool ? '链接成功' : '连接失败');
			if (Bool) {
				const startA : UInt16 = 0x00
				const countA : UInt16 = 5
				__f__('log','at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:15',`开始读取起始地址:${startA}寄存器数量:${countA}`);
				FPSSModbusTcpNative.readHoldingRegisters(startAddress = startA, count = countA, completion = (registers : any, Error : any) => {
					__f__('log','at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:17','读取结束');
					__f__('log','at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:18',registers, JSON.stringify(Error));
					// 断开连接
					disConnect()
				})
			} else {
				__f__('log','at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:23',Error);
			}
		})
}
// 直接导出disConnect函数，移除中间变量disConnect0
export const disConnect : connectType = function () {
	__f__('log','at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:29','断开连接');
	FPSSModbusTcpNative.disconnectModbusServer()
}
export const myApi : connectType = function () {
	__f__('log','at uni_modules/fpss-modbus-tcp/utssdk/app-ios/index.uts:33',"%c ✨ myApi??? ✨ ", "color:#0ff;");
	FPSSModbusTcpNative.myApiNa()
}

// 写入寄存器功能实现
export const writeHoldingRegisters : WriteRegisterType = function (
	_startAddress : number,
	_values : number[],
	callback : WriteRegisterCallback
) {
	// 将JavaScript的number类型转换为Swift的UInt16类型
	const startAddr : UInt16 = 0x00
	const regValues : UInt16[] = [0xFF, 0x10, 0x11]

	// 调用原生Swift方法执行写入操作
	FPSSModbusTcpNative.writeHoldingRegisters(
		startAddress = startAddr,
		values = regValues,
		completion = (success : Boolean, error : string | null) => {
			callback(success, error)
		}
	)
}
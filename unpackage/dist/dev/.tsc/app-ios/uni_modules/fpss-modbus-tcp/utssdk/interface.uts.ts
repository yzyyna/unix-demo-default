// 声明 uts 插件的 API 类型  


/**
 * 声明连接Modbus服务器API类型
 * connect
 */
export type connectType = () => void
export type connectType2 = (cb : (flag : Boolean) => void) => void

// 写入寄存器回调类型
export type WriteRegisterCallback = (success: boolean, error: string | null) => void

// 写入寄存器函数类型
export type WriteRegisterType = (startAddress: number, values: number[], callback: WriteRegisterCallback) => void
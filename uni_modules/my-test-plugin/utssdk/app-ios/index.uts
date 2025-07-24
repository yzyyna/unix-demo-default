import { GetMemoryInfo, OnMemoryInfoChange, OffMemoryInfoChange } from '../interface.uts'


/**
 * 获取内存信息
 */
export const getMemoryInfo : GetMemoryInfo = function () : Array<number> {
  // 将原生 swift 语言的 Int 数组转换成 uts 语言中的 number数组
  let numberArray = MemoryInfoNative.getMemInfoSwift().map((value : Int, index : number) : number => {
    // 将 Int 数据类型转换成 number
    return Number.from(value);
  })
  return numberArray;
}


/**
 * 开始监听内存信息变化
 */
export const onMemoryInfoChange : OnMemoryInfoChange = function (callback : (res : Array<number>) => void) {
  MemoryInfoNative.onMemoryInfoChangeSwift((res : Array<Int>) => {
    // 将原生 swift 语言的 Int 数组转换成 uts 语言中的 number数组
    let numberArray = res.map((value : Int, index : number) : number => {
      // 将 Int 数据类型转换成 number
      return Number.from(value);
    })
    callback(numberArray)
  })
}


/**
 * 停止监听内存信息变化
 */
export const offMemoryInfoChange : OffMemoryInfoChange = function () {
  MemoryInfoNative.offMemoryInfoChangeSwift()
}

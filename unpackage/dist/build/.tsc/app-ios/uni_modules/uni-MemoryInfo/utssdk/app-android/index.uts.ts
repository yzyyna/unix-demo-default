import { GetMemoryInfo, OnMemoryInfoChange, OffMemoryInfoChange } from '../interface.uts'
import { MemoryInfoNative } from 'uts.memoryinf.android'


/**
 * 获取内存信息
 */
export const getMemoryInfo : GetMemoryInfo = function () : Array<number> {
  let kotlinArray = MemoryInfoNative.getMemInfoKotlin()
  // 将原生 Kotlin 语言的数组转换成 uts 语言中的数组
  return Array.fromNative(kotlinArray)
}


/**
 * 开始监听内存信息变化
 */
export const onMemoryInfoChange : OnMemoryInfoChange = function (callback : (res : Array<number>) => void) {
  //避免原生语言与uts语言的Array类型，这里需使用kotlin.Array
  MemoryInfoNative.onMemoryInfoChangeKotlin(function (res : kotlin.Array<number>) {
    // 将原生 Kotlin 语言的数组转换成 uts 语言中的数组
    callback(Array.fromNative(res))
  })
}


/**
 * 停止监听内存信息变化
 */
export const offMemoryInfoChange : OffMemoryInfoChange = function () {
  MemoryInfoNative.offMemoryInfoChangeKotlin()
}


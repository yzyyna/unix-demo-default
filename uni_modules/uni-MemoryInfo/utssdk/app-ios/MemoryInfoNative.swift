// 引用原生系统库  
import Foundation
// 引用 uts 基础库  
import DCloudUTSFoundation


/**
 * 原生 Swift 语言实现封装类  
 */
public class MemoryInfoNative {
  // 记录上一次的任务id
  static private var lastTaskId = -1

  /**
   * 获取内测信息
   */
  static func getMemInfoSwift() -> [Int] {
    let freeMem = MemoryInfoNative.getFreeMemory()
    let totalMem = MemoryInfoNative.getTotalMemory()
    // 
    return [freeMem, totalMem]
  }


  /**
   * 开始监听内存信息变化
   */
  static func onMemoryInfoChangeSwift(_ callback: @escaping (_ res: [Int]) -> Void) {
    if lastTaskId != -1 {
      // 避免重复开启
      clearInterval(NSNumber.from(lastTaskId))
    }
        
    lastTaskId = setInterval({ 
      let freeMem = MemoryInfoNative.getFreeMemory()
      let totalMem = MemoryInfoNative.getTotalMemory()
      // 
      callback([freeMem, totalMem])
    }, 2000).toInt()
  }

  /**
   * 停止监听内存信息变化
   */
  static func offMemoryInfoChangeSwift() {
    if lastTaskId != -1 {
      clearInterval(NSNumber.from(lastTaskId))
      lastTaskId = -1
    }
  }

  /**
   * 获取总内存大小（以MB为单位）
   * Returns: 设备总内存
   */
  static func getTotalMemory() -> Int {
    return Int(ProcessInfo.processInfo.physicalMemory / 1024 / 1024)
  }

  /**
   * 获取可用内存大小（以MB为单位）
   * Returns: 设备可用内存
   */
  static func getFreeMemory() -> Int {
    var vmStats = vm_statistics_data_t()
    var infoCount = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.size / MemoryLayout<integer_t>.size)
    let kernReturn = withUnsafeMutablePointer(to: &vmStats) {
      $0.withMemoryRebound(to: integer_t.self, capacity: Int(infoCount)) {
        host_statistics(mach_host_self(), HOST_VM_INFO, $0, &infoCount)
      }
    }

    if kernReturn != KERN_SUCCESS {
      return 0
    }

    let vmPageSize = vm_page_size
    let freeMemorySize = Int(vmPageSize) * Int(vmStats.free_count + vmStats.inactive_count)
    return freeMemorySize / 1024 / 1024
  }

}


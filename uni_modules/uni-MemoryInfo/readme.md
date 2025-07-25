## uni-MemoryInfo

### 开发文档

此插件演示[uts原生混编](https://doc.dcloud.net.cn/uni-app-x/plugin/uts-plugin-hybrid.html)方式开发 uts 插件。  
在 App 平台实现 同步/异步 获取设备内存使用信息的功能。

示例:
```vue
<template>
	<view class="content">
		<button @tap="utsGetMemory">获取内存(同步)</button>
		<button @tap="utsStartMemoryWatch">开始监听内存变化</button>
		<button @tap="utsStopMemoryWatch">停止监听内存变化</button>
	</view>
  <view class="content">
		<text style="color: red;">{{memInfo}}</text>
  </view>
</template>


<script>
import {getMemoryInfo,onMemoryInfoChange,offMemoryInfoChange} from "@/uni_modules/uni-MemoryInfo";
 
export default {
  data() {
    return {
      memInfo: '-'
    }
  },
  onLoad() {
  },
  methods: {
    utsGetMemory(){
      let array = getMemoryInfo()
      this.memInfo = "可用内存:" + array[0] + "MB \n整体内存:" + array[1] + "MB"
      console.log('getMemoryInfo', array)
    },
    utsStartMemoryWatch(){
      onMemoryInfoChange((res: Array<number>) => {
        this.memInfo = "可用内存:" + res[0] + "MB \n整体内存:" + res[1] + "MB"
        console.log('onMemoryInfoChange', res)
      })
    },
    utsStopMemoryWatch(){
      offMemoryInfoChange()
      this.memInfo = "已停止监听"
      console.log('offMemoryInfoChange')
    },
  }
}
</script>


<style>
.content {
  margin: 12px;
}
</style>
```


### 参考  
完整测试项目参考: [uts-hybrid](https://gitcode.com/dcloud/uts-hybrid)

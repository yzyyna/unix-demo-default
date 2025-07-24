@file:Suppress("UNCHECKED_CAST", "USELESS_CAST", "INAPPLICABLE_JVM_NAME", "UNUSED_ANONYMOUS_PARAMETER", "NAME_SHADOWING", "UNNECESSARY_NOT_NULL_ASSERTION")
package uni.UNIC9725AD
import io.dcloud.uniapp.*
import io.dcloud.uniapp.extapi.*
import io.dcloud.uniapp.framework.*
import io.dcloud.uniapp.runtime.*
import io.dcloud.uniapp.vue.*
import io.dcloud.uniapp.vue.shared.*
import io.dcloud.uts.*
import io.dcloud.uts.Map
import io.dcloud.uts.Set
import io.dcloud.uts.UTSAndroid
import uts.sdk.modules.myTestPlugin as ModbusTCPClient
open class GenPagesIndexPage3native : BasePage {
    constructor(__ins: ComponentInternalInstance, __renderer: String?) : super(__ins, __renderer) {
        onLoad(fun(_: OnLoadOptions) {
            this.client = ModbusTCPClient("192.168.1.100", 502)
        }
        , __ins)
    }
    @Suppress("UNUSED_PARAMETER", "UNUSED_VARIABLE")
    override fun `$render`(): Any? {
        val _ctx = this
        val _cache = this.`$`.renderCache
        return _cE("view", null, _uA(
            _cE("button", _uM("onClick" to _ctx.connect), "连接控制器", 8, _uA(
                "onClick"
            )),
            _cE("button", _uM("onClick" to _ctx.readData), "读取寄存器", 8, _uA(
                "onClick"
            )),
            _cE("button", _uM("onClick" to _ctx.writeData), "写入寄存器", 8, _uA(
                "onClick"
            )),
            _cE("text", null, _tD(_ctx.data), 1)
        ))
    }
    open var client: Any? by `$data`
    open var data: String by `$data`
    @Suppress("USELESS_CAST")
    override fun data(): Map<String, Any?> {
        return _uM("client" to null, "data" to "")
    }
    open var connect = ::gen_connect_fn
    open fun gen_connect_fn() {
        this.client.connect()
    }
    open var readData = ::gen_readData_fn
    open fun gen_readData_fn() {
        this.client.readHoldingRegisters(40001, 1, fun(result, error){
            if (result) {
                this.data = "\u8BFB\u53D6\u7ED3\u679C: " + result.join(", ")
            } else {
                this.data = "\u8BFB\u53D6\u5931\u8D25: " + error
            }
        }
        )
    }
    open var writeData = ::gen_writeData_fn
    open fun gen_writeData_fn() {
        this.client.writeRegister(40001, 123, fun(success, error){
            if (success) {
                this.data = "写入成功"
            } else {
                this.data = "\u5199\u5165\u5931\u8D25: " + error
            }
        }
        )
    }
    companion object {
        val styles: Map<String, Map<String, Map<String, Any>>> by lazy {
            _nCS(_uA(), _uA(
                GenApp.styles
            ))
        }
        var inheritAttrs = true
        var inject: Map<String, Map<String, Any?>> = _uM()
        var emits: Map<String, Any?> = _uM()
        var props = _nP(_uM())
        var propsNeedCastKeys: UTSArray<String> = _uA()
        var components: Map<String, CreateVueComponent> = _uM()
    }
}

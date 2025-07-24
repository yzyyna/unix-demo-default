@file:Suppress("UNCHECKED_CAST", "USELESS_CAST", "INAPPLICABLE_JVM_NAME", "UNUSED_ANONYMOUS_PARAMETER", "NAME_SHADOWING", "UNNECESSARY_NOT_NULL_ASSERTION")
package uts.sdk.modules.myTestPlugin
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
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Deferred
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
open class MyApiOptions (
    @JsonNotNull
    open var paramA: Boolean = false,
    open var success: ((res: MyApiResult) -> Unit)? = null,
    open var fail: ((res: MyApiFail) -> Unit)? = null,
    open var complete: ((res: Any) -> Unit)? = null,
) : UTSObject()
open class MyApiResult (
    @JsonNotNull
    open var fieldA: Number,
    @JsonNotNull
    open var fieldB: Boolean = false,
    @JsonNotNull
    open var fieldC: String,
) : UTSObject()
typealias MyApiErrorCode = Number
interface MyApiFail : IUniError {
    override var errCode: MyApiErrorCode
}
typealias MyApi = (options: MyApiOptions) -> Unit
typealias MyApiSync = (paramA: Boolean) -> MyApiResult
val UniErrorSubject = "uts-api"
val MyAPIErrors: Map<MyApiErrorCode, String> = Map(_uA(
    _uA(
        9010001,
        "custom error mseeage1"
    ),
    _uA(
        9010002,
        "custom error mseeage2"
    )
))
open class MyApiFailImpl : UniError, MyApiFail {
    constructor(errCode: MyApiErrorCode) : super() {
        this.errSubject = UniErrorSubject
        this.errCode = errCode
        this.errMsg = MyAPIErrors.get(errCode) ?: ""
    }
}
val myApi: MyApi = fun(options: MyApiOptions) {
    if (options.paramA == true) {
        val res = MyApiResult(fieldA = 85, fieldB = true, fieldC = "some message")
        options.success?.invoke(res)
        options.complete?.invoke(res)
    } else {
        val err = MyApiFailImpl(9010001)
        options.fail?.invoke(err)
        options.complete?.invoke(err)
    }
}
val myApiSync: MyApiSync = fun(paramA: Boolean): MyApiResult {
    val res = MyApiResult(fieldA = 85, fieldB = paramA, fieldC = "some message")
    return res
}

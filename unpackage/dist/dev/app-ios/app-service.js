(function(vue) {
  "use strict";
  function initRuntimeSocket(hosts, port, id) {
    if (hosts == "" || port == "" || id == "")
      return Promise.resolve(null);
    return hosts.split(",").reduce((promise, host) => {
      return promise.then((socket) => {
        if (socket != null)
          return Promise.resolve(socket);
        return tryConnectSocket(host, port, id);
      });
    }, Promise.resolve(null));
  }
  const SOCKET_TIMEOUT = 500;
  function tryConnectSocket(host, port, id) {
    return new Promise((resolve, reject) => {
      const socket = uni.connectSocket({
        url: "ws://".concat(host, ":").concat(port, "/").concat(id),
        fail() {
          resolve(null);
        }
      });
      const timer = setTimeout(() => {
        socket.close({
          code: 1006,
          reason: "connect timeout"
        });
        resolve(null);
      }, SOCKET_TIMEOUT);
      socket.onOpen((e) => {
        clearTimeout(timer);
        resolve(socket);
      });
      socket.onClose((e) => {
        clearTimeout(timer);
        resolve(null);
      });
      socket.onError((e) => {
        clearTimeout(timer);
        resolve(null);
      });
    });
  }
  function initRuntimeSocketService() {
    const hosts = "127.0.0.1,192.168.110.88,10.211.55.2,10.37.129.2";
    const port = "8090";
    const id = "app-ios_YeNHJh";
    let socketTask = null;
    __registerWebViewUniConsole(() => {
      return '!function(){"use strict";"function"==typeof SuppressedError&&SuppressedError;var e=["log","warn","error","info","debug"],n=e.reduce((function(e,n){return e[n]=console[n].bind(console),e}),{}),t=null,r=new Set,o={};function i(e){if(null!=t){var n=e.map((function(e){if("string"==typeof e)return e;var n=e&&"promise"in e&&"reason"in e,t=n?"UnhandledPromiseRejection: ":"";if(n&&(e=e.reason),e instanceof Error&&e.stack)return e.message&&!e.stack.includes(e.message)?"".concat(t).concat(e.message,"\\n").concat(e.stack):"".concat(t).concat(e.stack);if("object"==typeof e&&null!==e)try{return t+JSON.stringify(e)}catch(e){return t+String(e)}return t+String(e)})).filter(Boolean);n.length>0&&t(JSON.stringify(Object.assign({type:"error",data:n},o)))}else e.forEach((function(e){r.add(e)}))}function a(e,n){try{return{type:e,args:u(n)}}catch(e){}return{type:e,args:[]}}function u(e){return e.map((function(e){return c(e)}))}function c(e,n){if(void 0===n&&(n=0),n>=7)return{type:"object",value:"[Maximum depth reached]"};switch(typeof e){case"string":return{type:"string",value:e};case"number":return function(e){return{type:"number",value:String(e)}}(e);case"boolean":return function(e){return{type:"boolean",value:String(e)}}(e);case"object":try{return function(e,n){if(null===e)return{type:"null"};if(function(e){return e.$&&s(e.$)}(e))return function(e,n){return{type:"object",className:"ComponentPublicInstance",value:{properties:Object.entries(e.$.type).map((function(e){return f(e[0],e[1],n+1)}))}}}(e,n);if(s(e))return function(e,n){return{type:"object",className:"ComponentInternalInstance",value:{properties:Object.entries(e.type).map((function(e){return f(e[0],e[1],n+1)}))}}}(e,n);if(function(e){return e.style&&null!=e.tagName&&null!=e.nodeName}(e))return function(e,n){return{type:"object",value:{properties:Object.entries(e).filter((function(e){var n=e[0];return["id","tagName","nodeName","dataset","offsetTop","offsetLeft","style"].includes(n)})).map((function(e){return f(e[0],e[1],n+1)}))}}}(e,n);if(function(e){return"function"==typeof e.getPropertyValue&&"function"==typeof e.setProperty&&e.$styles}(e))return function(e,n){return{type:"object",value:{properties:Object.entries(e.$styles).map((function(e){return f(e[0],e[1],n+1)}))}}}(e,n);if(Array.isArray(e))return{type:"object",subType:"array",value:{properties:e.map((function(e,t){return function(e,n,t){var r=c(e,t);return r.name="".concat(n),r}(e,t,n+1)}))}};if(e instanceof Set)return{type:"object",subType:"set",className:"Set",description:"Set(".concat(e.size,")"),value:{entries:Array.from(e).map((function(e){return function(e,n){return{value:c(e,n)}}(e,n+1)}))}};if(e instanceof Map)return{type:"object",subType:"map",className:"Map",description:"Map(".concat(e.size,")"),value:{entries:Array.from(e.entries()).map((function(e){return function(e,n){return{key:c(e[0],n),value:c(e[1],n)}}(e,n+1)}))}};if(e instanceof Promise)return{type:"object",subType:"promise",value:{properties:[]}};if(e instanceof RegExp)return{type:"object",subType:"regexp",value:String(e),className:"Regexp"};if(e instanceof Date)return{type:"object",subType:"date",value:String(e),className:"Date"};if(e instanceof Error)return{type:"object",subType:"error",value:e.message||String(e),className:e.name||"Error"};var t=void 0,r=e.constructor;r&&r.get$UTSMetadata$&&(t=r.get$UTSMetadata$().name);var o=Object.entries(e);(function(e){return e.modifier&&e.modifier._attribute&&e.nodeContent})(e)&&(o=o.filter((function(e){var n=e[0];return"modifier"!==n&&"nodeContent"!==n})));return{type:"object",className:t,value:{properties:o.map((function(e){return f(e[0],e[1],n+1)}))}}}(e,n)}catch(e){return{type:"object",value:{properties:[]}}}case"undefined":return{type:"undefined"};case"function":return function(e){return{type:"function",value:"function ".concat(e.name,"() {}")}}(e);case"symbol":return function(e){return{type:"symbol",value:e.description}}(e);case"bigint":return function(e){return{type:"bigint",value:String(e)}}(e)}}function s(e){return e.type&&null!=e.uid&&e.appContext}function f(e,n,t){var r=c(n,t);return r.name=e,r}var l=null,p=[],y={},g="---BEGIN:EXCEPTION---",d="---END:EXCEPTION---";function v(e){null!=l?l(JSON.stringify(Object.assign({type:"console",data:e},y))):p.push.apply(p,e)}var m=/^\\s*at\\s+[\\w/./-]+:\\d+$/;function b(){function t(e){return function(){for(var t=[],r=0;r<arguments.length;r++)t[r]=arguments[r];var o=function(e,n,t){if(t||2===arguments.length)for(var r,o=0,i=n.length;o<i;o++)!r&&o in n||(r||(r=Array.prototype.slice.call(n,0,o)),r[o]=n[o]);return e.concat(r||Array.prototype.slice.call(n))}([],t,!0);if(o.length){var u=o[o.length-1];"string"==typeof u&&m.test(u)&&o.pop()}if(n[e].apply(n,o),"error"===e&&1===t.length){var c=t[0];if("string"==typeof c&&c.startsWith(g)){var s=g.length,f=c.length-d.length;return void i([c.slice(s,f)])}if(c instanceof Error)return void i([c])}v([a(e,t)])}}return function(){var e=console.log,n=Symbol();try{console.log=n}catch(e){return!1}var t=console.log===n;return console.log=e,t}()?(e.forEach((function(e){console[e]=t(e)})),function(){e.forEach((function(e){console[e]=n[e]}))}):function(){}}function _(e){var n={type:"WEB_INVOKE_APPSERVICE",args:{data:{name:"console",arg:e}}};return window.__uniapp_x_postMessageToService?window.__uniapp_x_postMessageToService(n):window.__uniapp_x_.postMessageToService(JSON.stringify(n))}!function(){if(!window.__UNI_CONSOLE_WEBVIEW__){window.__UNI_CONSOLE_WEBVIEW__=!0;var e="[web-view]".concat(window.__UNI_PAGE_ROUTE__?"[".concat(window.__UNI_PAGE_ROUTE__,"]"):"");b(),function(e,n){if(void 0===n&&(n={}),l=e,Object.assign(y,n),null!=e&&p.length>0){var t=p.slice();p.length=0,v(t)}}((function(e){_(e)}),{channel:e}),function(e,n){if(void 0===n&&(n={}),t=e,Object.assign(o,n),null!=e&&r.size>0){var a=Array.from(r);r.clear(),i(a)}}((function(e){_(e)}),{channel:e}),window.addEventListener("error",(function(e){i([e.error])})),window.addEventListener("unhandledrejection",(function(e){i([e])}))}}()}();';
    }, (data) => {
      socketTask === null || socketTask === void 0 ? void 0 : socketTask.send({
        data
      });
    });
    return Promise.resolve().then(() => {
      return initRuntimeSocket(hosts, port, id).then((socket) => {
        if (socket == null) {
          return false;
        }
        socketTask = socket;
        return true;
      });
    }).catch(() => {
      return false;
    });
  }
  initRuntimeSocketService();
  const _sfc_main$4 = vue.defineComponent({
    data() {
      return {
        title: "Hello"
      };
    },
    onLoad() {
    },
    onReady() {
      uni.__log__("log", "at pages/index/index.uvue:22", getApp(), getCurrentPages());
    },
    methods: {
      onClick(path) {
        uni.navigateTo({
          url: path
        });
      }
    }
  });
  const _imports_0 = "/static/logo.png";
  const _style_0$2 = { "logo": { "": { "height": 100, "width": 100, "marginTop": 100, "marginRight": "auto", "marginBottom": 25, "marginLeft": "auto" } }, "title": { "": { "fontSize": 18, "color": "#8f8f94", "textAlign": "center" } }, "text-area": { "": { "color": "#333333" } } };
  const _export_sfc = (sfc, props) => {
    const target = sfc.__vccOpts || sfc;
    for (const [key, val] of props) {
      target[key] = val;
    }
    return target;
  };
  function _sfc_render$3(_ctx, _cache, $props, $setup, $data, $options) {
    return vue.openBlock(), vue.createElementBlock("view", null, [
      vue.createElementVNode("image", {
        class: "logo",
        src: _imports_0
      }),
      vue.createElementVNode("view", { class: "text-area" }, [
        vue.createElementVNode(
          "text",
          { class: "title" },
          vue.toDisplayString($data.title),
          1
          /* TEXT */
        )
      ]),
      vue.createElementVNode("view", {
        onClick: _cache[0] || (_cache[0] = ($event) => $options.onClick("/pages/index/page2"))
      }, "click to page2"),
      vue.createElementVNode("view", {
        onClick: _cache[1] || (_cache[1] = ($event) => $options.onClick("/pages/index/page3native"))
      }, "click to page3")
    ]);
  }
  const PagesIndexIndex = /* @__PURE__ */ _export_sfc(_sfc_main$4, [["render", _sfc_render$3], ["styles", [_style_0$2]], ["__file", "/Users/fortrust/Documents/HBuilderProjects/unix-demo-default/pages/index/index.uvue"]]);
  const _sfc_main$3 = vue.defineComponent({
    data() {
      return {};
    },
    methods: {}
  });
  function _sfc_render$2(_ctx, _cache, $props, $setup, $data, $options) {
    return vue.openBlock(), vue.createElementBlock("view", null, " test com ");
  }
  const __easycom_0 = /* @__PURE__ */ _export_sfc(_sfc_main$3, [["render", _sfc_render$2], ["__file", "/Users/fortrust/Documents/HBuilderProjects/unix-demo-default/components/test-com/test-com.uvue"]]);
  function resolveEasycom(component, easycom) {
    return typeof component === "string" ? easycom : component;
  }
  const _sfc_main$2 = vue.defineComponent({
    data() {
      return {};
    },
    onReady() {
      uni.__log__("log", "at pages/index/page2.uvue:16", getApp(), getCurrentPages());
    },
    methods: {}
  });
  function _sfc_render$1(_ctx, _cache, $props, $setup, $data, $options) {
    const _component_test_com = resolveEasycom(vue.resolveDynamicComponent("test-com"), __easycom_0);
    return vue.openBlock(), vue.createElementBlock("view", null, [
      vue.createTextVNode(" Page2 "),
      vue.createVNode(_component_test_com)
    ]);
  }
  const PagesIndexPage2 = /* @__PURE__ */ _export_sfc(_sfc_main$2, [["render", _sfc_render$1], ["__file", "/Users/fortrust/Documents/HBuilderProjects/unix-demo-default/pages/index/page2.uvue"]]);
  class MemoryInfoResult extends UTS.UTSType {
    static get$UTSMetadata$() {
      return {
        kind: 2,
        get fields() {
          return {
            freeMem: { type: Number, optional: false },
            totalMem: { type: Number, optional: false }
          };
        },
        name: "MemoryInfoResult"
      };
    }
    constructor(options, metadata = MemoryInfoResult.get$UTSMetadata$(), isJSONParse = false) {
      super();
      this.__props__ = UTS.UTSType.initProps(options, metadata, isJSONParse);
      this.freeMem = this.__props__.freeMem;
      this.totalMem = this.__props__.totalMem;
      delete this.__props__;
    }
  }
  const _sfc_main$1 = vue.defineComponent({
    data() {
      return {
        freeMem: 0,
        totalMem: 0,
        isListening: false
      };
    },
    methods: {
      getMemInfo() {
        const result = getMemInfo();
        this.freeMem = result.freeMem;
        this.totalMem = result.totalMem;
      },
      startListening() {
        if (!this.isListening) {
          this.isListening = true;
          onMemoryInfoChange((res = null) => {
            this.freeMem = res.freeMem;
            this.totalMem = res.totalMem;
          });
        }
      },
      stopListening() {
        if (this.isListening) {
          this.isListening = false;
          offMemoryInfoChange();
        }
      }
    }
  });
  const _style_0$1 = { "content": { "": { "paddingTop": "20rpx", "paddingRight": "20rpx", "paddingBottom": "20rpx", "paddingLeft": "20rpx", "flexDirection": "column", "alignItems": "center" } }, "button-group": { "": { "flexDirection": "column", "gap": "15rpx", "marginBottom": "30rpx" } }, "result-area": { "": { "width": "100%", "paddingTop": "20rpx", "paddingRight": "20rpx", "paddingBottom": "20rpx", "paddingLeft": "20rpx", "backgroundColor": "#f5f5f5", "borderTopLeftRadius": "10rpx", "borderTopRightRadius": "10rpx", "borderBottomRightRadius": "10rpx", "borderBottomLeftRadius": "10rpx" } }, "title": { "": { "fontSize": "36rpx", "fontWeight": "bold", "marginBottom": "15rpx" } } };
  function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
    return vue.openBlock(), vue.createElementBlock("view", { class: "content" }, [
      vue.createElementVNode("view", { class: "button-group" }, [
        vue.createElementVNode("button", {
          onClick: _cache[0] || (_cache[0] = (...args) => $options.getMemInfo && $options.getMemInfo(...args))
        }, "获取内存信息"),
        vue.createElementVNode("button", {
          onClick: _cache[1] || (_cache[1] = (...args) => $options.startListening && $options.startListening(...args))
        }, "开始监听"),
        vue.createElementVNode("button", {
          onClick: _cache[2] || (_cache[2] = (...args) => $options.stopListening && $options.stopListening(...args))
        }, "停止监听")
      ]),
      vue.createElementVNode("view", { class: "result-area" }, [
        vue.createElementVNode("text", { class: "title" }, "内存信息"),
        vue.createElementVNode(
          "text",
          null,
          "可用内存: " + vue.toDisplayString($data.freeMem) + " MB",
          1
          /* TEXT */
        ),
        vue.createElementVNode(
          "text",
          null,
          "总内存: " + vue.toDisplayString($data.totalMem) + " MB",
          1
          /* TEXT */
        )
      ])
    ]);
  }
  const PagesIndexPage3native = /* @__PURE__ */ _export_sfc(_sfc_main$1, [["render", _sfc_render], ["styles", [_style_0$1]], ["__file", "/Users/fortrust/Documents/HBuilderProjects/unix-demo-default/pages/index/page3native.uvue"]]);
  __definePage("pages/index/index", PagesIndexIndex);
  __definePage("pages/index/page2", PagesIndexPage2);
  __definePage("pages/index/page3native", PagesIndexPage3native);
  const _sfc_main = vue.defineComponent(new UTSJSONObject({
    onLaunch: function() {
      uni.__log__("log", "at App.uvue:5", "App Launch");
    },
    onShow: function() {
      uni.__log__("log", "at App.uvue:8", "App Show");
    },
    onHide: function() {
      uni.__log__("log", "at App.uvue:11", "App Hide");
    },
    onExit: function() {
      uni.__log__("log", "at App.uvue:32", "App Exit");
    }
  }));
  const _style_0 = { "uni-row": { "": { "flexDirection": "row" } }, "uni-column": { "": { "flexDirection": "column" } } };
  const App = /* @__PURE__ */ _export_sfc(_sfc_main, [["styles", [_style_0]], ["__file", "/Users/fortrust/Documents/HBuilderProjects/unix-demo-default/App.uvue"]]);
  const __global__ = typeof globalThis === "undefined" ? Function("return this")() : globalThis;
  __global__.__uniX = true;
  function createApp() {
    const app = vue.createSSRApp(App);
    return {
      app
    };
  }
  createApp().app.mount("#app");
})(Vue);
//# sourceMappingURL=../../../cache/.app-ios/sourcemap/app-service.js.map

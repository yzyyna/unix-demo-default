(function(vue) {
  "use strict";
  const _sfc_main$5 = vue.defineComponent({
    data() {
      return {
        title: "Hello"
      };
    },
    onLoad() {
    },
    onReady() {
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
        vue.createElementVNode("text", { class: "title" }, vue.toDisplayString($data.title), 1)
      ]),
      vue.createElementVNode("view", {
        onClick: _cache[0] || (_cache[0] = ($event) => $options.onClick("/pages/index/page2"))
      }, "click to page2"),
      vue.createElementVNode("view", {
        onClick: _cache[1] || (_cache[1] = ($event) => $options.onClick("/pages/index/page3native"))
      }, "click to page3"),
      vue.createElementVNode("view", {
        onClick: _cache[2] || (_cache[2] = ($event) => $options.onClick("/pages/index/page-modbus"))
      }, "click to page-modbus")
    ]);
  }
  const PagesIndexIndex = /* @__PURE__ */ _export_sfc(_sfc_main$5, [["render", _sfc_render$3], ["styles", [_style_0$2]]]);
  const _sfc_main$4 = vue.defineComponent({
    data() {
      return {};
    },
    methods: {}
  });
  function _sfc_render$2(_ctx, _cache, $props, $setup, $data, $options) {
    return vue.openBlock(), vue.createElementBlock("view", null, " test com ");
  }
  const __easycom_0 = /* @__PURE__ */ _export_sfc(_sfc_main$4, [["render", _sfc_render$2]]);
  function resolveEasycom(component, easycom) {
    return typeof component === "string" ? easycom : component;
  }
  const _sfc_main$3 = vue.defineComponent({
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
  const PagesIndexPage2 = /* @__PURE__ */ _export_sfc(_sfc_main$3, [["render", _sfc_render$1]]);
  const { registerUTSInterface: registerUTSInterface$1, initUTSProxyClass: initUTSProxyClass$1, initUTSProxyFunction: initUTSProxyFunction$1, initUTSPackageName: initUTSPackageName$1, initUTSIndexClassName: initUTSIndexClassName$1, initUTSClassName: initUTSClassName$1 } = uni;
  const name$1 = "uniMemoryInfo";
  const moduleName$1 = "uni-MemoryInfo";
  const moduleType$1 = "";
  const errMsg$1 = "";
  const is_uni_modules$1 = true;
  const pkg$1 = /* @__PURE__ */ initUTSPackageName$1(name$1, is_uni_modules$1);
  const cls$1 = /* @__PURE__ */ initUTSIndexClassName$1(name$1, is_uni_modules$1);
  const getMemoryInfo = /* @__PURE__ */ initUTSProxyFunction$1(false, { moduleName: moduleName$1, moduleType: moduleType$1, errMsg: errMsg$1, main: true, package: pkg$1, class: cls$1, name: "getMemoryInfoByJs", keepAlive: false, params: [], return: "" });
  const onMemoryInfoChange = /* @__PURE__ */ initUTSProxyFunction$1(false, { moduleName: moduleName$1, moduleType: moduleType$1, errMsg: errMsg$1, main: true, package: pkg$1, class: cls$1, name: "onMemoryInfoChangeByJs", keepAlive: false, params: [{ "name": "callback", "type": "UTSCallback" }], return: "" });
  const offMemoryInfoChange = /* @__PURE__ */ initUTSProxyFunction$1(false, { moduleName: moduleName$1, moduleType: moduleType$1, errMsg: errMsg$1, main: true, package: pkg$1, class: cls$1, name: "offMemoryInfoChangeByJs", keepAlive: false, params: [], return: "" });
  const _sfc_main$2 = vue.defineComponent({
    data() {
      return {
        memInfo: "-"
      };
    },
    onLoad() {
    },
    methods: {
      utsGetMemory() {
        let array = getMemoryInfo();
        this.memInfo = "可用内存:" + array[0] + "MB \n整体内存:" + array[1] + "MB";
        uni.__log__("log", "at pages/index/page3native.uvue:28", "getMemoryInfo", array);
      },
      utsStartMemoryWatch() {
        onMemoryInfoChange((res) => {
          this.memInfo = "可用内存:" + res[0] + "MB \n整体内存:" + res[1] + "MB";
          uni.__log__("log", "at pages/index/page3native.uvue:33", "onMemoryInfoChange", res);
        });
      },
      utsStopMemoryWatch() {
        offMemoryInfoChange();
        this.memInfo = "已停止监听";
        uni.__log__("log", "at pages/index/page3native.uvue:39", "offMemoryInfoChange");
      }
    }
  });
  const _style_0$1 = { "content": { "": { "marginTop": 12, "marginRight": 12, "marginBottom": 12, "marginLeft": 12 } } };
  function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
    return vue.openBlock(), vue.createElementBlock(vue.Fragment, null, [
      vue.createElementVNode("view", { class: "content" }, [
        vue.createElementVNode("button", {
          onClick: _cache[0] || (_cache[0] = (...args) => $options.utsGetMemory && $options.utsGetMemory(...args))
        }, "获取内存(同步)"),
        vue.createElementVNode("button", {
          onClick: _cache[1] || (_cache[1] = (...args) => $options.utsStartMemoryWatch && $options.utsStartMemoryWatch(...args))
        }, "开始监听内存变化"),
        vue.createElementVNode("button", {
          onClick: _cache[2] || (_cache[2] = (...args) => $options.utsStopMemoryWatch && $options.utsStopMemoryWatch(...args))
        }, "停止监听内存变化")
      ]),
      vue.createElementVNode("view", { class: "content" }, [
        vue.createElementVNode("text", { style: { "color": "red" } }, vue.toDisplayString($data.memInfo), 1)
      ])
    ], 64);
  }
  const PagesIndexPage3native = /* @__PURE__ */ _export_sfc(_sfc_main$2, [["render", _sfc_render], ["styles", [_style_0$1]]]);
  const { registerUTSInterface, initUTSProxyClass, initUTSProxyFunction, initUTSPackageName, initUTSIndexClassName, initUTSClassName } = uni;
  const name = "fpssModbusTcp";
  const moduleName = "fpss-modbus-tcp";
  const moduleType = "";
  const errMsg = "";
  const is_uni_modules = true;
  const pkg = /* @__PURE__ */ initUTSPackageName(name, is_uni_modules);
  const cls = /* @__PURE__ */ initUTSIndexClassName(name, is_uni_modules);
  const connect = /* @__PURE__ */ initUTSProxyFunction(false, { moduleName, moduleType, errMsg, main: true, package: pkg, class: cls, name: "connectByJs", keepAlive: false, params: [], return: "" });
  const disConnect = /* @__PURE__ */ initUTSProxyFunction(false, { moduleName, moduleType, errMsg, main: true, package: pkg, class: cls, name: "disConnectByJs", keepAlive: false, params: [], return: "" });
  const myApi = /* @__PURE__ */ initUTSProxyFunction(false, { moduleName, moduleType, errMsg, main: true, package: pkg, class: cls, name: "myApiByJs", keepAlive: false, params: [], return: "" });
  const _sfc_main$1 = /* @__PURE__ */ vue.defineComponent({
    __name: "page-modbus",
    setup(__props) {
      const msg = vue.ref("");
      const connectClient = (flag = null) => {
        if (flag) {
          uni.__log__("log", "at pages/index/page-modbus.uvue:15", "正在连接 Modbus 服务器...");
          connect();
        } else {
          uni.__log__("log", "at pages/index/page-modbus.uvue:24", "正在连接 Modbus 服务器...");
          disConnect();
          msg.value = "断开";
        }
      };
      const clickTestApi = () => {
        myApi();
      };
      return (_ctx = null, _cache = null) => {
        return vue.openBlock(), vue.createElementBlock("view", new UTSJSONObject({ class: "container" }), [
          vue.createElementVNode("button", new UTSJSONObject({
            onClick: _cache[0] || (_cache[0] = ($event = null) => {
              return connectClient(true);
            })
          }), "连接Modbus服务器"),
          vue.createElementVNode("button", new UTSJSONObject({
            onClick: _cache[1] || (_cache[1] = ($event = null) => {
              return connectClient(false);
            })
          }), "断开Modbus服务器"),
          vue.createElementVNode("button", new UTSJSONObject({ onClick: clickTestApi }), "测试Api"),
          vue.createElementVNode("view", null, vue.toDisplayString(vue.unref(msg)), 1)
        ]);
      };
    }
  });
  __definePage("pages/index/index", PagesIndexIndex);
  __definePage("pages/index/page2", PagesIndexPage2);
  __definePage("pages/index/page3native", PagesIndexPage3native);
  __definePage("pages/index/page-modbus", _sfc_main$1);
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
  const App = /* @__PURE__ */ _export_sfc(_sfc_main, [["styles", [_style_0]]]);
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

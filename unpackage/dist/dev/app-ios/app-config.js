const __uniConfig = {"pages":[],"globalStyle":{"navigationBarTextStyle":"black","navigationBarTitleText":"uni-app x","navigationBarBackgroundColor":"#F8F8F8","backgroundColor":"#F8F8F8"},"appname":"unix-demo-default","compilerVersion":"4.75","entryPagePath":"pages/index/index","entryPageQuery":"","realEntryPagePath":"","themeConfig":{}};
__uniConfig.getTabBarConfig = () =>  {return undefined};
__uniConfig.tabBar = __uniConfig.getTabBarConfig();
const __uniRoutes = [{"path":"pages/index/index","meta":{"isQuit":true,"isEntry":true,"navigationBarTitleText":"uni-app x"}},{"path":"pages/index/page2","meta":{"navigationBarTitleText":"Page2"}},{"path":"pages/index/page3native","meta":{"navigationBarTitleText":"Page3 native"}}].map(uniRoute=>(uniRoute.meta.route=uniRoute.path,__uniConfig.pages.push(uniRoute.path),uniRoute.path='/'+uniRoute.path,uniRoute)).concat(typeof __uniSystemRoutes !== 'undefined' ? __uniSystemRoutes : []);


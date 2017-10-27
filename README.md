1. **MainActivity.java** 是微端的主（也是唯一）Activity，其中初如化了一个 WebView，并通过 `mWebView.addJavascriptInterface(anyController, "gameshell");` 将 Java 对象实例 anyController 添加为 WebView 的扩展对象，之后在 H5 中即可通过 `window.gameshell.method()` 来调用 anyController 中公开的 Java 方法。

1. 下面的 **libForJava 库工程** 即是AnySDK Framework，具体是如何集成进来的请参考 http://docs.anysdk.com/integration/client-java/quick-integration/ ，如果你对 AnySDK 的原理还不了解的话，建议阅读 《[AnySDK 快速入门](http://docs.anysdk.com/rapid-experience/introduce/)》。

2. **AnyController.java** 初始化 AnySDK ，并实现登录和支付提供接口公开给 JS 调用。

3. **gameindex.html** 实现了一个简单的 H5 游戏，通过两个按钮来调用微端中的登录和支付。

因此，你只需要把微端 `AnyController.java` 中 appKey 等参数替换成你自己申请到的AnySDK参数、游戏地址替换成你自己的 H5 游戏地址，并在你的 H5 游戏页面中适当参考 `gameindex.html` 实现登录和支付的调用即可。

然后将这个微端放到 AnySDK 打包工具 进行打包（请参考《[客户端使用手册](http://docs.anysdk.com/tool-using/package-tool/)》），即可快速生成用于上线各大渠道的渠道包。

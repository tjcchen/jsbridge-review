## JsBridge-Review
JsBridge is a communication method between JavaScript and Native Code. This technology is also known as Hybrid app. In JsBridge, Native calls JavaScript through a webview method `stringByEvaluatingJavaScriptFromString`. On the other hand, JavaScript calls Native by sending dummy request to Native, then Native intercepts the dummy request, analyze the request, and execute the corresponding method.

## Mechanism Explained
### Flow of FE javascript code invokes iOS native code
1. Initially, we need to contruct a mock request url from FE webview to let native code intercept it. The mock url looks like this, and then we send it native code:
```js
window.location.href = "jsbridge://hello_jsbridge";

// Basically, the hello_jsbridge string could be a native method name
```
2. Secondly, we make webview delegate to self object, and let current self ViewController implements UIWebViewDelegate's shouldStartLoadWithRequest method.
```swift
@interface ViewController ()<UIWebViewDelegate>

- (void)viewDidLoad {
    // ...
    webview.delegate = self;

    [self.view addSubview:webview]
    // ...
}

//--------------------------------------------------------------------------------------
// Intercept request url logic goes here, all the request urls should come to this place
//--------------------------------------------------------------------------------------
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  NSString *path = request.URL.absoluteString;
  
  if ([path hasPrefix:@"jsbridge://"]) {
    // handle jsbridge request, request looks like: jsbridge://hello_jsbridge

    // TODO:
    // 1. retrieve method name from request url
    // 2. transform method name to native code method
    // 3. invoke native code method

    return NO; // let request stops here
  } else {
    // this is a normal request url, request looks like: https://www.google.com

    return YES; // continue to send url request
  }
}
```
3. Finally, we deal with jsbridge request, and then execute native method.

### Flow of iOS native code invokes FE javascript code
1. At the very first place, we define a method mounting to window object in webview.
```js
window.handleNativeValue = function(val) {
  document.getElementById('title').innerText = val;
};
```
2. Afterwards, we invoke `handleNativeValue` method from native code with `stringByEvaluatingJavaScriptFromString`.
```swift
 [webView stringByEvaluatingJavaScriptFromString:@"handleNativeValue('message from native code')"];
```
3. Finally, the message 'message from native code' is being successfully passed to FE webview.

## License
This project is licensed under terms MIT license.
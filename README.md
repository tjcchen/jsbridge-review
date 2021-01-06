## JsBridge-Review
A webview and IOS native code communication project

## JsBridge Mechanism Explained
### Flow of FE javascript code invoke iOS native code
1. Initially, we need to contruct a mock request url from FE webview to let native code intercept it. The mock url looks like this, and then we send it native code:
```
window.location.href = "jsbridge://hello_jsbridge";

Basically, the hello_jsbridge string could be a native method name
```
2. Secondly, we make webview delegate to self object, and let current self ViewController implements UIWebViewDelegate's shouldStartLoadWithRequest method.
```
@interface ViewController ()<UIWebViewDelegate>

- (void)viewDidLoad {
    // ...
    
    webview.delegate = self;

    [self.view addSubview:webview]

    // ...
}

//------------------------------------------------------------------------------
// Intercept request url logic goes here, all the request urls should come to this place
//------------------------------------------------------------------------------
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  NSString *path = request.URL.absoluteString;
  
  if ([path hasPrefix:@"jsbridge://"]) {

    // handle jsbridge request, request looks like: jsbridge://hello_jsbridge

    // TODO:
    // 1. retrieve method name from request url
    // 2. transform method name to native code method
    // 3. invoke native code method

    // let request stops here
    return NO;
  } else {

    // this is a normal request url, request looks like: https://www.google.com

    // continue to send url request
    return YES;
  }
}
```
3. Finally, we deal with jsbridge request, and then execute native method

### Flow of iOS native code invoke FE javascript code
1. At the very first place, we define a method mounting to window object in webview
```
window.handleNativeValue = function(val) {
  document.getElementById('title').innerText = val;
};
```
2. Afterwards, we invoke `handleNativeValue` method from native code with `stringByEvaluatingJavaScriptFromString`
```
 [webView stringByEvaluatingJavaScriptFromString:@"handleNativeValue('message from native code')"];
```
3. Finally, the message 'message from native code' is being successfully passed to FE webview

## License
MIT License

Copyright (c) 2021 Andy Chen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
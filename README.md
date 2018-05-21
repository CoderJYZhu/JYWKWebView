# JYWKWebView

```
@protocol JYWKWebViewDelegate <NSObject>
@optional
/** 页面开始加载时调用 */
- (void)webViewDidStartLoad:(JYWKWebView *)webView;
/** 内容开始返回时调用 */
- (void)webView:(JYWKWebView *)webView didCommitWithURL:(NSURL *)url;
/** 页面加载失败时调用 */
- (void)webView:(JYWKWebView *)webView didFinishLoadWithURL:(NSURL *)url;
/** 页面加载完成之后调用 */
- (void)webView:(JYWKWebView *)webView didFailLoadWithError:(NSError *)error;
/**
返回截取特定点击request类型
*/
- (void)webView:(JYWKWebView *)webView didSelectWithRequestStr:(NSString *)requestStr;
@end

@interface JYWKWebView : UIView
/** JYWKWebViewDelegate */
@property (nonatomic, weak) id<JYWKWebViewDelegate> delegate;
/** 进度条颜色(默认蓝色) */
@property (nonatomic, strong) UIColor *progressViewColor;
/** 进度条是否显示*/
@property (nonatomic , assign) BOOL progressViewHidden;
/** 导航栏标题 */
@property (nonatomic, copy) NSString *navigationItemTitle;
/** 导航栏存在且有穿透效果(默认导航栏存在且有穿透效果) */
@property (nonatomic, assign) BOOL isNavigationBarOrTranslucent;
/** 类方法创建 JYWKWebView */
+ (instancetype)webViewWithFrame:(CGRect)frame;
/** 加载 url */
- (void)loadUrlString:(NSString *)urlString;
/** 加载 web */
- (void)loadRequest:(NSURLRequest *)request;
/** 加载 HTML */
- (void)loadHTMLString:(NSString *)HTMLString;
/** 刷新数据 */
- (void)reloadData;
@end
```

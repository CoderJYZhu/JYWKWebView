//
//  JYWKWebView.h
//  test
//
//  Created by hollysmary on 2018/4/28.
//  Copyright © 2018年 Hollysmary. All rights reserved.
//

#import "JYWKWebView.h"
#import <WebKit/WebKit.h>



@interface JYWKWebView () <WKNavigationDelegate, WKUIDelegate>
/// WKWebView
@property (nonatomic, strong) WKWebView *wkWebView;
/// 进度条
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation JYWKWebView

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
static CGFloat const navigationBarHeight = 64;
static CGFloat const progressViewHeight = 2;


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.wkWebView];
        [self addSubview:self.progressView];
        [self bringSubviewToFront:self.progressView];
    }
    return self;
}

+ (instancetype)webViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:self.bounds];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        // KVO
        [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
    }
    return _wkWebView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.trackTintColor = [UIColor clearColor];
        // 高度默认有导航栏且有穿透效果
        if (iPhoneX) {
            _progressView.frame = CGRectMake(0, navigationBarHeight+24, self.frame.size.width, progressViewHeight);
        } else {
            _progressView.frame = CGRectMake(0, navigationBarHeight, self.frame.size.width, progressViewHeight);
        }
        // 设置进度条颜色
        _progressView.tintColor = [UIColor greenColor];
    }
    return _progressView;
}

- (void)setProgressViewColor:(UIColor *)progressViewColor {
    _progressViewColor = progressViewColor;
    if (progressViewColor) {
        _progressView.tintColor = progressViewColor;
    }
}

- (void)setIsNavigationBarOrTranslucent:(BOOL)isNavigationBarOrTranslucent {
    _isNavigationBarOrTranslucent = isNavigationBarOrTranslucent;
    if (isNavigationBarOrTranslucent == YES) { // 导航栏存在且有穿透效果
        if (iPhoneX) {
            _progressView.frame = CGRectMake(0, navigationBarHeight+24, self.frame.size.width, progressViewHeight);
        } else {
            _progressView.frame = CGRectMake(0, navigationBarHeight, self.frame.size.width, progressViewHeight);
        }
    } else { // 导航栏不存在或者没有有穿透效果
        _progressView.frame = CGRectMake(0, 0, self.frame.size.width, progressViewHeight);
    }
}

/// KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        self.progressView.alpha = 1.0;
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        if(self.wkWebView.estimatedProgress >= 0.97) {
            [UIView animateWithDuration:0.1 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0 animated:NO];
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - - - 加载的状态回调（WKNavigationDelegate）
/// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:self];
    }
}
/// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didCommitWithURL:)]) {
        [self.delegate webView:self didCommitWithURL:self.wkWebView.URL];
    }
    
    self.navigationItemTitle = self.wkWebView.title;
}
/// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.navigationItemTitle = self.wkWebView.title;
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didFinishLoadWithURL:)]) {
        [self.delegate webView:self didFinishLoadWithURL:self.wkWebView.URL];
    }
    
    self.progressView.alpha = 0.0;
}
/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:self didFailLoadWithError:error];
    }
    
    self.progressView.alpha = 0.0;
}

/// 加载 web
- (void)loadRequest:(NSURLRequest *)request {
    [self.wkWebView loadRequest:request];
}

/// 加载 HTML
- (void)loadHTMLString:(NSString *)HTMLString {
    [self.wkWebView loadHTMLString:HTMLString baseURL:nil];
}
/// 刷新数据
- (void)reloadData {
    [self.wkWebView reload];
}
/// dealloc
- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
//    JYLog(@"%@",strRequest);
    if ([strRequest rangeOfString:@"atdetail://unit/"].location != NSNotFound) {
        decisionHandler(WKNavigationActionPolicyCancel);//不允许跳转
        [self.delegate webView:self didSelectWithRequestStr:strRequest];
    }else {//截获页面里面的链接点击
        decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
    }
}




@end
//
//  代码地址: https://github.com/CoderJYZhu/JYWKWebView
//  JYWKWebView.h
//
//  Created by hollysmary on 2017/4/28.
//  Copyright © 2017年 Hollysmary. All rights reserved.
//  JYWKWebView 使用注意点：
//  如果 self.navigationController.navigationBar.translucent = NO；或者导航栏不存在; 那么 JYWKWebView 的 isNavigationBarOrTranslucent属性 必须设置 NO)

#import <UIKit/UIKit.h>

@class JYWKWebView;

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
/** 导航栏标题 */
@property (nonatomic, copy) NSString *navigationItemTitle;
/** 导航栏存在且有穿透效果(默认导航栏存在且有穿透效果) */
@property (nonatomic, assign) BOOL isNavigationBarOrTranslucent;
/// 拦截参数数组
@property (nonatomic, strong) NSMutableArray *navigationActionPolicyCancelArr;
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

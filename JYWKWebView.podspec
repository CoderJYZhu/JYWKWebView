Pod::Spec.new do |s|
s.name         = "JYWKWebView"
s.version      = "1.0.2"
s.summary      = "WKWebView简单封装"
s.ios.deployment_target = '9.0'
s.homepage     = "https://github.com/CoderJYZhu/JYWKWebView"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author       = { "某天" => "505340739@qq.com" }
s.source       = { :git => "https://github.com/CoderJYZhu/JYWKWebView.git", :tag => s.version }
s.source_files = "JYWKWebView/*.{h,m}"
s.requires_arc = true
end


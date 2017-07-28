//
//  WYDetailViewController.m
//  WYNews
//
//  Created by 刘杰 on 2017/7/28.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "WYDetailViewController.h"

@interface WYDetailViewController ()
@property (nonatomic, weak) UIWebView *webView;
@end

@implementation WYDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self loadData];
}

/// 搭建界面
- (void)setupUI{
    UIWebView *webView = [UIWebView new];
    
    self.view = webView;
    
    self.webView = webView;
}

- (void)loadData{
    [[JJNetWorkManager sharedManager] newsDetailWithDocid:_docid completion:^(NSDictionary *dict, NSError *error) {
        if (error != nil) {
            NSLog(@"请求错误");
            return ;
        }
        
        // 为webView绑定数据
        NSMutableString *htmlString_M = [NSMutableString stringWithString:@"<html><head><style>"];
        
        // 加载样式表
        NSString *path = [[NSBundle mainBundle] pathForResource:@"news.css" ofType:nil];
        NSString *css = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
        
//        [htmlString_M appendString:css];
        
        [htmlString_M appendString:@"</style>"];
        
        [htmlString_M appendString:@"<link rel='stylesheet' href='//img6.cache.netease.com/utf8/3g-new/css/article.1f5c3f18d07cd37923dae7545cf37180.css'>"];
        
        [htmlString_M appendString:@"</head><body>"];
        
        // 拼接body
        [htmlString_M appendString:[NSString stringWithFormat:@"<h1>%@</h1></br>",dict[@"title"]]];
        
        [htmlString_M appendString:dict[@"body"]];
        
        [htmlString_M appendString:@"</body></html>"];
        
        NSString *html = htmlString_M.copy;
        
        // 替换video
        NSArray *videos = dict[@"video"];
        
        for (NSDictionary *videoDict in videos) {
            
            NSString *replaceString = [NSString stringWithFormat:@"<video src=\"%@\"></video>",videoDict[@"url_m3u8"]];
            
            html = [html stringByReplacingOccurrencesOfString:videoDict[@"ref"] withString:replaceString];
        }
        
        // 替换图片
        NSArray *pics = dict[@"img"];
        
        for (NSDictionary *imgDict in pics) {
            
            NSString *replaceString = [NSString stringWithFormat:@"<img src=\"%@\"></video>",imgDict[@"src"]];
            
            html = [html stringByReplacingOccurrencesOfString:imgDict[@"ref"] withString:replaceString];
        }
        NSLog(@"%@",html);
        [_webView loadHTMLString:html baseURL:nil];
    }];
}

@end

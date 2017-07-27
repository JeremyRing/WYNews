//
//  JJNetWorkManager.m
//  WYNews
//
//  Created by 刘杰 on 2017/7/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "JJNetWorkManager.h"

@implementation JJNetWorkManager
+ (instancetype)sharedManager{
    static JJNetWorkManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 末尾要有反斜线
        NSURL *baseURL = [NSURL URLWithString:@"http://c.m.163.com/nc/article/"];
        
        instance = [[self alloc] initWithBaseURL:baseURL];
        
        // 设置相应的解析格式
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"*/*",nil];
        
    });
    
    return instance;
}

- (void)GETRequest:(NSString *)URLString parameters:(NSDictionary *)parameters completion:(void (^)(id json, NSError *error))completion{
    [self GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completion(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求错误 %@",error);
        
        completion(nil,error);
    }];
}

#pragma mark - 网易新闻接口

- (void)newsListWithChannel:(NSString *)channel start:(NSInteger)start completion:(void (^)(NSArray *, NSError *))completion {
    
    NSString *urlString = [NSString stringWithFormat:@"list/%@/%zd-20.html", channel, start];
    
    [self GETRequest:urlString parameters:nil completion:^(id json, NSError *error) {
        
        // 使用频道作为 key 获取数组
        NSArray *array = json[channel];
        
        completion(array, error);
    }];
}

@end

//
//  JJNetWorkManager.h
//  WYNews
//
//  Created by 刘杰 on 2017/7/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface JJNetWorkManager : AFHTTPSessionManager
+ (instancetype)sharedManager;

/**
 * 获取新闻数据列表
 */
- (void)newsListWithChannel:(NSString *)channel start:(NSInteger)start completion:(void (^)(NSArray *, NSError *))completion;

- (void)newsDetailWithDocid:(NSString *)docid completion:(void (^)(NSDictionary *dict,NSError *error))completion;
@end

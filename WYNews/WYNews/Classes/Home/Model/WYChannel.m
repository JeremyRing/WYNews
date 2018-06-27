//
//  WYChannel.m
//  WYNews
//
//  Created by 刘杰 on 2017/7/27.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "WYChannel.h"
#import "WYChannelView.h"

@implementation WYChannel
+ (NSArray <WYChannel *>*)channels{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"topic_news.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSArray *array = dict[@"tList"];
    
    NSArray *channels = [NSArray yy_modelArrayWithClass:[WYChannel class] json:array];
    
    // 根据 tid 排序:使用比较器排序
    return [channels sortedArrayUsingComparator:^NSComparisonResult(WYChannel *obj1, WYChannel *obj2) {
        return [obj1.tid compare:obj2.tid];
    }];
}
@end

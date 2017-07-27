//
//  UIImageView+JJWebImage.m
//  WYNews
//
//  Created by 刘杰 on 2017/7/27.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "UIImageView+JJWebImage.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (JJWebImage)
- (void)jj_setImageWithUrl:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSAssert(urlString != nil, @"使用JJWebImage请传入有效的url地址");
    
    [self sd_setImageWithURL:url];
}
@end

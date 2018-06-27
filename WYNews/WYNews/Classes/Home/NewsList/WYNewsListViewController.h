//
//  WYNewsListViewController.h
//  WYNews
//
//  Created by 刘杰 on 2017/7/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYNewsListViewController : UIViewController

@property (nonatomic, assign, readonly) NSInteger index;
@property (nonatomic, copy, readonly) NSString *tid;

- (instancetype)initWithChennalIndex:(NSInteger)index tid:(NSString *)tid;
@end

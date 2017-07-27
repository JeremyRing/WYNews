//
//  WYChannelView.h
//  WYNews
//
//  Created by 刘杰 on 2017/7/27.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  WYChannel;
@interface WYChannelView : UIView
+ (instancetype)channelView;

@property (nonatomic, strong) NSArray <WYChannel *> *channelList;
@end

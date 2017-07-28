//
//  WYChannelView.h
//  WYNews
//
//  Created by 刘杰 on 2017/7/27.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  WYChannel;
@interface WYChannelView : UIControl
+ (instancetype)channelView;

@property (nonatomic, strong) NSArray <WYChannel *> *channelList;

@property (nonatomic, assign, readonly) NSInteger seletedIndex;

- (void)setChannelSelected:(NSInteger)index scale:(CGFloat)scale;
@end

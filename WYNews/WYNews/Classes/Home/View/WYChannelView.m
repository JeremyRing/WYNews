//
//  WYChannelView.m
//  WYNews
//
//  Created by 刘杰 on 2017/7/27.
//  Copyright © 2017年 itcast. All rights reserved.
//

#define DefaultFontSize 14
#define BigFontSize 18

#import "WYChannelView.h"
#import "WYChannel.h"

@interface WYChannelView ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation WYChannelView

+ (instancetype)channelView{
    UINib *nib = [UINib nibWithNibName:@"WYChannelView" bundle:nil];
    return [nib instantiateWithOwner:nil options:0].lastObject;
}

- (void)setChannelList:(NSArray *)channelList{
    _channelList = channelList;
    
    CGFloat margin = 10;
    
    CGFloat edgeMargin = 15;
    
    CGFloat x = edgeMargin;
    
    NSUInteger index = 0;
    
    for (WYChannel *channel in _channelList) {
        // 创建 label
        UILabel *l = [UILabel cz_labelWithText:channel.tname fontSize:BigFontSize color:[UIColor blackColor]];
        
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont systemFontOfSize:DefaultFontSize];
        
        [self.scrollView addSubview:l];
        
        // 设置布局
        x += margin;
        
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(x);
        }];
        
        x += l.bounds.size.width;
        
        // 设置scrollView 滚动范围
        self.scrollView.contentSize = CGSizeMake(x + edgeMargin, 0);
        
        // 设置序号
        l.tag = index++;
    }
    
    [self setChannelSelected:0];
}

- (void)setChannelSelected:(NSInteger)index{
    UILabel *l = (UILabel *)self.scrollView.subviews[index];
    // 设置颜色和字体
    l.font = [UIFont systemFontOfSize:BigFontSize];
    l.textColor = [UIColor redColor];
}

@end

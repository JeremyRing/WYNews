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
        
        // 添加点击手势，监听点击事件
        l.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTheLabel:)];
        [l addGestureRecognizer:tap];
    }
    
    [self setChannelSelected:0 scale:1];
}

- (void)tapTheLabel:(UITapGestureRecognizer *)gesture{
    
    if (_seletedIndex == gesture.view.tag) {
        return;
    }
    
    // 取消之前选中状态
    [self setChannelSelected:_seletedIndex scale:0];
    
    // 设置新的index
    _seletedIndex = gesture.view.tag;
    
    // 设置新的选中状态
    [self setChannelSelected:_seletedIndex scale:1];
    
    // 发送事件
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setChannelSelected:(NSInteger)index scale:(CGFloat)scale{
    UILabel *l = (UILabel *)self.scrollView.subviews[index];
    // 设置颜色和字体
    
    // 14 - 18
    // 0  -  1
    
    CGFloat fontSize = DefaultFontSize + (BigFontSize - DefaultFontSize) * scale;
    
    l.font = [UIFont systemFontOfSize:fontSize];
    l.textColor = [UIColor colorWithRed:scale green:0 blue:0 alpha:1];
}

@end

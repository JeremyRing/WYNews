//
//  WYNewsListDefaultCell.h
//  WYNews
//
//  Created by 刘杰 on 2017/7/27.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYNewsListCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;

@end

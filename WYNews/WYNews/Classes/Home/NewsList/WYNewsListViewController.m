//
//  WYNewsListViewController.m
//  WYNews
//
//  Created by 刘杰 on 2017/7/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "WYNewsListViewController.h"
#import "WYNewsListCell.h"
#import "WYNewsItem.h"

@interface WYNewsListViewController ()<UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@end

static NSString *defaultCellId = @"defaultCellId";
static NSString *multiImageCellId = @"multiImageCellId";

@implementation WYNewsListViewController{
    NSArray <WYNewsItem *>*_newsItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self loadData];
}

- (void)loadData{
    
    [[JJNetWorkManager sharedManager] newsListWithChannel:@"T1348648517839" start:0 completion:^(NSArray *list, NSError *error) {
        if (error != nil) {
            NSLog(@"加载数据错误 %@error",error);
        }
        
        _newsItems = [NSArray yy_modelArrayWithClass:[WYNewsItem class] json:list];
        
        [self.tableView reloadData];
    }];
}

/// 搭建界面
- (void)setupUI{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.view = tableView;
    
    tableView.dataSource = self;
    
    self.tableView = tableView;
    
    // 注册默认的cell
    [tableView registerNib:[UINib nibWithNibName:@"WYNewsListDefaultCell" bundle:nil] forCellReuseIdentifier:defaultCellId];
    // 注册多图的cell
    [tableView registerNib:[UINib nibWithNibName:@"WYNewsListMultiImageCell" bundle:nil] forCellReuseIdentifier:multiImageCellId];
    
    // 设置自动行高
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 设置取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionP{
    return _newsItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WYNewsItem *model = _newsItems[indexPath.row];
    WYNewsListCell *cell;
    if (model.imgextra.count > 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:multiImageCellId forIndexPath:indexPath];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:defaultCellId forIndexPath:indexPath];
        
        cell.sourceLabel.text = model.source;
    }
    
    
    [cell.iconView jj_setImageWithUrl:model.imgsrc];
    cell.titleLabel.text = model.title;
    cell.replyLabel.text = @(model.replyCount).description;
    
    // 设置多图 － 如果没有不会进入循环
    NSInteger idx = 0;
    for (NSDictionary *dict in model.imgextra) {
        
        // 设置图像
        [cell.extraIcon[idx++] jj_setImageWithUrl:dict[@"imgsrc"]];
    }
    
    return cell;
}

@end













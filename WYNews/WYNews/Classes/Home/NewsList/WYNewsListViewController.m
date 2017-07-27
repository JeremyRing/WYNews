//
//  WYNewsListViewController.m
//  WYNews
//
//  Created by 刘杰 on 2017/7/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "WYNewsListViewController.h"
#import "WYNewsItem.h"

@interface WYNewsListViewController ()<UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@end

static NSString *defaultCellId = @"defaultCellId";

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
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:defaultCellId];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionP{
    return _newsItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellId forIndexPath:indexPath];
    
    WYNewsItem *model = _newsItems[indexPath.row];
    
    cell.textLabel.text = model.title;
    
    return cell;
}

@end













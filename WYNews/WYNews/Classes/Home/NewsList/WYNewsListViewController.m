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

NSString *const NewsListControllerSelectDocNotification = @"NewsListControllerSelectDocNotification";

@interface WYNewsListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@end

static NSString *defaultCellId = @"defaultCellId";
static NSString *multiImageCellId = @"multiImageCellId";
static NSString *bigImageCellId = @"bigImageCellId";
static NSString *headerCellId = @"headerCellId";

@implementation WYNewsListViewController{
    NSArray <WYNewsItem *>*_newsItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self loadData];
}

- (void)loadData{
    
    [[JJNetWorkManager sharedManager] newsListWithChannel:_tid start:0 completion:^(NSArray *list, NSError *error) {
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
    tableView.delegate = self;
    
    self.tableView = tableView;
    
    // 注册默认的cell
    [tableView registerNib:[UINib nibWithNibName:@"WYNewsListDefaultCell" bundle:nil] forCellReuseIdentifier:defaultCellId];
    // 注册多图的cell
    [tableView registerNib:[UINib nibWithNibName:@"WYNewsListMultiImageCell" bundle:nil] forCellReuseIdentifier:multiImageCellId];
    [tableView registerNib:[UINib nibWithNibName:@"WYNewsListBigImageCell" bundle:nil] forCellReuseIdentifier:bigImageCellId];
    [tableView registerNib:[UINib nibWithNibName:@"WYNewsListHeaderCell" bundle:nil] forCellReuseIdentifier:headerCellId];
    
    // 设置自动行高
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 设置取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置 contentInset
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionP{
    return _newsItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WYNewsItem *model = _newsItems[indexPath.row];
    
    NSString *cellId;
    if (model.hasHead) {
        cellId = headerCellId;
    } else if (model.imgType) {
        cellId = bigImageCellId;
    } else if (model.imgextra.count > 0) {
        cellId = multiImageCellId;
    } else {
        cellId = defaultCellId;
    }
    
    WYNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.sourceLabel.text = model.source;
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

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WYNewsItem *item = _newsItems[indexPath.row];
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:NewsListControllerSelectDocNotification object:item];
}

#pragma mark - obj method

- (instancetype)initWithChennalIndex:(NSInteger)index tid:(NSString *)tid{
    self = [super initWithNibName:nil bundle:nil];
    
    _index = index;
    _tid = tid;
    
    return self;
    
}

@end













//
//  WYHomeViewController.m
//  WYNews
//
//  Created by 刘杰 on 2017/7/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "WYHomeViewController.h"
#import "WYChannel.h"
#import "WYChannelView.h"
#import "WYNewsListViewController.h"

@interface WYHomeViewController ()
@property (nonatomic, weak) WYChannelView *channelView;
@property (nonatomic, weak) UIPageViewController *pageViewController;
@end

@implementation WYHomeViewController{
    NSArray <WYChannel *>*_channelList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self loadData];
    
    self.channelView.channelList = _channelList;
}

/// 搭建界面
- (void)setupUI{
    WYChannelView *channelView = [WYChannelView channelView];
    [self.view addSubview:channelView];
    
    [channelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(38);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
    }];
    
    self.channelView = channelView;
    
    // setup page view controller
    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:0];
    
    WYNewsListViewController *newsListVC = [WYNewsListViewController new];
    
    [pageViewController setViewControllers:@[newsListVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    
    [pageViewController didMoveToParentViewController:self];
    
    // set frame
    [pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.channelView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}

/**
 * 加载数据
 */
- (void)loadData{
    [self loadChannelList];
}

- (void)loadChannelList{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"topic_news.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSArray *array = dict[@"tList"];
    
    _channelList = [NSArray yy_modelArrayWithClass:[WYChannel class] json:array];
}

@end

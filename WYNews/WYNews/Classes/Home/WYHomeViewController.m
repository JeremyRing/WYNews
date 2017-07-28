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

@interface WYHomeViewController ()<UIPageViewControllerDataSource>
@property (nonatomic, weak) WYChannelView *channelView;
@property (nonatomic, weak) UIPageViewController *pageViewController;
@end

@implementation WYHomeViewController{
    NSArray <WYChannel *>*_channelList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _channelList = [WYChannel channels];
    
    [self setupUI];
    
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
    
    WYNewsListViewController *newsListVC = [[WYNewsListViewController alloc] initWithChennalIndex:0 tid:_channelList[0].tid];
    
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
    
    // set page view controller's datasource & delegate
    pageViewController.dataSource = self;
}


#pragma mark - UIPageViewControllerDataSource

// 返回前一个控制器
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    // 获取当前显示频道的索引（让控制器来保存索引），-1
    WYNewsListViewController *currentVC = (WYNewsListViewController *)viewController;
    NSInteger currentIndex = currentVC.index;
    if (currentIndex == 0) {
        NSLog(@"没有了");
        return nil;
    }
    NSInteger afterIndex = currentIndex - 1;
    
    // 根据新的索引创建控制器，
    WYNewsListViewController *vc = [[WYNewsListViewController alloc] initWithChennalIndex:afterIndex tid:_channelList[afterIndex].tid];
    
    return vc;
}

// 返回后面一个控制器
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    // 获取当前显示频道的索引（让控制器来保存索引），+1
    WYNewsListViewController *currentVC = (WYNewsListViewController *)viewController;
    NSInteger currentIndex = currentVC.index;
    NSInteger afterIndex = currentIndex + 1;
    
    // 根据新的索引创建控制器，
    WYNewsListViewController *vc = [[WYNewsListViewController alloc] initWithChennalIndex:afterIndex tid:_channelList[afterIndex].tid];
    
    return vc;
    
}








@end

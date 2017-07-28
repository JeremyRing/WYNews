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
#import "WYDetailViewController.h"
#import "WYNewsItem.h"

extern NSString *const NewsListControllerSelectDocNotification;

@interface WYHomeViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

/**
 * 频道视图
 */
@property (nonatomic, weak) WYChannelView *channelView;

/**
 * 分页控制器
 */
@property (nonatomic, weak) UIPageViewController *pageViewController;

/**
 * 分页控制器里面的scrollview
 */
@property (nonatomic, weak) UIScrollView *pageViewScrollView;

/**
 * 当前显示页面的index
 */
@property (nonatomic, assign) NSInteger currentIndex;

/**
 * 将要显示页面的index
 */
@property (nonatomic, assign) NSInteger nextIndex;
@end

@implementation WYHomeViewController{
    NSArray <WYChannel *>*_channelList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _channelList = [WYChannel channels];
    
    [self setupUI];
    
    self.channelView.channelList = _channelList;
    
    // 添加 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateToDetailPage:) name:NewsListControllerSelectDocNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)navigateToDetailPage:(NSNotification *)n{
    
    WYNewsItem *item = n.object;
    
    WYDetailViewController *vc = [WYDetailViewController new];
    vc.docid = item.docid;
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
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
    
    // add event observer
    [channelView addTarget:self action:@selector(didSelectChannel) forControlEvents:UIControlEventValueChanged];
    
    // setup page view controller
    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:0];
    
    _currentIndex = 0;
    WYNewsListViewController *newsListVC = [[WYNewsListViewController alloc] initWithChennalIndex:0 tid:_channelList[_currentIndex].tid];
    
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
    pageViewController.delegate = self;
    
    self.pageViewController = pageViewController;
    
    // KVO observe page view controller's scrollview's contentOffset
    UIScrollView *scrollView = (UIScrollView *)pageViewController.view.subviews[0];
    _pageViewScrollView = scrollView;
    
}

#pragma mark - event Observe method
- (void)didSelectChannel{
    
    // 设置默认方向
    UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionForward;
    if (_channelView.seletedIndex < _currentIndex) {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    _currentIndex = _channelView.seletedIndex;
    // 设置新的页面
    WYNewsListViewController *vc = [[WYNewsListViewController alloc] initWithChennalIndex:_currentIndex tid:_channelList[_currentIndex].tid];
    
    [self.pageViewController setViewControllers:@[vc] direction:direction animated:YES completion:nil];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    // 思考：移动偏移量(0-1) 和 channel字体大小之间的关系(14-18)
    
    int distance = ABS(_pageViewScrollView.contentOffset.x - _pageViewScrollView.bounds.size.width);
    
    float scale = distance / _pageViewScrollView.bounds.size.width;
    
    // 设置当前channel颜色大小，这里不能直接获取到当前channel.tid,所以要提前保存tid
    [_channelView setChannelSelected:_currentIndex scale:1-scale];
    [_channelView setChannelSelected:_nextIndex scale:scale];
    
}

#pragma mark - UIPageViewControllerDelegate
// 开始转场的代理方法
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{

    // 只能在转场动画一开始的时候设置，当前index 和 下一页index
    _currentIndex = ((WYNewsListViewController *)pageViewController.viewControllers[0]).index;
    _nextIndex = ((WYNewsListViewController *)pendingViewControllers[0]).index;
    
    // 添加 KVO 监听
    [_pageViewScrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:NULL];
}

// 结束转场的代理方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    
    // 移除 KVO 监听
    // 保证 在多次删除一个监听者时程序不崩溃
    @try {
        [_pageViewScrollView removeObserver:self forKeyPath:@"contentOffset"];
    } @catch (NSException *exception) {
        NSLog(@"ex");
    } @finally {
        
    }
    
}

#pragma mark - UIPageViewControllerDataSource
/// page view controller 最多能准备三个控制器，当需要准备新的控制器的时候才会调用数据源方法
// 返回前一个控制器
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    // 获取当前显示频道的索引（让控制器来保存索引），-1
    WYNewsListViewController *currentVC = (WYNewsListViewController *)viewController;
    NSInteger currentIndex = currentVC.index;
    
    // 判断越界
    if (currentIndex == 0) {
        return nil;
    }
    NSInteger nextIndex = currentIndex - 1;
    
    // 根据新的索引创建控制器，
    WYNewsListViewController *vc = [[WYNewsListViewController alloc] initWithChennalIndex:nextIndex tid:_channelList[nextIndex].tid];
    
    return vc;
}

// 返回后面一个控制器
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    // 获取当前显示频道的索引（让控制器来保存索引），+1
    WYNewsListViewController *currentVC = (WYNewsListViewController *)viewController;
    NSInteger currentIndex = currentVC.index;
    
    // 判断越界
    if (_currentIndex == _channelList.count - 1) {
        return nil;
    }
    
    NSInteger nextIndex = currentIndex + 1;

    // 根据新的索引创建控制器，
    WYNewsListViewController *vc = [[WYNewsListViewController alloc] initWithChennalIndex:nextIndex tid:_channelList[nextIndex].tid];
    
    return vc;
    
}








@end

//
//  WYNewsMainViewController.m
//  WYNews
//
//  Created by 刘杰 on 2017/7/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "WYNewsMainViewController.h"

@interface WYNewsMainViewController ()

@end

@implementation WYNewsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setChildViewControllers];
    
    [self setAppearance];
}

- (void)setAppearance{
//    [self.tabBar setTintColor:[UIColor cz_colorWithHex:0xDF0000]];
    [[UITabBar appearance] setTintColor:[UIColor cz_colorWithHex:0xDF0000]];
}

- (void)setChildViewControllers{
    UIViewController *newsVC = [self addChildControllerWithClsName:@"WYHomeViewController" title:@"首页" imageName:@"tabbar_news" selectedImageName:@"tabbar_news_highlighted"];
    UIViewController *importantNewsVC = [self addChildControllerWithClsName:@"UIViewController" title:@"要闻" imageName:@"tabbar_icon_importantNews_normal" selectedImageName:@"tabbar_icon_importantNews_highlight"];
    UIViewController *liveVC = [self addChildControllerWithClsName:@"UIViewController" title:@"直播" imageName:@"tabbar_icon_live_normal" selectedImageName:@"tabbar_icon_live_highlight"];
    UIViewController *videoVC = [self addChildControllerWithClsName:@"UIViewController" title:@"视频" imageName:@"tabbar_video" selectedImageName:@"tabbar_video_highlighted"];
    UIViewController *mineVC = [self addChildControllerWithClsName:@"UIViewController" title:@"我" imageName:@"tabbar_icon_me_normal" selectedImageName:@"tabbar_icon_me_highlight"];
    
    self.viewControllers = @[newsVC,importantNewsVC,liveVC,videoVC,mineVC];
    
}

- (UIViewController *)addChildControllerWithClsName:(NSString *)clsName title:(NSString *)title imageName:(NSString *)imgName selectedImageName:(NSString *)selImageName{
    Class cls = NSClassFromString(clsName);
    
    NSAssert(cls != nil, @"传入错误的控制器名称");
    
    UIViewController *vc = [cls new];
    
    vc.view.backgroundColor = [UIColor whiteColor];
    
    vc.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    return nav;
}



@end

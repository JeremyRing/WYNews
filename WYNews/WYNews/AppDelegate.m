//
//  AppDelegate.m
//  WYNews
//
//  Created by 刘杰 on 2017/7/25.
//  Copyright © 2017年 itcast. All rights reserved.
/* 开开心心开始 coding */

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    Class cls = NSClassFromString(@"WYNewsMainViewController");
    
    UIViewController *rootVC = [cls new];
    
    rootVC.view.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = rootVC;
    
    [self.window makeKeyAndVisible];
    
    [self setAppearance];
    
    return YES;
}

- (void)setAppearance{
    [[UITabBar appearance] setTintColor:[UIColor cz_colorWithHex:0xDF0000]];
    
    
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor cz_colorWithHex:0xDD3237]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
@end

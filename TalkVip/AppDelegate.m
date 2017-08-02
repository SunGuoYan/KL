//
//  AppDelegate.m
//  TalkVip
//
//  Created by SunGuoYan on 17/3/16.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MainVC.h"
#import "LoginVC.h"
#import "UIImageView+WebCache.h"
@interface AppDelegate ()
{
    BOOL isNetwork;
}
@end

@implementation AppDelegate

-(BOOL)startMonitoring{
    
    AFNetworkReachabilityManager *manager=[AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            isNetwork = NO;
        }else{
            isNetwork = YES;
        }
    }];
    
    return isNetwork;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [NSThread sleepForTimeInterval:1.0];//设置启动页面时间
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIStoryboard *sb_My = [UIStoryboard storyboardWithName:@"My" bundle:nil];
    LoginVC *vc=[sb_My instantiateViewControllerWithIdentifier:NSStringFromClass([LoginVC class])];
    UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:vc];
    
    UIStoryboard *sb_main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainVC *vc_MainVC=[sb_main instantiateViewControllerWithIdentifier:NSStringFromClass([MainVC class])];
    UINavigationController *nvc_MainVC=[[UINavigationController alloc]initWithRootViewController:vc_MainVC];
    
    BOOL result=[NSUserDefaults isLogin];
    
    if (result==YES) {
        self.window.rootViewController=nvc_MainVC;
    }else{
        //登录
        self.window.rootViewController=nvc;
    }
    
//    [self setLauncherImage];
    
    return YES;
}
-(void)setLauncherImage{
    
    __block NSString *imageUrl=nil;
    NSString *api=@"/Agreement/getImgUrl";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl_mt,api];
    [NetWorkManager loadDateWithToken:NO andWithUrl:urlStr andPara:nil andSuccess:^(NSDictionary *responseObject) {
        
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            imageUrl=[NSString stringWithFormat:@"%@%@",baseUrl_mt,responseObject[@"data"][@"url"]];
            UIImageView *imagev=[[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [imagev sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
            
            [[UIApplication sharedApplication].keyWindow addSubview:imagev];
            float w=imagev.frame.size.width;
            float h=imagev.frame.size.height;
            
            [UIView animateWithDuration:3.0 animations:^{
                imagev.frame=CGRectMake(0, 0, w+0.01, h+0.01);
            } completion:^(BOOL finished) {
                [imagev removeFromSuperview];
            }];
        }
    } andfailure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
   
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

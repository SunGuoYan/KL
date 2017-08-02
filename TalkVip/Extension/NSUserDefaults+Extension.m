//
//  NSUserDefaults+Extension.m
//  UIImage的截屏
//
//  Created by SunGuoYan on 17/2/13.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "NSUserDefaults+Extension.h"

@implementation NSUserDefaults (Extension)
+(void)setObject:(id)object ForKey:(NSString *)key{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}
+(id)getObjectForKey:(NSString *)key{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    id object=[defaults objectForKey:key];
    return object;
}
+(void)removeObjectForKey:(NSString *)key{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}
//判断是不是第一次运行（是不是新版本）
+(BOOL)isFirstBuldVesion{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"defaults：%@",[defaults objectForKey:@"Vesion"]);
    if ([defaults objectForKey:@"Vesion"]) {
        
        //读取本地plist文件的版本号
        NSString * systemVesion = [[NSBundle mainBundle]objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
        NSLog(@"systemVesion:%@",systemVesion);
        BOOL isFirstV = [systemVesion isEqualToString:[defaults objectForKey:@"Vesion"]];
        //不论是不是当前版本 都存入新值
        [defaults setObject:systemVesion forKey:@"Vesion"];
        [defaults synchronize];
        
        //比较存入的版本号是否相同 如果相同则进入tabBar页面否则进入滚动视图
        if (isFirstV) {
            return NO;
        }
        return YES;
    }
    NSString * systemVesion = [[NSBundle mainBundle]objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSLog(@"systemVesion:%@",systemVesion);
    [defaults setObject:systemVesion forKey:@"Vesion"];
    [defaults synchronize];
    
    return YES;
}
//判断是否登录
+ (BOOL)isLogin {
    //TODO: remove test
    
    //这里测试直接返回YES，所以永远是登录状态，做的时候把YES注掉
    
    //    return YES;
    //登录之后，用NSUserDefaults 将@"accountId"的value设置为YES
    //注销登录之后，将@"accountId"的value设置为nil
    
    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"];
    return currentUserId != nil ? YES : NO;
}
@end

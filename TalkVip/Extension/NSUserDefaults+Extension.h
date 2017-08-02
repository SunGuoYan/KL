//
//  NSUserDefaults+Extension.h
//  UIImage的截屏
//
//  Created by SunGuoYan on 17/2/13.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Extension)
/*
 * NSUserDefaults 存值
 */
+(void)setObject:(id)object ForKey:(NSString *)key;
/*
 * NSUserDefaults 取值
 */
+(id)getObjectForKey:(NSString *)key;
/*
 * NSUserDefaults 删值
 */
+(void)removeObjectForKey:(NSString *)key;

+(BOOL)isFirstBuldVesion;

+ (BOOL)isLogin;
@end

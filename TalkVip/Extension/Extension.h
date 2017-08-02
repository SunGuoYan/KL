//
//  Extension.h
//  Tools
//
//  Created by SunGuoYan on 17/2/22.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#ifndef Extension_h
#define Extension_h

/*
 判断手机尺寸的宏定义
 */
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#import "UILabel+Create.h"
#import "UIButton+Create.h"
#import "UIScrollView+Create.h"
#import "UIImageView+Create.h"
#import "UIView+Frame.h"
#import "NSUserDefaults+Extension.h"
#import "NSString+Extension.h"
#import "UIImage+Extension.h"
#import "UIImage+Extension.h"
#import "UIColor+Extension.h"
#endif /* Extension_h */

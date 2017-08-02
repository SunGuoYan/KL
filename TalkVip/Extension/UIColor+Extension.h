//
//  UIColor+Extension.h
//  Tools
//
//  Created by SunGuoYan on 17/2/22.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)
/**
 *  16进制颜色转化为UIColor
 *  eg. #52AC41 -->浅绿色
 */
+(UIColor *)colorWithHexString:(NSString *)hexColor;
@end

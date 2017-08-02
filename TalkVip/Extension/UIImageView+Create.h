//
//  UIImageView+Create.h
//  UIImage的截屏
//
//  Created by SunGuoYan on 17/2/13.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Create)
/**
 * 工厂模式 create UIImageView
 */
+(UIImageView *)imageWithFrame:(CGRect)frame Image:(NSString *)imageName BgColor:(UIColor *)color;
/**
 * 截图 rect为截屏的大小
 */
+ (UIImage *)getCapturedScreenWithRect:(CGRect)rect;
@end

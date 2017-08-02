//
//  UIImage+Extension.m
//  自定义TabBar
//
//  Created by SunGuoYan on 17/2/22.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
+ (UIImage *)imageWithOriginalRenderingMode:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end

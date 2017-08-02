//
//  UIImageView+Create.m
//  UIImage的截屏
//
//  Created by SunGuoYan on 17/2/13.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "UIImageView+Create.h"

@implementation UIImageView (Create)
+(UIImageView *)imageWithFrame:(CGRect)frame Image:(NSString *)imageName BgColor:(UIColor *)color{
    UIImageView *imageV=[[UIImageView alloc] initWithFrame:frame];
    if (imageName) {
        imageV.image=[UIImage imageNamed:imageName];
    }
    if (color) {
        imageV.backgroundColor=color;
    }
    return imageV;
}
+ (UIImage *)getCapturedScreenWithRect:(CGRect)rect
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//    CGRect rect = [keyWindow bounds];
   // CGRect rect=[UIScreen mainScreen].bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return capturedScreen;
}
@end

//
//  UIScrollView+Create.h
//  TalkVip
//
//  Created by SunGuoYan on 2017/7/21.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Create)
+(UIScrollView *)scrollWithFrame:(CGRect)frame pagingEnabled:(BOOL)isPage backgroundColor:(UIColor *)color contentSize:(CGSize)contentSize Indicator:(BOOL)isIndicator bounces:(BOOL)isBounce;
@end

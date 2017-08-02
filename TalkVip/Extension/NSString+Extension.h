//
//  NSString+Extension.h
//  UIImage的截屏
//
//  Created by SunGuoYan on 17/2/13.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Extension)
/**
 * 返回文本高度
 * size 字体大小
 * width 文本宽度
 */
-(CGSize)getFrameWithSize:(NSInteger)size andWidth:(CGFloat)width;
/*
 * 返回文字宽度
 */
-(CGFloat)getWidthWithSize:(NSInteger)size;
/*
 * 手机号的正则表达式
 */
-(BOOL)isValidatePhone;
@end

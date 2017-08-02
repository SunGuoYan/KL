//
//  UILabel+Create.h
//  happytoo
//
//  Created by william on 14-6-9.
//  Copyright (c) 2014年 etu6. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Create)
+ (UILabel *)labelWithFrame:(CGRect)frame withTest:(NSString *)text titleFontSize:(float)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)bgColor alignment:(NSTextAlignment)textAlignment;

@end

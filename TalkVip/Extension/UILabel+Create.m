//
//  UILabel+Create.m
//  happytoo
//
//  Created by william on 14-6-9.
//  Copyright (c) 2014年 etu6. All rights reserved.
//

#import "UILabel+Create.h"

@implementation UILabel (Create)
+ (UILabel *)labelWithFrame:(CGRect)frame withTest:(NSString *)text titleFontSize:(float)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)bgColor alignment:(NSTextAlignment)textAlignment{
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if (text) {
        label.text = text;
    }
    if (font) {
        label.font = [UIFont systemFontOfSize:font];
    }
    if (textColor) {
        label.textColor = textColor;
    }
    if (bgColor) {
        label.backgroundColor = bgColor;
    }
    if (textAlignment) {
        label.textAlignment = textAlignment;
    }
    
    return label;
}




@end

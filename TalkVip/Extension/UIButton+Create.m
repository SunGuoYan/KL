//
//  UIButton+Create.m
//  NT
//
//  Created by Kohn on 14-5-27.
//  Copyright (c) 2014年 Pem. All rights reserved.
//

#import "UIButton+Create.h"

@implementation UIButton (Create)
+ (UIButton *) buttonWithFrame:(CGRect)frame Title:(NSString *)title BgColor:(UIColor *)bgColor Image:(NSString *)image Target:(id)target Selector:(SEL)selector{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (bgColor) {
        button.backgroundColor=bgColor;
    }
    if (image) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    if (target&&selector) {
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    
    return button;
}
/*
+ (UIButton*) createButtonWithFrame: (CGRect) frame Target:(id)target Selector:(SEL)selector Image:(NSString *)image ImagePressed:(NSString *)imagePressed
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];

    [button setBackgroundImage:PNGIMAGE(image) forState:UIControlStateNormal];
    [button setBackgroundImage:PNGIMAGE(imagePressed) forState:UIControlStateHighlighted];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *) createButtonWithFrame:(CGRect)frame Title:(NSString *)title TitleFont:(float)font TitleColor:(UIColor *)color Tag:(NSInteger)tag Target:(id)target Selector:(SEL)selector Alignment:(UIControlContentHorizontalAlignment)alignment
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = SYSTEMFONT(font);
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setContentHorizontalAlignment:alignment];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton*) createButtonWithFrame: (CGRect) frame Tag:(NSInteger)tag Target:(id)target Selector:(SEL)selector Image:(NSString *)image ImagePressed:(NSString *)imagePressed
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    UIImage *newImage = PNGIMAGE(image);
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
    UIImage *newPressedImage = PNGIMAGE(imagePressed);
    [button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
    button.tag = tag;
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}


+ (UIButton *) buttonWithFrame:(CGRect)frame Title:(NSString *)title Image:(UIImage *image) BackgImage:(UIImage *)bgImage backGroundColor:(UIColor *)bgColor    Target:(id)target Selector:(SEL)selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (image) {
        <#statements#>
    }
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = SYSTEMFONT(font);
    
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

*/
@end

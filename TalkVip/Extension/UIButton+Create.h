//
//  UIButton+Create.h
//  NT
//
//  Created by Kohn on 14-5-27.
//  Copyright (c) 2014年 Pem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Create)

+ (UIButton *) buttonWithFrame:(CGRect)frame Title:(NSString *)title BgColor:(UIColor *)bgColor Image:(NSString *)image Target:(id)target Selector:(SEL)selector;


@end

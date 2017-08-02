//
//  SGYTextView.h
//  UItextView+placeholder
//
//  Created by SunGuoYan on 2017/5/6.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGYTextView : UITextView

//文字
@property(nonatomic,copy) NSString *myPlaceholder;
//文字颜色
@property(nonatomic,strong) UIColor *myPlaceholderColor;

@end

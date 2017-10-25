//
//  BeforeVC.h
//  TalkVip
//
//  Created by mac on 2017/8/21.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import <UIKit/UIKit.h>

//点击确认回调
typedef void(^MyBlock)(NSString *currentState);

@interface BeforeVC : UIViewController
@property(nonatomic,copy)NSString *accountID_str;
@property(nonatomic,copy)NSString *descriptionLab_str;

//未拨打时添加备注的回调
@property(nonatomic,copy)MyBlock block;
@end

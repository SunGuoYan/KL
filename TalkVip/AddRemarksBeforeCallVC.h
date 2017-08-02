//
//  AddRemarksBeforeCallVC.h
//  TalkVip
//
//  Created by SunGuoYan on 17/4/20.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import <UIKit/UIKit.h>

//点击确认回调
typedef void(^MyBlock)(NSString *currentState);

@interface AddRemarksBeforeCallVC : UIViewController
@property(nonatomic,copy)NSString *id_str;
@property(nonatomic,copy)NSString *type;

//未拨打时添加备注的回调
@property(nonatomic,copy)MyBlock block;
@end

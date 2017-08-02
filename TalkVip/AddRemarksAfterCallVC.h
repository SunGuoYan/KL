//
//  AddRemarksAfterCallVC.h
//  TalkVip
//
//  Created by SunGuoYan on 17/4/13.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import <UIKit/UIKit.h>

//点击确认回调
typedef void(^SaveBlock)(NSString *currentState);

@interface AddRemarksAfterCallVC : UIViewController
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger index;

//拨打后 添加备注的回调
@property(nonatomic,copy)SaveBlock block;

@property(nonatomic,copy)NSString *type;
@end

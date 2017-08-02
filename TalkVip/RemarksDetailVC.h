//
//  RemarksDetailVC.h
//  TalkVip
//
//  Created by SunGuoYan on 17/4/7.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListModel.h"
@interface RemarksDetailVC : UIViewController

//正向传值
@property(nonatomic,strong)ListModel *model;

//拨打电话备用
@property(nonatomic,strong)NSMutableArray *targetArray;
@property(nonatomic,assign)NSInteger index;
@end

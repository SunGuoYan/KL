//
//  ListModel.h
//  TalkVip
//
//  Created by SunGuoYan on 2017/5/4.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListModel : NSObject

@property(nonatomic,copy)NSString *id_str;
@property(nonatomic,copy)NSString *inputtime;
//@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *sourceid;

//未拨打，待跟进等
@property(nonatomic,copy)NSString *type;

@property(nonatomic,copy)NSString *notifyURL;
@end

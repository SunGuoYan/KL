//
//  MyCell.h
//  TalkVip
//
//  Created by SunGuoYan on 17/3/16.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void (^Block)(NSInteger index);
@interface MyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *laba;
@property (weak, nonatomic) IBOutlet UILabel *labb;
@property (weak, nonatomic) IBOutlet UILabel *labc;
@property (weak, nonatomic) IBOutlet UILabel *labd;


@property (nonatomic, copy) Block block;
@property (nonatomic, assign) NSInteger index;
@end

//
//  RemarksDetailCell.h
//  TalkVip
//
//  Created by SunGuoYan on 17/4/7.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RemarksModel;
@interface RemarksDetailCell : UITableViewCell
//2017-2-1
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
//11：37
@property (weak, nonatomic) IBOutlet UILabel *minLab;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIImageView *imageVb;




@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *remarks;
@property(nonatomic,strong)RemarksModel *model;
@property (weak, nonatomic) IBOutlet UIView *linea;
@property (weak, nonatomic) IBOutlet UIView *lineb;



@end

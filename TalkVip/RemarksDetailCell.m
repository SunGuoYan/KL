//
//  RemarksDetailCell.m
//  TalkVip
//
//  Created by SunGuoYan on 17/4/7.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "RemarksDetailCell.h"
#import "RemarksModel.h"
@implementation RemarksDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(RemarksModel *)model{
    _model=model;
    
    NSDate * nowTime = [NSDate dateWithTimeIntervalSince1970:model.date.integerValue];
    
    NSDateFormatter * formatter_date = [[NSDateFormatter alloc]init];
    [formatter_date setDateFormat:@"YYYY-MM-dd"];
    
    NSDateFormatter * formatter_min = [[NSDateFormatter alloc]init];
    [formatter_min setDateFormat:@"HH:mm:ss"];
    
    _dateLab.text=[formatter_date stringFromDate:nowTime];
    _minLab.text=[formatter_min stringFromDate:nowTime];
    
    
    
    
    if (model.time.length) {
        NSInteger second=model.time.integerValue;
        if (second==0) {
            _time.text=@"00:00";
        }else if (second<10) {
            _time.text=[NSString stringWithFormat:@"00:0%@",model.time];
        }else if (second<60){
            _time.text=[NSString stringWithFormat:@"00:%@",model.time];
        }else{//>60s
            NSInteger min=second/60;
            NSInteger sec=second-min*60;
            NSString *a=nil;
            NSString *b=nil;
            if (min<10) {
                a=[NSString stringWithFormat:@"0%ld",min];
            }else{
                a=[NSString stringWithFormat:@"%ld",min];
            }
            if (sec<10) {
                b=[NSString stringWithFormat:@"0%ld",sec];
            }else{
                b=[NSString stringWithFormat:@"%ld",sec];
            }
            _time.text=[NSString stringWithFormat:@"%@:%@",a, b];
        }
//        _time.text=model.time;
    }
    //time 通话时长
    //注意这里拨打之前的备注是没有通话时长的
    if ([model.time isEqualToString:@"<null>"]) {
        _time.hidden=YES;
        _imageV.image=[UIImage imageNamed:@"shijianz_beizhu"];
        _imageVb.hidden=YES;
    }else{
        _time.hidden=NO;
        _imageV.image=[UIImage imageNamed:@"shijianzhou_call"];
        _imageVb.hidden=NO;
    }
    
    
    CGSize size=[model.remarks getFrameWithSize:15 andWidth:screenW-100];
    _remarks.frame=CGRectMake(10, 70+10, screenW-120, size.height);
    
    
    if (model.remarks.length==0) {
        _remarks.text=@"暂无备注";
    }else{
        _remarks.text=model.remarks;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  MyCell.m
//  TalkVip
//
//  Created by SunGuoYan on 17/3/16.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.laba.layer.cornerRadius=20;
    self.laba.layer.masksToBounds=YES;
    
//    默认隐藏
    self.laba.hidden=YES;
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}
#pragma mark --- 点击cell上面的btn
- (IBAction)cellBtnCliked:(UIButton *)sender {
    if (self.block)
    {
        self.block(self.index);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

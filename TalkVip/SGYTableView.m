//
//  SGYTableView.m
//  TalkVip
//
//  Created by SunGuoYan on 2017/7/21.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "SGYTableView.h"

@implementation SGYTableView
/**
 注意：这里重写构造方法不同于类别
 类别是增加一些方法 属性
 重写构造是重写方法 初始化一些属性
 */
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self=[super initWithFrame:frame style:style];
    
    if (self) {
        self.tableFooterView=[[UIView alloc] init];
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

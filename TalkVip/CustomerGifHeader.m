//
//  CustomerGifHeader.m
//  TalkVip
//
//  Created by SunGuoYan on 17/4/11.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "CustomerGifHeader.h"

@implementation CustomerGifHeader
#pragma mark - 重写父类的方法
- (void)prepare{
    [super prepare];
    
    NSMutableArray *arr=[NSMutableArray array];
    
    NSInteger j=0;
    while (1) {
        UIImage *image=[[UIImage imageNamed:[NSString stringWithFormat:@"2_000%ld",j] ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        if (!image) {
            break;
        }
        [arr addObject:image];
        j++;
    }
    
    
//    for (int i=0; i<32; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"1_000%d", i]];
//        [arr addObject:image];
//    }
    
    //1.设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i*10]];
        [idleImages addObject:image];
    }
    [self setImages:arr forState:MJRefreshStateIdle];
    
    //2.设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:arr forState:MJRefreshStatePulling];
    
    //3. 设置正在刷新状态的动画图片
    [self setImages:arr forState:MJRefreshStateRefreshing];
    
    //隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    //隐藏状态
    self.stateLabel.hidden = YES;
}

@end

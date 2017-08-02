//
//  IndicaterView.m
//  ChargingStationHelper
//
//  Created by SunGuoYan on 16/10/8.
//  Copyright © 2016年 com.iycharge. All rights reserved.
//

#import "IndicaterView.h"

@implementation IndicaterView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView *grayBackground=[[UIView alloc]initWithFrame:frame];
        grayBackground.userInteractionEnabled=YES;
        grayBackground.backgroundColor=[UIColor whiteColor];
//        grayBackground.backgroundColor=[UIColor grayColor];
//        grayBackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:grayBackground];
        
        CGFloat loadW=750;
        CGFloat loadH=800;
        
        _imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenW*loadH/loadW)];
        _imageV.center=CGPointMake(screenW/2, screenH/2);
        [grayBackground addSubview:_imageV ];
        
        NSMutableArray *imageArr=[[NSMutableArray alloc] init];
        
        for (int i=0; i<37; i++) {
            UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"loading_000%d",i]];
            
            [imageArr addObject:image];
        }
        
        _imageV.animationImages =imageArr ;
        _imageV.animationDuration = 3.7f/2;
        _imageV.animationRepeatCount = CGFLOAT_MAX;
        
        //开始等待加载符
      //  _imageV.hidden = NO;
        [_imageV startAnimating];
    }
    return self;
}

@end

//
//  CustomerIndicater.m
//  TalkVip
//
//  Created by SunGuoYan on 2017/5/25.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "CustomerIndicater.h"

@implementation CustomerIndicater

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView *grayBackground=[[UIView alloc]initWithFrame:frame];
        grayBackground.userInteractionEnabled=YES;
        grayBackground.backgroundColor=[UIColor whiteColor];
        [self addSubview:grayBackground];
        
        CGFloat loadW=750;
        CGFloat loadH=800;
        
        _imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        _imageV.center=CGPointMake(screenW/2, screenH/2);
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

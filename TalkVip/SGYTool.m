//
//  SGYTool.m
//  TalkVip
//
//  Created by SunGuoYan on 2017/7/21.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "SGYTool.h"

@implementation SGYTool
+(void)setViewHidden:(NSArray <UIView *>*)array withState:(BOOL)state{
    if (array.count>0) {
        for (UIView *obj in array) {
            obj.hidden=state;
        }
    }
}
+(void)setImageV:(NSArray <UIImageView *>*)array withImageName:(NSString *)name{
    if (array.count>0) {
        for (UIImageView *imageV in array) {
            imageV.image=[UIImage imageNamed:name];
        }
    }
}
+(void)pushWithStoryBoard:(NSString *)name from:(UINavigationController *)nvc to:(NSString *)vc{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    
//    UIViewController *toVC=[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([vc class])];
    UIViewController *toVC=[storyboard instantiateViewControllerWithIdentifier:vc];
    [nvc pushViewController:toVC animated:YES];
}
+(NSString *)getDateWithFormat:(NSString *)formate{
    NSDate * nowTime = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formate];
    NSString * timeStr = [formatter stringFromDate:nowTime];
    return timeStr;
}
//工厂模式
+(UIImageView *)creatImageVWithFrame:(CGRect)frame andImage:(UIImage *)image andHidden:(BOOL)state andCenter:(CGPoint)point{
    UIImageView *imageV=[[UIImageView alloc] initWithFrame:frame];
    imageV.image=image;
    imageV.hidden=state;
    imageV.center=point;
    return imageV;
}
+(UIProgressView *)creatWithFrame:(CGRect)frame andCenter:(CGPoint)point andProgressTintColor:(UIColor *)colorA andTrackTintColor:(UIColor *)colorB andProgress:(CGFloat)progress{
    UIProgressView *progressView=[[UIProgressView alloc]initWithFrame:frame];
    progressView.center=point;
    
    progressView.progressTintColor=colorA;
    progressView.trackTintColor=colorB;
    //设置进度值，范围是0.0-1.0
    progressView.progress=progress;
    return progressView;
}

@end

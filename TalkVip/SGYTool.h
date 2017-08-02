//
//  SGYTool.h
//  TalkVip
//
//  Created by SunGuoYan on 2017/7/21.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SGYTool : NSObject
+(void)setViewHidden:(NSArray <UIView *>*)array withState:(BOOL)state;
+(void)setImageV:(NSArray <UIImageView *>*)array withImageName:(NSString *)name;
+(void)pushWithStoryBoard:(NSString *)name from:(UINavigationController *)nvc to:(NSString *)vc;
+(NSString *)getDateWithFormat:(NSString *)formate;
+(UIImageView *)creatImageVWithFrame:(CGRect)frame andImage:(UIImage *)image andHidden:(BOOL)state andCenter:(CGPoint)point;
+(UIProgressView *)creatWithFrame:(CGRect)frame andCenter:(CGPoint)point andProgressTintColor:(UIColor *)colorA andTrackTintColor:(UIColor *)colorB andProgress:(CGFloat)progress;
@end

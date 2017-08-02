//
//  UIScrollView+Create.m
//  TalkVip
//
//  Created by SunGuoYan on 2017/7/21.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "UIScrollView+Create.h"

@implementation UIScrollView (Create)
+(UIScrollView *)scrollWithFrame:(CGRect)frame pagingEnabled:(BOOL)isPage backgroundColor:(UIColor *)color contentSize:(CGSize)contentSize Indicator:(BOOL)isIndicator bounces:(BOOL)isBounce{
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:frame];
    
    scrollView.pagingEnabled=isPage;
    if (color) {
        scrollView.backgroundColor=color;
    }
    
    scrollView.contentSize=contentSize;
    
    
    scrollView.showsVerticalScrollIndicator=isIndicator;
    scrollView.showsHorizontalScrollIndicator=isIndicator;
    scrollView.bounces=isBounce;
    
    return scrollView;
}
@end

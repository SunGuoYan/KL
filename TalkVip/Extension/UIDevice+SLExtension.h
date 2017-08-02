//
//  UIDevice+SLExtension.h
//  BaoDan
//
//  Created by jochi on 16/10/21.
//  Copyright © 2016年 JOCHI. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 * 判断设备型号 iPhone 6 iPhone 6s等
 */
@interface UIDevice (SLExtension)
+ (NSString*)deviceVersion;
@end

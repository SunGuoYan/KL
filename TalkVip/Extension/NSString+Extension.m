//
//  NSString+Extension.m
//  UIImage的截屏
//
//  Created by SunGuoYan on 17/2/13.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
-(CGSize)getFrameWithSize:(NSInteger)size andWidth:(CGFloat)width{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
   CGRect frame = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    return frame.size;
}
-(CGFloat)getWidthWithSize:(NSInteger)size{
    
    CGSize strSize = [self sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}];
    return strSize.width;
}
-(BOOL)isValidatePhone{
    NSString *emailRegex = @"^[1][3-8]+\\d{9}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
@end

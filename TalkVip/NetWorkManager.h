//
//  NetWorkManager.h
//  TalkVip
//
//  Created by SunGuoYan on 2017/5/4.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(NSDictionary *responseObject);
typedef void(^FailureBlock)(NSError *error);

@interface NetWorkManager : NSObject
//1.首页数据列表的接口
+(void)loadNetDataWithAPI:(NSString *)api andPage:(NSString *)page andSize:(NSString *)size andSuccess:(SuccessBlock)successBlock andfailure:(FailureBlock)failureBlock;

//封装的公共请求类
+(void)loadDateWithToken:(BOOL)isTokenNeed andWithUrl:(NSString *)url andPara:(NSDictionary *)para andSuccess:(SuccessBlock)successBlock andfailure:(FailureBlock)failureBlock;

//上传图片 NSDate
+(void)loadDateUpImageWithToken:(BOOL)isTokenNeed andWithUrl:(NSString *)url andPara:(NSDictionary *)para andImage:(UIImage *)upImage andSuccess:(SuccessBlock)successBlock andfailure:(FailureBlock)failureBlock;

//上传图片 base
+(void)loadDateUpImageWithTokenByBase:(BOOL)isTokenNeed andWithUrl:(NSString *)url andPara:(NSDictionary *)para andImage:(UIImage *)image andSuccess:(SuccessBlock)successBlock andfailure:(FailureBlock)failureBlock;

@end

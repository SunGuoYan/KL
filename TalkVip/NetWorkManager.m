//
//  NetWorkManager.m
//  TalkVip
//
//  Created by SunGuoYan on 2017/5/4.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "NetWorkManager.h"

@implementation NetWorkManager

+(void)loadNetDataWithAPI:(NSString *)api andPage:(NSString *)page andSize:(NSString *)size andSuccess:(SuccessBlock)successBlock andfailure:(FailureBlock)failureBlock
{
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl_mt,api];
    
    NSDictionary *para=@{@"page":page,
                         @"size":size};
    
    AFHTTPSessionManager *_operation = [AFHTTPSessionManager  manager];
    
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头
    NSString *token=[NSUserDefaults getObjectForKey:TOKEN];
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    [_operation POST:urlStr parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failureBlock) {
            failureBlock(error);
        }
        
    }];
     
}


+(void)loadDateWithToken:(BOOL)isTokenNeed andWithUrl:(NSString *)url andPara:(NSDictionary *)para andSuccess:(SuccessBlock)successBlock andfailure:(FailureBlock)failureBlock{
    
    AFHTTPSessionManager *_operation = [AFHTTPSessionManager  manager];
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头
    if (isTokenNeed==YES) {
        
        NSString *value=[NSString stringWithFormat:@"Bearer %@",[NSUserDefaults getObjectForKey:TOKEN]];
        [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    }
    
    //开始请求
    [_operation POST:url parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failureBlock) {
            failureBlock(error);
        }
        
    }];
}
//上传图片
+(void)loadDateUpImageWithToken:(BOOL)isTokenNeed andWithUrl:(NSString *)url andPara:(NSDictionary *)para andImage:(UIImage *)upImage andSuccess:(SuccessBlock)successBlock andfailure:(FailureBlock)failureBlock{
    AFHTTPSessionManager *_operation = [AFHTTPSessionManager  manager];
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头
    if (isTokenNeed==YES) {
        
        NSString *value=[NSString stringWithFormat:@"Bearer %@",[NSUserDefaults getObjectForKey:TOKEN]];
        [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    }
    
    //开始请求
    [_operation POST:url parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /*
         name 对应你后台参数名
         filename 是图片的名
         你如果压缩的是jpeg  那就XXX.jpeg
         */
        
        [formData appendPartWithFileData:UIImageJPEGRepresentation(upImage, 1.0) name:@"userfile" fileName:@"test.jpg" mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
}
//上传图片 base
+(void)loadDateUpImageWithTokenByBase:(BOOL)isTokenNeed andWithUrl:(NSString *)url andPara:(NSDictionary *)para andImage:(UIImage *)upImage andSuccess:(SuccessBlock)successBlock andfailure:(FailureBlock)failureBlock{
    
    AFHTTPSessionManager *_operation = [AFHTTPSessionManager  manager];
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //设置请求头
    if (isTokenNeed==YES) {
        
        NSString *value=[NSString stringWithFormat:@"Bearer %@",[NSUserDefaults getObjectForKey:TOKEN]];
        [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    }
    
    
    [_operation POST:url parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failureBlock) {
            failureBlock(error);
        }
        
    }];
    
}
@end

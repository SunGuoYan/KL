//
//  ViewController.m
//  TalkVip
//
//  Created by SunGuoYan on 17/3/16.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//


//#define baseUrl @"http://c1.talkvip.cn"

#import "ViewController.h"
#import "AFNetWorking.h"
#import "MainVC.h"
#import "MBProgressHUD.h"
#import "RSAEncryptor.h"

#import "HBRSAHandler.h"



@interface ViewController ()
{
    HBRSAHandler* _handler;
}
@property (weak, nonatomic) IBOutlet UITextField *texta;
@property (weak, nonatomic) IBOutlet UITextField *textb;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self makeCall];
   
}
-(void)makeCall{
    NSString *api=@"/Authorization";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    NSString *accuntID=@"1";
    
    NSDate * nowTime = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString * timeStr = [formatter stringFromDate:nowTime];
    
    //时间戳
    NSString *timeStamp=[NSString stringWithFormat:@"%d%d%@",arc4random()%9+1,arc4random()%9+1,timeStr];
    
    //订单号 随机的六位数
    NSString *order=[NSString stringWithFormat:@"%d%d%d%d%d%d",arc4random()%9+1,arc4random()%9+1,arc4random()%9+1,arc4random()%9+1,arc4random()%9+1,arc4random()%9+1];
    
    //原始签名数据
    NSString *signInfo_Str=[NSString stringWithFormat:@"%@%@%@",accuntID,timeStamp,order];
    
    //初始化RSA
    NSString *publicKeyFilePath = [[NSBundle mainBundle] pathForResource:@"rsa_public_key.pem" ofType:nil];
    NSString *privateKeyFilePath = [[NSBundle mainBundle] pathForResource:@"rsa_private_key.pem" ofType:nil];
    
    _handler= [HBRSAHandler new];
    
    [_handler importKeyWithType:KeyTypePublic andPath:publicKeyFilePath];
    [_handler importKeyWithType:KeyTypePrivate andPath:privateKeyFilePath];
    //加密
    NSString *signInfo=[_handler encryptWithPublicKey:signInfo_Str];
    NSLog(@"加密前：%@",signInfo_Str);
    NSLog(@"加密后:%@",signInfo);
    NSLog(@"解密后:%@",[_handler decryptWithPrivatecKey:signInfo]);
    
    
    
    
    NSDictionary *para=@{@"accuntID":accuntID,
                         @"callingPhone":@"13657229663",
                         @"calledPhone":@"13971410254",
                         
                         @"dataID":@"",
                         @"order":order,
                         @"timeStamp":timeStamp,
                         
                         @"returnURL":@"",
                         @"notifyURL":@"http://www.baidu.com",
                         @"remark":@"",
                         @"signInfo":signInfo};
    NSLog(@"para:%@",para);
    
    AFHTTPSessionManager *_operation = [AFHTTPSessionManager  manager];
    
    // 设置超时时间
    //    [_operation.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    //    _operation.requestSerializer.timeoutInterval = 3.f;//新版的只要这一行
    //    [_operation.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    
    [_operation POST:urlStr parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
        NSLog(@"message:%@",responseObject[@"message"]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error:%@",error);
    }];
}

- (IBAction)loginBtnClicked:(UIButton *)sender {
    
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainVC *vc=[sb instantiateViewControllerWithIdentifier:NSStringFromClass([MainVC class])];
    UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:vc];
    [self.navigationController pushViewController:nvc animated:YES];
    
//    [self presentViewController:nvc animated:NO completion:nil];
    
//    if ([self.texta.text isEqualToString:@"1"]&&[self.textb.text isEqualToString:@"1"]) {
//
//        
//    }else{
//        
//    }
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

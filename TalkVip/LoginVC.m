//
//  LoginVC.m
//  TalkVip
//
//  Created by SunGuoYan on 17/4/6.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "LoginVC.h"
#import "MainVC.h"
#import "ServiceVC.h"
//#import "MBProgressHUD.h"

#import "HBRSAHandler.h"
#import "AFNetWorking.h"


@interface LoginVC ()<UITextFieldDelegate>
{
    HBRSAHandler* _handler;
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UIView *userbg;
@property (weak, nonatomic) IBOutlet UIView *pwdbg;

@property (weak, nonatomic) IBOutlet UITextField *TFuser;
@property (weak, nonatomic) IBOutlet UITextField *TFpwd;

@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;
@property (weak, nonatomic) IBOutlet UIImageView *loginBG;

@property (weak, nonatomic) IBOutlet UIImageView *PWDBG;


@property (weak, nonatomic) IBOutlet UILabel *agreementa;

@property (weak, nonatomic) IBOutlet UIButton *agreementb;


@end

@implementation LoginVC
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.TFuser resignFirstResponder];
    [self.TFpwd resignFirstResponder];
    
    self.PWDBG.image=[UIImage imageNamed:@"login_TF_bg"];
    self.loginBG.image=[UIImage imageNamed:@"login_TF_bg"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    HUD.labelText = @"登录中...";
    
//    self.agreementa.hidden=YES;
//    self.agreementb.hidden=YES;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"用户许可协议"];
    NSRange strRange = {0,[str length]};
    [str setAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:strRange];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    
    [self.serviceBtn setAttributedTitle:str forState:UIControlStateNormal];
    
    
    self.TFuser.delegate=self;
    self.TFpwd.delegate=self;
    
}
//监听textField
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==self.TFuser) {
        self.loginBG.image=[UIImage imageNamed:@"login_TF_bg_select"];
        self.PWDBG.image=[UIImage imageNamed:@"login_TF_bg"];
    }else if(textField==self.TFpwd){
        
        self.PWDBG.image=[UIImage imageNamed:@"login_TF_bg_select"];
        self.loginBG.image=[UIImage imageNamed:@"login_TF_bg"];
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //出去的时候显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //进来的时候隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
#pragma mark --- 点击 登录按钮
- (IBAction)Login:(UIButton *)sender {
    if (self.TFuser.text.length==0) {
        [MBProgressHUD showError:@"账号不能为空！"];
        return;
    }
    if (self.TFpwd.text.length==0) {
        [MBProgressHUD showError:@"密码不能为空！"];
        return;
    }
    [HUD show:YES];
    [self loginWithUserName:self.TFuser.text andPassWord:self.TFpwd.text];
}

-(void)goMain{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainVC *vc=[sb instantiateViewControllerWithIdentifier:NSStringFromClass([MainVC class])];
    [self.navigationController pushViewController:vc animated:YES];
    [NSUserDefaults setObject:@"YES" ForKey:@"isLogin"];
}

- (IBAction)serviceBtn:(UIButton *)sender {
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"My" bundle:nil];
   ServiceVC *vc=[sb instantiateViewControllerWithIdentifier:NSStringFromClass([ServiceVC class])];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)loginWithUserName:(NSString *)name andPassWord:(NSString *)word{
    NSString *api=@"/login/loginOn";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl_mt,api];
    //1.
    NSString *username=name;
    //2.
    NSString *password=word;
    NSDate * nowTime = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    //3.
    NSString * timeStamp = [formatter stringFromDate:nowTime];
    
    NSString * sign_str=[NSString stringWithFormat:@"%@|%@|%@",username,password,timeStamp];
    
    //初始化RSA
    NSString *publicKeyFilePath = [[NSBundle mainBundle] pathForResource:@"public_key.pem" ofType:nil];
    
    
    NSString *privateKeyFilePath = [[NSBundle mainBundle] pathForResource:@"rsa_private_key.pem" ofType:nil];
    
    _handler= [HBRSAHandler new];
    
    [_handler importKeyWithType:KeyTypePublic andPath:publicKeyFilePath];
    [_handler importKeyWithType:KeyTypePrivate andPath:privateKeyFilePath];
    //加密
    NSString *sign=[_handler encryptWithPublicKey:sign_str];
    
    NSDictionary *para=@{@"sign":sign};
    
    AFHTTPSessionManager *_operation = [AFHTTPSessionManager  manager];
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    //增加这几行代码；
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    //这里进行设置
    [_operation setSecurityPolicy:securityPolicy];
    
    
    [_operation POST:urlStr parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [HUD hide:YES];
        
        NSLog(@"responseObject:%@",responseObject);
        NSLog(@"msg:%@",responseObject[@"msg"]);
        /*
         responseObject:{
         code = 8888;
         data =     {
         email = "";
         phone = 15201667834;
         realname = kefu4282;
         token = b937346cda48e8d252aaa5d9975788c5;
         };
         msg = success;
         result = success;
         }
         2017-05-25 11:49:42.413 TalkVip[1600:532919] msg:success
         */
        //还是需要的 登录失败的时候需要
        if ([responseObject[@"result"] isEqualToString:@"fail"]) {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
        
        if ([responseObject[@"msg"] isEqualToString:@"success"]) {
            
            
            NSString *token=responseObject[@"data"][@"token"];
            NSString *email=responseObject[@"data"][@"email"];
            NSString *phone=responseObject[@"data"][@"phone"];
            NSString *extract_state=responseObject[@"data"][@"extract_state"];
            NSString *continuous_call=responseObject[@"data"][@"continuous_call"];
            NSString *headurl=[NSString stringWithFormat:@"%@",responseObject[@"data"][@"headurl"]];
            NSString *realname=responseObject[@"data"][@"realname"];
            
            [NSUserDefaults setObject:token ForKey:TOKEN];
            [NSUserDefaults setObject:email ForKey:EMAIL];
            [NSUserDefaults setObject:phone ForKey:PHONE];
            [NSUserDefaults setObject:extract_state ForKey:EXTRACT_STATE];
            [NSUserDefaults setObject:continuous_call ForKey:CONTINUOUS_CALL];
            
            if (headurl!=nil) {
                if (![headurl isEqualToString:@"<null>"]) {
                    headurl=[NSString stringWithFormat:@"%@%@",baseUrl_mt,headurl];
                    [NSUserDefaults setObject:headurl ForKey:HEADURL];
                }
                
            }
            [NSUserDefaults setObject:realname ForKey:REALNAME];
            
            
            [self goMain];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HUD hide:YES];
        [MBProgressHUD showError:@"无可用网络，请连接网络后重试"];
        NSLog(@"error1:::%@",error);
        NSLog(@"error2:::%@",error.userInfo);
        
    }];
}
#pragma mark --- 如果成功成功
@end

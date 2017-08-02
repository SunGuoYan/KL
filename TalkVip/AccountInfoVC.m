//
//  AccountInfoVC.m
//  TalkVip
//
//  Created by SunGuoYan on 17/4/6.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "AccountInfoVC.h"

@interface AccountInfoVC ()
{
    BOOL _state;
}
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UITextField *textFielda;
@property (weak, nonatomic) IBOutlet UITextField *textFieldb;

@end

@implementation AccountInfoVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.textFielda.text=[NSUserDefaults getObjectForKey:EMAIL];
    self.textFieldb.text=[NSUserDefaults getObjectForKey:PHONE];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _state=NO;
    
    [self setUserInteractionEnabled:NO];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textFielda resignFirstResponder];
    [self.textFieldb resignFirstResponder];
}
-(void)setUserInteractionEnabled:(BOOL)state{
    self.textFielda.userInteractionEnabled=state;
    self.textFieldb.userInteractionEnabled=state;
}
#pragma mark --- 点击 编辑 按钮
- (IBAction)editClick:(UIButton *)sender {
    if (_state==NO) {//点击编辑->保存
        
        [self.editBtn setTitle:@"        保存" forState:UIControlStateNormal];
        [self setUserInteractionEnabled:YES];
        _state=YES;
        
        self.textFielda.textColor=[UIColor blackColor];
        self.textFieldb.textColor=[UIColor blackColor];
    }else if(_state==YES){//点击保存提交
        
        //如果保存成功才能变为保存
//        [self.editBtn setTitle:@"        编辑" forState:UIControlStateNormal];
//        [self setUserInteractionEnabled:NO];
        
        [self updateAccountInformationWithEmail:self.textFielda.text andPhone:self.textFieldb.text];
        NSLog(@"Email:%@ tell:%@",self.textFielda.text,self.textFieldb.text);
    }
    sender.selected=!sender.selected;
    
}
-(void)updateAccountInformationWithEmail:(NSString *)email andPhone:(NSString *)phone{
    NSString *api=@"/Comment/updateAccountInformation";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl_mt,api];
    
    NSDictionary *para=@{@"phone":phone,
                         @"email":email};
    
    [NetWorkManager loadDateWithToken:YES andWithUrl:urlStr andPara:para andSuccess:^(NSDictionary *responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:responseObject[@"msg"]];
        });
        
        
        if ([responseObject[@"result"] isEqualToString:@"success"]) {//保存成功
 
            [self.editBtn setTitle:@"        编辑" forState:UIControlStateNormal];
            [self setUserInteractionEnabled:NO];
            _state=NO;
            
            [NSUserDefaults setObject:email ForKey:EMAIL];
            [NSUserDefaults setObject:phone ForKey:PHONE];
            self.textFielda.textColor=[UIColor colorWithHexString:@"94A6BD"];
            self.textFieldb.textColor=[UIColor colorWithHexString:@"94A6BD"];
            
            //            [self.navigationController popViewControllerAnimated:YES];
            
        }else{//保存失败
            //            [MBProgressHUD showError:msg];
            
            [self.editBtn setTitle:@"        保存" forState:UIControlStateNormal];
            [self setUserInteractionEnabled:YES];
            _state=YES;
            
        }
    } andfailure:^(NSError *error) {
        
        [MBProgressHUD showError:@"无可用网络，请连接网络后重试"];
    }];
   
}
#pragma mark --- 点击 返回 按钮
- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

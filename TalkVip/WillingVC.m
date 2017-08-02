//
//  WillingVC.m
//  TalkVip
//
//  Created by SunGuoYan on 17/4/6.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "WillingVC.h"

//问题反馈
@interface WillingVC ()<UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITextView *textViewa;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;



@end

@implementation WillingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textViewa.delegate=self;
    
  
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        self.placeholderLabel.hidden=YES;
    }else{
        self.placeholderLabel.hidden=NO;
    }
}

#pragma mark --- 点击发送按钮
- (IBAction)send:(UIButton *)sender {
    
    [self addFeedBackWith:self.textViewa.text];
}

-(void)addFeedBackWith:(NSString *)text{
    NSString *api=@"/Comment/addFeedBack";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl_mt,api];
    NSDictionary *para=@{@"text":text};
    
    [NetWorkManager loadDateWithToken:YES andWithUrl:urlStr andPara:para andSuccess:^(NSDictionary *responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:responseObject[@"msg"]];
        });
        
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    } andfailure:^(NSError *error) {
        [MBProgressHUD showError:@"无可用网络，请连接网络后重试"];
    }];
    
}

- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

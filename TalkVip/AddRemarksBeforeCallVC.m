//
//  AddRemarksBeforeCallVC.m
//  TalkVip
//
//  Created by SunGuoYan on 17/4/20.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "AddRemarksBeforeCallVC.h"

@interface AddRemarksBeforeCallVC ()<UITextViewDelegate>
{
    NSString *_status;
}
//未接通
@property (weak, nonatomic) IBOutlet UIButton *btna;
//重点
@property (weak, nonatomic) IBOutlet UIButton *btnb;
//待跟进
@property (weak, nonatomic) IBOutlet UIButton *btnc;
//无意愿
@property (weak, nonatomic) IBOutlet UIButton *btnd;



@property (weak, nonatomic) IBOutlet UIImageView *imageVa;
@property (weak, nonatomic) IBOutlet UIImageView *imageVb;
@property (weak, nonatomic) IBOutlet UIImageView *imageVc;
@property (weak, nonatomic) IBOutlet UIImageView *imageVd;

//文本输入框
@property (weak, nonatomic) IBOutlet UITextView *testView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLab;

@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *lineb;

//380
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHeight;
//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading;

//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailing;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;


@end

@implementation AddRemarksBeforeCallVC

- (IBAction)cancel:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.testView resignFirstResponder];
}
#pragma mark ---点击 保存 按钮
- (IBAction)save:(UIButton *)sender {
    self.saveBtn.userInteractionEnabled=NO;
    
    NSString *api=@"/Comment/directNotes";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl_mt,api];
    if (![self.type isEqualToString:@"已提取"]) {
        if (_status.length==0) {
            [MBProgressHUD showError:@"请选择类型！"];
            return;
        }
    }else{
        _status=@"5";
    }
    /*
     直接备注：1：重点；2：无意愿；3：待跟进;4:未接通;
             1：重点；2：无意愿；3：待跟进;4:未接通;5：已提取
     */
    
    NSArray *stateArray=@[@"重点",@"无意愿",@"待跟进",@"未接通",@"已提取"];
    NSString *currentState=stateArray[_status.integerValue-1];
    
    if (self.testView.text.length==0) {
        [MBProgressHUD showError:@"请输入备注！"];
        return;
    }
    NSDictionary *para=@{@"id":self.id_str,
                         @"note":self.testView.text,
                         @"status":_status};
    //开始请求
    [NetWorkManager loadDateWithToken:YES andWithUrl:urlStr andPara:para andSuccess:^(NSDictionary *responseObject) {
        
        self.saveBtn.userInteractionEnabled=YES;
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            
            if (self.block) {
                self.block(currentState);
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } andfailure:^(NSError *error) {
        self.saveBtn.userInteractionEnabled=YES;
        
    }];
}
//未接通
- (IBAction)btna:(UIButton *)sender {
    [self changeBackgroundImage:self.imageVa andBtn:self.btna];
    
    _status=@"4";
}
//重点
- (IBAction)btnb:(UIButton *)sender {
    [self changeBackgroundImage:self.imageVb andBtn:self.btnb];
    _status=@"1";
}
//待跟进
- (IBAction)btnc:(UIButton *)sender {
    [self changeBackgroundImage:self.imageVc andBtn:self.btnc];
    _status=@"3";
}
//无意愿
- (IBAction)btnd:(UIButton *)sender {
    [self changeBackgroundImage:self.imageVd andBtn:self.btnd];
    _status=@"2";
}
-(void)changeBackgroundImage:(UIImageView *)currentImage andBtn:(UIButton *)currentBtn{
    //1.切换背景图片
    for (UIImageView *tempImageV in @[self.imageVa,self.imageVb,self.imageVc,self.imageVd]) {
        tempImageV.image=[UIImage imageNamed:@"remark"];
    }
    currentImage.image=[UIImage imageNamed:@"remark_select"];
    
    //2.设置btn颜色
    for (UIButton *btn in @[self.btna,self.btnb,self.btnc,self.btnd]) {
        [btn setTitleColor:[UIColor colorWithHexString:@"abc5e6"] forState:UIControlStateNormal];
    }
    [currentBtn setTitleColor:[UIColor colorWithHexString:@"5a89ff"] forState:UIControlStateNormal];
}
#pragma mark --- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    
    self.testView.delegate=self;
    
    //默认隐藏 在"已提取"下显示
    [self hiddenLine];
    
    if (iPhone5) {
        self.bgHeight.constant=380;
        self.leading.constant=20;
        self.trailing.constant=20;
        
    }else if (iPhone6){
        
        self.bgHeight.constant=400;
        self.leading.constant=30;
        self.trailing.constant=30;
        
    }else if (iPhone6plus){
        
        self.bgHeight.constant=450;
        self.leading.constant=40;
        self.trailing.constant=40;
    }
    
}




-(void)hiddenLine{
    
    self.lineb.hidden=YES;
    
    if ([self.type isEqualToString:@"已提取"]) {
        self.btna.hidden=YES;
        self.btnb.hidden=YES;
        self.btnc.hidden=YES;
        self.btnd.hidden=YES;
        
        self.imageVa.hidden=YES;
        self.imageVb.hidden=YES;
        self.imageVc.hidden=YES;
        self.imageVd.hidden=YES;
        
        self.line.hidden=YES;
        self.lineb.hidden=NO;
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        self.placeholderLab.hidden=YES;
    }else{
        self.placeholderLab.hidden=NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

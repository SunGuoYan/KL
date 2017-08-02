//
//  AddRemarksAfterCallVC.m
//  TalkVip
//
//  Created by SunGuoYan on 17/4/13.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "AddRemarksAfterCallVC.h"
#import "ListModel.h"
#import "HBRSAHandler.h"

//监听电话
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

@interface AddRemarksAfterCallVC ()<UITextViewDelegate>
{
    BOOL isSelect;
    HBRSAHandler* _handler;
    NSString *_status;
    
    MBProgressHUD *HUD;
    NSString *hudStr;
    
    //1 隐藏 0 显示
    NSString *_extract_state;
    //1 连播 0 不联播
    NSString *_continuous_call;
}
//监听电话
@property (nonatomic, strong) CTCallCenter *callCenter;

@property (weak, nonatomic) IBOutlet UILabel *laba;
@property (weak, nonatomic) IBOutlet UILabel *labb;
@property (weak, nonatomic) IBOutlet UILabel *labc;

//提取
@property (weak, nonatomic) IBOutlet UIButton *btna;
//重点
@property (weak, nonatomic) IBOutlet UIButton *btnb;
//无意愿
@property (weak, nonatomic) IBOutlet UIButton *btnc;
//待跟进
@property (weak, nonatomic) IBOutlet UIButton *btnd;
//未接通
@property (weak, nonatomic) IBOutlet UIButton *btne;

@property (weak, nonatomic) IBOutlet UIImageView *imageVa;
@property (weak, nonatomic) IBOutlet UIImageView *imageVb;
@property (weak, nonatomic) IBOutlet UIImageView *imageVc;
@property (weak, nonatomic) IBOutlet UIImageView *imageVd;
@property (weak, nonatomic) IBOutlet UIImageView *imageVe;

//无 已提取状态
//重点
@property (weak, nonatomic) IBOutlet UIButton *buttonA;
//无意愿
@property (weak, nonatomic) IBOutlet UIButton *buttonB;
//待跟进
@property (weak, nonatomic) IBOutlet UIButton *buttonC;

//未接通
@property (weak, nonatomic) IBOutlet UIButton *buttonD;

@property (weak, nonatomic) IBOutlet UIImageView *imgA;
@property (weak, nonatomic) IBOutlet UIImageView *imgB;
@property (weak, nonatomic) IBOutlet UIImageView *imgC;
@property (weak, nonatomic) IBOutlet UIImageView *imgD;


@property (weak, nonatomic) IBOutlet UIView *linaa;
@property (weak, nonatomic) IBOutlet UIView *lineb;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remark;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *texty;



@property (weak, nonatomic) IBOutlet UILabel *placeholderLab;
@property (weak, nonatomic) IBOutlet UITextView *textViewa;


@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UIImageView *selectImageV;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;


@end

@implementation AddRemarksAfterCallVC

-(CTCallCenter *)callCenter{
    if (_callCenter==nil) {
        _callCenter=[[CTCallCenter alloc] init];
    }
    return _callCenter;
}
-(void)setContinuousCall:(NSString *)state{
    NSString *api=@"/Comment/modifyState";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl_mt,api];
    NSDictionary *para=@{@"continuous_cal":state};
    
    [NetWorkManager loadDateWithToken:YES andWithUrl:urlStr andPara:para andSuccess:^(NSDictionary *responseObject) {
        
        NSString *code=responseObject[@"code"];
        
        if (code.integerValue==1030) {
            NSLog(@"state:%@",state);
            [NSUserDefaults setObject:state ForKey:CONTINUOUS_CALL];
        }
        
    } andfailure:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
}
#pragma mark --- 选择 开启按钮
- (IBAction)selectBtnClicked:(UIButton *)sender {
    
   NSString *state= [NSUserDefaults getObjectForKey:CONTINUOUS_CALL];
    
    if (_continuous_call.integerValue==1) {//关闭
        
        self.selectImageV.image=[UIImage imageNamed:@"gouxuan_off"];
        [self setContinuousCall:@"0"];
        
        
    }else if (state.integerValue==0){
        self.selectImageV.image=[UIImage imageNamed:@"gouxuan_on"];
        [self setContinuousCall:@"1"];
        
        
        
    }
    isSelect=!isSelect;
    
    NSLog(@"select：%@",isSelect?@"YES":@"NO");
}
#pragma mark --- 点击 连拨按钮
- (IBAction)continueCal:(UIButton *)sender {
    
    
}

//提取
- (IBAction)btna:(UIButton *)sender {
    [self changeBackgroundImage:self.imageVa andBtn:self.btna];
    _status=@"5";
}
//重点
- (IBAction)btnb:(UIButton *)sender {
    [self changeBackgroundImage:self.imageVb andBtn:self.btnb];
    _status=@"1";
}
//无意愿
- (IBAction)btnc:(UIButton *)sender {
    [self changeBackgroundImage:self.imageVc andBtn:self.btnc];
    _status=@"2";
}
//待跟进
- (IBAction)btnd:(UIButton *)sender {
    [self changeBackgroundImage:self.imageVd andBtn:self.btnd];
    _status=@"3";
}
//未接通
- (IBAction)btne:(UIButton *)sender {
    [self changeBackgroundImage:self.imageVe andBtn:self.btne];
    _status=@"4";
}

//无 已提取状态下
- (IBAction)buttonA:(UIButton *)sender {
    _status=@"1";
    NSLog(@"%@",_status);
    
    [self changeBackgroundImageWithNo:self.imgA andBtn:self.buttonA];
}
- (IBAction)buttonB:(UIButton *)sender {
    _status=@"2";
    NSLog(@"%@",_status);
    [self changeBackgroundImageWithNo:self.imgB andBtn:self.buttonB];
}
- (IBAction)buttonC:(UIButton *)sender {
    _status=@"3";
    NSLog(@"%@",_status);
    [self changeBackgroundImageWithNo:self.imgC andBtn:self.buttonC];
}
- (IBAction)buttonD:(UIButton *)sender {
    _status=@"4";
    NSLog(@"%@",_status);
    [self changeBackgroundImageWithNo:self.imgD andBtn:self.buttonD];
}


-(void)changeBackgroundImage:(UIImageView *)currentImage andBtn:(UIButton *)currentBtn{
    //背景图片
    [self setImageVDefaultImage:@[self.imageVa,self.imageVb,self.imageVc,self.imageVd,self.imageVe]];
    
    if (currentImage) {
        currentImage.image=[UIImage imageNamed:@"remark_select"];
    }
    
    //字体颜色
    [self setBtnTitleDefaltColor:@[self.btna,self.btnb,self.btnc,self.btnd,self.btne]];
    
    if (currentBtn) {
        [currentBtn setTitleColor:[UIColor colorWithHexString:@"5a89ff"] forState:UIControlStateNormal];
    }
    
}
-(void)changeBackgroundImageWithNo:(UIImageView *)currentImage andBtn:(UIButton *)currentBtn{
    //背景图片
    [self setImageVDefaultImage:@[self.imgA,self.imgB,self.imgC,self.imgD]];
    
    if (currentImage) {
        currentImage.image=[UIImage imageNamed:@"remark_select"];
    }
    
    //字体颜色
    [self setBtnTitleDefaltColor:@[self.buttonA,self.buttonB,self.buttonC,self.buttonD]];
    
    if (currentBtn) {
        [currentBtn setTitleColor:[UIColor colorWithHexString:@"5a89ff"] forState:UIControlStateNormal];
    }
    
}

-(void)setImageVDefaultImage:(NSArray<UIImageView *> *)array{
    for (UIImageView *imageV in array) {
        imageV.image=[UIImage imageNamed:@"remark"];
    }
}
-(void)setBtnTitleDefaltColor:(NSArray<UIButton *> *)array{
    for (UIButton *btn in array) {
        [btn setTitleColor:[UIColor colorWithHexString:@"abc5e6"] forState:UIControlStateNormal];
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    self.placeholderLab.hidden=YES;
    
    if (textView.text.length>0) {
        self.placeholderLab.hidden=YES;
    }else{
        self.placeholderLab.hidden=NO;
    }
     
}

#pragma mark --- 点击 保存备注按钮！！！
//逻辑 先备注 后连播
- (IBAction)save:(UIButton *)sender {
    
    if (![self.type isEqualToString:@"已提取"]) {
        if (_status.length==0) {
            [MBProgressHUD showError:@"请选择类型！"];
            return;
        }
    }else{
        _status=@"5";
    }
    if (self.textViewa.text.length==0) {
        [MBProgressHUD showError:@"请添加备注！"];
        return;
    }
    _continuous_call=[NSUserDefaults getObjectForKey:CONTINUOUS_CALL];
    
    //如果连播
    if (_continuous_call.integerValue==1) {
        HUD.labelText = @"拨打中...";
    }else if(_continuous_call.integerValue==0){
        HUD.labelText = @"保存中...";
    }
    [HUD show:YES];
    //添加备注
    ListModel *model=self.dataArray[self.index];
    NSString *api=@"/Comment/phoneNotes";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl_mt,api];
    
    NSDictionary *para=@{@"id":model.id_str,
                         @"note":self.textViewa.text,
                         @"status":_status};
    //网络请求 开始保存备注
    [NetWorkManager loadDateWithToken:YES andWithUrl:urlStr andPara:para andSuccess:^(NSDictionary *responseObject) {
        
        NSLog(@"电话产生备注：responseObject:%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        
        
        [MBProgressHUD showError:responseObject[@"msg"]];
        
        //放在上面 成功失败都提示下
        //如果备注失败
        if ([responseObject[@"result"] isEqualToString:@"fail"]) {
            
            [HUD hide:YES];
        //如果备注成功
        }else{
            
            //如果连播
            if (_continuous_call.integerValue==1) {
                if (self.index+1>=self.dataArray.count) {
                    [MBProgressHUD showError:@"已至最底下行请返回！"];
                    [HUD hide:YES];
                    return;
                }
                self.index+=1;
                
                //连续拨打 核心
//                [HUD show:YES];
                [self makeSingleCallWithDataArray:self.dataArray andIndex:self.index];
            //如果不连播
            }else if(_continuous_call.integerValue==0){
                NSArray *stateArray=@[@"重点",@"无意愿",@"待跟进",@"未接通",@"已提取"];
                NSString *currentState=stateArray[_status.integerValue-1];
                if (self.block) {
                    self.block(currentState);
                }
                
                [HUD hide:YES];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            //备注成功之后，清除之前的记录
            self.textViewa.text=@"";
            _status=nil;
            [self changeBackgroundImage:nil andBtn:nil];
            
        }
        
    } andfailure:^(NSError *error) {
        [HUD hide:YES];
        [MBProgressHUD showError:error.description];
    }];
    
   
}


#pragma mark --- 单向呼叫打电话
-(void)makeSingleCallWithDataArray:(NSMutableArray *)dataArray andIndex:(NSInteger)index {
    NSString *api=@"/Authorization";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
//    NSString *accuntID=@"b6458ae8a4";
    
    NSDate * nowTime = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString * timeStr = [formatter stringFromDate:nowTime];
    
    //时间戳
    NSString *timeStamp=[NSString stringWithFormat:@"%d%d%@",arc4random()%9+1,arc4random()%9+1,timeStr];
    
    
    NSString *num_five=[NSString stringWithFormat:@"%d%d%d%d%d",arc4random()%9+1,arc4random()%9+1,arc4random()%9+1,arc4random()%9+1,arc4random()%9+1];
    
    //订单号 时间戳+随记五位数
    NSString *order=[NSString stringWithFormat:@"%@%@",[formatter stringFromDate:nowTime],num_five];
    
    //订单号 随机的六位数
//    NSString *order=[NSString stringWithFormat:@"%d%d%d%d%d%d",arc4random()%9+1,arc4random()%9+1,arc4random()%9+1,arc4random()%9+1,arc4random()%9+1,arc4random()%9+1];
    
    //原始签名数据
    NSString *signInfo_Str=[NSString stringWithFormat:@"%@%@%@",ACCOUNTID,timeStamp,order];
    
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
    
    
    NSString  *callingPhone=[NSUserDefaults getObjectForKey:PHONE];
    ListModel *model=dataArray[index];
    
    NSString *id_str=model.sourceid;
    NSString *notifyURL=model.notifyURL;
    NSDictionary *para=@{@"accuntID":ACCOUNTID,
                         @"callingPhone":callingPhone,
                         @"calledPhone":@"",
                         
                         @"dataID":id_str,
                         @"order":order,
                         @"line":@"E",
                         @"type":@"1",
                         @"timeStamp":timeStamp,
                         
                         @"returnURL":@"",
                         @"notifyURL":notifyURL,
                         @"remark":@"",
                         @"signInfo":signInfo};
    NSLog(@"para:%@",para);
    
    
    AFHTTPSessionManager *_operation = [AFHTTPSessionManager  manager];
    
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    
    [_operation POST:urlStr parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"连播：responseObject:%@",responseObject);
        NSLog(@"message:%@",responseObject[@"message"]);
        
        if ([responseObject[@"message"] isEqualToString:@"拨打成功"]) {
            
            //1.拨打
            NSString *tel=[NSString stringWithFormat:@"tel://%@",responseObject[@"fromSerNum"]];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
            
            //2.开始监听
            [self observeCallStateandDataArray:(NSMutableArray *)dataArray andIndex:(NSInteger)index ];
            
            //3.产生日志
            [self insertLogWithOrder:order andID:model.id_str];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [HUD hide:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"连播：error:%@",error);
        [HUD hide:YES];
    }];
}
-(void)insertLogWithOrder:(NSString *)order andID:(NSString *)id_Str{
    NSString *api=@"/Comment/insertLog";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl_mt,api];
    
    NSDictionary *para=@{@"id":id_Str,
                         @"order":order};
    
    [NetWorkManager loadDateWithToken:YES andWithUrl:urlStr andPara:para andSuccess:^(NSDictionary *responseObject) {
        NSLog(@"日志：%@",responseObject);
    } andfailure:^(NSError *error) {
        
    }];
}

-(void)observeCallStateandDataArray:(NSMutableArray *)dataArray andIndex:(NSInteger)index {
    
//    self.callCenter = [[CTCallCenter alloc] init];
    /*
     打出： 1.播出 2.通了 3.挂断
     接入：4.来电话了
     */
    
    __weak typeof(self) weakSelf = self;
    
    self.callCenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
//            [weakSelf goToAddRemarkVCandDataArray:(NSMutableArray *)dataArray andIndex:(NSInteger)index ];
//            weakSelf.callCenter=nil;
            [weakSelf configUIWithDataArray:dataArray andIndex:index];
            NSLog(@"3.挂断了电话咯 Call has been disconnected");
        }
        
        else if ([call.callState isEqualToString:CTCallStateConnected])
        {
            NSLog(@"2.电话通了Call has just been connected");
        }
        else if([call.callState isEqualToString:CTCallStateIncoming])
        {
            NSLog(@"4.来电话了Call is incoming");
            
        }
        else if ([call.callState isEqualToString:CTCallStateDialing])
        {
            NSLog(@"1.正在播出电话call is dialing");
        }
        else
        {
            NSLog(@"嘛都没做Nothing is done");
        }
    };
}


- (IBAction)goback:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.callCenter=nil;
    
    //2.退出的恢复正常 设置导航栏的背景图片为nil
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setNavImageClear{
    //1.设置导航栏的背景图片 new 透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
#pragma mark --- /*** viewDidLoad ***/
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1 连播 0 不联播
    _continuous_call=[NSUserDefaults getObjectForKey:CONTINUOUS_CALL];
    
    
    //0 不连播
    if (_continuous_call.integerValue==0) {
        self.selectImageV.image=[UIImage imageNamed:@"gouxuan_off"];
    //1 连播
    }else if (_continuous_call.integerValue==1){
        self.selectImageV.image=[UIImage imageNamed:@"gouxuan_on"];
    }
    
    
    
    //1 隐藏 0 显示
    _extract_state=[NSUserDefaults getObjectForKey:EXTRACT_STATE];
    
    
    if (_extract_state.integerValue ==1) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.btna.hidden=YES;
            self.btnb.hidden=YES;
            self.btnc.hidden=YES;
            self.btnd.hidden=YES;
            self.btne.hidden=YES;
            
            self.imageVa.hidden=YES;
            self.imageVb.hidden=YES;
            self.imageVc.hidden=YES;
            self.imageVd.hidden=YES;
            self.imageVe.hidden=YES;
        });
    }else if (_extract_state.integerValue ==0){
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            self.buttonA.hidden=YES;
            self.buttonB.hidden=YES;
            self.buttonC.hidden=YES;
            self.buttonD.hidden=YES;
            
            self.imgA.hidden=YES;
            self.imgB.hidden=YES;
            self.imgC.hidden=YES;
            self.imgD.hidden=YES;
        
        });
    }
    
    self.btna.hidden=YES;
    
    
    
    //默认开启
    isSelect=YES;
    
    
    self.textViewa.delegate=self;
    
    //设置导航栏透明
    [self setNavImageClear];
    
    //监听键盘弹起
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self configUIWithDataArray:self.dataArray andIndex:self.index];
    
    if ([self.type isEqualToString:@"已提取"]) {
        [self setHidden:YES];
        self.remark.constant=-5;
        self.texty.constant=-5;
    }else{
        //正常
        [self setHidden:NO];
        self.remark.constant=10;
        self.texty.constant=10;
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    HUD.labelText = @"拨打中...";
}
-(void)setHidden:(BOOL)state{
    self.linaa.hidden=!state;
    self.lineb.hidden=state;
    
    self.imageVa.hidden=state;
    self.imageVb.hidden=state;
    self.imageVc.hidden=state;
    self.imageVd.hidden=state;
    self.imageVe.hidden=state;
    self.btna.hidden=state;
    self.btnb.hidden=state;
    self.btnc.hidden=state;
    self.btnd.hidden=state;
    self.btne.hidden=state;
    
    
}
#pragma mark --- 刷新下一界面的数据
-(void)configUIWithDataArray:(NSMutableArray *)dataArray andIndex:(NSInteger) index{
    
    //主线程里面更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        ListModel *model=dataArray[index];
        self.laba.text=model.id_str;
        self.labb.text=model.mobile;
        self.labc.text=model.name;
    });
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)UIKeyboardWillShow:(NSNotification *)noti{
    
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //keyboardFrame.origin.y;
    CGFloat height = keyboardFrame.size.height;
    NSLog(@"%lf",height);
    
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = -height ;
        self.view.frame = frame;
    }];
    

}

-(void)UIKeyboardWillHide:(NSNotification *)noti{
    
    [UIView animateWithDuration:0.2 animations:^{
        //恢复到默认y为0的状态，有时候要考虑导航栏要+64
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

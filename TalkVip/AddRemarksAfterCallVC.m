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
    
    CGFloat bgView_x;
    NSInteger _count;
    //    0：未联系；1：重点；2：无意愿；3：有意愿;
    NSString  *_state_type;
    NSMutableString *_text;
    NSInteger _location;
}
//监听电话
@property (nonatomic, strong) CTCallCenter *callCenter;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *a;
@property (weak, nonatomic) IBOutlet UIButton *b;
@property (weak, nonatomic) IBOutlet UIButton *c;

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTop;

@end

@implementation AddRemarksAfterCallVC

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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavImageClear];
    
    [self setHidden:NO];
//    self.remark.constant=10;
//    self.texty.constant=10;
}
#pragma mark --- /*** viewDidLoad ***/
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    _text=[NSMutableString stringWithFormat:@""];
    self.bgView.hidden=YES;
    
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
    //    [self setNavImageClear];
    
    //监听键盘弹起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self configUIWithDataArray:self.dataArray andIndex:self.index];
    
    //    if ([self.type isEqualToString:@"已提取"]) {
    //        [self setHidden:YES];
    //        self.remark.constant=-5;
    //        self.texty.constant=-5;
    //    }else{
    //        //正常
    //        [self setHidden:NO];
    //        self.remark.constant=10;
    //        self.texty.constant=10;
    //    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    HUD.labelText = @"拨打中...";
    
    [self changeBackgroundImageWithNo:nil andBtn:nil];
    
    [self setGesture];
    [self setColor];
}
- (IBAction)a:(UIButton *)sender {
    [self insertTagNameWithState:100];
}
- (IBAction)b:(UIButton *)sender {
    [self insertTagNameWithState:101];
}
- (IBAction)c:(UIButton *)sender {
    [self insertTagNameWithState:102];
}
- (IBAction)tag:(UIButton *)sender {
    CGFloat distance=0;
    if (_state_type.integerValue==0) {
        distance=210;
    }else if(_state_type.integerValue==2){
        distance=150;
    }
    
    //如果在初始位置
    if (bgView_x==self.bgView.frame.origin.x) {
        //展开
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 animations:^{
                
                self.bgView.frame=CGRectMake(bgView_x-distance, self.bgView.frame.origin.y, self.bgView.frame.size.width, self.bgView.frame.size.height);
            }];
        });
    }else{
        //收起
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 animations:^{
                
                self.bgView.frame=CGRectMake(bgView_x, self.bgView.frame.origin.y, self.bgView.frame.size.width, self.bgView.frame.size.height);
            }];
        });
        
    }
}
//无 已提取状态下 B平台
//未联系
- (IBAction)buttonA:(UIButton *)sender {
    _status=@"1";
    [self changeBackgroundImageWithNo:self.imgA andBtn:self.buttonA];
    
    if (_count==0) {
        bgView_x=self.bgView.frame.origin.x;
        _count=1;
    }
    self.bgView.hidden=NO;
    _state_type=@"0";
     [self setTagNameByTape:3];
}

//无意愿
- (IBAction)buttonD:(UIButton *)sender {
    _status=@"4";
    [self changeBackgroundImageWithNo:self.imgD andBtn:self.buttonD];
    
    
    if (_count==0) {
        bgView_x=self.bgView.frame.origin.x;
        _count=1;
    }
    self.bgView.hidden=NO;
    [self setTagNameByTape:2];
    self.bgView.hidden=NO;
    _state_type=@"2";
}
//重点
- (IBAction)buttonB:(UIButton *)sender {
    _status=@"2";
    [self changeBackgroundImageWithNo:self.imgB andBtn:self.buttonB];
    self.bgView.hidden=YES;
    _state_type=@"1";
}
//有意愿
- (IBAction)buttonC:(UIButton *)sender {
    _status=@"3";
    [self changeBackgroundImageWithNo:self.imgC andBtn:self.buttonC];
    self.bgView.hidden=YES;
    _state_type=@"3";
}

-(void)setTagNameByTape:(NSInteger)type{
    if (type==3) {
        [self.a setTitle:@"无人接听" forState:UIControlStateNormal];
        [self.b setTitle:@"直接挂断" forState:UIControlStateNormal];
        [self.c setTitle:@"关机" forState:UIControlStateNormal];
    }else if(type==2){
        [self.a setTitle:@"无意愿" forState:UIControlStateNormal];
        [self.b setTitle:@"接通后挂断" forState:UIControlStateNormal];
    }
}


#pragma mark --- 选择 开启按钮
- (IBAction)selectBtnClicked:(UIButton *)sender {
    
   NSString *state= [NSUserDefaults getObjectForKey:CONTINUOUS_CALL];
    
    if (state.integerValue==1) {//关闭
        
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
    
    if (_state_type.length==0) {
        [MBProgressHUD showError:@"请选择类型！"];
        return;
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
                         @"status":_state_type};
    //网络请求 开始保存备注
    [NetWorkManager loadDateWithToken:YES andWithUrl:urlStr andPara:para andSuccess:^(NSDictionary *responseObject) {
        
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
            
            //备注成功之后，清除之前的记录,恢复到初始状态
            self.textViewa.text=@"";
            _status=nil;
            _state_type=nil;
            [self changeBackgroundImageWithNo:nil andBtn:nil];
            [self.view endEditing:YES];
        }
        
    } andfailure:^(NSError *error) {
        [HUD hide:YES];
        [MBProgressHUD showError:error.description];
    }];
}

- (IBAction)goback:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setGesture{
    //3.滑动手势
    UISwipeGestureRecognizer *swiper=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    swiper.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swiper];
    
    UISwipeGestureRecognizer *swiper1=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    swiper1.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiper1];
    
}
-(void)swipe:(UISwipeGestureRecognizer *)swipe
{
    if (self.bgView.hidden==NO) {
        
        CGFloat distance=0;
        if (_state_type.integerValue==0) {
            distance=210;
        }else if(_state_type.integerValue==2){
            distance=150;
        }
        
        
//        CGFloat distance=0;
//        if (_type==3) {
//            distance=210;
//        }else if(_type==2){
//            distance=150;
//        }
        
        if (swipe.direction==UISwipeGestureRecognizerDirectionLeft) {
            //展开
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.bgView.frame=CGRectMake(bgView_x-distance, self.bgView.frame.origin.y, self.bgView.frame.size.width, self.bgView.frame.size.height);
                }];
            });
        }else if (swipe.direction==UISwipeGestureRecognizerDirectionRight){
            //收起
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.bgView.frame=CGRectMake(bgView_x, self.bgView.frame.origin.y, self.bgView.frame.size.width, self.bgView.frame.size.height);
                }];
            });
        }
    }
}
#pragma mark --- ***********************
#pragma mark --- ******  实现部分  ********
#pragma mark --- ***********************
#pragma mark --- 单向呼叫打电话
#pragma mark - KVO
-(void)textViewDidChangeSelection:(UITextView *)textView{
    
    NSRange rg =textView.selectedRange;
    if (rg.location == NSNotFound) {
        // 如果没找到光标,就把光标定位到文字结尾
        rg.location = textView.text.length;
    }
    _location=rg.location;
}
-(void)setTextViewContentWith:(NSString *)content{
    
    [_text insertString:content atIndex:_location];
    self.textViewa.text=[NSString stringWithFormat:@"%@",_text];
}
#pragma mark --- 点击上面的a、b、c
-(void)insertTagNameWithState:(NSInteger)state{
    self.placeholderLab.hidden=YES;
    //收起 tag
    //1.主线程连更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            
            self.bgView.frame=CGRectMake(bgView_x, self.bgView.frame.origin.y, self.bgView.frame.size.width, self.bgView.frame.size.height);
        }];
    });
    
    
    if (_state_type.integerValue==0) {
        switch (state) {
            case 100:[self setTextViewContentWith:@"无人接听"];break;
            case 101:[self setTextViewContentWith:@"直接挂断"]; break;
            case 102:[self setTextViewContentWith:@"关机"]; break;
            default:break;
        }
    }else if (_state_type.integerValue==2){
        switch (state) {
            case 100:[self setTextViewContentWith:@"无意愿"];break;
            case 101:[self setTextViewContentWith:@"接通后挂断"];break;
            case 102:[self setTextViewContentWith:@"null"];break;
            default:break;
        }
    }
}
-(void)setColor{
    [self.a setTitleColor:[UIColor colorWithHexString:@"60718D"] forState:UIControlStateNormal ];
    [self.a setTitleColor:[UIColor colorWithHexString:@"5a89ff"] forState:UIControlStateHighlighted];
    
    [self.b setTitleColor:[UIColor colorWithHexString:@"60718D"] forState:UIControlStateNormal ];
    [self.b setTitleColor:[UIColor colorWithHexString:@"5a89ff"] forState:UIControlStateHighlighted];
    
    [self.c setTitleColor:[UIColor colorWithHexString:@"60718D"] forState:UIControlStateNormal ];
    [self.c setTitleColor:[UIColor colorWithHexString:@"5a89ff"] forState:UIControlStateHighlighted];
}
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
-(void)setNavImageClear{
    //1.设置导航栏的背景图片 new 透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
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
        self.labc.text=model.name;
    });
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)UIKeyboardWillHide:(NSNotification *)noti{
    
    [UIView animateWithDuration:0.2 animations:^{
        //恢复到默认y为0的状态，有时候要考虑导航栏要+64
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
    
    [self setNavImageClear];
    self.textViewTop.constant=15;
}
-(void)UIKeyboardWillShow:(NSNotification *)noti{
    
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //keyboardFrame.origin.y;
    CGFloat height = keyboardFrame.size.height;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = -height ;
        self.view.frame = frame;
    }];
    
    [self setNav];
    
    self.textViewTop.constant=height-245+64+30;
}

-(void)setNav{
    //1.设置导航栏的背景图片 new 透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_top_4"] forBarMetrics:UIBarMetricsDefault];
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
    //默认背景图片
    [self setImageVDefaultImage:@[self.imgA,self.imgB,self.imgC,self.imgD]];
    
    if (currentImage) {
        currentImage.image=[UIImage imageNamed:@"remark_select"];
    }
    
    //默认字体颜色
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
    _text=[NSMutableString stringWithString:textView.text];
    self.placeholderLab.hidden=YES;
    
    if (textView.text.length>0) {
        self.placeholderLab.hidden=YES;
    }else{
        self.placeholderLab.hidden=NO;
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

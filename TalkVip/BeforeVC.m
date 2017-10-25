//
//  BeforeVC.m
//  TalkVip
//
//  Created by mac on 2017/8/21.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "BeforeVC.h"

@interface BeforeVC ()<UITextViewDelegate>
{
    NSMutableString *_text;
    NSInteger _location;
    CGFloat bgView_x;
    NSInteger _type;
    
    //    0：未联系；1：重点；2：无意愿；3：有意愿;
    NSString  *_state_type;
    
    NSInteger _count;
}
@property (weak, nonatomic) IBOutlet UILabel *accountID;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLab;

@property (weak, nonatomic) IBOutlet UIButton *stateA;
@property (weak, nonatomic) IBOutlet UIButton *stateB;
@property (weak, nonatomic) IBOutlet UIButton *stateC;
@property (weak, nonatomic) IBOutlet UIButton *stateD;

@property (weak, nonatomic) IBOutlet UIImageView *imageVa;
@property (weak, nonatomic) IBOutlet UIImageView *imageVb;
@property (weak, nonatomic) IBOutlet UIImageView *imageVc;
@property (weak, nonatomic) IBOutlet UIImageView *imageVd;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLab;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailing;

@property (weak, nonatomic) IBOutlet UIButton *a;
@property (weak, nonatomic) IBOutlet UIButton *b;
@property (weak, nonatomic) IBOutlet UIButton *c;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTop;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation BeforeVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavImageClear];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeBackgroundImage:nil andBtn:nil];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    _count=0;
    self.bgView.hidden=YES;
    
    _text=[NSMutableString stringWithFormat:@""];
    self.textView.delegate=self;
    
    self.accountID.text=self.accountID_str;
    self.descriptionLab.text=self.descriptionLab_str;
    
    //监听键盘弹起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setColor];
    
    [self setGesture];
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
        if (_type==3) {
            distance=210;
        }else if(_type==2){
            distance=150;
        }
        
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
-(void)setColor{
    [self.a setTitleColor:[UIColor colorWithHexString:@"60718D"] forState:UIControlStateNormal ];
    [self.a setTitleColor:[UIColor colorWithHexString:@"5a89ff"] forState:UIControlStateHighlighted];
    
    [self.b setTitleColor:[UIColor colorWithHexString:@"60718D"] forState:UIControlStateNormal ];
    [self.b setTitleColor:[UIColor colorWithHexString:@"5a89ff"] forState:UIControlStateHighlighted];
    
    [self.c setTitleColor:[UIColor colorWithHexString:@"60718D"] forState:UIControlStateNormal ];
    [self.c setTitleColor:[UIColor colorWithHexString:@"5a89ff"] forState:UIControlStateHighlighted];
}
//收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)setNavImageClear{
    //1.设置导航栏的背景图片 new 透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
-(void)setNav{
    //1.设置导航栏的背景图片 new 透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_top_4"] forBarMetrics:UIBarMetricsDefault];
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
    //se 253  真机 282
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = -height ;
        self.view.frame = frame;
    }];
    [self setNav];
    //150
    //系统键盘正好 height-245+64
    self.textViewTop.constant=height-245+64+30;
}
//bgView_x=self.bgView.frame.origin.x
#pragma mark --- 点击tag标签
- (IBAction)tagBtn:(UIButton *)sender {
    [self showAndHide];
}
-(void)showAndHide{
    CGFloat distance=0;
    if (_type==3) {
        distance=210;
    }else if(_type==2){
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
    
    if (_type==3) {
        switch (state) {
            case 100:[self setTextViewContentWith:@"无人接听"];break;
            case 101:[self setTextViewContentWith:@"直接挂断"]; break;
            case 102:[self setTextViewContentWith:@"关机"]; break;
            default:break;
        }
    }else if (_type==2){
        switch (state) {
            case 100:[self setTextViewContentWith:@"无意愿"];break;
            case 101:[self setTextViewContentWith:@"接通后挂断"];break;
            case 102:[self setTextViewContentWith:@"null"];break;
            default:break;
        }
    }
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

//    0：未联系；1：重点；2：无意愿；3：有意愿;

//未联系 tag
#pragma mark --- 特别注意:这里这里获取bgView_x和viewDidLoad里面理论上应该是一样的，但是实际不一样，会造成不同手机效果不一样，可能是在storyboard上加载延时造成的！
- (IBAction)stateA:(UIButton *)sender {
    if (_count==0) {
        bgView_x=self.bgView.frame.origin.x;
        _count=1;
    }
    [self changeBackgroundImage:self.imageVa andBtn:self.stateA];

    self.bgView.hidden=NO;
    [self setTagNameByTape:3];
    _type=3;
    
    _state_type=@"0";
}
//重点
- (IBAction)stateB:(UIButton *)sender {
    
    self.bgView.hidden=YES;
    
    [self changeBackgroundImage:self.imageVb andBtn:self.stateB];
    
    _state_type=@"1";
}
//有意愿
- (IBAction)stateC:(UIButton *)sender {
    self.bgView.hidden=YES;
    [self changeBackgroundImage:self.imageVc andBtn:self.stateC];
    
    _state_type=@"3";
}
//无意愿 tag
- (IBAction)stateD:(UIButton *)sender {
    [self changeBackgroundImage:self.imageVd andBtn:self.stateD];
    
    //注意:这里用count的原因是保证bgView_x只赋值一次，否则frame变化的话会影响初始值
    if (_count==0) {
        bgView_x=self.bgView.frame.origin.x;
        _count=1;
    }
    
    self.bgView.hidden=NO;
    [self setTagNameByTape:2];
    _type=2;
    
    _state_type=@"2";
}

#pragma mark --- 保存
//    0：未联系；1：重点；2：无意愿；3：有意愿;
- (IBAction)save:(UIButton *)sender {
    if (self.textView.text.length==0) {
        [MBProgressHUD showError:@"请添加备注!"];
        return;
    }
    if (_state_type) {
        NSArray *arr=@[@"未联系",@"重点",@"无意愿",@"有意愿"];
        NSString *api=@"/Comment/directNotes";
        NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl_mt,api];
        NSDictionary *para=@{@"id":self.accountID_str,
                             @"note":self.textView.text,
                             @"status":_state_type};
        //开始请求
        [NetWorkManager loadDateWithToken:YES andWithUrl:urlStr andPara:para andSuccess:^(NSDictionary *responseObject) {
            
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                
                if (self.block) {
                    self.block(arr[_state_type.integerValue]);
                }
                
               [self.navigationController popViewControllerAnimated:YES];
            }
        } andfailure:^(NSError *error) {
            
        }];
    }else{
        [MBProgressHUD showError:@"请选择类型！"];
        return;
    }
}

- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)setTextViewContentWith:(NSString *)content{
    
    [_text insertString:content atIndex:_location];
    self.textView.text=[NSString stringWithFormat:@"%@",_text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(void)changeBackgroundImage:(UIImageView *)currentImage andBtn:(UIButton *)currentBtn{
    //1.切换背景图片
    for (UIImageView *tempImageV in @[self.imageVa,self.imageVb,self.imageVc,self.imageVd]) {
        tempImageV.image=[UIImage imageNamed:@"remark"];
    }
    if (currentImage) {
        currentImage.image=[UIImage imageNamed:@"remark_select"];
    }
    
    
    //2.设置btn颜色
    for (UIButton *btn in @[self.stateA,self.stateB,self.stateC,self.stateD]) {
        [btn setTitleColor:[UIColor colorWithHexString:@"abc5e6"] forState:UIControlStateNormal];
    }
    if (currentBtn) {
        [currentBtn setTitleColor:[UIColor colorWithHexString:@"5a89ff"] forState:UIControlStateNormal];
    }
    
}
#pragma mark - KVO
-(void)textViewDidChangeSelection:(UITextView *)textView{
    
    NSRange rg =textView.selectedRange;
    if (rg.location == NSNotFound) {
        // 如果没找到光标,就把光标定位到文字结尾
        rg.location = textView.text.length;
    }
    _location=rg.location;
}
//这里定位光标不行，非得文字长发生变化才执行
-(void)textViewDidChange:(UITextView *)textView{
    
    _text=[NSMutableString stringWithString:textView.text];
    
    self.placeholderLab.hidden=YES;
    
    if (textView.text.length>0) {
        self.placeholderLab.hidden=YES;
    }else{
        self.placeholderLab.hidden=NO;
    }
}
@end

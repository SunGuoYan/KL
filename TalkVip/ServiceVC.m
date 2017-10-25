//
//  ServiceVC.m
//  TalkVip
//
//  Created by SunGuoYan on 17/4/11.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "ServiceVC.h"

@interface ServiceVC ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@end

@implementation ServiceVC
-(void)initialSystemUI{
    //设置导航栏背景色
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithHexString:@"4f91ff"];
    
    //修改导航栏字体颜色及字体大小
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
}
-(void)setNav{
    //1.设置导航栏的背景图片 new 透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_top_4"] forBarMetrics:UIBarMetricsDefault];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNav];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化导航栏
    [self initialSystemUI];
    
    self.webView= [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH-64)];
    self.webView.scrollView.bounces=NO;
    [self.webView sizeToFit];
    self.webView.delegate=self;
    [self.view addSubview:_webView];
    
    [self loadData];
    
    //加载动画放在最下面
    [self addIndicaterView];
}
-(void)loadData{
    NSString *api=@"/Agreement/getAgreement";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl_mt,api];
    
    NSDictionary *para=@{@"did":@"1"};
    [NetWorkManager loadDateWithToken:NO andWithUrl:urlStr andPara:para andSuccess:^(NSDictionary *responseObject) {
        
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            
            [self.webView loadHTMLString:responseObject[@"data"][@"text"] baseURL:nil];
        }
        
    } andfailure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}
-(void)addIndicaterView{
    IndicaterView *c=[[IndicaterView alloc]initWithFrame:self.view.bounds];
    c.tag=100;
    //也可以添加到keyWindow 上
    //    [[UIApplication sharedApplication].keyWindow addSubview:c];
    [self.view addSubview:c];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    IndicaterView *c=(IndicaterView *)[[UIApplication sharedApplication].keyWindow viewWithTag:100];
    [c removeFromSuperview];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    IndicaterView *c=(IndicaterView *)[[UIApplication sharedApplication].keyWindow viewWithTag:100];
    [c removeFromSuperview];
}
- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)OKBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end

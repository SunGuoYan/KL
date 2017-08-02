//
//  MainVC.m
//  TalkVip
//
//  Created by SunGuoYan on 17/3/16.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "MainVC.h"
#import "MyCell.h"
#import "DXPopover.h"

#import "MenuView.h"
#import "LeftMenuViewDemo.h"

#import "SettingVC.h"
#import "AccountInfoVC.h"
#import "WillingVC.h"

#import "RemarksDetailVC.h"

#import "MJRefresh.h"
#import "CustomNormalHeader.h"
#import "CustomerGifHeader.h"
#import "CustomerGifFooter.h"
#import "CustomerBackGifFooter.h"


//监听电话
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

#import "AddRemarksAfterCallVC.h"

#import "ListModel.h"
#import "NetWorkManager.h"


#import "UIImageView+WebCache.h"

#import "LoginVC.h"

//加密
#import "HBRSAHandler.h"

#import "CheckIconVC.h"
#import "SGYTableView.h"


//1.未拨打
NSString *API_serviceNotCall_1=@"/Callphone/serviceNotCall";
//2.待跟进
NSString *API_serviceFollowUp_2=@"/Callphone/serviceFollowUp";
//3.未接通
NSString *API_serviceNotThrough_3=@"/Callphone/serviceNotThrough";
//4.无意愿
NSString *API_serviceNoDesirel_4=@"/Callphone/serviceNoDesire";
//5.重点
NSString *API_serviceFocusOn_5=@"/Callphone/serviceFocusOn";
//6.已提取
NSString *API_serviceExtracted_6=@"/Callphone/serviceExtracted";

#define lightGray [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1]
#define cellH 70
#define btnH 42 //小btn的高度
#define sliderY 38
#define btnW (414/6.0) //小btn的宽度 414 是plus的宽度 以最宽为基准
#define bannerH 44 //banner的高度
#define btnDefaultColor [UIColor colorWithHexString:@"#75879d"]
#define btnSelectColor [UIColor colorWithHexString:@"#5a89ff"]
#define sliderColor [UIColor colorWithHexString:@"#5a89ff"]
#define sliderW 15
@interface MainVC ()<UITableViewDelegate,UITableViewDataSource,HomeMenuViewDelegate,UIScrollViewDelegate>
{
    HBRSAHandler* _handler;
    
    UIImageView *emptyImageV_1;//空白页面
    UIImageView *emptyImageV_2;//空白页面
    UIImageView *emptyImageV_3;//空白页面
    UIImageView *emptyImageV_4;//空白页面
    UIImageView *emptyImageV_5;//空白页面
    UIImageView *emptyImageV_6;//空白页面
    
    UIImageView *indicatorV_1;
    UIImageView *indicatorV_2;
    UIImageView *indicatorV_3;
    UIImageView *indicatorV_4;
    UIImageView *indicatorV_5;
    UIImageView *indicatorV_6;
    
     MBProgressHUD *HUD;
    
    //1 隐藏 0 显示
    NSString *_extract_state;
}
@property(nonatomic,strong)NSMutableArray *emptyArray;
//监听电话
@property (nonatomic, strong) CTCallCenter *callCenter;

@property (weak, nonatomic) IBOutlet UIButton *allTelephoneBtn;

@property (nonatomic, strong) NSArray *configs;

@property (nonatomic, strong) DXPopover *popover;

@property (nonatomic ,strong)MenuView      *menu;

@property(nonatomic,strong)UIScrollView *scrolla;
@property(nonatomic,strong)UIScrollView *scrollb;

@property(nonatomic,strong)UITableView *table1;
@property(nonatomic,strong)UITableView *table2;
@property(nonatomic,strong)UITableView *table3;
@property(nonatomic,strong)UITableView *table4;
@property(nonatomic,strong)UITableView *table5;
@property(nonatomic,strong)UITableView *table6;

@property(nonatomic,strong)NSMutableArray *dataArray1;
@property(nonatomic,strong)NSMutableArray *dataArray2;
@property(nonatomic,strong)NSMutableArray *dataArray3;
@property(nonatomic,strong)NSMutableArray *dataArray4;
@property(nonatomic,strong)NSMutableArray *dataArray5;
@property(nonatomic,strong)NSMutableArray *dataArray6;
@property(nonatomic,strong)UIView *slider;

@property(nonatomic,strong)UILabel *indexLab ;
@property(nonatomic,copy)NSString *totalCount;
@property(nonatomic,strong)NSMutableArray *totalCountArray;

@property(nonatomic,assign)NSInteger currentIndex;

@property(nonatomic,strong)UIProgressView *progressView;

@property(nonatomic,assign)NSInteger page_1;
@property(nonatomic,assign)NSInteger page_2;
@property(nonatomic,assign)NSInteger page_3;
@property(nonatomic,assign)NSInteger page_4;
@property(nonatomic,assign)NSInteger page_5;
@property(nonatomic,assign)NSInteger page_6;

@end

@implementation MainVC


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.callCenter=nil;
}

#pragma mark ---/*** viewWillAppear ***/
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNav];
    
    [self getData];
    //创建 侧滑的View
    [self createLeftMenu];
}

-(void)addLine{
    UIImageView *line=[UIImageView imageWithFrame:CGRectMake(0, 0, screenW, bannerH) Image:@"Projection" BgColor:nil];
    [self.view addSubview:line];
}

-(void)leftbtnClick{
    [self.menu show];
}

#pragma mark --- /***   viewDidLoad   ***/
- (void)viewDidLoad {
    
    //原文地址：http://www.jianshu.com/p/63f758796438
    //如果想将状态栏和导航栏字体全变为白色,这样就行
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [super viewDidLoad];
    
    [self initWithLeftButton];
    
    //开启网络状态监听
    [self startMonitoring];
    
    self.page_1=1;
    self.page_2=1;
    self.page_3=1;
    self.page_4=1;
    self.page_5=1;
    self.page_6=1;
    
    //监听电话:在cell的点击事假之后来时监听
    
    //初始化导航栏
    [self initialSystemUI];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    //table的数据源
//    self.configs = @[@"未拨打",@"待跟进",@"未接通 ",@"无意愿 ",@"已提取",@"重点"];
    
    //1 隐藏 0 显示
    _extract_state=[NSUserDefaults getObjectForKey:EXTRACT_STATE];
    
    if (_extract_state.integerValue == 0) {
        
        self.configs = @[@"未拨打",@"待跟进",@"未接通 ",@"无意愿 ",@"重点",@"已提取"];
//        self.configs = @[@"未拨打",@"重点",@"未接通 ",@"无意愿 ",@"已提取"];
    
    }else if (_extract_state.integerValue == 1){
        self.configs = @[@"未拨打",@"待跟进",@"未接通 ",@"无意愿 ",@"重点"];
//        self.configs = @[@"未拨打",@"重点",@"未接通 ",@"无意愿 "];
    }
    //banner下面的阴影线
    [self addLine];
    
    //1.scrolla
    [self creatScrollAandBtnAndSlider];
    
    //2.scrollb
    [self creatScrollB];
    
    //3.创建 6个table
    [self creatSixTableView];
    
    //4 创建 index 底部的index 进度条
    [self creatIndexPart];
    
    //5.创建 6个定位
    [self createIndicatorV];
    
    //初始化 index 隐藏
    [self setIndicatorHidden:YES];
    
    //6.创建 6个空白图片
    [self creatSixEmptyImage];
    
    //7.创建 加载动画
    [self addIndicaterView];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    HUD.labelText = @"拨打中...";
}

-(void)addIndicaterView{
    IndicaterView *c=[[IndicaterView alloc]initWithFrame:self.view.frame];
    c.tag=100;
    [self.view addSubview:c];
}

-(void)getDataWithAPI:(NSString *)api andPage:(NSString *)page andSize:(NSString *)size andDataArray:(NSMutableArray *)array andTableView:(UITableView *)table andMark:(NSString *)num{
    
    [NetWorkManager loadNetDataWithAPI:api andPage:page andSize:size andSuccess:^(NSDictionary *responseObject) {
        
        if (num.integerValue==1) {
            IndicaterView *c=(IndicaterView *)[self.view viewWithTag:100];
            [c removeFromSuperview];
        }
        [self analysisWith:responseObject andDataArray:array andFreshWithTable:table andMark:num];
        
    } andfailure:^(NSError *error) {
        
        IndicaterView *c=(IndicaterView *)[self.view viewWithTag:100];
        [c removeFromSuperview];
        
        //如果没数据
        if ((self.dataArray1.count||self.dataArray2.count||self.dataArray3.count||self.dataArray4.count||self.dataArray5.count||self.dataArray6.count)) {
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.table1 reloadData];
                [self.table2 reloadData];
                [self.table3 reloadData];
                [self.table4 reloadData];
                [self.table5 reloadData];
                [self.table6 reloadData];
            });
            
            [SGYTool setImageV:@[emptyImageV_1,emptyImageV_2,emptyImageV_3,emptyImageV_4,emptyImageV_5,emptyImageV_6] withImageName:@"no_wifi"];
            
            [SGYTool setViewHidden:@[indicatorV_1,indicatorV_2,indicatorV_3,indicatorV_4,indicatorV_5,indicatorV_6] withState:NO];
        }
    }];
}

-(void)analysisWith:(NSDictionary *)responseObject andDataArray:(NSMutableArray *)array andFreshWithTable:(UITableView *)table andMark:(NSString *)num{
    //
    if ([responseObject[@"code"] isEqualToString:@"1006"]||[responseObject[@"code"] isEqualToString:@"1009"]) {
        
        UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:@"账号已过期，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionA=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        
        UIAlertAction *actionB=[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIStoryboard *sb_My = [UIStoryboard storyboardWithName:@"My" bundle:nil];
            LoginVC *vc=[sb_My instantiateViewControllerWithIdentifier:NSStringFromClass([LoginVC class])];
            UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:vc];

            
            [UIApplication sharedApplication].keyWindow.rootViewController = nvc;
            
            //刷新Window视图
            [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            [NSUserDefaults removeObjectForKey:@"isLogin"];
            
        }];
        
        [alertVC addAction:actionA];
        [alertVC addAction:actionB];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
    if ([responseObject[@"msg"] isEqualToString:@"success"]) {
        //总条数
        NSString *count=[NSString stringWithFormat:@"%@",responseObject[@"data"][@"total"]];
        NSString *notifyURL=[NSString stringWithFormat:@"%@",responseObject[@"data"][@"notifyURL"]];
        if (count.integerValue>0) {
            switch (num.integerValue) {
                case 1:
                    [SGYTool setViewHidden:@[emptyImageV_1,indicatorV_1] withState:YES];
                    break;
                case 2:
                    [SGYTool setViewHidden:@[emptyImageV_2,indicatorV_2] withState:YES];
                    break;
                case 3:
                    [SGYTool setViewHidden:@[emptyImageV_3,indicatorV_3] withState:YES];
                    break;
                case 4:
                    [SGYTool setViewHidden:@[emptyImageV_4,indicatorV_4] withState:YES];
                    break;
                case 5:
                    [SGYTool setViewHidden:@[emptyImageV_5,indicatorV_5] withState:YES];
                    break;
                case 6:
                    [SGYTool setViewHidden:@[emptyImageV_6,indicatorV_6] withState:YES];
                    break;
                default:
                    break;
            }
        }else{//如果只有0条
            UIImage *image=[UIImage imageNamed:@"empty_list"];
            switch (num.integerValue) {
                case 1:
                    [self setImageV:emptyImageV_1 with:image andHide:indicatorV_1];
                    break;
                case 2:
                    [self setImageV:emptyImageV_2 with:image andHide:indicatorV_2];
                    break;
                case 3:
                    [self setImageV:emptyImageV_3 with:image andHide:indicatorV_3];
                    break;
                case 4:
                    [self setImageV:emptyImageV_4 with:image andHide:indicatorV_4];
                    break;
                case 5:
                   [self setImageV:emptyImageV_5 with:image andHide:indicatorV_5];
                    break;
                case 6:
                    [self setImageV:emptyImageV_6 with:image andHide:indicatorV_6];
                    break;
                default:
                    break;
            }
        }
        //存储没页的个数
        [NSUserDefaults setObject:count ForKey:num];
        
        NSArray *arr = responseObject[@"data"][@"list"];
        if (count.integerValue>0)
        {
            for (NSDictionary *dic in arr) {
                ListModel *model=[[ListModel alloc] init];
                model.id_str=dic[@"id"];
                model.inputtime=dic[@"inputtime"];
                model.mobile=dic[@"mobile"];
                model.name=dic[@"name"];
                model.sourceid=dic[@"sourceid"];
                model.notifyURL=notifyURL;
                [array addObject:model];
            }
        }else{
        }
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [table reloadData];
        });
        //注意放到if外面  没有数据的时候也要停止刷新
//        [self TableEndRefreshing];
    }
}
-(void)setImageV:(UIImageView *)imageV with:(UIImage *)image andHide:(UIView *)A{
    imageV.image=image;
    imageV.hidden=NO;
    A.hidden=YES;
}

-(void)creatIndexPart{
    
    CGFloat indexW=60;
    CGFloat indexH=30;
    
    CGFloat progressH=10;
    CGFloat bgW=100;
    
    //0.bg
    UIView *bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bgW, indexH+5+progressH)];
    bg.center=CGPointMake(screenW/2, screenH-50-64);
    [self.view addSubview:bg];
    
    //1.indexLab
    self.indexLab=[UILabel labelWithFrame:CGRectMake(0, 0, indexW, indexH) withTest:@"1/123" titleFontSize:15 textColor:[UIColor colorWithHexString:@"#5a89ff"] backgroundColor:nil alignment:NSTextAlignmentCenter];
    self.indexLab.center=CGPointMake(bgW/2, indexH/2);
    self.indexLab.font=[UIFont boldSystemFontOfSize:14];
    [bg addSubview:self.indexLab];
    
    //2.progressView
    self.progressView=[[UIProgressView alloc]initWithFrame:CGRectMake(0, 35, 50, 20)];
    self.progressView.center=CGPointMake(bgW/2, indexH);
    
    self.progressView.progressTintColor=[UIColor colorWithHexString:@"#5a89ff"];
    self.progressView.trackTintColor=[UIColor colorWithRed:0.74 green:0.82 blue:1 alpha:1];
    //设置进度值，范围是0.0-1.0
    self.progressView.progress=0.5;
    self.progressView.alpha=1;
    
    //设定宽高
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    self.progressView.transform = transform;
    
    [bg addSubview:self.progressView];
}

-(void)createIndicatorV{
    UIImage *image=[UIImage imageNamed:@"indicater"];
    CGFloat W=image.size.width;
    CGFloat H=image.size.height;
    
    indicatorV_1=[UIImageView imageWithFrame:CGRectMake(12.5, cellH/2-5, W,H) Image:@"indicater" BgColor:nil];
    [self.scrollb addSubview:indicatorV_1];
    
    indicatorV_2=[UIImageView imageWithFrame:CGRectMake(12.5+screenW, cellH/2-5, W,H) Image:@"indicater" BgColor:nil];
    [self.scrollb addSubview:indicatorV_2];
    
    indicatorV_3=[UIImageView imageWithFrame:CGRectMake(12.5+screenW*2, cellH/2-5, W,H) Image:@"indicater" BgColor:nil];
    [self.scrollb addSubview:indicatorV_3];
    
    indicatorV_4=[UIImageView imageWithFrame:CGRectMake(12.5+screenW*3, cellH/2-5, W,H) Image:@"indicater" BgColor:nil];
    [self.scrollb addSubview:indicatorV_4];
    
    indicatorV_5=[UIImageView imageWithFrame:CGRectMake(12.5+screenW*4, cellH/2-5, W,H) Image:@"indicater" BgColor:nil];
    [self.scrollb addSubview:indicatorV_5];
    
    indicatorV_6=[UIImageView imageWithFrame:CGRectMake(12.5+screenW*5,cellH/2-5, W,H) Image:@"indicater" BgColor:nil];
    [self.scrollb addSubview:indicatorV_6];
    
    
    [SGYTool setViewHidden:@[indicatorV_1,indicatorV_2,indicatorV_3,indicatorV_4,indicatorV_5,indicatorV_6] withState:YES];
}

#pragma mark --- 6个table的创建
-(void)creatSixTableView{
    //1.未拨打
    self.table1=[[SGYTableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH-64-bannerH) style:UITableViewStylePlain];
    self.table1.dataSource=self;
    self.table1.delegate=self;
    
    self.table1.mj_header=[CustomerGifHeader headerWithRefreshingBlock:^{
        //这里不可以封装，self.page_1形参=1 但是实参没有
        /*
        [self refreshHeaderWithPage:self.page_1 andTargetDataArra:self.dataArray1 andAPI:API_serviceNotCall_1 andTableView:self.table1 andNum:@"1"];
        */
         
        self.page_1=1;
//        [self.dataArray1 removeAllObjects];
        
        //开始刷新
        [NetWorkManager loadNetDataWithAPI:API_serviceNotCall_1 andPage:[NSString stringWithFormat:@"%ld",self.page_1] andSize:@"20" andSuccess:^(NSDictionary *responseObject) {
            
            if ([responseObject[@"result"] isEqualToString:@"success"]){
                
                //清除之前的
                [self.dataArray1 removeAllObjects];
                //刷新后来的
                [self analysisWith:responseObject andDataArray:self.dataArray1 andFreshWithTable:self.table1 andMark:@"1"];
            }
        } andfailure:^(NSError *error) {
            
            [self startMonitoring];
        }];
        
         [self TableEndRefreshing];
         
    }];
    
    self.table1.mj_footer=[CustomerBackGifFooter footerWithRefreshingBlock:^{
        /*
        [self refreshFooterWithPage:self.page_1 andTargetDataArra:self.dataArray1 andAPI:API_serviceNotCall_1 andTableView:self.table1 andNum:@"1"];
        */
        self.page_1+=1;
        [NetWorkManager loadNetDataWithAPI:API_serviceNotCall_1 andPage:[NSString stringWithFormat:@"%ld",self.page_1] andSize:@"20" andSuccess:^(NSDictionary *responseObject) {
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                NSString *totalpage=[NSString stringWithFormat:@"%@",responseObject[@"data"][@"totalpage"]];
                //如果超页了
                if (self.page_1>totalpage.integerValue) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self TableEndRefreshing];
                    });
                    
                }else{
                    [self analysisWith:responseObject andDataArray:self.dataArray1 andFreshWithTable:self.table1 andMark:@"1"];
                }
            }
        } andfailure:^(NSError *error) {
            
            [self startMonitoring];
        }];
        
        [self TableEndRefreshing];
        
    }];
    [self.scrollb addSubview:self.table1];
    
    //2.待跟进
    self.table2=[[SGYTableView alloc]initWithFrame:CGRectMake(screenW, 0, screenW, screenH-64-bannerH) style:UITableViewStylePlain];
    self.table2.dataSource=self;
    self.table2.delegate=self;
    
    self.table2.mj_header=[CustomerGifHeader headerWithRefreshingBlock:^{
        
        self.page_2=1;
//        [self.dataArray2 removeAllObjects];
        
        [NetWorkManager loadNetDataWithAPI:API_serviceFollowUp_2 andPage:[NSString stringWithFormat:@"%ld",self.page_2] andSize:@"20" andSuccess:^(NSDictionary *responseObject) {
            
            if ([responseObject[@"result"] isEqualToString:@"success"]){
                //清除之前的
                [self.dataArray2 removeAllObjects];
                //刷新后来的
                [self analysisWith:responseObject andDataArray:self.dataArray2 andFreshWithTable:self.table2 andMark:@"2"];
            }
            
        } andfailure:^(NSError *error) {
            
            [self startMonitoring];
        }];
        
        [self TableEndRefreshing];
        
    }];
    
    self.table2.mj_footer=[CustomerBackGifFooter footerWithRefreshingBlock:^{
        self.page_2+=1;
        [NetWorkManager loadNetDataWithAPI:API_serviceFollowUp_2 andPage:[NSString stringWithFormat:@"%ld",self.page_2] andSize:@"20" andSuccess:^(NSDictionary *responseObject) {
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                NSString *totalpage=[NSString stringWithFormat:@"%@",responseObject[@"data"][@"totalpage"]];
                //如果超页了
                if (self.page_2>totalpage.integerValue) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self TableEndRefreshing];
                    });
                    
                }else{
                    [self analysisWith:responseObject andDataArray:self.dataArray2 andFreshWithTable:self.table2 andMark:@"2"];
                }
            }
        } andfailure:^(NSError *error) {
            [self startMonitoring];
        }];
        
        [self TableEndRefreshing];
        
    }];
    [self.scrollb addSubview:self.table2];
    
    //3.未接通
    self.table3=[[SGYTableView alloc]initWithFrame:CGRectMake(screenW*2, 0, screenW, screenH-64-bannerH) style:UITableViewStylePlain];
    self.table3.dataSource=self;
    self.table3.delegate=self;
    
    self.table3.mj_header=[CustomerGifHeader headerWithRefreshingBlock:^{
        
        self.page_3=1;
//        [self.dataArray3 removeAllObjects];
        
        [NetWorkManager loadNetDataWithAPI:API_serviceNotThrough_3 andPage:[NSString stringWithFormat:@"%ld",self.page_3] andSize:@"20" andSuccess:^(NSDictionary *responseObject) {
            
            if ([responseObject[@"result"] isEqualToString:@"success"]){
                //清除之前的
                [self.dataArray3 removeAllObjects];
                //刷新后来的
                [self analysisWith:responseObject andDataArray:self.dataArray3 andFreshWithTable:self.table3 andMark:@"3"];
            }
            
        } andfailure:^(NSError *error) {
            [self startMonitoring];
        }];
        
        [self TableEndRefreshing];
    }];
    
    self.table3.mj_footer=[CustomerBackGifFooter footerWithRefreshingBlock:^{
        
        self.page_3+=1;
        [NetWorkManager loadNetDataWithAPI:API_serviceNotThrough_3 andPage:[NSString stringWithFormat:@"%ld",self.page_3] andSize:@"20" andSuccess:^(NSDictionary *responseObject) {
            
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                NSString *totalpage=[NSString stringWithFormat:@"%@",responseObject[@"data"][@"totalpage"]];
                //如果超页了
                if (self.page_3>totalpage.integerValue) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self TableEndRefreshing];
                    });
                    
                }else{
                    [self analysisWith:responseObject andDataArray:self.dataArray3 andFreshWithTable:self.table3 andMark:@"3"];
                }
            }
        } andfailure:^(NSError *error) {
            [self startMonitoring];
        }];
        
        [self TableEndRefreshing];
        
    }];
    [self.scrollb addSubview:self.table3];
    
    //4.无意愿
    self.table4=[[SGYTableView alloc]initWithFrame:CGRectMake(screenW*3, 0, screenW, screenH-64-bannerH) style:UITableViewStylePlain];
    self.table4.dataSource=self;
    self.table4.delegate=self;
    
    self.table4.mj_header=[CustomerGifHeader headerWithRefreshingBlock:^{
        self.page_4=1;
//        [self.dataArray4 removeAllObjects];
        
        [NetWorkManager loadNetDataWithAPI:API_serviceNoDesirel_4 andPage:[NSString stringWithFormat:@"%ld",self.page_4] andSize:@"20" andSuccess:^(NSDictionary *responseObject) {
            
            if ([responseObject[@"result"] isEqualToString:@"success"]){
                //清除之前的
                [self.dataArray4 removeAllObjects];
                //刷新后来的
                [self analysisWith:responseObject andDataArray:self.dataArray4 andFreshWithTable:self.table4 andMark:@"4"];
            }
            
        } andfailure:^(NSError *error) {
            
            [self startMonitoring];
        }];
        [self TableEndRefreshing];
    }];
    
    self.table4.mj_footer=[CustomerBackGifFooter footerWithRefreshingBlock:^{
        self.page_4+=1;
        [NetWorkManager loadNetDataWithAPI:API_serviceNoDesirel_4 andPage:[NSString stringWithFormat:@"%ld",self.page_4] andSize:@"20" andSuccess:^(NSDictionary *responseObject) {
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                NSString *totalpage=[NSString stringWithFormat:@"%@",responseObject[@"data"][@"totalpage"]];
                //如果超页了
                if (self.page_4>totalpage.integerValue) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self TableEndRefreshing];
                    });
                    
                }else{
                    [self analysisWith:responseObject andDataArray:self.dataArray4 andFreshWithTable:self.table4 andMark:@"4"];
                }
            }
        } andfailure:^(NSError *error) {
            [self startMonitoring];
        }];
        [self TableEndRefreshing];
    }];
    [self.scrollb addSubview:self.table4];
    
    //5.重点
    self.table5=[[SGYTableView alloc]initWithFrame:CGRectMake(screenW*4, 0, screenW, screenH-64-bannerH) style:UITableViewStylePlain];
    self.table5.dataSource=self;
    self.table5.delegate=self;
    
    self.table5.mj_header=[CustomerGifHeader headerWithRefreshingBlock:^{
        
        self.page_5=1;
        //        [self.dataArray5 removeAllObjects];
        
        [NetWorkManager loadNetDataWithAPI:API_serviceFocusOn_5 andPage:[NSString stringWithFormat:@"%ld",self.page_5] andSize:@"20" andSuccess:^(NSDictionary *responseObject) {
            
            if ([responseObject[@"result"] isEqualToString:@"success"]){
                
                //清除之前的
                [self.dataArray5 removeAllObjects];
                //刷新后来的
                [self analysisWith:responseObject andDataArray:self.dataArray5 andFreshWithTable:self.table5 andMark:@"5"];
            }
            
        } andfailure:^(NSError *error) {
            [self startMonitoring];
        }];
        [self TableEndRefreshing];
    }];
    
    self.table5.mj_footer=[CustomerBackGifFooter footerWithRefreshingBlock:^{
        self.page_5+=1;
        [NetWorkManager loadNetDataWithAPI:API_serviceFocusOn_5 andPage:[NSString stringWithFormat:@"%ld",self.page_5] andSize:@"20" andSuccess:^(NSDictionary *responseObject) {
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                NSString *totalpage=[NSString stringWithFormat:@"%@",responseObject[@"data"][@"totalpage"]];
                //如果超页了
                if (self.page_5>totalpage.integerValue) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self TableEndRefreshing];
                    });
                    
                }else{
                    [self analysisWith:responseObject andDataArray:self.dataArray5 andFreshWithTable:self.table5 andMark:@"5"];
                }
            }
        } andfailure:^(NSError *error) {
            [self startMonitoring];
        }];
        [self TableEndRefreshing];
    }];
    [self.scrollb addSubview:self.table5];
    
    //6.已提取
    self.table6=[[SGYTableView alloc]initWithFrame:CGRectMake(screenW*5, 0, screenW, screenH-64-bannerH) style:UITableViewStylePlain];
    self.table6.dataSource=self;
    self.table6.delegate=self;
    //6.table6的刷新
    self.table6.mj_header=[CustomerGifHeader headerWithRefreshingBlock:^{
        self.page_6=1;
        
        [NetWorkManager loadNetDataWithAPI:API_serviceExtracted_6 andPage:[NSString stringWithFormat:@"%ld",self.page_6] andSize:@"20" andSuccess:^(NSDictionary *responseObject) {
            
            if ([responseObject[@"result"] isEqualToString:@"success"]){
                //清除之前的
                [self.dataArray6 removeAllObjects];
                //刷新后来的
                [self analysisWith:responseObject andDataArray:self.dataArray6 andFreshWithTable:self.table6 andMark:@"6"];
            }
            
        } andfailure:^(NSError *error) {
            
            [self startMonitoring];
        }];
        
        [self TableEndRefreshing];
    }];
    
    self.table6.mj_footer=[CustomerBackGifFooter footerWithRefreshingBlock:^{
        self.page_6+=1;
        [NetWorkManager loadNetDataWithAPI:API_serviceExtracted_6 andPage:[NSString stringWithFormat:@"%ld",self.page_6] andSize:@"20" andSuccess:^(NSDictionary *responseObject) {
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                NSString *totalpage=[NSString stringWithFormat:@"%@",responseObject[@"data"][@"totalpage"]];
                //如果超页了
                if (self.page_6>totalpage.integerValue) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self TableEndRefreshing];
                    });
                    
                }else{
                    [self analysisWith:responseObject andDataArray:self.dataArray6 andFreshWithTable:self.table6 andMark:@"6"];
                }
            }
        } andfailure:^(NSError *error) {
            [self startMonitoring];
        }];
        [self TableEndRefreshing];
        
    }];
    [self.scrollb addSubview:self.table6];
}
#pragma mark --- table的三个函数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView==self.table1) {
        
        return self.dataArray1.count;
        
    }else if (tableView==self.table2){
        
        return self.dataArray2.count;
        
    }else if (tableView==self.table3){
        
        return self.dataArray3.count;
        
    }else if (tableView==self.table4){
        
        return self.dataArray4.count;
        
    }else if (tableView==self.table5){
        
        return self.dataArray5.count;
        
    }else if (tableView==self.table6){
        
        return self.dataArray6.count;
    }
    
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.table1) {//1
        static NSString *cellName = @"MyCell";
        MyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCell" owner:nil options:nil] lastObject];
        }
        //cell的赋值
        
        //安全验证 防止频繁拉动的时候崩溃
        if (self.dataArray1.count>0) {
            if (self.dataArray1.count>=indexPath.row) {
                ListModel *model=self.dataArray1[indexPath.row];
                cell.labb.text=model.id_str;
                cell.labc.text=model.mobile;
                cell.labd.text=model.name;
                
                //cell右侧的点击事件
                cell.index=indexPath.row;
                cell.block = ^(NSInteger index)
                {
                    model.type=@"未拨打";
                    
                    [self goToRemarksDetailWithModel:model andTargetDataArray:self.dataArray1 andIndex:indexPath.row];
                };
            }
        }
        return cell;
        
    }else if (tableView==self.table2) {//2
        static NSString *cellName = @"MyCell2";
        MyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCell" owner:nil options:nil] lastObject];
        }
        if (self.dataArray2.count>0) {
            if (self.dataArray2.count>=indexPath.row) {
                ListModel *model=self.dataArray2[indexPath.row];
                cell.labb.text=model.id_str;
                cell.labc.text=model.mobile;
                cell.labd.text=model.name;
                cell.index=indexPath.row;
                cell.block = ^(NSInteger index)
                {
                    model.type=@"待跟进";
                    [self goToRemarksDetailWithModel:model andTargetDataArray:self.dataArray2 andIndex:indexPath.row];
                };
            }
        }
        return cell;
    }else if (tableView==self.table3) {//3
        static NSString *cellName = @"MyCell3";
        MyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCell" owner:nil options:nil] lastObject];
        }
        if (self.dataArray3.count>0) {
            if (self.dataArray3.count>=indexPath.row) {
                ListModel *model=self.dataArray3[indexPath.row];
                cell.labb.text=model.id_str;
                cell.labc.text=model.mobile;
                cell.labd.text=model.name;
                cell.index=indexPath.row;
                cell.block = ^(NSInteger index)
                {
                    model.type=@"未接通";
                    [self goToRemarksDetailWithModel:model andTargetDataArray:self.dataArray3 andIndex:indexPath.row];
                };
            }
        }
        return cell;
    }else if (tableView==self.table4) {//4
        static NSString *cellName = @"MyCell4";
        MyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCell" owner:nil options:nil] lastObject];
        }
        if (self.dataArray4.count>0) {
            if (self.dataArray4.count>=indexPath.row) {
                ListModel *model=self.dataArray4[indexPath.row];
                cell.labb.text=model.id_str;
                cell.labc.text=model.mobile;
                cell.labd.text=model.name;
                
                cell.index=indexPath.row;
                cell.block = ^(NSInteger index)
                {
                    model.type=@"无意愿";
                    [self goToRemarksDetailWithModel:model andTargetDataArray:self.dataArray4 andIndex:indexPath.row];
                };
            }
        }
        return cell;
    }else if (tableView==self.table5) {//5
        static NSString *cellName = @"MyCell5";
        MyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell==nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCell" owner:nil options:nil] lastObject];
        }
        //安全验证 防崩溃
        if (self.dataArray5.count>0) {
            if (self.dataArray5.count>=indexPath.row) {
                ListModel *model=self.dataArray5[indexPath.row];
                cell.labb.text=model.id_str;
                cell.labc.text=model.mobile;
                cell.labd.text=model.name;
                
                cell.index=indexPath.row;
                cell.block = ^(NSInteger index)
                {
                    model.type=@"重点";
                    [self goToRemarksDetailWithModel:model andTargetDataArray:self.dataArray5 andIndex:indexPath.row];
                };
            }
        }
        return cell;
    }else if (tableView==self.table6) {//6
        static NSString *cellName = @"MyCell6";
        MyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCell" owner:nil options:nil] lastObject];
        }
        
        if (self.dataArray6.count>0) {
            if (self.dataArray6.count>=indexPath.row) {
                ListModel *model=self.dataArray6[indexPath.row];
                cell.labb.text=model.id_str;
                cell.labc.text=model.mobile;
                cell.labd.text=model.name;
                
                cell.index=indexPath.row;
                cell.block = ^(NSInteger index)
                {
                    model.type=@"已提取";
                    [self goToRemarksDetailWithModel:model andTargetDataArray:self.dataArray6 andIndex:indexPath.row];
                };
            }
        }
        return cell;
    }
    return nil;
}
//拨打之后进入详细
-(void)addRemarksAfterCalling{
    [SGYTool pushWithStoryBoard:@"My" from:self.navigationController to:@"AddRemarksAfterCallVC"];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)setTableUserInteractionEnabled:(BOOL)state{
    self.table1.userInteractionEnabled=state;
    self.table2.userInteractionEnabled=state;
    self.table3.userInteractionEnabled=state;
    self.table4.userInteractionEnabled=state;
    self.table5.userInteractionEnabled=state;
    self.table6.userInteractionEnabled=state;
}
#pragma mark --- cell 的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [HUD show:YES];
//    [self setTableUserInteractionEnabled:NO];
    
    NSMutableArray *targetArray=nil;
    NSString *num=nil;
    if (tableView==self.table1) {
        
        targetArray=self.dataArray1;
        //待跟进
        num=@"1";
    }else if (tableView==self.table2){
        
        targetArray=self.dataArray2;
        //未接通
        num=@"2";
    }else if (tableView==self.table3){
        
        targetArray=self.dataArray3;
        //无意愿
        num=@"3";
        
    }else if (tableView==self.table4){
        
        targetArray=self.dataArray4;
        //已提取
        num=@"4";
        
    }else if (tableView==self.table5){
        
        targetArray=self.dataArray5;
        //重点
        num=@"5";
        
    }else if (tableView==self.table6){
        
        targetArray=self.dataArray6;
        //已提取
        num=@"6";
    }
    
    if (targetArray.count>0) {
        
        [self makeSingleCallWithDataArray:targetArray andIndex:indexPath.row andNum:num];
    }else{
        
//        [self setTableUserInteractionEnabled:YES];
    }
    
    //电话结束后跳转到备注界面
//    [self addRemarksAfterCalling];
    
}
#pragma mark --- 单向呼叫打电话
-(void)makeSingleCallWithDataArray:(NSMutableArray *)dataArray andIndex:(NSInteger)index andNum:(NSString *)num{
    NSString *api=@"/Authorization";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,api];
    
    NSDate * nowTime = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString * timeStr = [formatter stringFromDate:nowTime];
    
    //时间戳
    NSString *timeStamp=[NSString stringWithFormat:@"%d%d%@",arc4random()%9+1,arc4random()%9+1,timeStr];
    
    
    //订单号order 时间+随机的五位数（不足的左补零）
    NSDateFormatter * formatter_SSS = [[NSDateFormatter alloc]init];
    [formatter_SSS setDateFormat:@"YYYYMMddHHmmssSSS"];
    NSString *num_five=[NSString stringWithFormat:@"%d%d%d%d%d",arc4random()%9+1,arc4random()%9+1,arc4random()%9+1,arc4random()%9+1,arc4random()%9+1];
    
    NSString *order=[NSString stringWithFormat:@"%@%@",[formatter stringFromDate:nowTime],num_five];
    
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
                         @"line":@"E",//E
                         @"type":@"1",//1
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
            
            //2，开始监听
            [self observeCallStateandDataArray:(NSMutableArray *)dataArray andIndex:(NSInteger)index andNum:num];
                        
            //3,产生日志
            [self insertLogWithOrder:order andID:model.id_str];
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        [HUD hide:YES];
//        [self setTableUserInteractionEnabled:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [HUD hide:YES];
        
        [MBProgressHUD showError:@"无可用网络，请连接网络后重试"];
        
//        [self setTableUserInteractionEnabled:YES];
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

-(void)goToRemarksDetailWithModel:(ListModel *)model andTargetDataArray:(NSMutableArray *)dataArray andIndex:(NSInteger)index{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"My" bundle:nil];
    RemarksDetailVC *vc=[sb instantiateViewControllerWithIdentifier:NSStringFromClass([RemarksDetailVC class])];
    vc.model=model;
    vc.targetArray=dataArray;
    vc.index=index;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --- 点击侧滑按钮
- (IBAction)goSliderClicked:(UIButton *)sender {
    [self.menu show];
}
-(void)pushToIcon{
    [SGYTool pushWithStoryBoard:@"My" from:self.navigationController to:@"CheckIconVC"];
}
#pragma mark --- 点击侧滑table的回调函数
-(void)LeftMenuViewClick:(NSInteger)tag{

    [self.menu hidenWithAnimation];
    switch (tag) {
        case 0:[self pushToAccountInfo]; break;
        case 1:[self pushToWillingVC]; break;
        case 2:[self pushToSettingVC]; break;
            //200 点击头像
        case 200:[self pushToIcon]; break;
        default:
            break;
    }
}

#pragma mark --- scrollView的代码函数
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    BOOL state_y=(scrollView!=self.scrolla)&&(scrollView!=self.scrollb);
    if (state_y) {
        [self setIndicatorHidden:NO];
    }
}

#pragma mark --- scroll停止拖动的时候（区别滑动）
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //保证拖到动结束的时候最上面的cell不显示半个（区别滑动）
    [self setCell:scrollView];
}
#pragma mark --- scroll停止滑动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self goToIndex:scrollView];
    
    //保证滑动结束的时候最上面的cell不显示半个
    [self setCell:scrollView];
    BOOL state_y=(scrollView!=self.scrolla)&&(scrollView!=self.scrollb);
    if (state_y) {
        [self setIndicatorHidden:YES];
    }
}
-(void)setIndicatorHidden:(BOOL)state{
    self.indexLab.superview.hidden=state;
    self.indexLab.hidden=state;
    self.progressView.hidden=state;
}

#pragma mark --- scroll滑动中
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updatIndexLab:scrollView];
    [self goToIndex:scrollView];
}
-(void)updatIndexLab:(UIScrollView *)scrollView{
    NSInteger index_current=scrollView.contentOffset.y/cellH;
    NSInteger page=self.scrollb.contentOffset.x/screenW;
    NSString * index_total=[NSUserDefaults getObjectForKey:[NSString stringWithFormat:@"%ld",page+1]];
    
    self.indexLab.text=[NSString stringWithFormat:@"%ld/%@",index_current+1,index_total];
    self.progressView.progress=index_current/index_total.floatValue;
}

// cell不显示半个
-(void)setCell:(UIScrollView *)scrollView{
}
//设置slider的滑动
-(void)goToIndex:(UIScrollView *)scrollView{
    if (scrollView == self.scrollb) {
        
        NSInteger index=scrollView.contentOffset.x/screenW;
        
        NSString *totalCount=[NSUserDefaults getObjectForKey:[NSString stringWithFormat:@"%ld",index+1]];
        
        if (totalCount.integerValue>0) {
            
//            indicatorV.hidden=NO;
//            emptyImageV.hidden=YES;
        }else{
//            indicatorV.hidden=YES;
//            emptyImageV.hidden=NO;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            self.slider.center=CGPointMake(btnW/2+(btnW+10)*index, sliderY);
        }];
        
        CGFloat sliderMaxX=btnW+(btnW+10)*index;
        if (sliderMaxX>screenW) {
            [UIView animateWithDuration:0.25 animations:^{
                self.scrolla.contentOffset=CGPointMake(sliderMaxX-screenW, 0);
            }];
        }
        if (sliderMaxX<=btnW+10+btnW) {
            [UIView animateWithDuration:0.25 animations:^{
               self.scrolla.contentOffset=CGPointMake(0, 0);
            }];
        }
        
        for (int i=0; i<self.configs.count; i++) {
            UIButton *btn=[self.view viewWithTag:200+i];
            [btn setTitleColor:btnDefaultColor forState:UIControlStateNormal];
        }
        
        UIButton *currentBtn=[self.view viewWithTag:200+index];
        [currentBtn setTitleColor:btnSelectColor forState:UIControlStateNormal];
    }
}
#pragma mark *******************************
#pragma mark ************ 非重点 ************
#pragma mark *******************************
#pragma mark --- table的数据源
-(void)goToAddRemarkVCandDataArray:(NSMutableArray *)dataArray andIndex:(NSInteger)index andNum:(NSString *)num{
    //主线程里面更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"My" bundle:nil];
        AddRemarksAfterCallVC *vc=[sb instantiateViewControllerWithIdentifier:NSStringFromClass([AddRemarksAfterCallVC class])];
        
        vc.dataArray=dataArray;
        vc.index=index;
        if (num.integerValue==6) {
            vc.type=@"已提取";
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    });
}
//viewDidAppear里面调用，每次返回的时候刷新数据
-(void)getData{
    
    [self.dataArray1 removeAllObjects];
    [self.dataArray2 removeAllObjects];
    [self.dataArray3 removeAllObjects];
    [self.dataArray4 removeAllObjects];
    [self.dataArray5 removeAllObjects];
    [self.dataArray6 removeAllObjects];
    //1,未拨打
    [self getDataWithAPI:API_serviceNotCall_1 andPage:@"1" andSize:@"20" andDataArray:self.dataArray1 andTableView:self.table1 andMark:@"1"];
    
    //2.
    [self getDataWithAPI:API_serviceFollowUp_2 andPage:@"1" andSize:@"20" andDataArray:self.dataArray2 andTableView:self.table2 andMark:@"2"];
    //3.
    [self getDataWithAPI:API_serviceNotThrough_3 andPage:@"1" andSize:@"20" andDataArray:self.dataArray3 andTableView:self.table3 andMark:@"3"];
    //4.
    [self getDataWithAPI:API_serviceNoDesirel_4 andPage:@"1" andSize:@"20" andDataArray:self.dataArray4 andTableView:self.table4 andMark:@"4"];
    //5.
    [self getDataWithAPI:API_serviceFocusOn_5 andPage:@"1" andSize:@"20" andDataArray:self.dataArray5 andTableView:self.table5 andMark:@"5"];
    //6.已提取
    [self getDataWithAPI:API_serviceExtracted_6 andPage:@"1" andSize:@"20" andDataArray:self.dataArray6 andTableView:self.table6 andMark:@"6"];
}
-(void)createLeftMenu{
    LeftMenuViewDemo *demo = [[LeftMenuViewDemo alloc]initWithFrame:CGRectMake(0, 0, screenW* 0.8, screenH)];
    demo.customDelegate = self;
    MenuView *menu = [MenuView MenuViewWithDependencyView:self.view MenuView:demo isShowCoverView:YES];
    self.menu = menu;
}
-(void)creatScrollB{
    
    self.scrollb=[UIScrollView scrollWithFrame:CGRectMake(0, bannerH, screenW, screenH-64-bannerH) pagingEnabled:YES backgroundColor:[UIColor purpleColor] contentSize:CGSizeMake(screenW*self.configs.count, screenH-64-bannerH) Indicator:NO bounces:NO];
    self.scrollb.delegate=self;
    [self.view addSubview:self.scrollb];
}
-(void)creatScrollAandBtnAndSlider{
    
    self.scrolla=[UIScrollView scrollWithFrame:CGRectMake(0, 0, screenW, bannerH) pagingEnabled:NO backgroundColor:nil contentSize:CGSizeMake((btnW+10)*self.configs.count, bannerH) Indicator:NO bounces:NO];
    self.scrolla.delegate=self;
    
    [self.view addSubview:self.scrolla];
    
    for (int i=0; i<self.configs.count; i++) {
        UIButton *btn=[UIButton buttonWithFrame:CGRectMake((btnW+10)*i, 0, btnW, btnH) Title:self.configs[i] BgColor:nil Image:nil Target:self Selector:@selector(bannerClicked:)];
        
        btn.tag=200+i;
        btn.titleLabel.font=[UIFont systemFontOfSize:12];
        btn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
        [btn setTitleColor:btnDefaultColor forState:UIControlStateNormal];
        if (i==0) {
            [btn setTitleColor:btnSelectColor forState:UIControlStateNormal];
        }
        [self.scrolla addSubview:btn];
    }
    //小滑块
    self.slider=[[UIView alloc]initWithFrame:CGRectMake(0, btnH, sliderW, bannerH-btnH)];
    self.slider.center=CGPointMake(btnW/2, sliderY);
    self.slider.backgroundColor=sliderColor;
    self.slider.radius=2;
    [self.scrolla addSubview:self.slider];
}
-(void)TableEndRefreshing{
    //1.
    if ([self.table1.mj_header isRefreshing]) {
        [self.table1.mj_header endRefreshing];
    }
    if ([self.table1.mj_footer isRefreshing]) {
        [self.table1.mj_footer endRefreshing];
    }
    //2.
    if ([self.table2.mj_header isRefreshing]) {
        [self.table2.mj_header endRefreshing];
    }
    if ([self.table2.mj_footer isRefreshing]) {
        [self.table2.mj_footer endRefreshing];
    }
    //3.
    if ([self.table3.mj_header isRefreshing]) {
        [self.table3.mj_header endRefreshing];
    }
    if ([self.table3.mj_footer isRefreshing]) {
        [self.table3.mj_footer endRefreshing];
    }
    //4.
    if ([self.table4.mj_header isRefreshing]) {
        [self.table4.mj_header endRefreshing];
    }
    if ([self.table4.mj_footer isRefreshing]) {
        [self.table4.mj_footer endRefreshing];
    }
    //5.
    if ([self.table5.mj_header isRefreshing]) {
        [self.table5.mj_header endRefreshing];
    }
    if ([self.table5.mj_footer isRefreshing]) {
        [self.table5.mj_footer endRefreshing];
    }
    //6.
    if ([self.table6.mj_header isRefreshing]) {
        [self.table6.mj_header endRefreshing];
    }
    if ([self.table6.mj_footer isRefreshing]) {
        [self.table6.mj_footer endRefreshing];
    }
}
-(void)refreshFooterWithPage:(NSInteger)page andTargetDataArra:(NSMutableArray *)dataArray andAPI:(NSString *)api andTableView:(UITableView *)table andNum:(NSString *)num{
    page+=1;
    [NetWorkManager loadNetDataWithAPI:api andPage:[NSString stringWithFormat:@"%ld",page] andSize:@"20" andSuccess:^(NSDictionary *responseObject) {
        
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            
            NSString *totalpage=[NSString stringWithFormat:@"%@",responseObject[@"data"][@"totalpage"]];
            //如果超页了
            if (page>totalpage.integerValue) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self TableEndRefreshing];
                });
                
            }else{
                [self analysisWith:responseObject andDataArray:dataArray andFreshWithTable:table andMark:num];
            }
        }
    } andfailure:^(NSError *error) {
        
    }];
}

-(void)refreshHeaderWithPage:(NSInteger)page andTargetDataArra:(NSMutableArray *)dataArray andAPI:(NSString *)api andTableView:(UITableView *)table andNum:(NSString *)num{
    
    page=1;
    [dataArray removeAllObjects];
    [NetWorkManager loadNetDataWithAPI:api andPage:[NSString stringWithFormat:@"%ld",page] andSize:@"20" andSuccess:^(NSDictionary *responseObject) {
        
        if ([responseObject[@"result"] isEqualToString:@"success"]){
            
            [self analysisWith:responseObject andDataArray:dataArray andFreshWithTable:table andMark:num];
        }
        
    } andfailure:^(NSError *error) {
        
    }];
}
#pragma mark --- banner上面的btn的点击事件
-(void)bannerClicked:(UIButton *)button{
    
    NSInteger index=button.tag-200;
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollb.contentOffset=CGPointMake(screenW*index, 0);
        self.slider.center=CGPointMake(btnW/2+(btnW+10)*index, sliderY);
    }];
    
    for (int i=0; i<self.configs.count; i++) {
        UIButton *btn=[self.view viewWithTag:200+i];
        [btn setTitleColor:btnDefaultColor forState:UIControlStateNormal];
    }
    
    UIButton *currentBtn=[self.view viewWithTag:button.tag];
    [currentBtn setTitleColor:btnSelectColor forState:UIControlStateNormal];
    
    switch (index) {
        case 0:
            NSLog(@"未拨打");
            break;
        case 1:
            NSLog(@"待跟进");
            break;
        case 2:
            NSLog(@"未接通");
            break;
        case 3:
            NSLog(@"无意愿");
            break;
        case 4:
            NSLog(@"已提取");
            break;
        case 5:
            NSLog(@"重点");
            break;
            
        default:
            break;
    }
}
-(void)creatSixEmptyImage{
    UIImage *image=[UIImage imageNamed:@"empty_list"];
    CGFloat imageW=image.size.width;
    CGFloat imageH=image.size.height;
    CGFloat centerY=screenH/2-64;
    
    CGFloat center_1=screenW/2+screenW*0;
    CGFloat center_2=screenW/2+screenW*1;
    CGFloat center_3=screenW/2+screenW*2;
    CGFloat center_4=screenW/2+screenW*3;
    CGFloat center_5=screenW/2+screenW*4;
    CGFloat center_6=screenW/2+screenW*5;
    
    //1.
    emptyImageV_1=[SGYTool creatImageVWithFrame:CGRectMake(0, 0, imageW, imageH) andImage:image andHidden:YES andCenter:CGPointMake(center_1, centerY)];
    [self.scrollb addSubview:emptyImageV_1];
    
    //2.
    emptyImageV_2=[SGYTool creatImageVWithFrame:CGRectMake(0, 0, imageW, imageH) andImage:image andHidden:YES andCenter:CGPointMake(center_2, centerY)];
    [self.scrollb addSubview:emptyImageV_2];
    
    //3.
    emptyImageV_3=[SGYTool creatImageVWithFrame:CGRectMake(0, 0, imageW, imageH) andImage:image andHidden:YES andCenter:CGPointMake(center_3, centerY)];
    [self.scrollb addSubview:emptyImageV_3];
    
    //4.
    emptyImageV_4=[SGYTool creatImageVWithFrame:CGRectMake(0, 0, imageW, imageH) andImage:image andHidden:YES andCenter:CGPointMake(center_4, centerY)];
    [self.scrollb addSubview:emptyImageV_4];
    
    //5.
    emptyImageV_5=[SGYTool creatImageVWithFrame:CGRectMake(0, 0, imageW, imageH) andImage:image andHidden:YES andCenter:CGPointMake(center_5, centerY)];
    [self.scrollb addSubview:emptyImageV_5];
    
    //6.
    emptyImageV_6=[SGYTool creatImageVWithFrame:CGRectMake(0, 0, imageW, imageH) andImage:image andHidden:YES andCenter:CGPointMake(center_6, centerY)];
    [self.scrollb addSubview:emptyImageV_6];
}
#pragma mark --- 监听电话
-(void)observeCallStateandDataArray:(NSMutableArray *)dataArray andIndex:(NSInteger)index andNum:(NSString *)num{
    
    self.callCenter = [[CTCallCenter alloc] init];
    /*
     打出： 1.播出 2.通了 3.挂断
     接入：4.来电话了
     */
    
    __weak typeof(self) weakSelf = self;
    
    self.callCenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            [weakSelf goToAddRemarkVCandDataArray:(NSMutableArray *)dataArray andIndex:(NSInteger)index andNum:num];
            weakSelf.callCenter=nil;
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
-(void)pushToWillingVC{
    [SGYTool pushWithStoryBoard:@"My" from:self.navigationController to:@"WillingVC"];
}
-(void)pushToAccountInfo{
    [SGYTool pushWithStoryBoard:@"My" from:self.navigationController to:@"AccountInfoVC"];
}
-(void)initWithLeftButton{
    
    UIButton *button = [UIButton buttonWithFrame:CGRectMake(0, 0, 20, 30) Title:nil BgColor:nil Image:@"sidebar" Target:self Selector:@selector(leftbtnClick)];
    UIBarButtonItem *rigthItem1 = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //增加一个空白的，避免单独一个时按钮的点击范围过大
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = @[rigthItem1,item1];
}
-(BOOL)startMonitoring{
    __block BOOL isNetwork = YES;
    __block NSInteger mark=-1;
    AFNetworkReachabilityManager *manager=[AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusNotReachable) {
            isNetwork = NO;
            mark=0;
            
        }else{
            mark+=1;
            isNetwork = YES;
        }
        if (mark==1) {
            [self getData];
        }
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                
                UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:@"无可用网络" message:@"请连接网络后重试" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *actionA=[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                }];
                
                [alertVC addAction:actionA];
                [self presentViewController:alertVC animated:YES completion:nil];
            };
                
                break;
            default:
                break;
        }
    }];
    
    return isNetwork;
}
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
-(NSMutableArray *)emptyArray{
    if (_emptyArray==nil) {
        _emptyArray=[[NSMutableArray alloc] init];
    }
    return _emptyArray;
}
-(NSMutableArray *)dataArray1{
    
    if (_dataArray1==nil) {
        _dataArray1=[[NSMutableArray alloc]init];
    }
    return _dataArray1;
}
-(NSMutableArray *)dataArray2{
    if (_dataArray2==nil) {
        _dataArray2=[[NSMutableArray alloc]init];
    }
    return _dataArray2;
}
-(NSMutableArray *)dataArray3{
    if (_dataArray3==nil) {
        _dataArray3=[[NSMutableArray alloc]init];
    }
    return _dataArray3;
}
-(NSMutableArray *)dataArray4{
    if (_dataArray4==nil) {
        _dataArray4=[[NSMutableArray alloc]init];
    }
    return _dataArray4;
}
-(NSMutableArray *)dataArray5{
    if (_dataArray5==nil) {
        _dataArray5=[[NSMutableArray alloc]init];
    }
    return _dataArray5;
}
-(NSMutableArray *)dataArray6{
    if (_dataArray6==nil) {
        _dataArray6=[[NSMutableArray alloc]init];
    }
    return _dataArray6;
}
-(NSMutableArray *)totalCountArray{
    if (_totalCountArray==nil) {
        _totalCountArray=[[NSMutableArray alloc] init];
    }
    return _totalCountArray;
}
-(void)pushToSettingVC{
    [SGYTool pushWithStoryBoard:@"Main" from:self.navigationController to:@"SettingVC"];
}
@end

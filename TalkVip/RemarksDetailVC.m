//
//  RemarksDetailVC.m
//  TalkVip
//
//  Created by SunGuoYan on 17/4/7.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "RemarksDetailVC.h"
#import "RemarksModel.h"
#import "RemarksDetailCell.h"

#import "AddRemarksBeforeCallVC.h"

#import "HBRSAHandler.h"
//监听电话
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

#import "AddRemarksAfterCallVC.h"

#import "CustomerIndicater.h"
#import "BeforeVC.h"
@interface RemarksDetailVC ()<UITableViewDataSource,UITableViewDelegate>
{
    HBRSAHandler* _handler;
    MBProgressHUD *HUD;
}
@property (nonatomic, strong) CTCallCenter *callCenter;
@property (weak, nonatomic) IBOutlet UILabel *accountID;
@property (weak, nonatomic) IBOutlet UILabel *telNumber;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLab;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *dialBtn;

@property (weak, nonatomic) IBOutlet UIImageView *emptyV;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation RemarksDetailVC



-(NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[[NSMutableArray alloc] init];
    }
    return _dataArray;
}
#pragma mark --- viewWillDisappear
//2.退出的恢复正常 设置导航栏的背景图片为nil
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    //出去界面的时候关闭监听
    self.callCenter=nil;
}

#pragma mark --- viewWillAppear
//1.进来的时候 设置导航栏透明
//注意别写在viewDidLoad里面，push到下个界面，pop回来的时候不执行，
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //1.设置导航栏的背景图片 new 透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    
    //push的时候能用
    //请求数据
    [self.dataArray removeAllObjects];
    //在这里刷新数据
    [self getNetData];
}

-(void)configTitleLab{
    
    self.accountID.text=self.model.id_str;
    self.descriptionLab.text=self.model.name;
    self.stateLab.text=self.model.type;
    if ([self.model.type isEqualToString:@"重点"]) {
        self.stateLab.text=[NSString stringWithFormat:@"重  点"];
    }
}

#pragma mark --- getNetData
-(void)getNetData{
    [self.dataArray removeAllObjects];
    
    NSString *api=@"/Comment/getHistoryNotes";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl_mt,api];
    
    NSDictionary *para=@{@"id":self.model.id_str};
    
    AFHTTPSessionManager *_operation = [AFHTTPSessionManager  manager];
    
    [_operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    //设置请求头
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[defaults objectForKey:@"token"];
    NSString *value=[NSString stringWithFormat:@"Bearer %@",token];
    [_operation.requestSerializer setValue:value forHTTPHeaderField:@"Authorization"];
    
    [_operation POST:urlStr parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        CustomerIndicater *c=(CustomerIndicater *)[[UIApplication sharedApplication].keyWindow viewWithTag:100];
        [c removeFromSuperview];
        
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            
            NSString *id_Str=   responseObject[@"data"][@"info"][@"id"];
            NSString *name=     responseObject[@"data"][@"info"][@"name"];
            NSString *status=   responseObject[@"data"][@"info"][@"status"];
            
            //未拨打
            NSArray *stateArr=@[@"未联系",@"重点",@"无意愿",@"有意愿"];
            NSString *currentState=stateArr[status.integerValue];
            
            self.accountID.text=id_Str;
            self.descriptionLab.text=name;
            self.stateLab.text=currentState;
            if ([currentState isEqualToString:@"重点"]) {
                self.stateLab.text=[NSString stringWithFormat:@"重  点"];
            }
            
            NSDictionary *dataList=responseObject[@"data"];
            NSArray *arr=dataList[@"list"];
            if (arr.count==0) {
                self.emptyV.hidden=NO;
            }else{
                self.emptyV.hidden=YES;
            }
            for (NSDictionary *tempDic in dataList[@"list"]) {
                
                RemarksModel *model=[[RemarksModel alloc] init];
                model.date=tempDic[@"inputtime"];
                model.time=[NSString stringWithFormat:@"%@",tempDic[@"duration"]];
                model.remarks=tempDic[@"note"];
                
                [self.dataArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.table reloadData];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"无可用网络，请连接网络后重试"];
        CustomerIndicater *c=(CustomerIndicater *)[[UIApplication sharedApplication].keyWindow viewWithTag:100];
        [c removeFromSuperview];
    }];
}
#pragma mark --- /***  viewDidLoad ***/
- (void)viewDidLoad {
    [super viewDidLoad];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    HUD.labelText = @"拨打中...";
    
    //title赋值
//    [self configTitleLab];
    
    self.dialBtn.radius=30;
    
    self.table.delegate=self;
    self.table.dataSource=self;
    self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.emptyV.hidden=YES;
    
    //加载动画
//    [self addIndicaterView];
}
-(void)addIndicaterView{
    CustomerIndicater *c=[[CustomerIndicater alloc]initWithFrame:self.table.frame];
    c.tag=100;
    [self.view addSubview:c];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
#pragma mark --- table 的三个函数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"RemarksDetailCell";
    RemarksDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RemarksDetailCell" owner:nil options:nil] lastObject];
    }
    if (indexPath.row==0) {
        cell.linea.hidden=YES;
    }else if(indexPath.row==self.dataArray.count-1){
        cell.lineb.hidden=YES;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.model=self.dataArray[indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RemarksModel *model=self.dataArray[indexPath.row];
    CGSize size=[model.remarks getFrameWithSize:15 andWidth:screenW-120];
    return 70+size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- 点击 拨打按钮
- (IBAction)dialing:(UIButton *)sender {
    [HUD show:YES];
    //点击的时候关闭交互 请求结束之后开启 防止连续点击的时候多次提交
    self.dialBtn.userInteractionEnabled=NO;
    [self makeSingleCallWithDataArray:self.targetArray andIndex:self.index];
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
    ListModel *model=self.targetArray[self.index];
    
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
    
    
    AFHTTPSessionManager *_operation = [AFHTTPSessionManager  manager];
    
    _operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    _operation.responseSerializer=[AFJSONResponseSerializer serializer];
    _operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    
    [_operation POST:urlStr parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
        NSLog(@"message:%@",responseObject[@"message"]);
        
        if ([responseObject[@"message"] isEqualToString:@"拨打成功"]) {
            
            
            NSString *tel=[NSString stringWithFormat:@"tel://%@",responseObject[@"fromSerNum"]];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
            
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://17072198372"]];
            //1，开始监听
            [self observeCallStateandDataArray:(NSMutableArray *)dataArray andIndex:(NSInteger)index ];
            
            
            //2,产生日志
            [self insertLogWithOrder:order andID:model.id_str];
            
            
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        self.dialBtn.userInteractionEnabled=YES;
        
        [HUD hide:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.dialBtn.userInteractionEnabled=YES;
        NSLog(@"error:%@",error);
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

#pragma mark --- 监听电话
-(void)observeCallStateandDataArray:(NSMutableArray *)dataArray andIndex:(NSInteger)index {
    
    self.callCenter = [[CTCallCenter alloc] init];
    /*
     打出： 1.播出 2.通了 3.挂断
     接入：4.来电话了
     */
    
    __weak typeof(self) weakSelf = self;
    
    self.callCenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            [weakSelf goToAddRemarkVCandDataArray:(NSMutableArray *)dataArray andIndex:(NSInteger)index ];
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
#pragma mark --- 拨打之后备注
-(void)goToAddRemarkVCandDataArray:(NSMutableArray *)dataArray andIndex:(NSInteger)index {
    //主线程里面更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"My" bundle:nil];
        AddRemarksAfterCallVC *vc=[sb instantiateViewControllerWithIdentifier:NSStringFromClass([AddRemarksAfterCallVC class])];
        vc.block=^(NSString *current){
            //这里其实不需要block回调，viewWillAppear里面有刷新
//            self.stateLab.text=current;
//            [self.dataArray removeAllObjects];
//            [self getNetData];
        };
        vc.dataArray=dataArray;
        vc.index=index;
        vc.type=self.model.type;
        [self.navigationController pushViewController:vc animated:YES];
        
    });
}
#pragma mark --- 点击 右上角备注按钮(拨打之前备注)
- (IBAction)beizhu:(UIButton *)sender {
    
//    [self gotoremark];
    
    [self gotoremarkWithTag];
    
}
-(void)gotoremarkWithTag{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"My" bundle:nil];
    
    BeforeVC *vc=[sb instantiateViewControllerWithIdentifier:NSStringFromClass([BeforeVC class])];
    vc.accountID_str=self.accountID.text;
    vc.descriptionLab_str=self.descriptionLab.text;
    //点击确认的回调
    vc.block=^(NSString *currentState){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.stateLab.text=currentState;
        });
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)gotoremark{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"My" bundle:nil];
    
    AddRemarksBeforeCallVC *vc=[sb instantiateViewControllerWithIdentifier:NSStringFromClass([AddRemarksBeforeCallVC class])];
    
    //如果是已提取，就没有选择
    vc.id_str=self.model.id_str;
    vc.type=self.model.type;
    vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    
    //这行代码设置铺在上面，
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    //点击确认的回调
    vc.block=^(NSString *currentState){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.stateLab.text=currentState;
            
            [self.dataArray removeAllObjects];
            //请求数据
            [self getNetData];
        });
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)remarked:(UIButton *)sender {
    
    
}

@end

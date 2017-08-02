//
//  SettingVC.m
//  TalkVip
//
//  Created by SunGuoYan on 17/4/6.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "SettingVC.h"
#import "LoginVC.h"
#import "AboutVC.h"
@interface SettingVC ()
@property (weak, nonatomic) IBOutlet UILabel *clearLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.numLab setBorderWithColor:[UIColor colorWithHexString:@"5a89ff"] andWidth:1];
    self.numLab.text=[NSString stringWithFormat:@"%.2lfM",[self readCacheSize]];
}
- (IBAction)commentsBtn:(UIButton *)sender {
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1239292125"]];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/客来-上亿客户-触手可达/id1239292125?l=zh&ls=1&mt=8"]];
    NSLog(@"评价");
}


- (IBAction)about:(UIButton *)sender {
    
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AboutVC *vc=[sb instantiateViewControllerWithIdentifier:NSStringFromClass([AboutVC class])];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 点击 清除缓冲
- (IBAction)clear:(UIButton *)sender {
    [self clearFile];
}

//1. 获取缓存文件的大小 M
-(float)readCacheSize
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    NSLog(@"cachePath:%@",cachePath);
    return [ self folderSizeAtPath :cachePath];
}
//由于缓存文件存在沙箱中，我们可以通过NSFileManager API来实现对缓存文件大小的计算。
// 遍历文件夹获得文件夹大小，返回多少 M
-(float)folderSizeAtPath:(NSString *) folderPath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    
    return folderSize/(1024.0 * 1024.0);
}

// 计算 单个文件的大小
- ( long long ) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}
//2. 清除缓存
- (void)clearFile
{
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    //NSLog ( @"cachpath = %@" , cachePath);
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
        
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }
    //读取缓存大小
    self.numLab.text=[NSString stringWithFormat:@"%.2lfM",[self readCacheSize]];
    //读取缓存大小
//    float cacheSize = [self readCacheSize] *1024;
//    self.numLab.text = [NSString stringWithFormat:@"%.2fKB",cacheSize];
//    NSLog(@"%.2fKB",cacheSize);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark --- 点击退出
- (IBAction)goOut:(UIButton *)sender {
    
    [NSUserDefaults removeObjectForKey:HEADURL];
    
    UIStoryboard *sb_My = [UIStoryboard storyboardWithName:@"My" bundle:nil];
    LoginVC *vc=[sb_My instantiateViewControllerWithIdentifier:NSStringFromClass([LoginVC class])];
    UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:vc];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = nvc;

    //刷新Window视图
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [NSUserDefaults removeObjectForKey:@"isLogin"];
    
    /*
    TBLoginController *loginVc = [[TBLoginController alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = loginVc;
    
    //刷新Window视图
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
     */
}


- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

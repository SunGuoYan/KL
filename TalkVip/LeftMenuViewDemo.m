//
//  LeftMenuViewDemo.m
//  MenuDemo
//
//  Created by Lying on 16/6/12.
//  Copyright © 2016年 Lying. All rights reserved.
//
#define ImageviewWidth    18
#define Frame_Width       self.frame.size.width//200
#define headerH 218

#import "LeftMenuViewDemo.h"
#import "LeftMenuCell.h"

#import "UIButton+WebCache.h"



@interface LeftMenuViewDemo ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView    *contentTableView;
    NSIndexPath *currentIndex;
}
//@property (nonatomic ,strong)UITableView    *contentTableView;

@end

@implementation LeftMenuViewDemo

 
-(instancetype)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){
        self.backgroundColor=[UIColor whiteColor];
        [self initView];
    }
    return  self;
}
-(void)iconClicked{
    
    if([self.customDelegate respondsToSelector:@selector(LeftMenuViewClick:)]){
        [self.customDelegate LeftMenuViewClick:200];
    }
    
    
    NSLog(@"q");
}
-(void)initView{
    //添加头部
    UIView *headerView     = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Frame_Width, headerH)];
    [headerView setBackgroundColor:[UIColor whiteColor]];

    CGFloat width  = 90/2;
    
    UIImage *portrait_image=[UIImage imageNamed:@"portrait"];
    CGFloat imageW=portrait_image.size.width;
    CGFloat imageH=portrait_image.size.height;
    
    //1.icon
    CGFloat y=60;
    UIButton *btn=[UIButton buttonWithFrame:CGRectMake(Frame_Width/2-imageW/2, y, imageW, imageH) Title:nil BgColor:nil Image:nil Target:self Selector:@selector(iconClicked)];
    btn.radius=imageW/2;
    NSString *headStr=[NSUserDefaults getObjectForKey:HEADURL];
//
    if (headStr) {
        [btn sd_setImageWithURL:[NSURL URLWithString:headStr] forState:UIControlStateNormal];
    }else{
        [btn setImage:portrait_image forState:UIControlStateNormal];
    }
    
    
    [headerView addSubview:btn];
    
    
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(Frame_Width/2-imageW/2, y, imageW, imageH)];
    imageview.image=portrait_image;
//    [headerView addSubview:imageview];
    
    
    width  = 15;
    
    //2.name
    CGFloat nameH=50;
    CGFloat nameW=90;
    UILabel *NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(Frame_Width/2-nameW/2,CGRectGetMaxY(imageview.frame), nameW, nameH)];
    NameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold, sans-serif" size:18];
    NameLabel.font=[UIFont boldSystemFontOfSize:18];
    NameLabel.textAlignment=NSTextAlignmentCenter;
    
    NameLabel.text=[NSUserDefaults getObjectForKey:REALNAME];
    NameLabel.textColor=[UIColor colorWithHexString:@"#60718d"];
    [headerView addSubview:NameLabel];
    
    [self addSubview:headerView];
    
    
    //二。中间tableview
     contentTableView        = [[UITableView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height, Frame_Width, 350) style:UITableViewStylePlain];
    [contentTableView setBackgroundColor:[UIColor whiteColor]];
    contentTableView.bounces=NO;
    contentTableView.dataSource          = self;
    contentTableView.delegate            = self;
    contentTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    contentTableView.showsVerticalScrollIndicator=NO;
    contentTableView.showsHorizontalScrollIndicator=NO;
    contentTableView.separatorStyle      = UITableViewCellSeparatorStyleNone;
    contentTableView.tableFooterView = [UIView new];
    [self addSubview:contentTableView];
}


#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 56 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellID=@"LeftMenuCell";
    LeftMenuCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"LeftMenuCell" owner:self options:nil] firstObject];
        
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.iconV.image=[UIImage imageNamed:@"inf_off"];
            cell.lab.text=@"账户信息";
        }
            break;
        case 1:
        {
            cell.iconV.image=[UIImage imageNamed:@"feedback_off"];
            cell.lab.text=@"问题反馈";
        }
            break;
        case 2:
        {
            cell.iconV.image=[UIImage imageNamed:@"set_off"];
            cell.lab.text=@"设置";
            
        }
            break;
        default:
            break;
    }
//    cell.lab.highlightedTextColor=[UIColor redColor];
//    cell.lab.highlightedTextColor=[UIColor colorWithHexString:@"76899e"];
//    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
//    cell.selectedBackgroundView.backgroundColor = [UIColor xxxxxx];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark --- cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    if (currentIndex==nil) {
        currentIndex=indexPath;
    }else if (currentIndex!=indexPath) {
        
        //取出之前的cell
        LeftMenuCell *cell = [contentTableView cellForRowAtIndexPath:currentIndex];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.lab.textColor=[UIColor colorWithHexString:@"76899e"];
            cell.backgroundView.backgroundColor=[UIColor whiteColor];
        });
        switch (currentIndex.row) {
            case 0:{cell.iconV.image=[UIImage imageNamed:@"inf_off"];} break;
            case 1:{cell.iconV.image=[UIImage imageNamed:@"feedback_off"];} break;
            case 2:{cell.iconV.image=[UIImage imageNamed:@"set_off"];} break;
            default: break;
        }
        currentIndex=indexPath;
    }
    
    
    //讲点击的那个设置为亮色
    LeftMenuCell *cell = [contentTableView cellForRowAtIndexPath:indexPath];
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.lab.textColor=[UIColor colorWithHexString:@"5a89ff"];
        cell.backgroundView.backgroundColor=[UIColor colorWithHexString:@"f4f8fe"];
        switch (indexPath.row) {
            case 0:{cell.iconV.image=[UIImage imageNamed:@"inf_on"];}break;
            case 1:{cell.iconV.image=[UIImage imageNamed:@"feedback_on"];}break;
            case 2:{cell.iconV.image=[UIImage imageNamed:@"set_on"];}break;
            default:break;
        }
    });
    
    
    if([self.customDelegate respondsToSelector:@selector(LeftMenuViewClick:)]){
        [self.customDelegate LeftMenuViewClick:indexPath.row];
    }
    
}



@end

//
//  AboutVC.m
//  TalkVip
//
//  Created by SunGuoYan on 17/4/11.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()
@property (weak, nonatomic) IBOutlet UIImageView *iconV;
@property (weak, nonatomic) IBOutlet UILabel *versionLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

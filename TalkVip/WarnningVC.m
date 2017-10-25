//
//  WarnningVC.m
//  TalkVip
//
//  Created by mac on 2017/9/4.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "WarnningVC.h"

@interface WarnningVC ()
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@end

@implementation WarnningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    
    self.dateLab.text=[NSString stringWithFormat:@"%@%ld%@",@"您的账号将于",self.days,@"天后过期，\n请及时续费，确保正常使用"];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.dateLab.text];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor redColor]
                    range:NSMakeRange(6, 2)];
    //设置label的富文本
    self.dateLab.attributedText = attrStr;
    
}
- (IBAction)OK:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

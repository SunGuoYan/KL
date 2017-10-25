//
//  CheckIconVC.m
//  TalkVip
//
//  Created by SunGuoYan on 2017/7/13.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "CheckIconVC.h"
#import "RSKImageCropper.h"

#import "AFNetWorking.h"

#import "UIImageView+WebCache.h"

@interface CheckIconVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,RSKImageCropViewControllerDelegate>
{
    UIImagePickerController *pickerController;
}
//空白页面
@property (weak, nonatomic) IBOutlet UIImageView *noImageV;

//用户头像
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation CheckIconVC

-(void)setNoImageState{
    
    NSString *str=[NSUserDefaults getObjectForKey:HEADURL];
    if (str) {
        self.noImageV.hidden=YES;
    }else{
        self.noImageV.hidden=NO;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self setNoImageState];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithLeftButton];
    
    [self initWithRightButton];
    
    [self setNoImageState];
    
    self.navigationItem.title=@"头像";
    
    pickerController=[[UIImagePickerController alloc]init];
    pickerController.delegate=self;
    
    NSString *headStr=[NSUserDefaults getObjectForKey:HEADURL];
    [_imageV sd_setImageWithURL:[NSURL URLWithString:headStr] placeholderImage:[UIImage imageNamed:@""]];
}
-(void)turnRight{
    //类方法
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:@"拍照或相册" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction=[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //点击事件
        pickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickerController animated:YES completion:nil];
        
        
    }];
    UIAlertAction *cameraAction=[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]==NO) {
            NSLog(@"no camera");
            return ;
        }
        //需要真机调试
        pickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerController animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    
    [alertVC addAction:photoAction];
    [alertVC addAction:cameraAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}
-(void)turnLeft{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //pickerController.allowsEditing=NO;的话选择这个
    UIImage *image=info[UIImagePickerControllerOriginalImage];
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
    imageCropVC.delegate = self;
    
    UINavigationController *nvc=[[UINavigationController alloc] initWithRootViewController:imageCropVC];
    
    [pickerController presentViewController:nvc animated:YES completion:nil];
}
//对图片尺寸进行压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark - 点击 取消 的回调
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 点击 确定 的回调
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    [self upImageByNsdata:croppedImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)upImageByNsdata:(UIImage *)croppedImage{
    /*压缩*/
    CGSize imagesize = croppedImage.size;
    imagesize.height = 200;
    imagesize.width = 200;
    croppedImage = [self imageWithImage:croppedImage scaledToSize:imagesize];
    
    
    
    NSString *api=@"/Comment/uploadHead";
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",baseUrl_mt,api];
    
    NSDictionary *para=@{@"userfile":@"text"};
    
    [NetWorkManager loadDateUpImageWithToken:YES andWithUrl:urlStr andPara:para andImage:croppedImage andSuccess:^(NSDictionary *responseObject) {
        
        NSString *result=responseObject[@"result"];
        if ([result isEqualToString:@"success"]) {
            [MBProgressHUD showError:responseObject[@"msg"]];
            NSString *headurl=responseObject[@"data"][@"headurl"];
            headurl =[NSString stringWithFormat:@"%@%@",baseUrl_mt,headurl];
            [NSUserDefaults setObject:headurl ForKey:HEADURL];
            //上传成功，更新头像
            self.imageV.image=croppedImage;
            
            self.noImageV.hidden=YES;
            
        }
        
    } andfailure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}
-(void)leftbtnClick{
    
    [self turnLeft];
}
-(void)initWithLeftButton{
    
    UIButton *button = [UIButton buttonWithFrame:CGRectMake(0, 0, 20, 30) Title:nil BgColor:nil Image:@"backicon" Target:self Selector:@selector(leftbtnClick)];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //增加一个空白的，避免单独一个时按钮的点击范围过大
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    self.navigationItem.leftBarButtonItems = @[item1,item2];
}
-(void)rightbtnClick{
    [self turnRight];
}
-(void)initWithRightButton{
    
    //增加一个空白的，避免单独一个时按钮的点击范围过大
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
    
    UIButton *button2 = [UIButton buttonWithFrame:CGRectMake(0, 0, 20, 30) Title:nil BgColor:nil Image:@"edit" Target:self Selector:@selector(rightbtnClick)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
    
    self.navigationItem.rightBarButtonItems = @[item1,item2];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

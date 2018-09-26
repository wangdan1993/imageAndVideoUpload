//
//  VideoUploadViewController.m
//  photoAndvideoUpload
//
//  Created by hisilc-mac002 on 2018/9/26.
//  Copyright © 2018年 wangdan. All rights reserved.
//

#import "VideoUploadViewController.h"
#import "WDHttpAFNetworking.h"
#import "VideoPicker.h"
@interface VideoUploadViewController ()
@property (nonatomic, strong) UIButton * photoBtn;
@property (nonatomic, copy) NSString * logoImageFilePath;
@end

@implementation VideoUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
    self.photoBtn.backgroundColor = [UIColor orangeColor];
    self.photoBtn.clipsToBounds = YES;
    self.photoBtn.layer.cornerRadius = 75;
    [self.photoBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.photoBtn];
}
- (void)click{
    __weak typeof(self) weakSelf = self;
    [[VideoPicker sharedImagePicker] showImagePickerInViewController:self complete:^(NSString *imagePath) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.logoImageFilePath = imagePath;
        UIImage * image = [UIImage imageWithContentsOfFile:imagePath];//读取图片文件
        [strongSelf.photoBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self uploadLogo];
       
        //        [strongSelf setButton:uploadButton enable:YES];
    }];
}
- (void)uploadLogo{
        NSString *urlString = [NSString stringWithFormat:@"%@/fmms/store_upAdvertFile.action",@"http://"];

        NSDictionary * params = @{
                                  @"logoImage":_logoImageFilePath,
                                  @"storeId":@"",
                                  @"storeType":@"2",
                                  
                                  //                              @"storeSrvNumber":[GlobalMethod getstoreSrvNumber],
                                  //                              @"password":[[GlobalMethod getBossPassword] getMd5_32Bit],
                                  };
    [WDHttpAFNetworking afUploadVideo:self.logoImageFilePath url:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"==%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

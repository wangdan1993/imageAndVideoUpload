//
//  ViewController.m
//  photoAndvideoUpload
//
//  Created by hisilc-mac002 on 2018/9/26.
//  Copyright © 2018年 wangdan. All rights reserved.
//

#import "ViewController.h"
#import "WDHttpAFNetworking.h"
#import "ImagePicker.h"
@interface ViewController ()
@property (nonatomic, strong) UIButton * photoBtn;
@property (nonatomic, copy) NSString * logoImageFilePath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
    self.photoBtn.backgroundColor = [UIColor orangeColor];
    self.photoBtn.clipsToBounds = YES;
    self.photoBtn.layer.cornerRadius = 75;
    [self.photoBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.photoBtn];
    
}
- (void)click{
    __weak typeof(self) weakSelf = self;
    [[ImagePicker sharedImagePicker] showImagePickerInViewController:self complete:^(NSString *imagePath) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.logoImageFilePath = imagePath;
        UIImage * image = [UIImage imageWithContentsOfFile:imagePath];//读取图片文件
        [strongSelf.photoBtn setBackgroundImage:image forState:UIControlStateNormal];

        [self uploadLogo];
//        [strongSelf setButton:uploadButton enable:YES];
    }];
}
- (void)uploadLogo{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",@"http:",@"store_uploadLogo.do"];
    
    NSDictionary * params = @{
                              @"logoImage":_logoImageFilePath,
                              @"storeId":@"13",
                              @"storeType":@"2",
                              @"imgApp":@(1),
//                              @"storeSrvNumber":[GlobalMethod getstoreSrvNumber],
//                              @"password":[[GlobalMethod getBossPassword] getMd5_32Bit],
                              };
    [WDHttpAFNetworking afUploadImage:self.logoImageFilePath url:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"==%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

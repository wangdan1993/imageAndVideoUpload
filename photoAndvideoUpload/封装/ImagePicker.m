//
//  ImagePicker.m
//  photoAndvideoUpload
//
//  Created by hisilc-mac002 on 2018/9/26.
//  Copyright © 2018年 wangdan. All rights reserved.
//

#import "ImagePicker.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+WDExtension.h"
@implementation ImagePicker
+ (id)sharedImagePicker {
    static ImagePicker *imagePicker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imagePicker = [[ImagePicker alloc] init];
    });
    return imagePicker;
}

- (void)showImagePickerInViewController:(UIViewController *)vc complete:(CompleteBlock)complete {
    _viewController = vc;
    completeBlock = complete;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet showInView:vc.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: // 拍照
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [_viewController presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        case 1: // 从相册选择
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [_viewController presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.0];
    } else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        // NSString *videoPath = (NSString *__strong)[[info objectForKey:UIImagePickerControllerMediaURL] path];
        // self.fileData = [NSData dataWithContentsOfFile:videoPath];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- 保存图像
- (void)saveImage:(UIImage *)image {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    /*-----获取保存图片的路径-----*/
    NSString *imagePath = [NSString stringWithFormat:@"%@/Documents/foodImage.jpg", NSHomeDirectory()];
    
    BOOL success = [fileManager fileExistsAtPath:imagePath];
    if(success) {
        [fileManager removeItemAtPath:imagePath error:&error];
    }
    //    UIImage *smallImage = [UIImage scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    
    
    UIImage *smallImage = [UIImage thumbImageWithOriginalImage:image size:CGSizeMake(600, 600)];
    
    NSData *originData = UIImageJPEGRepresentation(smallImage, 1.0f);
    NSInteger maxLength = 2 * 1024 * 1024;
    NSInteger originLength = originData.length;
    CGFloat scalef = maxLength > originLength ? 0.8f : ((CGFloat)maxLength) / originLength;
    NSData *destData = UIImageJPEGRepresentation(smallImage, scalef);
    // NSData *destData = [Utils reSizeImageData:image maxImageSize:600 maxSizeWithKB:1024.0];
    [destData writeToFile:imagePath atomically:YES];//写入文件， 1.0f压缩比例
    /*--------返回图片路径-------*/
    completeBlock(imagePath);
}

@end

//
//  VideoPicker.m
//  photoAndvideoUpload
//
//  Created by hisilc-mac002 on 2018/9/26.
//  Copyright © 2018年 wangdan. All rights reserved.
//

#import "VideoPicker.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+WDExtension.h"
#import <AVFoundation/AVFoundation.h>
@implementation VideoPicker
+ (id)sharedImagePicker {
    static VideoPicker *imagePicker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imagePicker = [[VideoPicker alloc] init];
    });
    return imagePicker;
}

- (void)showImagePickerInViewController:(UIViewController *)vc complete:(CompleteBlock)complete {
    viewController = vc;
    completeBlock = complete;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];
        ipc.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*) kUTTypeMovie, (NSString*) kUTTypeVideo, nil];                                            }
    ipc.delegate = self;
    ipc.allowsEditing = NO;
    [viewController presentViewController:ipc animated:YES completion:NULL];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])    { //视频上传
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        
        _url = videoURL;
        
        NSURL    *movieURL = [info valueForKey:UIImagePickerControllerMediaURL];
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]                                                         forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:movieURL options:opts];  // 初始化视频媒体文件
        long long  second = 0;
        second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
        NSLog(@"movie duration : %lld", second);
        [picker dismissViewControllerAnimated:YES completion:^{
            CGRect frame = self->viewController.view.frame;
            if (frame.size.height == 300 - 44) {
                picker.view.hidden = YES;
                [self->viewController presentViewController:picker animated:NO completion:nil];
                [picker dismissViewControllerAnimated:NO completion:nil];            }                    }];        // video url:        // file:///private/var/mobile/Applications/B3CDD0B2-2F19-432B-9CFA-158700F4DE8F/tmp/capture-T0x16e39100.tmp.9R8weF/capturedvideo.mp4
        // we will convert it to mp4 format
        NSURL *mp4 = [self convert2Mp4:videoURL];
        NSFileManager *fileman = [NSFileManager defaultManager];
        if ([fileman fileExistsAtPath:videoURL.path]) {
            NSError *error = nil;
            [fileman removeItemAtURL:videoURL error:&error];
            if (error) {
                NSLog(@"failed to remove file, error:%@.", error);
                
            }
            
        }
        [self alertUploadVideo:mp4];
        //    [self uploadfile:mp4.path];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- 保存图像
- (void)saveImage:(UIImage *)image {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    /*-----获取保存图片的路径-----*/
    NSString *imagePath = [NSString stringWithFormat:@"%@/Documents/video.mp4", NSHomeDirectory()];
    
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
- (CGFloat) getFileSize:(NSString *)path
{
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}

//获取视频的分辨率


-(void)alertUploadVideo:(NSURL*)URL{
    
   
    
    CGFloat size = [self getFileSize:[URL path]];
    NSString *message;
    NSString *sizeString;
    CGFloat sizemb= size/1024;
    if(size<=1024){
        sizeString = [NSString stringWithFormat:@"%.2fKB",size];
    }else{
        sizeString = [NSString stringWithFormat:@"%.2fMB",sizemb];
    }
    
    
    
    
    if(sizemb<=50){
        completeBlock(URL.path);

        
    }
    
   
    else if(sizemb>50){
        message = [NSString stringWithFormat:@"视频%@，超过5MB，不能上传，抱歉。", sizeString];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
                                                                                  message: message
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshwebpages" object:nil userInfo:nil];
            [[NSFileManager defaultManager] removeItemAtPath:[URL path] error:nil];//取消之后就删除，以免占用手机硬盘空间
            
        }]];
        [viewController presentViewController:alertController animated:YES completion:nil];
        
    }
    
    
}
#pragma mark 网络请求
/** *  功能 AFNetWorking带进度指示文件上传 *
 @param filePath 文件路径 */
-(void)uploadfile:(NSString *)filePath{
    
    
    
    
    
    
}

//转成mp4
- (NSURL *)convert2Mp4:(NSURL *)movUrl {
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]                                         initWithAsset:avAsset                                               presetName:AVAssetExportPreset640x480];
        mp4Url = [movUrl copy];
        mp4Url = [mp4Url URLByDeletingPathExtension];
        mp4Url = [mp4Url URLByAppendingPathExtension:@"mp4"];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);        //        [self showHudInView:self.view hint:@"正在压缩"];        //        __weak typeof(self) weakSelf = self;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{            //            [weakSelf hideHud];
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;        }    }
    return mp4Url;
    
}
@end

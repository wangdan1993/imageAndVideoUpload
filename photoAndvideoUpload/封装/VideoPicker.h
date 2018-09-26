//
//  VideoPicker.h
//  photoAndvideoUpload
//
//  Created by hisilc-mac002 on 2018/9/26.
//  Copyright © 2018年 wangdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
enum {
    BufferSize = 32768
};
typedef void(^CompleteBlock)(NSString *videoPath);

@interface VideoPicker : NSObject<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIViewController * viewController;
    CompleteBlock completeBlock;
    uint8_t buffer[BufferSize];
    size_t  bufferOffset;
    size_t  bufferLimit;
    UILabel * stateLabel;
}
@property (nonatomic,strong)NSURL *url;
@property (nonatomic,strong)NSString *account;
@property (nonatomic,strong)NSString *password;
@property (nonatomic,retain)NSInputStream  *fileStream;
@property (nonatomic,retain)NSOutputStream *networkStream;
@property (nonatomic,strong)NSString *path;
+ (id)sharedImagePicker;

- (void)showImagePickerInViewController:(UIViewController *)vc complete:(CompleteBlock)complete;


@end

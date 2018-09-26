//
//  ImagePicker.h
//  photoAndvideoUpload
//
//  Created by hisilc-mac002 on 2018/9/26.
//  Copyright © 2018年 wangdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^CompleteBlock)(NSString *imagePath);
@interface ImagePicker : NSObject <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIViewController *_viewController;
    CompleteBlock completeBlock;
}

+ (id)sharedImagePicker;

- (void)showImagePickerInViewController:(UIViewController *)vc complete:(CompleteBlock)complete;


@end

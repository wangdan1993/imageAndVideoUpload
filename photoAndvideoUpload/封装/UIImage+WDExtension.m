//
//  UIImage+WDExtension.m
//  photoAndvideoUpload
//
//  Created by hisilc-mac002 on 2018/9/26.
//  Copyright © 2018年 wangdan. All rights reserved.
//

#import "UIImage+WDExtension.h"

@implementation UIImage (WDExtension)
#pragma mark- 生成一个缩略图
+ (UIImage *)thumbImageWithOriginalImage:(UIImage *)aImage size:(CGSize)aSize {
    UIImage *newimage;
    if (nil == aImage) {
        newimage = nil;
    } else {
        CGSize oldsize = aImage.size;
        CGRect rect;
        if (aSize.width/aSize.height > oldsize.width/oldsize.height) {
            rect.size.width = aSize.height*oldsize.width/oldsize.height;
            rect.size.height = aSize.height;
            rect.origin.x = (aSize.width - rect.size.width)/2;
            rect.origin.y = 0;
        } else {
            rect.size.width = aSize.width;
            rect.size.height = aSize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (aSize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(aSize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, aSize.width, aSize.height));//clear background
        [aImage drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

@end

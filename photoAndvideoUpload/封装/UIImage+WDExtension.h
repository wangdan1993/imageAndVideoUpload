//
//  UIImage+WDExtension.h
//  photoAndvideoUpload
//
//  Created by hisilc-mac002 on 2018/9/26.
//  Copyright © 2018年 wangdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WDExtension)
// 保持原来的长宽比，生成一个缩略图
+ (UIImage *)thumbImageWithOriginalImage:(UIImage *)aImage size:(CGSize)aSize;
@end

//
//  WDHttpAFNetworking.h
//  photoAndvideoUpload
//
//  Created by hisilc-mac002 on 2018/9/26.
//  Copyright © 2018年 wangdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^SuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void(^FailureBlock)(NSURLSessionDataTask *task, NSError *error);

@interface WDHttpAFNetworking : NSObject
+(void)afGet:(NSString *)url dictionary:(NSDictionary *)dict successs:(SuccessBlock)successblock failure:(FailureBlock)failureblock;

+(void)afPost:(NSString *)url dictionary:(NSDictionary *)dict success:(SuccessBlock)successblock failure:(FailureBlock)failureblock;

+ (void)afUploadImage:(NSString *)imagePath url:(NSString *)url parameters:(NSDictionary *)dict success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;
+ (void)afUploadVideo:(NSString *)videoPath url:(NSString *)url parameters:(NSDictionary *)dict success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

+(void)Post:(NSString *)url dictionary:(NSDictionary *)dict success:(SuccessBlock)successblock failure:(FailureBlock)failureblock;

//字典转json字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
@end

//
//  WDHttpAFNetworking.m
//  photoAndvideoUpload
//
//  Created by hisilc-mac002 on 2018/9/26.
//  Copyright © 2018年 wangdan. All rights reserved.
//

#import "WDHttpAFNetworking.h"

@implementation WDHttpAFNetworking

+ (void)afGet:(NSString *)url dictionary:(NSDictionary *)dict successs:(SuccessBlock)successblock failure:(FailureBlock)failureblock
{
   
    NSDictionary *urlDic = dict;
    
    AFHTTPSessionManager *man = [AFHTTPSessionManager manager];
    //设置请求超时时间
    [man.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    man.requestSerializer.timeoutInterval = 6.0f;
    [man.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    man.responseSerializer = [AFHTTPResponseSerializer serializer];
    man.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/plain", @"text/javascript", nil];
    [man GET:url parameters:urlDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        successblock(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failureblock(task, error);
    }];
}

+ (void)afPost:(NSString *)url dictionary:(NSDictionary *)dict success:(SuccessBlock)successblock failure:(FailureBlock)failureblock
{
    //字典转JSON字符串
    NSString *jsonstr = [self dictionaryToJson:dict];
    NSDictionary *urlDic = @{@"adJson":jsonstr};
    //    NSLog(@"3333~~~~~~~~~~~~~%@",urlDic);
    AFHTTPSessionManager *man = [AFHTTPSessionManager manager];
    
    //设置请求超时时间
    [man.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    man.requestSerializer.timeoutInterval = 6.0f;
    [man.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    man.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    
    [man POST:url parameters:urlDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successblock(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureblock(task, error);
    }];
}

+ (void)afUploadImage:(NSString *)imagePath url:(NSString *)url parameters:(NSDictionary *)dict success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/pjpeg",
                                                         //                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    NSString *jsonStr = [self dictionaryToJson:dict];
    NSDictionary *dic = @{@"adJson": jsonStr};
    NSDictionary *headers = @{
                              @"Content-Type": @"application/octet-stream",
                              @"Content-Disposition": @"form-data; name=\"image\";filename=\"foodImage.jpg\""
                              };
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(image,1);
        NSData *data = [[self dictionaryToJson:dic] dataUsingEncoding:NSUTF8StringEncoding];
        [formData appendPartWithHeaders:headers body:data];
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"image"
                                fileName:@"foodImage.jpg"
                                mimeType:@"image/jpg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@" ====:成功!%@",responseObject);
        successBlock(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@" ====:失败!");
        failureBlock(task, error);
    }];
}


+ (void)afUploadVideo:(NSString *)videoPath url:(NSString *)url parameters:(NSDictionary *)dict success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/plain", @"text/javascript", nil];
    NSString *jsonStr = [self dictionaryToJson:dict];
    NSDictionary *dic = @{@"adJson": jsonStr};
    [manager.requestSerializer setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    NSData *filedata=[NSData dataWithContentsOfFile:videoPath];
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:filedata
                                    name:@"image"
                                fileName:@"video.mp4"
                                mimeType:@"application/octet-stream"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@" ====:成功!%@",responseObject);
        successBlock(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@" ====:失败!");
        failureBlock(task, error);
    }];
}


+ (void)Post:(NSString *)url dictionary:(NSDictionary *)dict success:(SuccessBlock)successblock failure:(FailureBlock)failureblock{
    //    AFHTTPSessionManager * managerA = [AFHTTPSessionManager manager];
    //    managerA.requestSerializer = [AFJSONRequestSerializer serializer];
    //    [managerA POST:url parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
    //        successblock(task, responseObject);
    //
    //    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    //        failureblock(task, error);
    //    }];
    
    AFHTTPSessionManager *man = [AFHTTPSessionManager manager];
    [man.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    man.requestSerializer.timeoutInterval = 6.0f;
    [man.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    man.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    
    [man POST:url parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successblock(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureblock(task, error);
    }];
    
}

//字典转json字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

@end

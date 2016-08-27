
//
//  YXTNetworkTool.m
//  MyDemo
//
//  Created by YXT on 16/8/17.
//  Copyright © 2016年 YXT. All rights reserved.
//

#import "YXTNetworkTool.h"
#import <AFNetworking.h>

@interface YXTNetworkTool ()

@end

@implementation YXTNetworkTool


#pragma mark-
#pragma mark -----------------分-----------------类----------------线-----------------
#pragma mark - AFNetworking POST 请求

+ (void)POST:(NSString *)baseURL parameters:(id)parameters progress:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //acceptableContentTypes
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    [manager POST:baseURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        
    }];
}


#pragma mark -
#pragma mark -----------------分-----------------类----------------线-----------------
#pragma mark - AFNetworking GET 请求

+ (void)GET:(NSString *)baseURL header:(id)header parameters:(id)parameters progress:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    //设置 header
    NSDictionary *headerDic = (NSDictionary *)header;
    NSString *key = [[headerDic allKeys] lastObject];
    NSString *value = [headerDic valueForKey:key];
    
    [sessionManager.requestSerializer setValue:value forHTTPHeaderField:key];
    
    
    [sessionManager GET:baseURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

#pragma mark -
#pragma mark -----------------分-----------------类----------------线-----------------
#pragma mark - AFNetworking download 请求（单任务下载）

/**
 *  <#Description#>
 *
 *  @param baseURL             <#baseURL description#>
 *  @param parameters          <#parameters description#>
 *  @param downloadMode        <#downloadMode description#>
 *  @param searchPathDirectory <#searchPathDirectory description#>
 *  @param downloadProgress    <#downloadProgress description#>
 *  @param success             <#success description#>
 *  @param failure             <#failure description#>
 */
+ (void)DOWNLOAD:(NSString *)baseURL parameters:(id)parameters downloadMode:(DownloadMode)downloadMode downloadPath:(NSString *)searchPathDirectory progress:(ProgressBlock)downloadProgress success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    if (downloadMode == DownloadModelWithFilePath) {
        
        [self downloadWithFilePath:baseURL parameters:parameters downloadPath:searchPathDirectory progress:^(NSProgress * _Nullable progress) {
            
            downloadProgress(progress);
        } success:^(id  _Nullable respanceData) {
            success(respanceData);
            
        } failure:^(NSError * _Nullable error) {
            failure(error);
        }];
    }else if (downloadMode == DownloadModelWithResumeData){
        
        /**
         *
         *  未 实 现
         *
         *  - (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData
                                                            progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                                        destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                                    completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;
         */
    }
}

//下载模式1：DownloadModelWithFilePath
+ (void)downloadWithFilePath:(NSString *)baseURL
                  parameters:(id)parameters
                downloadPath:(NSString *)searchPathDirectory
                    progress:(ProgressBlock)progress
                     success:(SuccessBlock)success
                     failure:(FailureBlock)failure{
    
    NSMutableURLRequest *mRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseURL]];
    
    AFHTTPSessionManager *downloadManager = [AFHTTPSessionManager manager];
    NSURLSessionDownloadTask *downloadTask = [downloadManager downloadTaskWithRequest:mRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度回传
        progress(downloadProgress);
        NSLog(@"%lld",downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //下载文件所在文件夹路径
        NSString *documentPath =  searchPathDirectory;
        
        //下载文件的路径
        NSString *filePath = [documentPath stringByAppendingPathComponent:response.suggestedFilename];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            //若文件已存在，不下载
            return nil;
        }
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error != nil) {
            failure(error);
        }else{
            success([filePath path]);
        }
    }];
    
    [downloadTask resume];
}



/**
 *  获取 上传/下载 的路径
 *
 *  @param searchPathDirectory 枚举值 NSSearchPathDirectory 文件夹类型
 *
 *  @return 上传/下载 的路径
 */
+ (NSString *)uploadAndDownloadPath:(NSSearchPathDirectory)searchPathDirectory{
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(searchPathDirectory, NSUserDomainMask, YES) lastObject];
    
    return documentPath;
}

#pragma mark -
#pragma mark -----------------分-----------------类----------------线-----------------
#pragma mark - AFNetworking upload 请求（单任务上传）

/**
 *  <#Description#>
 *
 *  @param baseURL     <#baseURL description#>
 *  @param filaPath    <#filaPath description#>
 *  @param fileData    <#fileData description#>
 *  @param uploadModel <#uploadModel description#>
 *  @param parameters  <#parameters description#>
 *  @param progress    <#progress description#>
 *  @param success     <#success description#>
 *  @param failure     <#failure description#>
 */
+ (void)UPLOAD:(NSString *)baseURL
      filePath:(NSString *)filaPath
      fileData:(NSData *)fileData
   uploadModel:(UploadMode)uploadModel
    parameters:(id)parameters
      progress:(ProgressBlock)progress
       success:(SuccessBlock)success
       failure:(FailureBlock)failure
{
    
    NSURLSessionConfiguration *configration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *uploadSessionManager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configration];
    NSURLSessionUploadTask *uploadTask = [[NSURLSessionUploadTask alloc]init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:baseURL]];
    
    switch (uploadModel) {
        case UpLoadModeWithFilePath:
        {
            uploadTask = [uploadSessionManager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:filaPath] progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                
            }];
        }
            break;
        case UpLoadModeWithFileData:
        {
            uploadTask = [uploadSessionManager uploadTaskWithRequest:request fromData:fileData progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                
            }];
        }
            break;
        case UpLoadModeWithStreamed:
        {
            /**
             *   未 实 现
             
             *  - (NSURLSessionUploadTask *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
                                                                progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock
                                                        completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError * _Nullable error))completionHandler
             */
        }
            break;
            
        default:
        {
            uploadTask = [uploadSessionManager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:filaPath] progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                
            }];
        }
            break;
    }
    
    [uploadTask resume];
}


#pragma mark -
#pragma mark -----------------分-----------------类----------------线-----------------
#pragma mark - 判断网络连接

+ (void)judgeNetworkStatus:(void (^)(NetworkStatus))networkStatus{
    
    //初始化网络判断管理器
    AFNetworkReachabilityManager *networkStatusManager = [AFNetworkReachabilityManager sharedManager];
    
    [networkStatusManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
       
        /**
         *  AFNetworkReachabilityStatusUnknown          = -1,
         AFNetworkReachabilityStatusNotReachable     = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                //网络类型不可知
                networkStatus(Unknown);
                break;
            case AFNetworkReachabilityStatusNotReachable:
                //网络未连接
                networkStatus(NotReachable);
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                //2G,3G,4G...网络
                networkStatus(WAN);
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //WiFi 网络
                networkStatus(WiFi);
                break;
            default:
                networkStatus(NotReachable);
                break;
        }
    }];
    //开始监听
    [networkStatusManager startMonitoring];
}


@end

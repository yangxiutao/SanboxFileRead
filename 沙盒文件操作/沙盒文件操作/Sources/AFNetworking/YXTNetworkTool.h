//
//  YXTNetworkTool.h
//  MyDemo
//
//  Created by YXT on 16/8/17.
//  Copyright © 2016年 YXT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DownloadMode) {
    
    DownloadModelWithFilePath   =   1,//文件所在路径
    DownloadModelWithResumeData =   2,
    
};

//上传文件方式
typedef NS_ENUM(NSInteger, UploadMode) {
    
    UpLoadModeWithFilePath      = 1,   //文件所在路径(默认上传方式)
    UpLoadModeWithFileData      = 2,   //文件数据（也就是将上传的文件转换成 NSData 类型）
    UpLoadModeWithStreamed      = 3,   //上传方式
};

//网络状态
typedef NS_ENUM(NSInteger, NetworkStatus){
    Unknown          = -1,  //位置网络
    NotReachable     =  0,  //网络未连接
    WAN              =  1,  //2G,3G,4G..网络
    WiFi             =  2,  //WiFi 网络
};


typedef void(^ _Nullable ProgressBlock)(NSProgress * _Nullable progress); //进度回调

typedef void(^ _Nullable SuccessBlock)(id _Nullable respanceData);  //成功回调方法

typedef void(^ _Nullable FailureBlock)(NSError  * _Nullable error); //失败回调方法

@interface YXTNetworkTool : NSObject

/**
 *  AFNetworking GET 请求
 *
 *  @param baseURL    请求路径
 *  @param header     请求头
 *  @param parameters 请求参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
+ (void)GET:(NSString * _Nullable)baseURL
     header:(id _Nullable)header
 parameters:(id _Nullable)parameters
   progress:(ProgressBlock)progress
    success:(SuccessBlock)success
    failure:(FailureBlock)failure;

/**
 *  AFNetworking POST 网络请求
 *
 *  @param baseURL    请求路径
 *  @param parameters 请求参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
+ (void)POST:(NSString * _Nullable)baseURL
  parameters:(id _Nonnull)parameters
    progress:(ProgressBlock)progress
     success:(SuccessBlock)success
     failure:(FailureBlock)failure;

/**
 *  AFNetworking download 网络下载（单任务下载）
 *
 *  @param baseURL              下载路径
 *  @param parameters           下载参数
 *  @param downloadMode         下载方式
 *  @param searchPathDirectory  指定下载文件的路径
 *  @param downloadProgress     下载进度回调
 *  @param success              下载成功回调（回传下载文件所在的路径）
 *  @param failure              下载失败回调
 */
+ (void)DOWNLOAD:(NSString * _Nullable)baseURL
      parameters:(id _Nullable)parameters
    downloadMode:(DownloadMode)downloadMode
    downloadPath:(NSString * _Nonnull)searchPathDirectory
        progress:(ProgressBlock)downloadProgress
         success:(SuccessBlock)success
         failure:(FailureBlock)failure;


/**
 *  AFNetworking upload 网络上传（单任务上传）--------- 未测试
 *
 *  @param baseURL      上传路径
 *  @param uploadModel  文件上传方式
 *  @param filePath     上传文件所在路径
 *  @param fileData     上传文件的数据（NSData 类型）
 *  @param parameters   上传参数
 *  @param progress     上传进度回调
 *  @param success      上传成功回调
 *  @param failure      上传失败回调
 */
+ (void)UPLOAD:(NSString * _Nonnull)baseURL
      filePath:(NSString * _Nullable)filaPath
      fileData:(NSData * _Nullable)fileData
   uploadModel:(UploadMode)uploadModel
    parameters:(id _Nullable)parameters
      progress:(ProgressBlock)progress
       success:(SuccessBlock)success
       failure:(FailureBlock)failure;

/**
 *  判断网络状态
 *
 *  @param networkStatus 网络状态回调
 */
+ (void)judgeNetworkStatus:(void(^ _Nonnull)(NetworkStatus  status))networkStatus;

@end

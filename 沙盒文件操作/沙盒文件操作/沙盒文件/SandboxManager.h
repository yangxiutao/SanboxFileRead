//
//  SandboxManager.h
//  沙盒文件操作
//
//  Created by YXT on 16/8/26.
//  Copyright © 2016年 YXT. All rights reserved.
//  沙盒文件的存入，读取

#import <Foundation/Foundation.h>

typedef void(^GetSandboxFileSuccessBlock)(NSArray *allFilesArray);

@interface SandboxManager : NSObject

+ (instancetype)defaultManager;

- (NSString *)createDownloadFileDirectory:(NSString *)directoryPath;//设置文件下载路径

- (void)getFilesFromDirectory:(NSString *)directoryPath success:(GetSandboxFileSuccessBlock)success;//获取某一目录下的所有文件

- (void)deleteFileWithPath:(NSString *)filePath;//删除数据

@end

//
//  SandboxManager.m
//  沙盒文件操作
//
//  Created by YXT on 16/8/26.
//  Copyright © 2016年 YXT. All rights reserved.
//

#import "SandboxManager.h"

@interface SandboxManager ()

@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation SandboxManager

+ (instancetype)defaultManager{

    static SandboxManager *_sandboxManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sandboxManager = [[SandboxManager alloc]init];
    });

    return _sandboxManager;
}

- (NSFileManager *)fileManager{
    
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    
    return _fileManager;
}

/**
 *  设置文件下载路径
 *
 *  @param directoryPath 下载文件的路径
 *  @return 路径
 */
- (NSString *)createDownloadFileDirectory:(NSString *)directoryPath{
    
    NSString *downloadPath = [[self getDocumentDirectoryPath]stringByAppendingPathComponent:directoryPath];
    
    if ([self.fileManager fileExistsAtPath:downloadPath]) {
        return downloadPath;
    }
    
    NSError *error = nil;
    [self.fileManager createDirectoryAtPath:downloadPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (error) {
        NSLog(@"创建文件夹失败，原因 ==== %@",error);
    }else{
        NSLog(@"创建文件夹成功");
    }
    
    return downloadPath;
}

/**
 *  获得 documentDirectory 文件夹的路径
 */
- (NSString *)getDocumentDirectoryPath{
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    return documentPath;
    
}

- (void)getFilesFromDirectory:(NSString *)directoryPath success:(GetSandboxFileSuccessBlock)success{
    
    NSDirectoryEnumerator *directoryEnumrator = [self.fileManager enumeratorAtPath:directoryPath];
    
    //图片数组
    NSMutableArray *albumFilesArray = [NSMutableArray array];
    
    //文档
    NSMutableArray *txtFilesArray = [NSMutableArray array];
    
    //视频
    NSMutableArray *videoFilesArray = [NSMutableArray array];
    
    //其他
    NSMutableArray *otherFilesArray = [NSMutableArray array];
    
    NSString *fileName;
    
    while (fileName = [directoryEnumrator nextObject]) {
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",directoryPath,fileName];
        
        /*
        //获取文件属性方法1：
        
        
        NSError *attributeError = nil;
        NSDictionary *fileAttribute =  [self.fileManager attributesOfItemAtPath:filePath error:&attributeError];
        if (!attributeError) {
            NSLog(@"文件属性 === %@",fileAttribute);
        }else{
            NSLog(@"获取文件属性错误 error === %@",attributeError);
            
        }
         //获取文件属性方法2
         NSLog(@"%@",directoryEnumrator.fileAttributes);
         
         //获取文件所在文件夹属性
         NSLog(@"%@",directoryEnumrator.directoryAttributes);
         
         */
        
        
        
        
        NSDictionary *fileAttribute = directoryEnumrator.fileAttributes;
        float size = fileAttribute.fileSize;
        
        NSString *fileSize = [NSString string];
        if (size > 1000 * 1000) {
            fileSize = [NSString stringWithFormat:@"%.2fM",size/1000/1000];
        }else{
            fileSize = [NSString stringWithFormat:@"%.2fkb",size/1000];
        }
        NSDictionary *fileDic = @{@"fileName":fileName,@"filePath":filePath,@"fileSize":fileSize};
        
        
        
        
        
        //在此判断文件类型
        if ([[fileName pathExtension] isEqualToString:@"jpg"]||[[fileName pathExtension] isEqualToString:@"png"]) {
            
            //图片类型
            [albumFilesArray addObject:fileDic];
            
        }else if ([[fileName pathExtension] isEqualToString:@"doc"]||[[fileName pathExtension] isEqualToString:@"docx"]||[[fileName pathExtension] isEqualToString:@"pdf"]||[[fileName pathExtension] isEqualToString:@"PDF"]||[[fileName pathExtension] isEqualToString:@"xls"]||[[fileName pathExtension] isEqualToString:@"xlsx"]){
            //文档类型
            [txtFilesArray addObject:fileDic];
            
        }else if ([[fileName pathExtension] isEqualToString:@"mp4"]){
            //视频类型
            [videoFilesArray addObject:fileDic];
            
        }else{
            //其他类型
            [otherFilesArray addObject:fileDic];
        }
        
    }
    
    NSArray *allArray = @[@{@"type":@"相册",@"list":albumFilesArray},@{@"type":@"文档",@"list":txtFilesArray},@{@"type":@"视频",@"list":videoFilesArray},@{@"type":@"其他",@"list":otherFilesArray}];
    
    success(allArray);
}

- (void)deleteFileWithPath:(NSString *)filePath{
    
    [self.fileManager removeItemAtPath:filePath error:nil];
     
}

@end

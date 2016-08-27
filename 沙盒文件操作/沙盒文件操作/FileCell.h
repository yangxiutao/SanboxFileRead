//
//  FileCell.h
//  沙盒文件操作
//
//  Created by YXT on 16/8/27.
//  Copyright © 2016年 YXT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *rowDic;

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath;

@end

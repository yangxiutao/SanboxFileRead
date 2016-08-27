//
//  FileCell.m
//  沙盒文件操作
//
//  Created by YXT on 16/8/27.
//  Copyright © 2016年 YXT. All rights reserved.
//

#import "FileCell.h"

@interface FileCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@end

@implementation FileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath{
    
    FileCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FileCell" owner:nil options:nil]  lastObject];
    }
    
    return cell;
}

- (void)setRowDic:(NSDictionary *)rowDic{
    _rowDic = rowDic;
    
    NSString *fileName = [NSString stringWithFormat:@"%@",[rowDic valueForKey:@"fileName"]];
    self.titleLabel.text = fileName;
    self.sizeLabel.text = [rowDic valueForKey:@"fileSize"];
    
    //在此判断文件类型
    if ([[fileName pathExtension] isEqualToString:@"jpg"]||[[fileName pathExtension] isEqualToString:@"png"]) {
        
        //图片类型
        
        NSLog(@"图片");
        
        UIImage *image = [UIImage imageWithContentsOfFile:[rowDic valueForKey:@"filePath"]];
        self.imgView.image = image;
        
    }else if ([[fileName pathExtension] isEqualToString:@"doc"]||[[fileName pathExtension] isEqualToString:@"docx"]){
        //文档类型:word
        
        NSLog(@"文档");
        
        self.imgView.image = [UIImage imageNamed:@"Word"];
        
    }else if ([[fileName pathExtension] isEqualToString:@"TXT"]||[[fileName pathExtension] isEqualToString:@"txt"]){
        //文档类型:TXt
        
        NSLog(@"TXT");
        
        self.imgView.image = [UIImage imageNamed:@"txt"];
        
    }else if ([[fileName pathExtension] isEqualToString:@"pdf"]||[[fileName pathExtension] isEqualToString:@"PDF"]){
        //文档类型:PDF
        
        NSLog(@"PDF");
        
        self.imgView.image = [UIImage imageNamed:@"pdf"];
 
    }else if ([[fileName pathExtension] isEqualToString:@"xls"]||[[fileName pathExtension] isEqualToString:@"xlsx"]){
        //文档类型:Excel
        
        NSLog(@"Excel");
        
        self.imgView.image = [UIImage imageNamed:@"Excel"];
        
    }else if ([[fileName pathExtension] isEqualToString:@"mp4"]){
        //视频类型
        NSLog(@"视频");
        UIImage *image = [UIImage imageWithContentsOfFile:[rowDic valueForKey:@"filePath"]];
        self.imgView.image = image;
        
    }else if ([[fileName pathExtension] isEqualToString:@"ZIP"]||[[fileName pathExtension] isEqualToString:@"zip"]){
        //Zip
        NSLog(@"Zip");
      
        self.imgView.image = [UIImage imageNamed:@"Zip"];
        
    }else if ([[fileName pathExtension] isEqualToString:@"RAR"]||[[fileName pathExtension] isEqualToString:@"rar"]){
        //Rar
        NSLog(@"Rar");
        
        self.imgView.image = [UIImage imageNamed:@"Rar"];
        
    }else{
        //其他类型
        NSLog(@"其他");
        UIImage *image = [UIImage imageWithContentsOfFile:[rowDic valueForKey:@"filePath"]];
        self.imgView.image = image;
      
    }
}

@end

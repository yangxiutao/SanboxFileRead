//
//  ImageViewController.m
//  沙盒文件操作
//
//  Created by YXT on 16/8/26.
//  Copyright © 2016年 YXT. All rights reserved.
//

#import "ImageViewController.h"
#import <UIImageView+WebCache.h>

@interface ImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *img = [UIImage imageWithContentsOfFile:self.imgStr];
    self.imgView.image = img;
//    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.imgStr]];
    
}



@end

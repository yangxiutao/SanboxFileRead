//
//  ViewController.m
//  沙盒文件操作
//
//  Created by 杨修涛 on 16/8/26.
//  Copyright © 2016年 YXT. All rights reserved.
//

#import "ViewController.h"
#import "SandboxManager.h"
#import "YXTNetworkTool.h"
#import "ImageViewController.h"
#import "PDFViewController.h"
#import "FileCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView  *tableView;
@property(nonatomic, strong) NSMutableArray *showArray;

@property (nonatomic, strong) SandboxManager *sanboxManager;
@property (nonatomic, strong) NSString *fileDwonloadPath;

@end

@implementation ViewController

- (SandboxManager *)sanboxManager{
    
    if (!_sanboxManager) {
        _sanboxManager = [SandboxManager defaultManager];
        
    }
    
    return _sanboxManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    //文件下载路径
    self.fileDwonloadPath = [self.sanboxManager createDownloadFileDirectory:@"Download"];
    
    [YXTNetworkTool DOWNLOAD:@"http://image.tianjimedia.com/uploadImages/2014/126/14/99DPC7722YXH.jpg" parameters:nil downloadMode:DownloadModelWithFilePath downloadPath:self.fileDwonloadPath progress:^(NSProgress * _Nullable progress) {
//        NSLog(@"%lld",progress.completedUnitCount/progress.totalUnitCount);
    } success:^(id  _Nullable respanceData) {
//        NSLog(@"%@",respanceData);
        
    } failure:^(NSError * _Nullable error) {
//        NSLog(@"%@",error);
    }];
    
    
    
    [self.sanboxManager getFilesFromDirectory:self.fileDwonloadPath success:^(NSArray *allFilesArray) {
        self.showArray = [NSMutableArray arrayWithArray:allFilesArray];
        [self.tableView reloadData];
    }]; 
}



#pragma mark -
#pragma mark -----------------分-----------------类----------------线-----------------
#pragma mark - 展示

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:(UITableViewStylePlain)];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"FileCell" bundle:nil] forCellReuseIdentifier:@"cell_fileAllType"];
    }
    
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.showArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSDictionary *sectionDic = [NSDictionary dictionaryWithDictionary:[self.showArray objectAtIndex:section]];
    NSArray *listArray = [NSArray arrayWithArray:[sectionDic valueForKey:@"list"]];
    return listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FileCell *cell = [FileCell cellWithTableView:tableView identifier:@"cell_fileAllType" indexPath:indexPath];
    NSDictionary *sectionDic = [NSDictionary dictionaryWithDictionary:[self.showArray objectAtIndex:indexPath.section]];
    NSArray *listArray = [NSArray arrayWithArray:[sectionDic valueForKey:@"list"]];
    
    NSDictionary *rowDic = [NSDictionary dictionaryWithDictionary:[listArray objectAtIndex:indexPath.row]];
    cell.rowDic = rowDic;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *sectionDic = [NSDictionary dictionaryWithDictionary:[self.showArray objectAtIndex:indexPath.section]];
    NSArray *listArray = [NSArray arrayWithArray:[sectionDic valueForKey:@"list"]];
    
    NSDictionary *rowDic = [NSDictionary dictionaryWithDictionary:[listArray objectAtIndex:indexPath.row]];
    
    NSString *filePath = [NSString stringWithFormat:@"%@",[rowDic valueForKey:@"filePath"]];
    
    
    PDFViewController *pdfVC = [[PDFViewController alloc]init];
    pdfVC.pdfURL = filePath;
    [self.navigationController pushViewController:pdfVC animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary *sectionDic = [NSDictionary dictionaryWithDictionary:[self.showArray objectAtIndex:section]];
    
    return [sectionDic valueForKey:@"type"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}



#pragma mark -
#pragma mark -----------------分-----------------类----------------线-----------------
#pragma mark - 删除数据

- (IBAction)editTableView:(id)sender {
    
    UIBarButtonItem *item = (UIBarButtonItem *)sender;
    
    if ([item.title isEqualToString:@"编辑"]) {
        [self.tableView setEditing:YES animated:YES];
        [item setTitle:@"完成"];
    }else{
        [self.tableView setEditing:NO animated:NO];
        [item setTitle:@"编辑"];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//单元格返回的编辑风格，包括删除 添加 和 默认  和不可编辑三种风格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
         NSMutableDictionary *sectionDic = [NSMutableDictionary dictionaryWithDictionary:[self.showArray objectAtIndex:indexPath.section]];
        
        NSMutableArray *list = [NSMutableArray arrayWithArray:[sectionDic valueForKey:@"list"]];
        
 
        NSDictionary *rowDic = [NSDictionary dictionaryWithDictionary:[list objectAtIndex:indexPath.row]];
 
        NSString *filePath = [NSString stringWithFormat:@"%@",[rowDic valueForKey:@"filePath"]];
 
        [self.sanboxManager deleteFileWithPath:filePath];
        
        [list removeObjectAtIndex:indexPath.row];
        sectionDic[@"list"] = list;
        
        self.showArray[indexPath.section] = sectionDic;
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        [self.sanboxManager getFilesFromDirectory:self.fileDwonloadPath success:^(NSArray *allFilesArray) {
            self.showArray = [NSMutableArray arrayWithArray:allFilesArray];
            [self.tableView reloadData];
        }];
    }
 
}

@end

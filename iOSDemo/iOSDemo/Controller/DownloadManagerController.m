//
//  DownloadManagerController.m
//  iOSDemo
//
//  Created by smile on 2018/12/20.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import <CocoaDownloader/CocoaDownloader.h>

#import "UIView+Toast.h"

#import "DownloadManagerController.h"
#import "DownloadInfoCell.h"
#import "MyBusinessInfo.h"
#import "IDUtil.h"
#import "Constants.h"
#import "ORMUtil.h"

@interface DownloadManagerController ()

@property DownloadManager *downloadManager;

@property BOOL hasDownloading;

@end

@implementation DownloadManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initViews{
    [super initViews];
    
    self.downloadingDataArray=[[NSMutableArray alloc] init];
    self.downloadedDataArray=[[NSMutableArray alloc] init];
    
    self.downloadingTableView.delegate=self;
    self.downloadingTableView.dataSource=self;
    
    self.downloadedTableView.delegate=self;
    self.downloadedTableView.dataSource=self;
}

- (void)initDatas{
    [super initDatas];
    self.downloadManager=[DownloadManager sharedInstance];

    [self loadDownloadingData];
    [self loadDownloadedData];
    
}

- (void)initListeners{
    [super initListeners];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onDownloadStatusChanged:) name:DownloadStatusChanged object:nil];
}

- (void)onDownloadStatusChanged:(NSNotification *)notification
{
    [self loadDownloadingData];
    [self loadDownloadedData];
}

- (void)loadDownloadingData{
    [self.downloadingDataArray removeAllObjects];
    [self.downloadingDataArray addObjectsFromArray:[self.downloadManager findAllDownloading]];
    [self.downloadingTableView reloadData];
    
    [self setPauseOrResumeButtonStatus];
}

- (void)loadDownloadedData{
    NSLog(@"download manager controller loadDownloadedData");
    [self.downloadedDataArray removeAllObjects];
    [self.downloadedDataArray addObjectsFromArray:[self.downloadManager findAllDownloaded]];
    [self.downloadedTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.downloadingTableView]) {
        //downloading
        return [self.downloadingDataArray count];
    } else {
        //downloaded
        return [self.downloadedDataArray count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DownloadInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL forIndexPath:indexPath];
    
    cell.downloadManager=self.downloadManager;
    
    DownloadInfo *downloadInfo=nil;
    if ([tableView isEqual:self.downloadingTableView]) {
        //downloading
        downloadInfo=self.downloadingDataArray[indexPath.row];
    } else {
        //downloaded
        downloadInfo=self.downloadedDataArray[indexPath.row];
    }
    
    NSString *downloadInfoId=[IDUtil stringToMD5:downloadInfo.uri];
    
    //显示业务数据
    MyBusinessInfo *data=[[ORMUtil sharedInstance] findBusinessInfo:downloadInfoId];
    
    [cell bindData:data];
    
    //显示下载数据
    [cell bindDownloadData:downloadInfo];
    
    return cell;
}


- (IBAction)onPageChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            self.vwDownloading.hidden=NO;
            self.vwDownloaded.hidden=YES;
        }
            break;
        case 1:
        {
            self.vwDownloading.hidden=YES;
            self.vwDownloaded.hidden=NO;
        }
            break;
            
        default:
            break;
    }
}

- (void)pauseOrResumeAll{
    if (self.hasDownloading) {
        [self pauseAll];
        self.hasDownloading =false;
    } else {
        [self resumeAll];
        self.hasDownloading =true;
    }
    
    [self setPauseOrResumeButtonStatus];
}

- (void)setPauseOrResumeButtonStatus{
    self.hasDownloading=NO;
    
    for (DownloadInfo *downloadInfo in self.downloadingDataArray) {
        if (DownloadStatusDownloading==downloadInfo.status) {
            //如果有一个的状态是正在下载，按钮就是暂停所有
            self.hasDownloading=YES;
            
            break;
        }
    }
    
    if (self.hasDownloading) {
        [self.btDownloadControllClick setTitle:@"Pause all" forState:UIControlStateNormal];
    } else {
        [self.btDownloadControllClick setTitle:@"Start all" forState:UIControlStateNormal];
    }
}

- (void)pauseAll{
    [self.downloadManager pauseAll];
    [self.downloadingTableView reloadData];
}

- (void)resumeAll{
    [self.downloadManager resumeAll];
    [self.downloadingTableView reloadData];
}


#pragma mark - 下载按钮相关
//暂停所有，开始所有
- (IBAction)onPauseAll:(UIButton *)sender {
    //无数据，可以按照需求来处理；原版是没有下载任务，不能进入到该界面
    if ([self.downloadingDataArray count]==0) {
        [self.view makeToast:@"No download task."];
        return;
    }
    
    [self pauseOrResumeAll];
}


//删除所有除下载完成的任务
- (IBAction)onDeleteAllClick:(UIButton *)sender {
    if ([self.downloadingDataArray count]==0) {
        [self.view makeToast:@"No download task."];
        return;
    }
    
    for (DownloadInfo *data in self.downloadingDataArray) {
        [self.downloadManager remove:data];
    }
    
    [self.downloadingDataArray removeAllObjects];
    [self.downloadingTableView reloadData];
}


- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

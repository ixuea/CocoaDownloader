//
//  DownloadManagerController.m
//  CocoaDownloaderMacOS
//
//  Created by smile on 2018/12/19.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import <CocoaDownloader/CocoaDownloader.h>

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

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    if ([tableView isEqual:self.downloadingTableView]) {
        //downloading
        return [self.downloadingDataArray count];
    } else {
        //downloaded
        return [self.downloadedDataArray count];
    }
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    DownloadInfoCell *cell=[tableView makeViewWithIdentifier:CELL owner:self];
    
    cell.downloadManager=self.downloadManager;
    
    DownloadInfo *downloadInfo=nil;
    if ([tableView isEqual:self.downloadingTableView]) {
        //downloading
        downloadInfo=self.downloadingDataArray[row];
    } else {
        //downloaded
        downloadInfo=self.downloadedDataArray[row];
    }
    
    NSString *downloadInfoId=[IDUtil stringToMD5:downloadInfo.uri];
    
    //显示业务数据
    MyBusinessInfo *data=[[ORMUtil sharedInstance] findBusinessInfo:downloadInfoId];
    
    [cell bindData:data];
    
    //显示下载数据
    [cell bindDownloadData:downloadInfo];
    
    return cell;
}

- (void)loadDownloadingData{
    [self.downloadingDataArray removeAllObjects];
    [self.downloadingDataArray addObjectsFromArray:[self.downloadManager findAllDownloading]];
    [self.downloadingTableView reloadData];
    
    [self setPauseOrResumeButtonStatus];
    
}

- (void)loadDownloadedData{
    [self.downloadedDataArray removeAllObjects];
    [self.downloadedDataArray addObjectsFromArray:[self.downloadManager findAllDownloaded]];
    [self.downloadedTableView reloadData];
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
        [self.btDownloadControllClick setTitle:@"Pause all"];
    } else {
        [self.btDownloadControllClick setTitle:@"Start all"];
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
- (IBAction)onPauseAll:(NSButton *)sender {
    //无数据，可以按照需求来处理；原版是没有下载任务，不能进入到该界面
    if ([self.downloadingDataArray count]==0) {
        //        [NSObject shortToast:@"没有下载任务！"];
        NSLog(@"Not download task.");
        return;
    }
    
    [self pauseOrResumeAll];
}

//删除所有除下载完成的任务
- (IBAction)onDeleteAllClick:(NSButton *)sender {
    if ([self.downloadingDataArray count]==0) {
//        [NSObject shortToast:@"没有下载任务！"];
        return;
    }
    
    for (DownloadInfo *data in self.downloadingDataArray) {
        [self.downloadManager remove:data];
    }
    
    [self.downloadingDataArray removeAllObjects];
    [self.downloadingTableView reloadData];
}

- (IBAction)onPageChanged:(NSSegmentedCell *)sender {
    switch (sender.selectedSegment) {
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


@end

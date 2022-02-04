//
//  SampleController.m
//  iOSDemo
//
//  Created by smile on 2018/12/20.
//  Copyright © 2018 ixuea(http://a.ixuea.com/y). All rights reserved.
//

#import <CocoaDownloader/CocoaDownloader.h>

#import "SampleController.h"
#import "FileUtil.h"

static NSString * const DEFAULT_URL = @"http://wdj-qn-apk.wdjcdn.com/d/c0/3311e7a27b2d3b209bf8d02aca26ac0d.apk";

static NSString * const DEFAULT_ID = @"ixuea";


@interface SampleController ()
@property (weak, nonatomic) IBOutlet UIButton *btDownload;
@property (weak, nonatomic) IBOutlet UILabel *lbDownloadInfo;

@property DownloadManager *downloadManager;
@property DownloadInfo *downloadInfo;

@end

@implementation SampleController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initViews{
    [super initViews];
    [super setTitle:@"Get started"];
}

- (void)initDatas{
    [super initDatas];
    self.downloadManager= [DownloadManager sharedInstance];
    
    //查询下载信息
    self.downloadInfo = [self.downloadManager findDownloadInfo:DEFAULT_ID];
    
    if (self.downloadInfo) {
        [self setDownloadCallbackBlock];
        //刷新界面状态
        [self refresh];
    }
    
    NSLog(@"sample controller download info current block:%@",self.downloadInfo.downloadBlock);
}

- (IBAction)onDownloadClick:(UIButton *)sender {
    if (self.downloadInfo) {
        switch (self.downloadInfo.status) {
            case DownloadStatusNone:
            case DownloadStatusPaused:
            case DownloadStatusError:
                //resume downloadInfo
                [self.downloadManager resume:self.downloadInfo];
                break;
            case DownloadStatusDownloading:
            case DownloadStatusPrepareDownload:
            case DownloadStatusWait:
                //pause downloadInfo
                [self.downloadManager pause:self.downloadInfo];
                break;
            case DownloadStatusCompleted:
                //remove downloadInfo
                [self.downloadManager remove:self.downloadInfo];
                break;
        }
        
    } else {
        [self createDownload];
    }
    
}

- (void)createDownload{
    self.downloadInfo=[[DownloadInfo alloc] init];
    [self.downloadInfo setPath:@"CocoaDownloader/a.apk"];
    [self.downloadInfo setUri:DEFAULT_URL];
    
    [self.downloadInfo setId:DEFAULT_ID];
    
    //获取当前时间0秒后的时间，就是当前
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    //转为时间戳
    NSTimeInterval currentTimeMillis=[date timeIntervalSince1970];
    [self.downloadInfo setCreatedAt:currentTimeMillis];
    
    [self setDownloadCallbackBlock];
    
    [self.downloadManager download:self.downloadInfo];
}

- (void)setDownloadCallbackBlock{
    __weak typeof(self) weakSelf = self;
    
    //set download callback
    [self.downloadInfo setDownloadBlock:^(DownloadInfo * _Nonnull downloadInfo) {
        [weakSelf refresh];
    }];
}

- (void)refresh{
    switch (self.downloadInfo.status) {
        case DownloadStatusPaused:{
            [self.btDownload setTitle:@"Continue" forState:UIControlStateNormal];
            [self.lbDownloadInfo setText:@"Paused"];
        }
            break;
        case DownloadStatusError:{
            [self.btDownload setTitle:@"Continue" forState:UIControlStateNormal];
            [self.lbDownloadInfo setText:[NSString stringWithFormat:@"download error:%@",[self getErrorInfo]]];
        }
            break;
            
        case DownloadStatusDownloading:
        case DownloadStatusPrepareDownload:{
            [self.btDownload setTitle:@"Pause" forState:UIControlStateNormal];
            [self.lbDownloadInfo setText:[NSString stringWithFormat:@"%@/%@",[FileUtil formatFileSize:self.downloadInfo.progress],[FileUtil formatFileSize:self.downloadInfo.size]]];
        }
            break;
        case DownloadStatusCompleted:{
            [self.btDownload setTitle:@"Delete" forState:UIControlStateNormal];
            [self.lbDownloadInfo setText:@"Download success"];
            break;
        }
        case DownloadStatusWait:{
            [self.btDownload setTitle:@"Pause" forState:UIControlStateNormal];
            [self.lbDownloadInfo setText:@"Waiting"];
        }
            break;
            
            
        default:
        {
            //download set nil
            self.downloadInfo=nil;
            
            [self.btDownload setTitle:@"Download" forState:UIControlStateNormal];
            [self.lbDownloadInfo setText:@""];
        }
            break;
    }
}


/**
 获取错误描述，具体的可以参考我们的iOS企业级项目实战课程
 
 @return <#return value description#>
 */
- (NSString *)getErrorInfo{
    NSString *errorInfo=nil;
    if (self.downloadInfo.error) {
        switch (self.downloadInfo.error.code) {
            case NSURLErrorNotConnectedToInternet:
                errorInfo=@"network error!";
                break;
        }
        
    }
    return @"Unknown error！";
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.downloadInfo) {
        self.downloadInfo.downloadBlock = nil;
    }
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

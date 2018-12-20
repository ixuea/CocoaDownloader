//
//  DownloadDetailController.m
//  iOSDemo
//
//  Created by smile on 2018/12/20.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import <CocoaDownloader/CocoaDownloader.h>

#import "DownloadDetailController.h"
#import "IDUtil.h"
#import "FileUtil.h"
#import "ImageUtil.h"

@interface DownloadDetailController ()

@property DownloadManager *downloadManager;
@property DownloadInfo *downloadInfo;


@end

@implementation DownloadDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.lbTitle setText:self.data.title];
    [ImageUtil showImage:self.ivIcon uri:self.data.icon];
    
    self.downloadManager=[DownloadManager sharedInstance];
    
    self.downloadInfo=[self.downloadManager findDownloadInfo:[IDUtil stringToMD5:self.data.url]];
    
    if (self.downloadInfo) {
        [self setDownloadCallbackBlock];
    }
    
    //刷新界面状态
    [self refresh];
}

- (void)setDownloadCallbackBlock{
    __weak typeof(self) weakSelf = self;
    
    //set download callback
    [self.downloadInfo setDownloadBlock:^(DownloadInfo * _Nonnull downloadInfo) {
        [weakSelf refresh];
    }];
}

- (void)refresh{
    if (self.downloadInfo) {
        switch (self.downloadInfo.status) {
            case DownloadStatusPaused:{
                [self.btAction setTitle:@"Continue" forState:UIControlStateNormal];
                [self.lbStatus setText:@"Paused"];
            }
                break;
            case DownloadStatusError:{
                [self.btAction setTitle:@"Continue" forState:UIControlStateNormal];
                [self.lbStatus setText:[NSString stringWithFormat:@"download error"]];
            }
                break;
                
            case DownloadStatusDownloading:
            case DownloadStatusPrepareDownload:{
                [self.btAction setTitle:@"Pause" forState:UIControlStateNormal];
                [self.lbStatus setText:[NSString stringWithFormat:@"downloading"]];
            }
                break;
            case DownloadStatusCompleted:{
                [self.btAction setTitle:@"Delete" forState:UIControlStateNormal];
                [self.lbStatus setText:@"Download success"];
                break;
            }
            case DownloadStatusWait:{
                [self.btAction setTitle:@"Pause" forState:UIControlStateNormal];
                [self.lbStatus setText:@"Waiting"];
            }
                break;
                
                
            default:
            {
                [self defaultStatusUI];
            }
                break;
        }
        
        [self.lbProgress setText:[NSString stringWithFormat:@"%@/%@",[FileUtil formatFileSize:self.downloadInfo.progress],[FileUtil formatFileSize:self.downloadInfo.size]]];
        
        if (self.downloadInfo.size!=0) {
            [self.pvProgress setProgress: self.downloadInfo.progress*1.0/self.downloadInfo.size];
        }
        
        
    } else {
        [self defaultStatusUI];
    }
}

- (void)defaultStatusUI{
    //download set nil
    self.downloadInfo=nil;
    
    [self.btAction setTitle:@"Download" forState:UIControlStateNormal];
    [self.lbStatus setText:@"Not download"];
    [self.lbProgress setText:@""];
    [self.pvProgress setProgress:0];
}

- (IBAction)onDownloadActionClick:(id)sender {
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
                
                self.downloadInfo=nil;
                break;
        }
    } else {
        //Create new download task
        //save path
        NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"CocoaDownloader/%@",self.data.title]];
        
        NSLog(@"download save path:%@",path);
        
        self.downloadInfo=[[DownloadInfo alloc] init];
        [self.downloadInfo setPath:path];
        [self.downloadInfo setUri:self.data.url];
        
        [self.downloadInfo setId:[IDUtil stringToMD5:self.data.url]];
        
        //获取当前时间0秒后的时间，就是当前
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        
        //转为时间戳
        NSTimeInterval currentTimeMillis=[date timeIntervalSince1970];
        [self.downloadInfo setCreatedAt:currentTimeMillis];
        
        [self setDownloadCallbackBlock];
        
        [self.downloadManager download:self.downloadInfo];
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

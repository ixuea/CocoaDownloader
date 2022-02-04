//
//  DownloadInfoCell.m
//  CocoaDownloaderMacOS
//
//  Created by smile on 2018/12/19.
//  Copyright © 2018 ixuea(http://a.ixuea.com/y). All rights reserved.
//

#import "DownloadInfoCell.h"
#import "ImageUtil.h"
#import "IDUtil.h"
#import "FileUtil.h"
#import "Constants.h"
#import "ORMUtil.h"

@implementation DownloadInfoCell

- (void)bindData:(MyBusinessInfo *)data{
    if (data) {
        self.data=data;
        [self.lbTitle setStringValue:data.title];
        [ImageUtil showImage:self.ivIcon uri:data.icon];
    }
    
}

- (void)bindDownloadData:(DownloadInfo *)data{
    self.downloadInfo=data;
    
    [self setDownloadCallbackBlock];
    
    [self refresh:NO];
}

- (IBAction)onDownloadActionClick:(NSButton *)sender {
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
        //Create new download task
        //save path, This is set to Documents/CocoaDownloader/
        self.downloadInfo=[[DownloadInfo alloc] init];
        [self.downloadInfo setPath:[NSString stringWithFormat:@"CocoaDownloader/%@",self.data.url]];
        [self.downloadInfo setUri:self.data.url];
        
        [self.downloadInfo setId:[IDUtil stringToMD5:self.data.url]];
        
        //获取当前时间0秒后的时间，就是当前
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        
        //转为时间戳
        NSTimeInterval currentTimeMillis=[date timeIntervalSince1970];
        [self.downloadInfo setCreatedAt:currentTimeMillis];
        
        [self setDownloadCallbackBlock];
        
        [self.downloadManager download:self.downloadInfo];
        
        //保存扩展信息到我们的业务数据库
        self.data.Id=[IDUtil stringToMD5:self.data.url];
        
        //更新到数据库
        [[ORMUtil sharedInstance] createOrUpdateBusinessInfo:self.data];
    }
}


- (void)setDownloadCallbackBlock{
    __weak typeof(self) weakSelf = self;
    
    //set download callback
    [self.downloadInfo setDownloadBlock:^(DownloadInfo * _Nonnull downloadInfo) {
        [weakSelf refresh:YES];
    }];
    
}


- (void)refresh:(BOOL)downloadManagerNotify{
    if (self.downloadInfo) {
        switch (self.downloadInfo.status) {
            case DownloadStatusPaused:{
                [self.btAction setTitle:@"Continue"];
                [self.lbStatus setStringValue:@"Paused"];
            }
                break;
            case DownloadStatusError:{
                [self.btAction setTitle:@"Continue"];
                [self.lbStatus setStringValue:[NSString stringWithFormat:@"download error"]];
            }
                break;
                
            case DownloadStatusDownloading:
            case DownloadStatusPrepareDownload:{
                [self.btAction setTitle:@"Pause"];
                [self.lbStatus setStringValue:[NSString stringWithFormat:@"downloading"]];
            }
                break;
            case DownloadStatusCompleted:{
                [self.btAction setTitle:@"Delete"];
                [self.lbStatus setStringValue:@"Download success"];
                [self publishDownloadStatusChanged:downloadManagerNotify];
                break;
            }
            case DownloadStatusWait:{
                [self.btAction setTitle:@"Pause"];
                [self.lbStatus setStringValue:@"Waiting"];
            }
                break;
                
                
            default:
            {
                [self publishDownloadStatusChanged:downloadManagerNotify];
                [self defaultStatusUI];
            }
                break;
        }
        
        [self.lbProgress setStringValue:[NSString stringWithFormat:@"%@/%@",[FileUtil formatFileSize:self.downloadInfo.progress],[FileUtil formatFileSize:self.downloadInfo.size]]];
        
        if (self.downloadInfo.size!=0) {
            [self.pvProgress setDoubleValue: self.downloadInfo.progress*100.0/self.downloadInfo.size];
        }
        
        
    } else {
        [self defaultStatusUI];
    }
}

- (void)defaultStatusUI{
    //download set nil
    self.downloadInfo=nil;
    
    [self.btAction setTitle:@"Download"];
    [self.lbStatus setStringValue:@"Not download"];
    [self.lbProgress setStringValue:@""];
    [self.pvProgress setDoubleValue:0];
}

- (void)publishDownloadStatusChanged:(BOOL)downloadManagerNotify{
    if (downloadManagerNotify) {
        [NSNotificationCenter.defaultCenter postNotificationName:DownloadStatusChanged object:nil userInfo:@{@"data":self.downloadInfo}];
    }
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    

}

@end

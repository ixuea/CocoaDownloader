//
//  DownloadTask.m
//  CocoaDownloader
//
//  Created by smile on 2018/12/14.
//  Copyright © 2018 ixuea(http://a.ixuea.com/y). All rights reserved.
//

#import "DownloadTask.h"
#import "DownloadLogger.h"

@implementation DownloadTask

- (instancetype)initOperationQueue:(NSOperationQueue *)operationQueue dispatch:(DownloadDispatch *)dispatch download:(DownloadInfo *)download config:(DownloadConfig *)config delegate:(id<DownloadTaskDelegate>)delegate{
    if (self=[super init]) {
        self.operationQueue=operationQueue;
        self.dispatch=dispatch;
        self.downloadInfo=download;
        self.config=config;
        self.delegate=delegate;
    }
    return self;
}

- (void)start{
//    __weak typeof(self) weakSelf = self;
//    NSBlockOperation *blockOperation =[NSBlockOperation blockOperationWithBlock:^{
//        downloadLogDebug(@"download task start:%@",self.downloadInfo.uri);
//
//        if (0==weakSelf.downloadInfo.size) {
//            //获取文件大小
//        } else {
//            [weakSelf prepareDownload:weakSelf];
//        }
//    }];
//    [self.operationQueue addOperation:blockOperation];
    
    //由于DownloadThread内部使用的是NSURLSessionDataTask
    //他通过代理回调，所以这里不用在放入子线程
    [self prepareDownload:self];
}

- (void)prepareDownload:(DownloadTask *)weakSelf{
    [weakSelf.downloadInfo setStatus:DownloadStatusDownloading];
    [weakSelf.dispatch onStatusChanged:weakSelf.downloadInfo];
    
    DownloadThread *downloadThread=[[DownloadThread alloc] initDispatch:weakSelf.dispatch download:weakSelf.downloadInfo config:weakSelf.config delegate:weakSelf];
    [downloadThread start];
}

- (void)onProgress{
    //获取当前时间0秒后的时间，就是当前
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    //转为时间戳
    NSTimeInterval currentTimeMillis=[date timeIntervalSince1970];
    
    //每秒钟回调一次进度
    if (currentTimeMillis - self.lastTime > DEFAULT_PUBLISH_DOWNLOAD_PROGRESS_TIME) {
        //间隔大于1秒才回调，这样做是避免频繁操作数据库
        //频繁刷新界面带来的性能消耗
        [self.dispatch onStatusChanged:self.downloadInfo];
        
        self.lastTime = currentTimeMillis;
    }
}

- (void)onDownloadSuccess{
    [self.delegate onDownloadSuccess:self.downloadInfo];
}

- (void)onDownloadFail{
    [self.delegate onDownloadFail:self.downloadInfo];
}

- (void)onDownloadFileInfoSuccess:(long)size supportRange:(BOOL)supportRange{
    [self.downloadInfo setSize:size];
    [self.downloadInfo setSupportRange:supportRange];
    
    [self prepareDownload:self];
}

- (void)onDownloadFileInfoFailed{
    
}

@end

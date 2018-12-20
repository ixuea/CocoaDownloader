//
//  DownloadManager.m
//  CocoaDownloader
//
//  Created by smile on 2018/12/12.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import "DownloadManager.h"

@implementation DownloadManager
static DownloadManager *sharedInstance = nil;

+ (DownloadManager *)sharedInstance{
    return [self sharedInstance:nil];
}

+ (DownloadManager *)sharedInstance:(DownloadConfig *)config{
    if (!sharedInstance) {
        sharedInstance = [[self alloc] initWithConfig:config];
    }
    return sharedInstance;
}

- (instancetype)initWithConfig:(DownloadConfig *)config{
    if (self=[super init]) {
        if (config) {
            self.config=config;
        } else {
            self.config=[[DownloadConfig alloc] init];
        }
        
        self.databaseController=[DatabaseController sharedInstance:self.config];
        
//        self.operationQueue=[[NSOperationQueue alloc] init];
//        self.operationQueue.maxConcurrentOperationCount=self.config.self.operationQueue;
        
        self.dispatch=[[DownloadDispatch alloc] initDatabaseController:self.databaseController];
        
        self.cacheDownloadTask=[[NSMutableDictionary alloc] init];
        
        self.downloadingCaches=[[NSMutableArray alloc] init];
        
        //将数据库中，除下载完成的任务状态改为暂停
        [self.databaseController pauseAllDownloading];
        
        NSArray *allDownloading=[self.databaseController findAllDownloading];
        if (allDownloading) {
            [self.downloadingCaches addObjectsFromArray:allDownloading];
        }
    }
    return self;
}

- (void)download:(DownloadInfo *)downloadInfo{
    [self.downloadingCaches addObject:downloadInfo];
    [self prepareDownload:downloadInfo];
}

- (void)prepareDownload:(DownloadInfo *)downloadInfo{
    if ([self.cacheDownloadTask count]>=self.config.downloadTaskNumber) {
        downloadInfo.status=DownloadStatusWait;
    } else {
        DownloadTask *downloadTask=[[DownloadTask alloc] initOperationQueue:self.operationQueue dispatch:self.dispatch download:downloadInfo config:self.config delegate:self];
        [self.cacheDownloadTask setObject:downloadTask forKey:downloadInfo.id];
        [downloadInfo setStatus:DownloadStatusPrepareDownload];
        [downloadTask start];
    }
    
    [self.dispatch onStatusChanged:downloadInfo];
}

- (void)pause:(DownloadInfo *)downloadInfo{
    if ([self isExecute]) {
        [self pauseInner:downloadInfo];
    }
}

- (void)pauseAll{
    for (DownloadInfo *downloadInfo in self.downloadingCaches) {
        [self pauseInner:downloadInfo];
    }
}

- (void)pauseInner:(DownloadInfo *)downloadInfo{
    [downloadInfo setStatus:DownloadStatusPaused];
    [self.cacheDownloadTask removeObjectForKey:downloadInfo.id];
    [self.dispatch onStatusChanged:downloadInfo];
    [self prepareDownloadNextTask];
}

- (void)resume:(DownloadInfo *)downloadInfo{
    if ([self isExecute]) {
        [self prepareDownload:downloadInfo];
    }
}

- (void)resumeAll{
    for (DownloadInfo *downloadInfo in self.downloadingCaches) {
        [self prepareDownload:downloadInfo];
    }
}

- (void)remove:(DownloadInfo *)downloadInfo{
    [downloadInfo setStatus:DownloadStatusNone];
    [self.cacheDownloadTask removeObjectForKey:downloadInfo.id];
    [self.downloadingCaches removeObject:downloadInfo];
    [self.databaseController remove:downloadInfo];
    
    //获取文件管理器
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //删除下载的文件
    [manager removeItemAtPath:downloadInfo.path error:nil];
    
    [self.dispatch onStatusChanged:downloadInfo];
    
    [self prepareDownloadNextTask];
}

- (DownloadInfo *)findDownloadInfo:(NSString *)id{
    DownloadInfo *downloadInfo=nil;
    
    for (DownloadInfo *info in self.downloadingCaches){
        if ([info.id isEqualToString:id]) {
            downloadInfo=info;
            break;
        }
    }
    
    if(!downloadInfo){
        downloadInfo=[self.databaseController findDownloadInfo:id];
    }
    
    return downloadInfo;
}

- (NSArray *)findAllDownloading{
    return self.downloadingCaches;
}

- (NSArray *)findAllDownloaded{
    downloadLogDebug(@"download manager findAllDownloaded");
    return [self.databaseController findAllDownloaded];
}

- (void)prepareDownloadNextTask{
    for (DownloadInfo *downloadInfo in self.downloadingCaches){
        if (DownloadStatusWait==downloadInfo.status) {
            [self prepareDownload:downloadInfo];
            break;
        }
    }
}

- (BOOL)isExecute{
    //获取当前时间0秒后的时间，就是当前
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    //转为时间戳
    NSTimeInterval currentTimeMillis=[date timeIntervalSince1970];
    
    if (currentTimeMillis-self.lastExecuteTime>MIN_EXECUTE_INTERVAL) {
        self.lastExecuteTime=currentTimeMillis;
        return YES;
    }
    return NO;
}

- (void)onDownloadSuccess:(DownloadInfo *)downloadInfo{
    [self.cacheDownloadTask removeObjectForKey:downloadInfo.id];
    [self.downloadingCaches removeObject:downloadInfo];
    [self prepareDownloadNextTask];
}

- (void)onDownloadFail:(DownloadInfo *)downloadInfo{
    [self onDownloadSuccess:downloadInfo];
}

+ (void)destroy{
    if (sharedInstance) {
        [sharedInstance pauseAll];
        sharedInstance=nil;
    }
}

@end

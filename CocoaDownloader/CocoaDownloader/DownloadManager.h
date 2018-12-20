//
//  DownloadManager.h
//  CocoaDownloader
//
//  Created by smile on 2018/12/12.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DownloadInfo.h"
#import "DownloadConfig.h"
#import "DownloadDispatch.h"
#import "DownloadTask.h"
#import "DatabaseController.h"

NS_ASSUME_NONNULL_BEGIN

static int const MIN_EXECUTE_INTERVAL = 0.5;

@interface DownloadManager : NSObject<DownloadTaskDelegate>

@property NSMutableArray *downloadingCaches;

@property DownloadConfig *config;

@property NSMutableDictionary *cacheDownloadTask;

@property DownloadDispatch *dispatch;

@property NSOperationQueue *operationQueue;

@property DatabaseController *databaseController;

@property double lastExecuteTime;

/**
 返回当前类实例
 
 @return return value description
 */
+ (DownloadManager *)sharedInstance;


/**
 返回当前类实例，可以配置下载器

 @param config <#config description#>
 @return <#return value description#>
 */
+ (DownloadManager *)sharedInstance:(DownloadConfig *)config;

- (void)download:(DownloadInfo *)downloadInfo;

- (void)pause:(DownloadInfo *)downloadInfo;

- (void)pauseAll;

- (void)resume:(DownloadInfo *)downloadInfo;

- (void)resumeAll;

- (void)remove:(DownloadInfo *)downloadInfo;

- (DownloadInfo *)findDownloadInfo:(NSString *)id;

- (NSArray *)findAllDownloading;

- (NSArray *)findAllDownloaded;

+ (void)destroy;

@end

NS_ASSUME_NONNULL_END

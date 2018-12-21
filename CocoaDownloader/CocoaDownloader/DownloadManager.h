//
//  DownloadManager.h
//  Download manager, including download, pause, delete, etc.
//
//  Created by smile on 2018/12/12.
//  Copyright © 2018 ixuea(http://a.ixuea.com/y). All rights reserved.
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

/**
 In addition to downloading completed tasks.
 */
@property NSMutableArray *downloadingCaches;

/**
 Download manager config.
 */
@property DownloadConfig *config;

/**
 Cache all download task.
 */
@property NSMutableDictionary *cacheDownloadTask;

/**
 Download info dispenser.
 */
@property DownloadDispatch *dispatch;

@property NSOperationQueue *operationQueue;

/**
 Databae helper.
 */
@property DatabaseController *databaseController;

@property double lastExecuteTime;

/**
 Get download manager instance.
 
 @return return value description
 */
+ (DownloadManager *)sharedInstance;


/**
 Get download manager instance, you can pass configurations.

 @param config <#config description#>
 @return <#return value description#>
 */
+ (DownloadManager *)sharedInstance:(DownloadConfig *)config;

/**
 Start download.

 @param downloadInfo <#downloadInfo description#>
 */
- (void)download:(DownloadInfo *)downloadInfo;

/**
 Pause download.

 @param downloadInfo <#downloadInfo description#>
 */
- (void)pause:(DownloadInfo *)downloadInfo;

/**
 Pause all download task.
 */
- (void)pauseAll;

/**
 Continue download.

 @param downloadInfo <#downloadInfo description#>
 */
- (void)resume:(DownloadInfo *)downloadInfo;

/**
 Continue all download task.
 */
- (void)resumeAll;

/**
 Delete a download.

 @param downloadInfo <#downloadInfo description#>
 */
- (void)remove:(DownloadInfo *)downloadInfo;

/**
 Query download info.

 @param id <#id description#>
 @return <#return value description#>
 */
- (DownloadInfo *)findDownloadInfo:(NSString *)id;

/**
 Query all tasks except those completed by downloading.

 @return <#return value description#>
 */
- (NSArray *)findAllDownloading;

/**
 Query for all downloaded tasks.

 @return <#return value description#>
 */
- (NSArray *)findAllDownloaded;

/**
 Destroys the current download manager.
 */
+ (void)destroy;

@end

NS_ASSUME_NONNULL_END

//
//  DownloadTask.h
//  CocoaDownloader
//
//  Created by smile on 2018/12/14.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DownloadDispatch.h"
#import "DownloadInfo.h"
#import "DownloadConfig.h"
#import "DownloadThread.h"

NS_ASSUME_NONNULL_BEGIN

//回调下载时间间隔，1秒
static float const DEFAULT_PUBLISH_DOWNLOAD_PROGRESS_TIME = 1;

@protocol DownloadTaskDelegate <NSObject>

- (void)onDownloadSuccess:(DownloadInfo *)downloadInfo;

- (void)onDownloadFail:(DownloadInfo *)downloadInfo;

@end

@interface DownloadTask : NSObject<DownloadThreadDelegate>

@property (nonatomic, weak) id<DownloadTaskDelegate> delegate;
@property NSOperationQueue *operationQueue;
@property DownloadDispatch *dispatch;
@property DownloadInfo *downloadInfo;
@property DownloadConfig *config;

/**
 上一次回调进度时间
 */
@property NSTimeInterval lastTime;

- (instancetype)initOperationQueue:(NSOperationQueue *)operationQueue dispatch:(DownloadDispatch *)dispatch download:(DownloadInfo *)download config:(DownloadConfig *)config delegate:(id<DownloadTaskDelegate>)delegate;

- (void)start;

@end

NS_ASSUME_NONNULL_END

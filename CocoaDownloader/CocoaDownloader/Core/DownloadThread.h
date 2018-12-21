//
//  DownloadThread.h
//  CocoaDownloader
//
//  Created by smile on 2018/12/14.
//  Copyright © 2018 ixuea(http://a.ixuea.com/y). All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DownloadDispatch.h"
#import "DownloadInfo.h"
#import "DownloadConfig.h"
#import "DownloadLogger.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DownloadThreadDelegate <NSObject>

- (void)onProgress;

- (void)onDownloadSuccess;

- (void)onDownloadFail;

@end

@interface DownloadThread : NSObject<NSURLSessionDataDelegate>

@property (nonatomic, weak) id<DownloadThreadDelegate> delegate;
@property DownloadDispatch *dispatch;
@property DownloadInfo *downloadInfo;
@property DownloadConfig *config;

@property long lastProgress;

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSFileHandle *fileHandle;

- (instancetype)initDispatch:(DownloadDispatch *)dispatch download:(DownloadInfo *)download config:(DownloadConfig *)config delegate:(id<DownloadThreadDelegate>)delegate;

- (void)start;

@end

NS_ASSUME_NONNULL_END

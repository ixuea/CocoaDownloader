//
//  DownloadInfo.h
//  CocoaDownloader
//
//  Created by smile on 2018/12/12.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DownloadStatus) {
    DownloadStatusNone,
    DownloadStatusPrepareDownload,
    DownloadStatusDownloading,
    DownloadStatusWait,
    DownloadStatusPaused,
    DownloadStatusCompleted,
    DownloadStatusError
};

NS_ASSUME_NONNULL_BEGIN

@interface DownloadInfo : NSObject

@property NSString *id;

@property NSString *uri;

@property NSString *path;

@property long progress;

@property long size;

@property DownloadStatus status;

@property BOOL supportRange;

@property double createdAt;

@property NSError *error;

@property void (^downloadBlock)(DownloadInfo *downloadInfo);

@end

NS_ASSUME_NONNULL_END

//
//  SampleController.h
//  CocoaDownloaderMacOS
//
//  Created by smile on 2018/12/18.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import <CocoaDownloader/CocoaDownloader.h>

#import "BaseTitleController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SampleController : BaseTitleController
@property (weak) IBOutlet NSButton *btDownload;
@property (weak) IBOutlet NSTextField *lbDownloadInfo;

@property DownloadManager *downloadManager;
@property DownloadInfo *downloadInfo;

@end

NS_ASSUME_NONNULL_END

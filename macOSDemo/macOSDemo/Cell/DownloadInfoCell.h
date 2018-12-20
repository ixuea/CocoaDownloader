//
//  DownloadInfoCell.h
//  CocoaDownloaderMacOS
//
//  Created by smile on 2018/12/19.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <CocoaDownloader/CocoaDownloader.h>

#import "MyBusinessInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadInfoCell : NSTableCellView

@property (weak) IBOutlet NSImageView *ivIcon;

@property (weak) IBOutlet NSTextField *lbTitle;
@property (weak) IBOutlet NSButton *btAction;
@property (weak) IBOutlet NSTextField *lbProgress;
@property (weak) IBOutlet NSTextField *lbStatus;
@property (weak) IBOutlet NSProgressIndicator *pvProgress;


@property DownloadInfo *downloadInfo;
@property MyBusinessInfo *data;

@property DownloadManager *downloadManager;


- (void)bindData:(MyBusinessInfo *)data;

- (void)bindDownloadData:(DownloadInfo *)data;

@end

NS_ASSUME_NONNULL_END

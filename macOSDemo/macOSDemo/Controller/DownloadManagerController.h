//
//  DownloadManagerController.h
//  CocoaDownloaderMacOS
//
//  Created by smile on 2018/12/19.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import "BaseTitleController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadManagerController : BaseTitleController
@property (weak) IBOutlet NSView *vwDownloading;
@property (weak) IBOutlet NSView *vwDownloaded;

@property (weak, nonatomic) IBOutlet NSTableView *downloadingTableView;
@property (weak, nonatomic) IBOutlet NSTableView *downloadedTableView;

@property (weak) IBOutlet NSButton *btDownloadControllClick;

@property NSMutableArray *downloadingDataArray;
@property NSMutableArray *downloadedDataArray;

@end

NS_ASSUME_NONNULL_END

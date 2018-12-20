//
//  DownloadManagerController.h
//  iOSDemo
//
//  Created by smile on 2018/12/20.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import "BaseTitleController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadManagerController : BaseTitleController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *vwDownloading;
@property (weak, nonatomic) IBOutlet UIView *vwDownloaded;

@property (weak, nonatomic) IBOutlet UITableView *downloadingTableView;
@property (weak, nonatomic) IBOutlet UITableView *downloadedTableView;
@property (weak, nonatomic) IBOutlet UIButton *btDownloadControllClick;


@property NSMutableArray *downloadingDataArray;
@property NSMutableArray *downloadedDataArray;

@end

NS_ASSUME_NONNULL_END

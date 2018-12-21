//
//  DownloadInfoCell.h
//  iOSDemo
//
//  Created by smile on 2018/12/20.
//  Copyright © 2018 ixuea(http://a.ixuea.com/y). All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CocoaDownloader/CocoaDownloader.h>

#import "MyBusinessInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadInfoCell : UITableViewCell

@property DownloadInfo *downloadInfo;
@property MyBusinessInfo *data;

@property DownloadManager *downloadManager;

@property (weak, nonatomic) IBOutlet UIImageView *ivIcon;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *btAction;
@property (weak, nonatomic) IBOutlet UILabel *lbProgress;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UIProgressView *pvProgress;

- (void)bindData:(MyBusinessInfo *)data;

- (void)bindDownloadData:(DownloadInfo *)data;

@end

NS_ASSUME_NONNULL_END

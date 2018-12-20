//
//  DownloadResponse.m
//  CocoaDownloader
//
//  Created by smile on 2018/12/14.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import "DownloadDispatch.h"

@implementation DownloadDispatch

- (instancetype)initDatabaseController:(DatabaseController *)databaseController{
    if (self=[super init]) {
        self.databaseController=databaseController;
        
    }
    return self;
}

- (void)onStatusChanged:(DownloadInfo *)downloadInfo{
    if (downloadInfo.downloadBlock) {
        __weak typeof(downloadInfo) weakDownloadInfo = downloadInfo;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //保存信息到数据库
            [self.databaseController createOrUpdate:downloadInfo];
           
            //通知界面
            downloadLogDebug(@"download dispatch onStatusChanged id:%@ current block:%@",weakDownloadInfo.id,weakDownloadInfo.downloadBlock);
            weakDownloadInfo.downloadBlock(weakDownloadInfo);
        }];
    }
}

@end

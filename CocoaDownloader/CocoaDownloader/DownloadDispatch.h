//
//  DownloadResponse.h
//  CocoaDownloader
//
//  Created by smile on 2018/12/14.
//  Copyright © 2018 ixuea(http://a.ixuea.com/y). All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DownloadInfo.h"
#import "DatabaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadDispatch : NSObject

@property DatabaseController *databaseController;

- (instancetype)initDatabaseController:(DatabaseController *)databaseController;

- (void)onStatusChanged:(DownloadInfo *)downloadInfo;

@end

NS_ASSUME_NONNULL_END

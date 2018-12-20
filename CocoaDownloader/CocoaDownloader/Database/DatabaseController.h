//
//  DatabaseController.h
//  CocoaDownloader
//
//  Created by smile on 2018/12/12.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "DownloadInfo.h"
#import "DownloadLogger.h"
#import "DownloadConfig.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const TABLE_NAME_DOWNLOAD_INFO = @"download_info";

static NSString * const SQL_CREATE_DOWNLOAD_TABLE = @"CREATE TABLE IF NOT EXISTS download_info (_id varchar(255) PRIMARY KEY NOT NULL,uri varchar(255) NOT NULL,path varchar(255) NOT NULL,progress long NOT NULL,size long NOT NULL,status integer NOT NULL,supportRange integer NOT NULL, createdAt double);";

//static NSString * const SQL_UPDATE_DOWNLOAD_INFO = @"REPLACE INTO %s (_id,uri,path,progress,size,status,supportRange,createdAt) VALUES(?,?,?,?,?,?,?,?);";

static NSString * const SQL_UPDATE_DOWNLOAD_INFO = @"REPLACE INTO download_info (_id,uri,path,progress,size,status,supportRange,createdAt) VALUES('%@','%@','%@',%ld,%ld,%d,%d,%f);";

static NSString * const SQL_DELETE_DOWNLOAD_INFO_WHERE_ID = @"DELETE FROM download_info WHERE _id = '%@';";

static NSString * const SQL_SELECT_DOWNLOAD_INFO_WHERE_ID = @"SELECT * FROM download_info WHERE _id='%@';";

//查询除完成状态的下载
static NSString * const SQL_SELECT_DOWNLOAD_INFO_WHERE_STATUS_DOWNLOADING = @"SELECT * FROM download_info WHERE status!=5 ORDER BY createdAt DESC;";

//查询完成的下载
static NSString * const SQL_SELECT_DOWNLOAD_INFO_WHERE_STATUS_DOWNLOADED = @"SELECT * FROM download_info WHERE status=5 ORDER BY createdAt DESC;";

//将所有未下载完成的任务更改为暂停
static NSString * const SQL_UPDATE_DOWNLOADING_INFO_STATUS = @"UPDATE download_info SET status=4 WHERE status!=5;";

@interface DatabaseController : NSObject

@property (nonatomic,assign) sqlite3 *database;

/**
 返回当前类实例
 
 @return return value description
 */
+ (DatabaseController *)sharedInstance:(DownloadConfig *)config;

/**
 根据Id查询下载信息

 @param downloadInfoId 下载对象Id
 @return <#return value description#>
 */
- (DownloadInfo *)findDownloadInfo:(NSString *)downloadInfoId;

- (NSArray *)findAllDownloading;

- (NSArray *)findAllDownloaded;

- (void)pauseAllDownloading;

- (void)createOrUpdate:(DownloadInfo *)downloadInfo;

- (void)remove:(DownloadInfo *)downloadInfo;

@end

NS_ASSUME_NONNULL_END

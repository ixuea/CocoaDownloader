//
//  DatabaseController.m
//  CocoaDownloader
//
//  Created by smile on 2018/12/12.
//  Copyright © 2018 ixuea(http://a.ixuea.com/y). All rights reserved.
//

#import "DatabaseController.h"

@interface DatabaseController()

@property DownloadConfig *config;

@end

@implementation DatabaseController

+ (DatabaseController *)sharedInstance:(id)config{
    static DatabaseController *sharedInstance = nil;
    if (!sharedInstance) {
        sharedInstance = [[self alloc] initWithConfig:config];
    }
    return sharedInstance;
    
}

- (instancetype)initWithConfig:(DownloadConfig *)config{
    if (self=[super init]) {
        self.config=config;
        [self initDatabase];
    }
    return self;
}

- (void)initDatabase{
    NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *databasePath=[documentPath stringByAppendingPathComponent:self.config.databaseName];
    
    NSLog(@"database controller path:%@",databasePath);
    
    //将OC字符串转换为c语言的字符串
    const char *databasePathC=databasePath.UTF8String;
    //1.打开数据库文件（如果数据库文件不存在，那么该函数会自动创建数据库文件）
    int result = sqlite3_open(databasePathC, &_database);
    if (SQLITE_OK==result) {
        NSLog(@"打开数据库成功");
        
        [self createTable];
    }else{
        NSLog(@"打开数据库失败:%d",result);
    }
}

- (void)createTable{
    char *error;
    int result=sqlite3_exec(self.database, SQL_CREATE_DOWNLOAD_TABLE.UTF8String, NULL, NULL, &error);
    if (SQLITE_OK==result) {
        NSLog(@"创建表成功");
    }else{
        NSLog(@"创建表失败");
    }
}

- (NSArray *)findAllDownloading{
    return [self findAllDownload:SQL_SELECT_DOWNLOAD_INFO_WHERE_STATUS_DOWNLOADING];
}

- (NSArray *)findAllDownloaded{
    return [self findAllDownload:SQL_SELECT_DOWNLOAD_INFO_WHERE_STATUS_DOWNLOADED];
}

- (NSArray *)findAllDownload:(NSString *)sql{
    downloadLogDebug(@"database controller findAllDownload start");
    NSMutableArray *results=[[NSMutableArray alloc] init];
    
    sqlite3_stmt *stmt=NULL;
    
    //进行查询前的准备工作
    if (SQLITE_OK==sqlite3_prepare_v2(self.database, sql.UTF8String, -1, &stmt, NULL)) {
        
        //SQL语句没有问题
        NSLog(@"查询语句没有问题");
        
        //每调用一次sqlite3_step函数，stmt就会指向下一条记录
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            //找到一条记录
            DownloadInfo *downloadInfo=[[DownloadInfo alloc] init];
            
            [self inflateDownloadInfo:stmt downloadInfo:downloadInfo];
            
            [results addObject:downloadInfo];
        }
    }else{
        NSLog(@"查询语句有问题");
    }
    
    downloadLogDebug(@"database controller findAllDownload end");
    
    return results;
}


- (DownloadInfo *)findDownloadInfo:(NSString *)downloadInfoId{
    sqlite3_stmt *stmt=NULL;
    
    NSString *finalSQL=[NSString stringWithFormat:SQL_SELECT_DOWNLOAD_INFO_WHERE_ID,downloadInfoId];
    
    //进行查询前的准备工作
    if (SQLITE_OK==sqlite3_prepare_v2(self.database, finalSQL.UTF8String, -1, &stmt, NULL)) {
        
        //SQL语句没有问题
        NSLog(@"查询语句没有问题");
        
        //每调用一次sqlite3_step函数，stmt就会指向下一条记录
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            //找到一条记录
            DownloadInfo *downloadInfo=[[DownloadInfo alloc] init];
            
            [self inflateDownloadInfo:stmt downloadInfo:downloadInfo];
            return downloadInfo;
        }
    }else{
        NSLog(@"查询语句有问题");
    }
    
    return nil;
}

- (void)inflateDownloadInfo:(sqlite3_stmt *)stmt downloadInfo:(DownloadInfo *)downloadInfo{
    const unsigned char *downloadInfoId=sqlite3_column_text(stmt, 0);
    const unsigned char *uri=sqlite3_column_text(stmt, 1);
    
    const unsigned char *path=sqlite3_column_text(stmt, 2);
    
    long progress=sqlite3_column_int64(stmt, 3);
    
    long size=sqlite3_column_int64(stmt, 4);
    
    int status=sqlite3_column_int(stmt, 5);
    
    int supportRange=sqlite3_column_int(stmt, 6);
    
    double createdAt=sqlite3_column_double(stmt, 7);
    
    downloadInfo.id=[NSString stringWithUTF8String:downloadInfoId];
    downloadInfo.uri=[NSString stringWithUTF8String:uri];
    downloadInfo.path=[NSString stringWithUTF8String:path];
    downloadInfo.progress=progress;
    downloadInfo.size=size;
    downloadInfo.status=status;
    downloadInfo.supportRange=supportRange;
    downloadInfo.createdAt=createdAt;
}

- (void)pauseAllDownloading{
    char *errorMessage=NULL;
    if (SQLITE_OK==sqlite3_exec(self.database, SQL_UPDATE_DOWNLOADING_INFO_STATUS.UTF8String, NULL, NULL, &errorMessage)) {
        downloadLogDebug(@"database controller pauseAllDownloading success");
    }else{
        downloadLogDebug(@"database controller pauseAllDownloading fail");
    }
}

- (void)createOrUpdate:(DownloadInfo *)downloadInfo{
    if (DownloadStatusNone==downloadInfo.status) {
        //如果是这样的状态，就不存储
        return;
    }
    
    NSString *finalSQL=[NSString stringWithFormat:SQL_UPDATE_DOWNLOAD_INFO,downloadInfo.id,downloadInfo.uri,downloadInfo.path,downloadInfo.progress,downloadInfo.size,downloadInfo.status,downloadInfo.supportRange,downloadInfo.createdAt];
    
    char *errorMessage=NULL;
    if (SQLITE_OK==sqlite3_exec(self.database, finalSQL.UTF8String, NULL, NULL, &errorMessage)) {
        downloadLogDebug(@"database controller createOrUpdate success id:%@",downloadInfo.id);
    }else{
        downloadLogDebug(@"database controller createOrUpdate fail id:%@",downloadInfo.id);
    }
    
}

- (void)remove:(DownloadInfo *)downloadInfo{
    NSString *finalSQL=[NSString stringWithFormat:SQL_DELETE_DOWNLOAD_INFO_WHERE_ID,downloadInfo.id];
    
    char *errorMessage=NULL;
    if (SQLITE_OK==sqlite3_exec(self.database,finalSQL.UTF8String, NULL, NULL, &errorMessage)) {
        downloadLogDebug(@"database controller remove success id:%@",downloadInfo.id);
    }else{
        downloadLogDebug(@"database controller remove fail id:%@",downloadInfo.id);
    }
}

@end

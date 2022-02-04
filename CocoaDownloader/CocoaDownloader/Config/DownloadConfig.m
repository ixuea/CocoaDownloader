//
//  DownloadConfig.m
//  CocoaDownloader
//
//  Created by smile on 2018/12/14.
//  Copyright © 2018 ixuea(http://a.ixuea.com/y). All rights reserved.
//

#import "DownloadConfig.h"

@implementation DownloadConfig

- (instancetype)init{
    if (self=[super init]) {
        self.downloadTaskNumber=1;
        self.timeoutInterval=120.0;
        self.databaseName=@"IxueaCocoaDownloader.db";
    }
    return self;
}

@end

//
//  DownloadInfo.m
//  CocoaDownloader
//
//  Created by smile on 2018/12/12.
//  Copyright © 2018 ixuea(http://a.ixuea.com/y). All rights reserved.
//

#import "DownloadInfo.h"

@implementation DownloadInfo

- (instancetype)init{
    if (self = [super init]) {
        self.status=DownloadStatusNone;
    }
    return self;
}

@end

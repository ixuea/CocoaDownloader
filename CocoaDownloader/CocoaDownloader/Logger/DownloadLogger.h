//
//  DownloadLogger.h
//  CocoaDownloader
//
//  Created by smile on 2018/12/12.
//  Copyright © 2018 ixuea(http://a.ixuea.com/y). All rights reserved.
//

#ifndef DownloadLogger_h
#define DownloadLogger_h

#import <Foundation/Foundation.h>

#define downloadLogError(frmt, ...)   NSLog(frmt, ##__VA_ARGS__)

#define downloadLogDebug(frmt, ...)   NSLog(frmt, ##__VA_ARGS__)

#endif /* DownloadLogger_h */

//
//  DownloadConfig.h
//  CocoaDownloader
//
//  Created by smile on 2018/12/14.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadConfig : NSObject


/**
 Download task number, default is 1.
 */
@property int downloadTaskNumber;


/**
 Timeout, default is 120 seconds.
 */
@property NSTimeInterval timeoutInterval;


/**
 Database name, default is "IxueaCocoaDownloader.db"
 */
@property NSString *databaseName;

@end

NS_ASSUME_NONNULL_END

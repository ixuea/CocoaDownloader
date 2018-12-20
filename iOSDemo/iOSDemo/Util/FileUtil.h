//
//  FileUtil.h
//  CocoaDownloader
//
//  Created by smile on 2018/12/15.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileUtil : NSObject

/**
 文件大小格式化
 
 @param size <#size description#>
 @return 返回值实例：1.22M
 */
+ (NSString *)formatFileSize:(NSInteger)size;

@end

NS_ASSUME_NONNULL_END

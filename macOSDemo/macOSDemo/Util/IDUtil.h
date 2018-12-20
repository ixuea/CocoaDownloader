//
//  IDUtil.h
//  CocoaDownloader
//
//  Created by smile on 2018/12/17.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IDUtil : NSObject


/**
 将字符串转为MD5

 @param str <#str description#>
 @return <#return value description#>
 */
+ (NSString *)stringToMD5:(NSString *)str;

@end

NS_ASSUME_NONNULL_END

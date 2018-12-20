//
//  ORMUtil.h
//  CocoaDownloader
//
//  Created by smile on 2018/12/17.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MyBusinessInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ORMUtil : NSObject

/**
 返回当前类实例
 
 @return <#return value description#>
 */
+ (ORMUtil *)sharedInstance;

- (void)createOrUpdateBusinessInfo:(MyBusinessInfo *)data;

- (void)deleteBusinessInfo:(NSString *)id;

- (MyBusinessInfo *)findBusinessInfo:(NSString *)id;

@end

NS_ASSUME_NONNULL_END

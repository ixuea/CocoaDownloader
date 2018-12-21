//
//  BaseController.h
//  CocoaDownloaderMacOS
//
//  Created by smile on 2018/12/18.
//  Copyright © 2018 ixuea(http://a.ixuea.com/y). All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseController : NSViewController

/**
 控件
 */
- (void)initViews;

/**
 数据
 */
- (void)initDatas;

/**
 监听器
 */
- (void)initListeners;

@end

NS_ASSUME_NONNULL_END

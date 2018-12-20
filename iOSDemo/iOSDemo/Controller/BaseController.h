//
//  BaseController.h
//  iOSDemo
//
//  Created by smile on 2018/12/20.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseController : UIViewController


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

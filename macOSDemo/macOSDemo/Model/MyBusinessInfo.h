//
//  MyBusinessInfo.h
//  下载对象业务信息，这里包含图标，名称等信息
//
//  Created by smile on 2018/12/19.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SharkORM.h"

NS_ASSUME_NONNULL_BEGIN

//继承自SRKStringObject对象，才能支持Id主键为NSString
@interface MyBusinessInfo : SRKStringObject

@property NSString *title;
@property NSString *icon;
@property NSString *url;

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon url:(NSString *)url;

@end

NS_ASSUME_NONNULL_END

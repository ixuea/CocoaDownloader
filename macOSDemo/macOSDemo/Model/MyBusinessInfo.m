//
//  MyBusinessInfo.m
//  CocoaDownloaderMacOS
//
//  Created by smile on 2018/12/19.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import "MyBusinessInfo.h"

@implementation MyBusinessInfo

@dynamic title,icon,url;

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon url:(NSString *)url{
    if (self=[super init]) {
        self.title=title;
        self.icon=icon;
        self.url=url;
    }
    return self;
}

@end

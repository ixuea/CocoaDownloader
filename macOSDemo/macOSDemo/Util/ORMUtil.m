//
//  ORMUtil.m
//  CocoaDownloader
//
//  Created by smile on 2018/12/17.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import "ORMUtil.h"

@implementation ORMUtil

+ (ORMUtil *)sharedInstance{
    static ORMUtil *sharedInstance = nil;
    if (!sharedInstance) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

- (instancetype)init{
    if (self=[super init]) {
        //TODO Database init.
    }
    return self;
}

- (void)createOrUpdateBusinessInfo:(MyBusinessInfo *)data{
    [data commit];
}

- (void)deleteBusinessInfo:(MyBusinessInfo *)data{
    [data remove];
}

- (MyBusinessInfo *)findBusinessInfo:(NSString *)id{
    MyBusinessInfo *resutl=[[[MyBusinessInfo query] where:@"Id = ?" parameters:@[id]] first];
    return resutl;
}

@end

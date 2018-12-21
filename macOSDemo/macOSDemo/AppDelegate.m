//
//  AppDelegate.m
//  CocoaDownloaderMacOS
//
//  Created by smile on 2018/12/18.
//  Copyright © 2018 ixuea(http://a.ixuea.com/y). All rights reserved.
//

#import "SharkORM.h"

#import "AppDelegate.h"
#import "MyBusinessInfo.h"

@interface AppDelegate ()<SRKDelegate>

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    //Database init.
    [self initDatabase];
}

//Database init.
- (void)initDatabase{
    [SharkORM setDelegate:self];
    [SharkORM openDatabaseNamed:@"ixuea"];
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end

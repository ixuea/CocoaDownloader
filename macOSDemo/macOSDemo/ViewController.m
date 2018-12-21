//
//  ViewController.m
//  CocoaDownloaderMacOS
//
//  Created by smile on 2018/12/18.
//  Copyright © 2018 ixuea(http://a.ixuea.com/y). All rights reserved.
//

#import <CocoaDownloader/CocoaDownloader.h>

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [DownloadManager sharedInstance];
}

- (IBAction)onAboutClick:(NSButton *)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://a.ixuea.com/M"]];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end

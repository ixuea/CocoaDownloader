//
//  ViewController.m
//  iOSDemo
//
//  Created by smile on 2018/12/20.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import <CocoaDownloader/CocoaDownloader.h>

#import "ViewController.h"

@interface ViewController ()

@property DownloadManager *downloadManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initViews{
    [super initViews];
    [super setTitle:@"Cocoa downloader demo"];
}

- (void)initDatas{
    [super initDatas];
    //Default config
    //    self.downloadManager=[DownloadManager sharedInstance];
    
    //Custom config
    DownloadConfig *config=[[DownloadConfig alloc] init];
    
    //Download task number
    config.downloadTaskNumber=2;
    
    self.downloadManager=[DownloadManager sharedInstance:config];
}

- (IBAction)onAboutClick:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ixuea.com"] options:@{} completionHandler:^(BOOL success) {
        
    }];
}



@end

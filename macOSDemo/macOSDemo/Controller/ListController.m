//
//  ListController.m
//  CocoaDownloaderMacOS
//
//  Created by smile on 2018/12/18.
//  Copyright © 2018 ixuea. All rights reserved.
//

#import <CocoaDownloader/CocoaDownloader.h>

#import "ListController.h"
#import "DownloadInfoCell.h"
#import "MyBusinessInfo.h"
#import "IDUtil.h"
#import "ORMUtil.h"
#import "Constants.h"

@interface ListController ()<NSTableViewDataSource,NSTableViewDelegate>

@property DownloadManager *downloadManager;
@property NSMutableArray *dataArray;

@property ORMUtil *orm;

@end

@implementation ListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)initViews{
    [super initViews];
    
    self.dataArray=[[NSMutableArray alloc] init];
}

- (void)initDatas{
    [super initDatas];
    
    self.downloadManager=[DownloadManager sharedInstance];
    
    [self.dataArray addObjectsFromArray:[self getDownloadListData]];
    [self.tableView reloadData];
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [self.dataArray count];
}

//- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
//    return @"aaa";
//}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    DownloadInfoCell *cell=[tableView makeViewWithIdentifier:CELL owner:self];
    
    cell.downloadManager=self.downloadManager;
    
    MyBusinessInfo *data=self.dataArray[row];
    
    //显示业务数据
    [cell bindData:data];
    
    NSString *downloadInfoId=[IDUtil stringToMD5:data.url];
    
    //显示下载数据
    DownloadInfo *downloadInfo=[self.downloadManager findDownloadInfo:downloadInfoId];
    
    [cell bindDownloadData:downloadInfo];
    
    
    return cell;
}

/**
 返回要下载的测试数据
 
 真实项目中可以来自任何位置
 
 @return <#return value description#>
 */
- (NSArray *)getDownloadListData{
    NSMutableArray *myBusinessInfos=[[NSMutableArray alloc] init];
    [myBusinessInfos addObject:[[MyBusinessInfo alloc] initWithTitle:@"QQ" icon:@"http://img.wdjimg.com/mms/icon/v1/4/c6/e3ff9923c44e59344e8b9aa75e948c64_256_256.png" url:@"http://wdj-qn-apk.wdjcdn.com/e/b8/520c1a2208bf7724b96f538247233b8e.apk"]];
    
    [myBusinessInfos addObject:[[MyBusinessInfo alloc] initWithTitle:@"微信" icon:@"http://img.wdjimg.com/mms/icon/v1/7/ed/15891412e00a12fdec0bbe290b42ced7_256_256.png" url:@"http://wdj-uc1-apk.wdjcdn.com/1/a3/8ee2c3f8a6a4a20116eed72e7645aa31.apk"]];
    
    //    [myBusinessInfos addObject:[[MyBusinessInfo alloc] initWithTitle:@"360手机卫士" icon:@"http://img.wdjimg.com/mms/icon/v1/d/29/dc596253e9e80f28ddc84fe6e52b929d_256_256.png" url:@"http://wdj-qn-apk.wdjcdn.com/4/0b/ce61a5f6093fe81502fc0092dd6700b4.apk"]];
    
    [myBusinessInfos addObject:[[MyBusinessInfo alloc] initWithTitle:@"陌陌" icon:@"http://img.wdjimg.com/mms/icon/v1/a/6e/03d4e21876706e6a175ff899afd316ea_256_256.png" url:@"http://wdj-qn-apk.wdjcdn.com/b/0a/369eec172611626efff4e834fedce0ab.apk"]];
    
    [myBusinessInfos addObject:[[MyBusinessInfo alloc] initWithTitle:@"美颜相机" icon:@"http://img.wdjimg.com/mms/icon/v1/7/7b/eb6b7905241f22b54077cbd632fe87b7_256_256.png" url:@"http://wdj-qn-apk.wdjcdn.com/a/e9/618d265197a43dab6277c41ec5f72e9a.apk"]];
    
    [myBusinessInfos addObject:[[MyBusinessInfo alloc] initWithTitle:@"Chrome" icon:@"http://img.wdjimg.com/mms/icon/v1/d/fd/914f576f9fa3e9e7aab08ad0a003cfdd_256_256.png" url:@"http://wdj-qn-apk.wdjcdn.com/6/0d/6e93a829b97d671ee56190aec78400d6.apk"]];
    
    [myBusinessInfos addObject:[[MyBusinessInfo alloc] initWithTitle:@"淘宝" icon:@"https://android-artworks.25pp.com/fs08/2018/11/28/9/110_5eb0ac0aebf3abcf91590b8a0a320630_con_130x130.png" url:@"https://alissl.ucdl.pp.uc.cn/fs08/2018/11/27/9/110_7a50865b726e729b6edc31cfd724c7b7.apk"]];
    
    
    [myBusinessInfos addObject:[[MyBusinessInfo alloc] initWithTitle:@"手机天猫" icon:@"https://android-artworks.25pp.com/fs08/2018/11/22/11/110_c6ff596ba84d12ba188749fd6b57808c_con_130x130.png" url:@"https://alissl.ucdl.pp.uc.cn/fs08/2018/11/22/5/110_e3f773e7c9b1182424c73f538f9a74b4.apk"]];
    
    [myBusinessInfos addObject:[[MyBusinessInfo alloc] initWithTitle:@"支付宝" icon:@"https://android-artworks.25pp.com/fs08/2018/11/23/7/110_ba7b3b9f5b1c2c460a5ad1f4ae8ce9e0_con_130x130.png" url:@"https://alissl.ucdl.pp.uc.cn/fs08/2018/12/13/5/1_5054c6afc3449aeb24971054a8c88675.apk"]];
    
    [myBusinessInfos addObject:[[MyBusinessInfo alloc] initWithTitle:@"千牛" icon:@"https://android-artworks.25pp.com/fs08/2018/12/14/7/110_038a0ba36ffa386619dead98213cef06_con_130x130.png" url:@"https://alissl.ucdl.pp.uc.cn/fs08/2018/12/05/2/2_351d072ff63ab47e65ee2bebc7935645.apk"]];
    
    [myBusinessInfos addObject:[[MyBusinessInfo alloc] initWithTitle:@"网易云音乐" icon:@"https://android-artworks.25pp.com/fs08/2018/12/03/3/110_64498e47e368fdad382aa302f56704e0_con_130x130.png" url:@"https://alissl.ucdl.pp.uc.cn/fs08/2018/11/30/9/2_320fca742c90c3e9b0cd77cc5c74309d.apk"]];
    
    [myBusinessInfos addObject:[[MyBusinessInfo alloc] initWithTitle:@"闲鱼" icon:@"https://android-artworks.25pp.com/fs08/2018/12/06/1/110_d6a44ec74dfa4bd4c3b8a4f5991ec18a_con_130x130.png" url:@"https://alissl.ucdl.pp.uc.cn/fs08/2018/12/06/3/110_3e70a6f3ba319efe15aef5cce13f8623.apk"]];
    
    return myBusinessInfos;
}

@end

# CocoaDownloader

[English][13] | 中文

一个功能强大的下载框架，支持iOS和macOS平台.  [提交一个Issue][10], Android平台使用[AndroidDownloader][12].

## iOS Demo
<img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/ios/Home.png" width="30%" height="30%"><img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/ios/DownloadAFile.png" width="30%" height="30%">
<img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/ios/UseInList.png" width="30%" height="30%"> 
<img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/ios/Downloading.png" width="30%" height="30%">
<img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/ios/Downloaded.png" width="30%" height="30%">

更多信息查看iOSDemo.

## macOS Demo
<img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/mac/Home.png" width="40%" height="40%"><img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/mac/DownloadAFile.png" width="40%" height="40%">
<img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/mac/UseInList.png" width="40%" height="40%"> 
<img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/mac/Downloading.png" width="40%" height="40%">
<img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/mac/Downloaded.png" width="40%" height="40%">

更多信息查看macOSDemo.

## 入门

### 1.导入头文件

```objc
#import <CocoaDownloader/CocoaDownloader.h>
```

### 2.创建DownloadManager实例

```objc
self.downloadManager=[DownloadManager sharedInstance];
```

或者通过自定义配置创建下载器.

```objc
//Custom config
DownloadConfig *config=[[DownloadConfig alloc] init];

//Download task number
config.downloadTaskNumber=2;

self.downloadManager=[DownloadManager sharedInstance:config];
```

### 3.下载一个文件

```objc
//save path
NSString *documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
NSString *path=[documentPath stringByAppendingPathComponent:@"IxueaCocoaDownloader/a.apk"];

NSLog(@"ixuea download save path:%@",path);

//Create download info.
self.downloadInfo=[[DownloadInfo alloc] init];

//Set download save path.
[self.downloadInfo setPath:path];

//Set download url.
[self.downloadInfo setUri:DEFAULT_URL];

//Set download info id.
[self.downloadInfo setId:DEFAULT_ID];

NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];

NSTimeInterval currentTimeMillis=[date timeIntervalSince1970];

//Set download create time.
[self.downloadInfo setCreatedAt:currentTimeMillis];

//Set download callcabk.
[self.downloadInfo setDownloadBlock:^(DownloadInfo * _Nonnull downloadInfo) {
    //TODO Progress, status changes are callbacks.
}];

//Start download.
[self.downloadManager download:self.downloadInfo];
```

更多信息请查看[SampleController][11]文件源码.

## 更多帮助信息

请查看Demo项目, iOS和macOS平台使用下载器API都是一样的.

## 作者

Smile - @ixueadev on GitHub, Email is ixueadev@163.com, See more ixuea([http://www.ixuea.com][100])

iOS & macOS开发交流群QQ群: 965841894.

[10]: https://github.com/ixuea/CocoaDownloader/issues/new
[11]: https://github.com/ixuea/CocoaDownloader/blob/master/iOSDemo/iOSDemo/Controller/SampleController.m
[12]: http://a.ixuea.com/O
[13]: https://github.com/ixuea/CocoaDownloader
[14]: https://github.com/ixuea/CocoaDownloader/blob/master/docs/zh.md

[100]: http://a.ixuea.com/d


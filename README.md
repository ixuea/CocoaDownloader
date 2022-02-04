# CocoaDownloader

English | [中文][14]

An powerful download library for iOS, macOS.  [Report an issue][10], Android use [AndroidDownloader][12].

## iOS Demo
<img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/ios/Home.png" width="30%" height="30%"><img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/ios/DownloadAFile.png" width="30%" height="30%">
<img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/ios/UseInList.png" width="30%" height="30%"> 
<img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/ios/Downloading.png" width="30%" height="30%">
<img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/ios/Downloaded.png" width="30%" height="30%">

See iOSDemo for details.

## macOS Demo
<img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/mac/Home.png" width="40%" height="40%"><img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/mac/DownloadAFile.png" width="40%" height="40%">
<img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/mac/UseInList.png" width="40%" height="40%"> 
<img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/mac/Downloading.png" width="40%" height="40%">
<img src="https://raw.githubusercontent.com/ixuea/CocoaDownloader/master/art/mac/Downloaded.png" width="40%" height="40%">

See macOSDemo for details.

## Getting Started

### 1.Import header file

```objc
#import <CocoaDownloader/CocoaDownloader.h>
```

### 2.Create a DownloadManager instance

```objc
self.downloadManager=[DownloadManager sharedInstance];
```

Or detailed configuration.

```objc
//Custom config
DownloadConfig *config=[[DownloadConfig alloc] init];

//Download task number
config.downloadTaskNumber=2;

self.downloadManager=[DownloadManager sharedInstance:config];
```

### 3.Download a file

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

See [SampleController][11] for details.

## More

See the example code, iOS and macOS platform downloaders use the same API.

## Author

Smile - @ixueadev on GitHub, Email is ixueadev@163.com, See more ixuea([http://www.ixuea.com][100])

iOS & macOS QQ development group: 965841894.

[10]: https://github.com/ixuea/CocoaDownloader/issues/new
[11]: https://github.com/ixuea/CocoaDownloader/blob/master/iOSDemo/iOSDemo/Controller/SampleController.m
[12]: http://a.ixuea.com/O
[13]: https://github.com/ixuea/CocoaDownloader
[14]: https://github.com/ixuea/CocoaDownloader/blob/master/docs/zh.md


[100]: http://a.ixuea.com/d


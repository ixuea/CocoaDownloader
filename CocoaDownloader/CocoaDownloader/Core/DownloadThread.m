//
//  DownloadThread.m
//  CocoaDownloader
//
//  Created by smile on 2018/12/14.
//  Copyright © 2018 ixuea(http://a.ixuea.com/y). All rights reserved.
//

#import "DownloadThread.h"

@implementation DownloadThread

- (instancetype)initDispatch:(DownloadDispatch *)dispatch download:(DownloadInfo *)download config:(DownloadConfig *)config delegate:(id<DownloadThreadDelegate>)delegate{
    if (self=[super init]) {
        self.dispatch=dispatch;
        self.downloadInfo=download;
        self.config=config;
        self.delegate=delegate;
        
        self.lastProgress=download.progress;
    }
    return self;
}

- (void)start{
    [self checkPause];
    //开始下载
    [self.dataTask resume];
}

- (void)checkPause{
    if (DownloadStatusPaused==self.downloadInfo.status) {
        [self.dataTask suspend];
    }
    
}

- (NSURLSessionDataTask *)dataTask{
    if (!_dataTask) {
        //创建下载URL
        NSURL *url = [NSURL URLWithString:self.downloadInfo.uri];
        
        //创建request请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:self.config.timeoutInterval];
        
        //设置Range，支持断点继续下载
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.downloadInfo.progress];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        //创建下载任务
        _dataTask = [self.session dataTaskWithRequest:request];
    }
    return _dataTask;
}

- (NSURLSession *)session{
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    return _session;
}

#pragma mark - NSURLSessionDataDelegate代理方法

/**
 接收到数据

 @param session <#session description#>
 @param dataTask <#dataTask description#>
 @param response <#response description#>
 @param completionHandler <#completionHandler description#>
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    
    if (0==self.downloadInfo.size) {
       //如果文件没有长度，设置文件长度
        self.downloadInfo.size=response.expectedContentLength;
    }
    
    //documents目录
    NSURL *pathUrl = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    //拼接用户添加的路径
    pathUrl=[pathUrl URLByAppendingPathComponent:self.downloadInfo.path];
    
    //获取文件管理器
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:pathUrl.path]) {
        //截取文件夹路径
        NSString *downloadFolder=[pathUrl URLByDeletingLastPathComponent].path;
        
        //创建文件夹
        [manager createDirectoryAtPath:downloadFolder withIntermediateDirectories:YES attributes:nil error:nil];
        
        //创建文件
        [manager createFileAtPath:pathUrl.path contents:nil attributes:nil];
    }
    
    downloadLogDebug(@"download thread didReceiveResponse size:%ld uri:%@ path:%@",self.downloadInfo.size,self.downloadInfo.uri,pathUrl.path);
    
    //创建文件句柄
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:pathUrl.path];
    
    //允许接收服务端数据
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 接收到数据，写入文件
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    //移动到文件末尾
    [self.fileHandle seekToEndOfFile];
    
    //向文件写入数据
    [self.fileHandle writeData:data];
    
    //已经下载的进度
    self.downloadInfo.progress +=data.length;
    
    downloadLogDebug(@"download thread didReceiveData id:%@ progress:%ld size:%ld self:%@",self.downloadInfo.id,self.downloadInfo.progress,self.downloadInfo.size,self);
    
    [self.delegate onProgress];
    
    [self checkPause];
}

/**
 *  下载完文件之后调用：关闭文件、清空长度
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    downloadLogDebug(@"download thread didCompleteWithError id:%@ progress:%ld size:%ld error:%@",self.downloadInfo.id, self.downloadInfo.progress,self.downloadInfo.size,error);
    
    //close file
    [self.fileHandle closeFile];
    
    if (error) {
        //有错误
        
        //状态设置为错误
        [self.downloadInfo setStatus:DownloadStatusError];
        
        //将错误保存到下载对象上
        //这样用户就可以在外面判断是什么错误
        self.downloadInfo.error=error;
        
        downloadLogDebug(@"download thread didCompleteWithError fail id:%@ progress:%ld size:%ld error:%@",self.downloadInfo.id,self.downloadInfo.progress,self.downloadInfo.size,error);
        
        [self.delegate onDownloadFail];
    } else {
        if (self.downloadInfo.progress==self.downloadInfo.size) {
            
            downloadLogDebug(@"download thread didCompleteWithError success id:%@ progress:%ld size:%ld error:%@",self.downloadInfo.id,self.downloadInfo.progress,self.downloadInfo.size,error);
           
            //下载完成
            [self.downloadInfo setStatus:DownloadStatusCompleted];
            
            [self.delegate onDownloadSuccess];
            
        }else{
            //其他错误
            [self.downloadInfo setStatus:DownloadStatusError];
            
            [self.delegate onDownloadFail];
        }
    }
    
    [self.dispatch onStatusChanged:self.downloadInfo];
}


@end

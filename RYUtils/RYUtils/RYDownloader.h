//
//  RYDownloader.h
//  RYStudio
//
//  Created by Ryan on 13-4-17.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    kDownloadWaiting = 0,           //等待下载
    kDownloading = 1,               //正在下载
    kDownloadingHandling = 2,       //下载已返回，处于回调处理中
    kDownloadSucceed = 3,           //下载成功
    kDownloadFailed = 4,            //下载失败
    kDownloadCanceled = 5           //下载取消
}DownloaderStatus;

@protocol RYDownloaderDelegate;

@interface RYDownloader : NSObject

@property (nonatomic, copy) NSString* purpose;              //downloader的标识
@property (nonatomic, assign) DownloaderStatus status;      //设置下载状态，默认为等待下载

#if ! __has_feature(objc_arc)
@property (nonatomic, retain) NSURLRequest *urlRequest;
@property (nonatomic, retain) NSURLConnection *theConnection;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, assign) id<RYDownloaderDelegate> delegate;
#else
@property (nonatomic, strong) NSURLRequest *urlRequest;
@property (nonatomic, strong) NSURLConnection *theConnection;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, weak) id<RYDownloaderDelegate> delegate;
#endif

- (void)startDownloadWithRequest:(NSURLRequest *)request
                        callback:(id<RYDownloaderDelegate>)receiver
                         purpose:(NSString *)pur;
- (void)cancelDownload;
@end

@protocol RYDownloaderDelegate<NSObject>
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data;
- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message;
@end
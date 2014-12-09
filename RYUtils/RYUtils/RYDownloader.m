//
//  RYDownloader.m
//  RYStudio
//
//  Created by Ryan on 13-4-17.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "RYDownloader.h"
#import "RYDownloaderManager.h"

@interface RYDownloader()

- (void)clearData;

@end

@implementation RYDownloader

@synthesize purpose,urlRequest;
@synthesize theConnection,responseData;
@synthesize delegate,status;

#pragma mark - Memory management
- (id)init
{
    if(self = [super init])
    {
        status = kDownloadWaiting;
    }
    return self;
}

- (void)dealloc
{
    [self cancelDownload];
#if ! __has_feature(objc_arc)
    [urlRequest release];
	[responseData release];
	[purpose release];
	[super dealloc];
#endif
}

#pragma mark - Private methods

- (void)clearData
{
    self.responseData = nil;
    self.theConnection = nil;
    self.purpose = nil;
    self.urlRequest = nil;
}

#pragma mark - Public methods
- (void)startDownloadWithRequest:(NSURLRequest *)request
                        callback:(id<RYDownloaderDelegate>)receiver
                         purpose:(NSString *)pur
{
    self.urlRequest = request;
    self.delegate = receiver;
    self.purpose = pur;
    self.status = kDownloading;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSMutableData *data = [[NSMutableData alloc] init];
    self.responseData = data;
#if ! __has_feature(objc_arc)
    [data release];
#endif
    self.theConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}
- (void)cancelDownload
{
	[theConnection cancel];
    [self clearData];
    self.status = kDownloadCanceled;
    [[RYDownloaderManager sharedManager] reloadNetworkActivityIndicator];
}

#pragma mark - NSURLConnectionDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse * httpResponse;
	httpResponse = (NSHTTPURLResponse *) response;
	assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
	if ((httpResponse.statusCode / 100) != 2)
	{
        /**
         HTTP协议状态码表示的意思主要分为五类 ,大体是 :
         1×× 　　保留
         2×× 　　表示请求成功地接收                - Successful
         3×× 　　为完成请求客户需进一步细化请求      - Redirection
         4×× 　　客户错误                        - Client Error
         5×× 　　服务器错误                      - Server Error
         */
        
        [connection cancel];
		[self connection:connection didFailWithError:[NSError errorWithDomain:@"response error" code:httpResponse.statusCode userInfo:nil]];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if([delegate respondsToSelector:@selector(downloader:didFinishWithError:)])
        [delegate downloader:self didFinishWithError:[NSString stringWithFormat:@"%@",error]];
    [self clearData];
    self.status = kDownloadFailed;
    [[RYDownloaderManager sharedManager] reloadNetworkActivityIndicator];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if([delegate respondsToSelector:@selector(downloader:completeWithNSData:)])
        [delegate downloader:self completeWithNSData:responseData];
    [self clearData];
    self.status = kDownloadSucceed;
    [[RYDownloaderManager sharedManager] reloadNetworkActivityIndicator];
}

@end

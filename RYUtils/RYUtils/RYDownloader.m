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
    [urlRequest release];
	[responseData release];
	[purpose release];
	[super dealloc];
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
    [data release];
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

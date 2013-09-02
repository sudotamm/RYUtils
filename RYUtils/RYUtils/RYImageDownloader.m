//
//  RYImageDownloader.m
//  RYUtils
//
//  Created by Ryan Yuan on 11/20/10.
//  Copyright 2010 Ryan. All rights reserved.
//

#import "RYImageDownloader.h"

@implementation RYImageDownloader
@synthesize delegate, purpose;
@synthesize activeDownload, theConnection;
@synthesize requestUrl;
#pragma mark -
#pragma mark Memory management
- (void)dealloc
{
    [requestUrl release];
    [theConnection cancel];
    [theConnection release];
    theConnection = nil;
	[activeDownload release];
	[purpose release];
	[super dealloc];
}


#pragma mark -
#pragma mark interface functions
- (void)startDownloadWithURL:(NSString*)url
{
    [self cancelDownload];
    self.requestUrl = url;
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url] 
																			  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0] delegate:self];
    self.theConnection = conn;
    [conn release];
	if (self.theConnection != nil) {
		NSMutableData *data = [[NSMutableData alloc] init];
        self.activeDownload = data;
        [data release];
	}
}
- (void)cancelDownload
{
	[self.theConnection cancel];
    self.theConnection = nil;
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [delegate downloader:self didFinishWithError:[NSString stringWithFormat:@"%@",error]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[delegate downloader:self completeWithNSData:activeDownload];
    self.activeDownload = nil;
}
@end

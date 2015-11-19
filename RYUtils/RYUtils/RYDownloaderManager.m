//
//  RYDownloaderManager.m
//  RYStudio
//
//  Created by Ryan on 13-4-17.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "RYDownloaderManager.h"
#import "RYDownloader.h"

@interface RYDownloaderManager()

/**
	用reuse的方式获取downloader，如果当前downloader已存在并处于downloading中，则cancel掉，再reuse
    receiver和purpose用来标识downloader的唯一性，两个不能同时为nil
	@param receiver downloader的callback
	@param purpose  downloader的purpose
	@returns 返回manager中空闲RYDownloader实例
 */
- (RYDownloader *)reuseDownloaderWithDelegate:(id<RYDownloaderDelegate>)receiver
                                      purpose:(NSString*)purpose;


/**
	建立网络请求，判断receiver和purpose不可以同时为nil(crash)
	@param urlRequest 请求的url request
	@param receiver   请求之后的callback
	@param purpose    请求的purpose
 */
- (void)requestDataWithURLRequest:(NSURLRequest *)urlRequest
                         delegate:(id)receiver
                          purpose:(NSString *)purpose;


@end

@implementation RYDownloaderManager

@synthesize downloaders;

#pragma mark - Singleton methods

+ (RYDownloaderManager *)sharedManager
{
    static RYDownloaderManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RYDownloaderManager alloc] init];
    });
    return manager;
}

- (id)init
{
    if(self = [super init])
    {
        self.downloaders = [NSMutableArray array];
    }
    return self;
}

#if ! __has_feature(objc_arc)
- (void)dealloc
{
    [downloaders release];
    [super dealloc];
}
#endif

#pragma mark - Private methods
- (RYDownloader *)reuseDownloaderWithDelegate:(id<RYDownloaderDelegate>)receiver
                                      purpose:(NSString*)purpose
{
    //如果当前的download已经存在，将request cancel，再从空闲的downloader中取出reuse
    [self cancelDownloaderWithDelegate:receiver purpose:purpose];
    
    RYDownloader *downloader = nil;
    
    for(RYDownloader *down in downloaders)
    {
        if(nil == downloader)
        {
            if(down.status == kDownloadCanceled || down.status == kDownloadFailed || down.status == kDownloadSucceed)
            {
                downloader = down;
                downloader.status = kDownloadWaiting;
            }
        }
    }
    
    if(nil == downloader)
    {
        downloader = [[RYDownloader alloc] init];
        [downloaders addObject:downloader];
#if ! __has_feature(objc_arc)
        [downloader release];
#endif
    }
    return downloader;
}


- (void)requestDataWithURLRequest:(NSURLRequest *)urlRequest
                         delegate:(id<RYDownloaderDelegate>)receiver
                          purpose:(NSString *)purpose
{
    if(nil == receiver && nil == purpose)
    {
        NSAssert(nil, @"receiver and purpose can not be nil together.");
    }
    RYDownloader *downloader = [self reuseDownloaderWithDelegate:receiver purpose:purpose];
    [downloader startDownloadWithRequest:urlRequest callback:receiver purpose:purpose];
}

#pragma mark - Public methods
#pragma mark Cancel request methods
- (void)cancelDownloaderWithDelegate:(id)receiver
                             purpose:(NSString *)purpose
{
    if(!receiver && !purpose)
    {
        //cancel所有下载中的downloader
        for(RYDownloader *down in downloaders)
        {
            if(down.status == kDownloading)
                [down cancelDownload];
        }
    }
    else if(receiver && !purpose)
    {
        //cancel所有下载中且delegate = receiver的downloader
        for(RYDownloader *down in downloaders)
        {
            if(down.delegate == receiver && down.status == kDownloading)
                [down cancelDownload];
        }
    }
    else if(!receiver && purpose)
    {
        //cancel所有下载中且purpose equal的downloader
        for(RYDownloader *down in downloaders)
        {
            if([down.purpose isEqualToString:purpose] && down.status == kDownloading)
                [down cancelDownload];
        }
    }
    else
    {
        //cancel所有下载中且purpose equal且delegate = receiver的downloader
        for(RYDownloader *down in downloaders)
        {
            if(down.delegate == receiver && [down.purpose isEqualToString:purpose] && down.status == kDownloading)
                [down cancelDownload];
        }
    }
}

- (void)removeUnuseDownloaders
{
    NSInteger index = 0;
    NSMutableIndexSet *unuseSet = [NSMutableIndexSet indexSet];
    for(RYDownloader *down in downloaders)
    {
        if(down.status != kDownloading)
            [unuseSet addIndex:index];
        index++;
    }
    [downloaders removeObjectsAtIndexes:unuseSet];
}

- (void)reloadNetworkActivityIndicator
{
    BOOL show = NO;
    for(RYDownloader *down in downloaders)
    {
        if(down.status == kDownloading)
        {
            show = YES;
            break;
        }
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = show;
}

#pragma mark Call server methods
- (void)requestDataByGetWithURLString:(NSString *)urlStr
                             delegate:(id<RYDownloaderDelegate>)receiver
                              purpose:(NSString *)purpose
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.f];
    [self requestDataWithURLRequest:request delegate:receiver purpose:purpose];
}

- (void)requestDataByPostWithURLString:(NSString *)urlStr
                            postParams:(NSMutableDictionary *)params
                           contentType:(NSString *)contentType
                              delegate:(id<RYDownloaderDelegate>)receiver
                              purpose:(NSString *)purpose
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:@"POST"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSString *realString = nil;
    if([contentType rangeOfString:@"json"].length > 0)
    {
        if(params && params.allKeys.count != 0)
        {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
#if ! __has_feature(objc_arc)
            realString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
#else
            realString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
#endif
        }
        else
            realString = @"";
    }
    else
    {
        if(params && params.allKeys.count != 0)
        {
            NSMutableString *bodyString = [NSMutableString string];
            for(NSString *key in [params allKeys])
            {
                NSString *value = [NSString stringWithFormat:@"%@",[params objectForKey:key]];
                [bodyString appendFormat:@"%@=%@&",key,value];
            }
            realString = [bodyString substringToIndex:(bodyString.length-1)];
        }
        else
            realString = @"";
    }
    NSData *paramData = [realString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:paramData];
    
    [self requestDataWithURLRequest:request delegate:receiver purpose:purpose];
}

- (void)uploadFileByPostWithURLString:(NSString *)urlStr
                           postParams:(NSMutableDictionary *)params
                          contentType:(NSString *)contentType
                             fileData:(NSData *)data
                             fileType:(NSString *)fileType
                              fileKey:(NSString *)fileKey
                             fileName:(NSString *)fileName
                             delegate:(id<RYDownloaderDelegate>)receiver
                              purpose:(NSString *)purpose;
{
    //根据url初始化request
#if ! __has_feature(objc_arc)
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
#else
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
#endif
    [request setURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:@"POST"];

    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //分界线 --AaB03x
    NSString *MPboundary= [NSString stringWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[NSString stringWithFormat:@"%@--",MPboundary];
    //http body的字符串
    NSMutableString *body= [NSMutableString string];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[params objectForKey:key]];
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",fileKey,fileName];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: %@\r\n\r\n",fileType];
    
    //声明结束符：--AaB03x--
    NSString *end=[NSString stringWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[NSString stringWithFormat:@"%@; boundary=%@",contentType,TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%ld", (long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    
    [self requestDataWithURLRequest:request delegate:receiver purpose:purpose];
}

- (void)uploadFileByPutWithURLString:(NSString *)urlStr
                           putParams:(NSMutableDictionary *)params
                         contentType:(NSString *)contentType
                            fileData:(NSData *)data
                            fileName:(NSString *)fileName
                            delegate:(id<RYDownloaderDelegate>)receiver
                             purpose:(NSString *)purpose
{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:30.f];
    [request setHTTPMethod:@"PUT"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    for(NSString *key in [params allKeys])
    {
        NSString *value = [params objectForKey:key];
        [request setValue:value forHTTPHeaderField:key];
    }
	[request setValue:[NSString stringWithFormat:@"%llu", (unsigned long long)[data length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBodyStream:[NSInputStream inputStreamWithData:data]];
    
    [self requestDataWithURLRequest:request delegate:receiver purpose:purpose];
}

@end

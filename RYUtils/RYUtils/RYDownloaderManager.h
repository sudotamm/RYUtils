//
//  RYDownloaderManager.h
//  RYStudio
//
//  Created by Ryan on 13-4-17.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

/*
 文件改动日志
 v1.0 添加基本get,post/application/x-www-form-urlencoded方法
 v1.1 修改download在回调之后立刻可被reuse的bug
 v1.2 添加上传文件 post/multipart/form-data 方法
 v1.3 移除manager类与downloader类之间的依赖
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
    request的receiver和purpose不可以同时为nil，这样cancel的时候会cancel掉所有的downloader，而无法确定具体某一个
    当receiver != nil时，相同receiver下的purpose不可以相同，如果相同会cancel掉同一个receiver下前面的downloader
    当receiver == nil时，manager中的所有purpose不可以相同，如果相同会cancel掉所有的downloader
    pupose建议命名方式: receiver_purpose
                  如: homeViewContoller_getWeather, nil_getWeather
 */

@interface RYDownloaderManager : NSObject

#if ! __has_feature(objc_arc)
@property (nonatomic, retain) NSMutableArray *downloaders;
#else
@property (nonatomic, strong) NSMutableArray *downloaders;
#endif

+ (RYDownloaderManager *)sharedManager;

/**
	释放掉所有空闲的downloader
 */
- (void)removeUnuseDownloaders;

/**
	统一管理加入到manager中的所有downloader，有网络请求时显示，全部空闲则隐藏
 */
- (void)reloadNetworkActivityIndicator;

/**
	根据receiver和purpose取消队列中的downloader request，但downloader没有释放
    使用类似notification:name:object的管理方式
    当receiver=nil && purpose == nil，则取消所有downloader request
	@param receiver 取消delegate=receiver的所有downloader request
	@param purpose  取消purpose equal的所有downloader request
 */
- (void)cancelDownloaderWithDelegate:(id)receiver
                             purpose:(NSString *)purpose;

/**
	post方式与server交互
	@param urlStr 请求地址
	@param params 请求参数
	@param contentType 请求的Content-Type， 如application/x-www-form-urlencoded或application/json
	@param receiver 接受callback的对象
	@param purpose downloader的purpose
 */
- (void)requestDataByPostWithURLString:(NSString *)urlStr
                            postParams:(NSMutableDictionary *)params
                           contentType:(NSString *)contentType
                              delegate:(id)receiver
                               purpose:(NSString *)purpose;

/**
	get方式与server交互
	@param urlStr 请求地址
	@param receiver 接受callback的对象
	@param purpose downloader的purpose
 */
- (void)requestDataByGetWithURLString:(NSString *)urlStr
                             delegate:(id)receiver
                              purpose:(NSString *)purpose;

/**
	post文件上传
	@param urlStr 请求地址
	@param params 请求参数，text/plain
	@param contentType 请求content-Type，如multipart/form-data
	@param data 上传文件二进制流
	@param fileType 上传文件类型，如image/jpg
 	@param fileKey 上传文件对应的key - 服务端解析图片字段的key
	@param fileName 上传文件名称     - 服务端解析图片后的文件名
	@param receiver 接受callback的对象
	@param purpose downloader的purpose
 */
- (void)uploadFileByPostWithURLString:(NSString *)urlStr
                           postParams:(NSMutableDictionary *)params
                          contentType:(NSString *)contentType
                             fileData:(NSData *)data
                             fileType:(NSString *)fileType
                              fileKey:(NSString *)fileKey
                             fileName:(NSString *)fileName
                             delegate:(id)receiver
                              purpose:(NSString *)purpose;


/**
 put上传文件
 @param urlStr 请求地址
 @param params 请求参数
 @param contentType 请求content-Type,如text/plain%%image/jpeg%%audio/aac
 @param data 上传二进制流文件
 @param fileName 上传文件名
 @param receiver 接受callback的对象
 @param purpose downloader的purpose
 */
- (void)uploadFileByPutWithURLString:(NSString *)urlStr
                           putParams:(NSMutableDictionary *)params
                         contentType:(NSString *)contentType
                            fileData:(NSData *)data
                            fileName:(NSString *)fileName
                            delegate:(id)receiver
                             purpose:(NSString *)purpose;

@end

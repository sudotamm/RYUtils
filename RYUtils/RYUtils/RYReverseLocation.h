//
//  RYReverseLocation.h
//  SuZhouWeather
//
//  Created by Ryan on 13-8-9.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

/*
 Ryan创建的全局定位类来管理定位获取用户经纬度和具体解析地址
 使用block来管理异步回调，注意block使用过程中的内存管理
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^RYCompletionBlock)(CLLocation *location);
typedef void (^RYErrorBlock)(NSString *error);

typedef void (^ReverseCompletionBlock)(NSString *address);
typedef void (^ReverseErrorBlock)(NSString *error);

@interface RYReverseLocation : NSObject<CLLocationManagerDelegate>

#if ! __has_feature(objc_arc)
@property (nonatomic, retain) CLLocation *curLocation;          //保存定位成功之后的经纬度
#else
@property (nonatomic, strong) CLLocation *curLocation;          //保存定位成功之后的经纬度
#endif
@property (nonatomic, copy) NSString *address;                  //保存地址解析成功后的位置
//block 使用,简化回调
@property (nonatomic, copy) RYCompletionBlock completionBlock;                //定位成功后的回调
@property (nonatomic, copy) RYErrorBlock errorBlock;                          //定位失败后的回调

@property (nonatomic, copy) ReverseCompletionBlock reverseCompletionBlock;  //解析成功后的回调
@property (nonatomic, copy) ReverseErrorBlock reverseErrorBlock;            //解析失败后的回调

+ (RYReverseLocation *)sharedLocation;

/**
	更新用户的位置
	@param completion 定位成功之后返回用户的经纬度
	@param error 定位失败则返回失败信息
 */
- (void)updateLocationOnCompletion:(RYCompletionBlock)completion error:(RYErrorBlock)error;


/**
	解析经纬度到具体的地理位置
	@param location 需要解析的经纬度
	@param reverseCompletion 解析成功之后返回的地址
	@param reverseError 解析失败返回的消息
 */
- (void)reverseAddressFromLocation:(CLLocation *)location
                      onCompletion:(ReverseCompletionBlock)reverseCompletion
                           onError:(ReverseErrorBlock)reverseError;

@end

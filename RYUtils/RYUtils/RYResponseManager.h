//
//  RYResponseManager.h
//  PandaStock
//
//  Created by YuanRyan on 1/26/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

/**
 *    创建人：Ryan
 *    创建如期：2016-01-26
 *    用途：用于验证服务端返回数据的有效性
 */

#import <Foundation/Foundation.h>

#define kRYResponseCodeKey          @"error_code"
#define kRYResponseMessageKey       @"error_info"
#define kRYResponseBodyKey          @"infos"
#define kRYResponseSucceedValue     0

@interface RYResponseManager : NSObject

+ (instancetype)sharedManger;

/**
 *  判断服务端返回的数据是否有效
 *	@param responseDict 返回的二进制流数据转换成的dict
 
 *  @return yes-有效 no-无效
 */
+ (BOOL)isValidResponseWithDict:(NSDictionary *)responseDict;

/**
 *	服务端返回的数据对应的消息提示
 *	@param responseDict 返回的二进制流数据转换成的dict
 
 *  @return 返回对应的提示消息，可以为nil
 */
+ (NSString *)responseMessageWithDict:(NSDictionary *)responseDict;

/**
 *	服务端返回的数据的正文体
 *	@param responseDict 返回的二进制流数据转换成的dict
 
 *  @return 返回对应的正文体，可以为任意类型
 */
+ (id)responseBodyWithDict:(NSDictionary *)responseDict;

@end

//
//  UIDevice+RYUDID.h
//  RYUtils
//
//  Created by Ryan on 13-8-27.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (RYUDID)

/*
 * @method RYUDID
 添加最新ios7兼容支持-在ios7中返回的mac地址统一为空串
 如果是6.0之前，返回mac地址md5加密
 如果是6.0之后，返回IDFV
 */

- (NSString *)RYUDID;

@end

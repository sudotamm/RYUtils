//
//  RYBaseModel.h
//  RYUtils
//
//  Created by ryan on 12/12/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYBaseModel : NSObject

/**
 *  字典映射到BaseModel
 *
 *  @param dict 字典
 *
 *  @return 继承BaseModel的对象
 */
- (id)initWithRYDict:(NSDictionary *)dict;

/**
 *  将RYXMLReader解析出的xml字段映射到BaseModel对象
 *
 *  @param dict xml字典
 *
 *  @return 继承BaseModel的对象
 */
- (id)initWithRYXMLDict:(NSDictionary *)dict;

/**
 *  RYBaseModel转换成字典，只转换nil/String/Number/BaseModel四种类型数据
 *
 *  @return 返回对应的字典
 */
- (NSMutableDictionary *)toRYDict;

@end

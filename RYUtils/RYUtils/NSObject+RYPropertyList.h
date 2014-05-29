//
//  NSObject+RYPropertyList.h
//  RYUtils
//
//  Created by ryan on 5/29/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (RYPropertyList)
/**
 *  动态运行时获取当前类的所有属性值
 *
 *  @return 返回所有属性值对应的dictionary
 */
- (NSDictionary *)properties_aps;

/**
 *  log出当前类中所有的方法名称
 */
-(void)printMothList;

@end

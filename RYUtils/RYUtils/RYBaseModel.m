//
//  RYBaseModel.m
//  RYUtils
//
//  Created by ryan on 12/12/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import "RYBaseModel.h"
#import "RYXMLReader.h"

@implementation RYBaseModel

- (id)initWithRYDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        for(__strong NSString *key in [dict allKeys])
        {
            NSString *value = [dict objectForKey:key];
            if ([key isEqualToString:@"id"]) {
                key = @"idTemp";
            }
            if([value isKindOfClass:[NSNumber class]])
                value = [NSString stringWithFormat:@"%@",value];
            else if([value isKindOfClass:[NSNull class]])
                value = @"";
            @try {
                [self setValue:value forKey:key];
            }
            @catch (NSException *exception) {
                NSLog(@"试图添加不存在的key:%@到实例:%@中.",key,NSStringFromClass([self class]));
            }
        }
    }
    return self;
}

- (id)initWithRYXMLDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        for(__strong NSString *key in [dict allKeys])
        {
            if([key isEqualToString:kXMLReaderTextNodeKey])
                continue;
            NSDictionary *valueDict = [dict objectForKey:key];
            NSString *value = [valueDict objectForKey:kXMLReaderTextNodeKey];
            @try
            {
                [self setValue:value forKey:key];
            }
            @catch (NSException *exception) {
                NSLog(@"试图添加不存在的key:%@到实例:%@中.", key, NSStringFromClass([self class]));
            }
        }
    }
    return self;
}

@end

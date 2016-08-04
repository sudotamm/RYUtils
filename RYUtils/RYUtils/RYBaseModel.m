//
//  RYBaseModel.m
//  RYUtils
//
//  Created by ryan on 12/12/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import "RYBaseModel.h"
#import "RYXMLReader.h"
#import <objc/runtime.h>

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
            [self setValue:value forKey:key];
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

            [self setValue:value forKey:key];
        }
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"试图添加不存在的key:%@到实例:%@中.", key, NSStringFromClass([self class]));
}

- (NSMutableDictionary *)toRYDict
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        id finalValue;
        if(nil == propertyValue){
            finalValue = @"";
        }else if([propertyValue isKindOfClass:[NSNumber class]] || [propertyValue isKindOfClass:[NSString class]]){
            finalValue = [NSString stringWithFormat:@"%@", propertyValue];
        }else if([propertyValue isKindOfClass:[RYBaseModel class]]){
            RYBaseModel *bm = (RYBaseModel *)propertyValue;
            finalValue = [bm toRYDict];
        }else{
            continue;
        }
        [props setObject:finalValue forKey:propertyName];
    }
    free(properties);
    return props;
}
@end

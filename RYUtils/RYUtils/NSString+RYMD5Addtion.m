//
//  NSString+RYMD5Addtion.m
//  RYUtils
//
//  Created by Ryan on 13-8-27.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "NSString+RYMD5Addtion.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (RYMD5Addtion)

- (NSString *) stringFromMD5{
    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [outputString autorelease];
}


@end

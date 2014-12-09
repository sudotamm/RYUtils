//
//  RYXMLReader.m
//  p_yl_sz_ios
//
//  Created by Ryan on 13-10-31.
//  Copyright (c) 2013年 YuLong. All rights reserved.
//

#import "RYXMLReader.h"

NSString *const kXMLReaderTextNodeKey = @"text";

@interface RYXMLReader (Internal)

- (NSDictionary *)objectWithData:(NSData *)data;

@end

@implementation RYXMLReader

#pragma mark -
#pragma mark Public methods

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data
{
    RYXMLReader *reader = [[RYXMLReader alloc] init];
    NSDictionary *rootDictionary = [reader objectWithData:data];
#if ! __has_feature(objc_arc)
    [reader release];
#endif
    return rootDictionary;
}

+ (NSDictionary *)dictionaryForXMLString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [RYXMLReader dictionaryForXMLData:data];
}

#pragma mark -
#pragma mark Parsing
#if ! __has_feature(objc_arc)
- (void)dealloc
{
    [dictionaryStack release];
    [textInProgress release];
    [super dealloc];
}
#endif

- (NSDictionary *)objectWithData:(NSData *)data
{
    // Clear out any old data
#if ! __has_feature(objc_arc)
    [dictionaryStack release];
    [textInProgress release];
#endif
    dictionaryStack = [[NSMutableArray alloc] init];
    textInProgress = [[NSMutableString alloc] init];
    
    // Initialize the stack with a fresh dictionary
    [dictionaryStack addObject:[NSMutableDictionary dictionary]];
    
    // Parse the XML
#if ! __has_feature(objc_arc)
    NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:data] autorelease];
#else
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
#endif
    parser.delegate = self;
    BOOL success = [parser parse];
    
    // Return the stack’s root dictionary on success
    if (success)
    {
        NSDictionary *resultDict = [dictionaryStack objectAtIndex:0];
        return resultDict;
    }
    return nil;
}

#pragma mark -
#pragma mark NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // Get the dictionary for the current level in the stack
    NSMutableDictionary *parentDict = [dictionaryStack lastObject];
    
    // Create the child dictionary for the new element, and initilaize it with the attributes
    NSMutableDictionary *childDict = [NSMutableDictionary dictionary];
    [childDict addEntriesFromDictionary:attributeDict];
    
    // If there’s already an item for this key, it means we need to create an array
    id existingValue = [parentDict objectForKey:elementName];
    if (existingValue)
    {
        NSMutableArray *array = nil;
        if ([existingValue isKindOfClass:[NSMutableArray class]])
        {
            // The array exists, so use it
            array = (NSMutableArray *) existingValue;
        }
        else
        {
            // Create an array if it doesn’t exist
            array = [NSMutableArray array];
            [array addObject:existingValue];
            
            // Replace the child dictionary with an array of children dictionaries
            [parentDict setObject:array forKey:elementName];
        }
        
        // Add the new child dictionary to the array
        [array addObject:childDict];
    }
    else
    {
        // No existing value, so update the dictionary
        [parentDict setObject:childDict forKey:elementName];
    }
    
    // Update the stack
    [dictionaryStack addObject:childDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // Update the parent dict with text info
    NSMutableDictionary *dictInProgress = [dictionaryStack lastObject];
    
    // Set the text property
    if ([textInProgress length] > 0)
    {
        //给value string加入\n\t字符的过滤处理
        NSString *valueString = [textInProgress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        // Get rid of leading + trailing whitespace
        [dictInProgress setObject:valueString forKey:kXMLReaderTextNodeKey];
        
        // Reset the text
#if ! __has_feature(objc_arc)
        [textInProgress release];
#endif
        textInProgress = [[NSMutableString alloc] init];
    }
    
    // Pop the current dict
    [dictionaryStack removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // Build the text value
    [textInProgress appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    // Set the error pointer to the parser’s error object
    NSLog(@"RYXMLParser解析错误：%@",parseError);
}

@end
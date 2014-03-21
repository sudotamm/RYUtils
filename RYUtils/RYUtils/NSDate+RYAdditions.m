//
//  NSDate+RYAdditions.m
//  RYUtils
//
//  Created by Ryan Yuan on 6/9/11.
//  Copyright 2011 Ryan. All rights reserved.
//

#import "NSDate+RYAdditions.h"

@implementation NSDate(RYAdditions)
// convert string to date by given format
+ (NSDate *)dateFromStringByFormat:(NSString *)format string:(NSString *)string
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
	[dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    NSDate *date = [dateFormatter dateFromString:string];
    [dateFormatter release];
    return date;
}
// covert date to string by given format
+ (NSString *)dateToStringByFormat:(NSString *)format date:(NSDate *)date
{
     NSDateFormatter*dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
	[dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    NSString *str = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return str;
}

//get week day for current date
+ (NSString *)weekdataForDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    switch (component.weekday) {
        case 1:
            return @"星期日";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            break;
    }
    return @"";
}
@end

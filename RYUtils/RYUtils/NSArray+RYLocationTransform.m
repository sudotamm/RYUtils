//
//  NSArray+RYLocationTransform.m
//  WDZZ
//
//  Created by Ryan on 13-9-12.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "NSArray+RYLocationTransform.h"

@implementation NSArray (RYLocationTransform)

#pragma mark - 坐标系方法
// 火星坐标系 (GCJ-02)
// 百度坐标系 (BD-09)
// 地球坐标系 (WGS-84)
const double x_pi = M_PI * 3000.0 / 180.0;
+ (NSArray *)iOSMaptoBaidu:(double)gg_lat longitude:(double)gg_lon
{
    double x = gg_lon, y = gg_lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    
    double bd_lon = z * cos(theta) + 0.0065;
    double bd_lat = z * sin(theta) + 0.006;
    
    NSString *lat = [NSString stringWithFormat:@"%f", bd_lat];
    NSString *lon = [NSString stringWithFormat:@"%f", bd_lon];
    
    return [NSArray arrayWithObjects:lat, lon, nil];
}

+ (NSArray *)BaidutoiOSMap:(double)bd_lat longitude:(double)bd_lon
{
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    
    double gg_lon = z * cos(theta);
    double gg_lat = z * sin(theta);
    
    NSString *lat = [NSString stringWithFormat:@"%f", gg_lat];
    NSString *lon = [NSString stringWithFormat:@"%f", gg_lon];
    
    return [NSArray arrayWithObjects:lat, lon, nil];
}

+ (double)transformLat:(double)x andY:(double)y
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

+ (double)transformLon:(double)x andY:(double)y
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}
//
// Krasovsky 1940
//
// a = 6378245.0, 1/f = 298.3
// b = a * (1 - f)
// ee = (a^2 - b^2) / a^2;
const double a = 6378245.0;
const double ee = 0.00669342162296594323;

+ (NSArray *)WorldtoiOSMap:(double)wgLat longitude:(double)wgLon
{
    double dLat = [self transformLat:wgLon - 105.0 andY:wgLat - 35.0];
    double dLon = [self transformLon:wgLon - 105.0 andY:wgLat - 35.0];
    double radLat = wgLat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    
    double mgLat = wgLat + dLat;
    double mgLon = wgLon + dLon;
    
    NSString *lat = [NSString stringWithFormat:@"%f", mgLat];
    NSString *lon = [NSString stringWithFormat:@"%f", mgLon];
    return [NSArray arrayWithObjects:lat, lon, nil];
}

@end

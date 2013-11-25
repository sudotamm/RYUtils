//
//  NSArray+RYLocationTransform.h
//  WDZZ
//
//  Created by Ryan on 13-9-12.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 - 火星坐标系 (GCJ-02)
 - 百度坐标系 (BD-09)
 - 地球坐标系 (WGS-84) - 国际通用坐标系
 
 */

@interface NSArray (RYLocationTransform)

/**
	ios地图经纬度转百度地图经纬度
	@param gg_lat ios地图纬度
	@param gg_lon ios地图经度
	@returns 百度的经纬度array[纬度(lat),精度(lon)]
 */
+ (NSArray *)iOSMaptoBaidu:(double)gg_lat longitude:(double)gg_lon;

/**
	百度地图经纬度转ios地图经纬度
	@param bd_lat 百度地图纬度
	@param bd_lon 百度地图经度
	@returns ios地图的经纬度array[纬度(lat),经度(lon)]
 */
+ (NSArray *)BaidutoiOSMap:(double)bd_lat longitude:(double)bd_lon;

/**
	国际通用坐标转ios地图显示 - gps经纬度转火星坐标
	@param wgLat gps纬度
	@param wgLon gps经度
	@returns 火星坐标array[纬度(lat),经度(lon)]
 */
+ (NSArray *)WorldtoiOSMap:(double)wgLat longitude:(double)wgLon;


@end

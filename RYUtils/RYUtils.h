//
//  RYUtils.h
//  RYUtils
//
//  Created by Ryan on 13-4-15.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

/*
    必要的denpendencies
    UIView+RYUtilities - QuartzCore.framework
    RYMediaPicker      - AssetsLibrary.framework
    RYMediaPicker      - CoreLocation.framework
    UIDevice+RYUDID    - AdSupport.framework
    UIImage+RYBlurGlass   - Accelerate.framework
 版本管理：
 v1.0 
    - 添加基本常用库
 v1.1 
    - 添加RYDownloaderManager类，管理网络交互
 v1.2 
    - 移除管理类和实现之间的依赖，隐藏实现类细节
    - RYMediaPicker类移除5.0之前的支持,移除RYMediaPicker对Mapkit的依赖
 v1.3 
    - 添加地理位置定位和解析服务-RYReverseLocation
 v1.4
    - 添加md5函数的category - NSString+RYMD5Addtion
    - 添加UDID获取category  - UIDevice+RYUDID
 v1.5 
    - 添加私有动画api注释到UIView+RYUtilities中
 v1.6
    - 添加Downloader类到RYUtils中，方便外部使用对应类的delegate
 v1.7
    - 修改RYPullDownRefreshTableView类，移除类中UITableViewDatasource @required method warnings
 v1.8 2013-10-29 Ryan
    - 框架支持最低修改至6.0，移除对应过期方法使用的warning
 v1.8.1 2013-11-18 Ryan
    - 修改RYHUDManager进度加载占位显示方法
 v1.8.2 2013-11-18 Ryan
    - 修改RYHUDManager在custom模式下即时更新customView
 v1.9 2013-11-25
    - 添加截图函数的category - UIImage+RYScreenShot
    - 添加模糊函数的category - UIImage+RYBlurGlass
    - 添加经纬度转换的category - NSArray+RYLocationTransform
 v2.0 2013-12-19
    - 添加xml解析成NSDictionary的通用类 - RYXMLReader
    - 添加首尾滚动加载头条控件           - RYCycleScrollView
    - 添加通用方法存储类                - RYCommonMethods
 v2.1 2013-12-20
    - 加入遗漏的头文件引用
 v2.2 2013-12-24
    - RYXMLReader memory leak fix.
 v3.0 2013-12-27
    - RYDownloaderManager加入put上传文件方式
    - RYCommonMethods加入唯一识别码和base64加密方法
 v3.1 2014-1-3
    - RYDownloader加入responseCode/100 != 2则转入error处理
 v3.2 2014-1-15
    - UIDevice-RYUDID加入advertisingTrackingEnabled判断
 v3.3 2014-3-7
    - RYCommonMethods memory leak 处理
 v3.3.1 2014-3-18
    - RYAsynImageView: 修复reuse时如果本地图片已经存在没有取消之前回调的bug
 v3.3.2 2014-3-21
    - RYAsynImageView: 修复reuser时resize的frame不是基于初始frame的bug
 v3.4 2014-3-21
    - 移除旧版fake framework脚本
    - iOS-Universal-Framework制作地址：https://github.com/pub-burrito/iOS-Universal-Framework
 v3.5 2014-3-27
    - 添加UIImage+RYUtilities方法
 v3.6 2014-4-4
    - RYRootBlurViewManager类添加
    - NSDate+RYAdditions添加时间线获取方法
 */

#ifndef RYUtils_RYUtils_h
#define RYUtils_RYUtils_h

#import "RYHUDManager.h"
#import "NSDate+RYAdditions.h"
#import "UIView+RYUtilities.h"
#import "RYAsynImageView.h"
#import "RYAppBackgroundConfiger.h"
#import "RYDownloader.h"
#import "RYDownloaderManager.h"
#import "RYPullDownRefreshTableView.h"
#import "RYMediaPicker.h"
#import "RYReverseLocation.h"
#import "NSString+RYMD5Addtion.h"
#import "UIDevice+RYUDID.h" 
#import "NSArray+RYLocationTransform.h"
#import "UIImage+RYBlurGlass.h"
#import "UIImage+RYScreenShot.h"
#import "RYXMLReader.h"
#import "RYCommonMethods.h"
#import "RYCycleScrollView.h"
#import "UIImage+RYUtilities.h"
#import "RYRootBlurViewManager.h"

#endif

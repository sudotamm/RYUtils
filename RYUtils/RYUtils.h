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
 v3.6.1 2014-4-11
    - 替换RYUDID中IDFA为IDFV,移除ADFramework的依赖
    - Fix bug: 修复RYReverseLocation第一次使用定位是不会跳出定位提示的bug
 v3.6.2 2014-4-28
    - RYReverseLocation: 加入定位错误或解析错误提示
 v3.6.3 2014-5-14
    - 1. 修复RYHUD第一次indicator不显示的bug
    - 2. 加入RYHUD多行文本显示功能
 v3.6.4 2014-5-29
    - 加入NSObject+RYPropertyList category，动态获取类中所有属性及方法
 v3.6.5 2014-5-29
    - 修复RYHUD在展示nil或者空message时出现异常的bug
 v3.6.6 2014-6-15
    - 修复RYHUD第一次跟着alertview后面加载显示不出来的bug
 v3.6.7 2014-7-9
    - RYDownloaderManager requestDataByPostWithURLString方法加入json参数处理
 v3.6.8 2014-7-31
    - RYHUDManager 修正文本显示带"\n"字符不正常的bug
 v3.6.9 2014-8-4
    - RYCommonMethods 加入base64编码/解码的通用方法
 v3.7 2014-11-28
    - iOS8下定位依赖处理
 v3.7.7 2014-12-3
    - iOS8下设置应用使用是定位
 v3.7.8 2014-12-3
    - 移除64bit支持下整型转换的warning
    - 合并字符串md5加密方法至类RYCommonMethods中
 v3.7.9 2014-12-3
    - 移除64bit支持下得类型转换warning
 v3.8 2014-12-9
    - 移除自定义下拉刷新控件
 v3.9 2014-12-9
    - 加入自定义框架的arc/非arc的支持处理
 v3.9.1 2014-12-11
    - 移除计算字符串高度过期方法的使用
 v4.0 2014-12-12
    - 加入获取应用启动图/Icon的category
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
#import "RYMediaPicker.h"
#import "RYReverseLocation.h"
#import "UIDevice+RYUDID.h" 
#import "NSArray+RYLocationTransform.h"
#import "UIImage+RYBlurGlass.h"
#import "UIImage+RYScreenShot.h"
#import "RYXMLReader.h"
#import "RYCommonMethods.h"
#import "RYCycleScrollView.h"
#import "UIImage+RYUtilities.h"
#import "RYRootBlurViewManager.h"
#import "NSObject+RYPropertyList.h"
#import "UIImage+RYAssetLaunchImage.h"

#endif

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
 */

#ifndef RYUtils_RYUtils_h
#define RYUtils_RYUtils_h

#import "RYHUDManager.h"
#import "NSDate+RYAdditions.h"
#import "UIView+RYUtilities.h"
#import "RYAsynImageView.h"
#import "RYAppBackgroundConfiger.h"
#import "RYDownloaderManager.h"
#import "RYPullDownRefreshTableView.h"
#import "RYMediaPicker.h"
#import "RYReverseLocation.h"
#import "NSString+RYMD5Addtion.h"
#import "UIDevice+RYUDID.h" 

#endif
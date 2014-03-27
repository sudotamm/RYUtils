//
//  UIImage+RYUtilities.h
//  RYUtils
//
//  Created by ryan on 3/27/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RYUtilities)

/**
    将实际图片的尺寸等比缩小到提供的最大尺寸内，如果实际尺寸小于最大尺寸，返回实际尺寸
    @param maxSize 获取图片的最大尺寸
    @param actualSize 图片的实际尺寸
    @return 同比缩小的尺寸，如果图片的整体都小雨最大尺寸，返回图片实际尺寸，如果大于，则同比缩小
 */
+ (CGSize)equalScaleSizeForMaxSize:(CGSize)maxSize actualSize:(CGSize)actualSize;

/**
    同比缩小图片的size，如果不足targetSize，png填充，返回的图片大小: targetSize
    @param targetSize 目标尺寸
    @return targetSize大小的图片
 */
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;

/**
    截取图片部分
    @param rect 需要截取的目标区域
    @reture 返回目标区域的截图
 */
- (UIImage *)imageAtRect:(CGRect)rect;

/**
    该方法使用之前需要测试，未明确
 */
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;

/**
    非等比拉伸或缩小图片尺寸，实际返回大小: targetSize
    @param targetSize 目标尺寸
    @reture 返回非等比拉伸后的图片
 */
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

/**
    根据弧度旋转图片
    @param radians 需要旋转的弧度
    @return 返回旋转后的图片
 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

/**
 根据角度旋转图片
 @param radians 需要旋转的角度
 @return 返回旋转后的图片
 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end

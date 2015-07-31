//
//  RYCommonMethods.h
//  p_yl_sz_ios
//
//  Created by Ryan on 13-11-6.
//  Copyright (c) 2013年 YuLong. All rights reserved.
//

/*
    该类集中了一些通用的方法，这些方法不适合加入到category中，集中到该类中统一管理
    该类中的方法会不定期更新
 */

#import <Foundation/Foundation.h>

@interface RYCommonMethods : NSObject

/**
	该方法用于计算UITextView更新text之后的contentSize.height,ios7中contentSize.height的高度获取返回不准确
    解决方案：ios7 之前：contentSize.height
            ios7 之后：重新计算
 
	@param textView 更新text之后需要计算高度的textView
	@returns 返回兼容ios6,7的实际内容高度
 */
+ (CGFloat)measureHeightOfUITextView:(UITextView *)textView;

/**
 *  该方法用于计算文字在固定宽度下得动态高度，使用于iOS7.0及以上
 *
 *  @param text       需要计算的文字，如果为空，则高度返回0
 *  @param widthValue 固定宽度
 *  @param font       字体
 *
 *  @return 计算后的文字高度
 */
+ (CGFloat)measureHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;

/**
 *  该方法用于计算文字在固定高度下得动态宽度，使用于iOS7.0及以上
 *
 *  @param text       需要计算的文字，如果为空，则宽度返回0
 *  @param heightValue 固定高度
 *  @param font       字体
 *
 *  @return 计算后的文字宽度
 */
+ (CGFloat)measureWidthForText:(NSString *)text havingHeight:(CGFloat)heightValue andFont:(UIFont *)font;

/**
 获取唯一识别字符串
 @returns 唯一识别字符串
 */
+ (NSString *)generateUniqueString;

/**
 *  base64编码
 *  文字或图片转成二进制data之后进行base64编码，lineLength传0即可
 *  @param imgData    需要编码的数据流
 *  @param lineLength 传0即可
 *
 *  @return 编码后的base64字符串
 */
+ (NSString *) base64StringFromData:(NSData *)imgData length:(NSInteger)lineLength;
/**
 *  base64解码
 *  将base64字符串解码成二进制流
 *  @param string 需要解码的base64字符串
 *
 *  @return 解码后的二进制流
 */
+ (NSData *)dataFromBase64String:(NSString *)string;

/**
	字符串md5加密
	@returns 返回加密后的字符串
 */
+ (NSString *)md5String:(NSString *)baseString;

/**
 *  生成QRImage - 二维码图片 - 用AVFoundation就可以decode
 *
 *  @param qrString 需要生成的字符串（支持中英文）
 *
 *  @return 二维码图片
 */
+ (UIImage *)qrImageForString:(NSString *)qrString;

/**
 *  获取应用名称
 *
 *  @return 返回应用info.plist Bundle Display Name值
 */
+ (NSString *)appBundleDispalyName;

/**
 *  获取应用名称
 *
 *  @return 返回应用info.plist Bundle Version值
 */
+ (NSString *)appBundleVersion;
@end

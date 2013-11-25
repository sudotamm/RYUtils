//
//  UIImage+RYBlurGlass.h
//  iCityYangzhou
//
//  Created by Ryan on 13-9-4.
//  Copyright (c) 2013年 YuLong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RYBlurGlass)

/**
	创建类似ios7 中的毛玻璃底，同步创建模糊的底图
	@param image 需要变模糊的原图
	@param blur 模糊程度，最小0，最大1，超出这个范围默认使用 0.5
	@returns 模糊处理后的返回图片
 */
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;


/**
	创建类似ios7 中的毛玻璃底，异步创建模糊的底图
	@param originImage 需要变模糊的原图
	@param level 模糊程度，最小0，最大1，超出这个范围默认使用 0.5
 */
+ (void)blurOriginImage:(UIImage *)originImage
              blurLevel:(CGFloat)level
             completion:(void(^)(UIImage *image))completion;


@end

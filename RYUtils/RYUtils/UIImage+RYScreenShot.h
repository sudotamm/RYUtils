//
//  UIImage+RYScreenShot.h
//  SuZhouWeather
//
//  Created by Ryan on 13-3-12.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RYScreenShot)

/**
	按照传入的UIView的实际frame截图
	@param shotView 需要截图的view
	@returns 返回截图之后的image
 */
+ (UIImage *)screenShotForView:(UIView *)shotView;


/**
	按照传入的scrollView的实际contentSize截图
	@param scrollView 需要截图的scrollView
	@returns 返回截图之后的image
 */
+ (UIImage *) screenShotForScrollView:(UIScrollView *)scrollView;


@end

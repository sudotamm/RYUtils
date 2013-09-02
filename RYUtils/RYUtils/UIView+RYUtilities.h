//
//  UIView+RYUtilities.h
//  RYUtils
//
//  Created by Ryan on 12-8-3.
//  Copyright (c) 2012年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (RYUtilities)

#pragma mark - 不常用
//两侧外阴影
-(void)addGrayGradientShadow;
/**
	贝塞尔曲线
 */
-(void)addShadow;
-(void)addMovingShadow;
//内阴影
//Not test - This method may not work properly
- (void)addInnerShadow;

#pragma mark - 常用

/**
	view中加入CAAnimation
	@param type 动画类型- kCATransitionPush
	@param subtype 动画子类型 - kCATransitionFromTop
 */
- (void)addAnimationWithType:(NSString *)type subtype:(NSString *)subtype;

@end

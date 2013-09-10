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
 
 以下是基本的四种效果
 kCATransitionPush 推入效果
 kCATransitionMoveIn 移入效果
 kCATransitionReveal 截开效果
 kCATransitionFade 渐入渐出效果
 
 以下API效果可以安全使用
 cube 方块
 alignedCube
 rotate 旋转
 suckEffect 三角
 rippleEffect 水波抖动
 pageCurl 上翻页
 pageUnCurl 下翻页
 flip
 oglFlip 上下翻转
 alignedFlip
 cameraIris 镜头快门关闭再打开
 cameraIrisHollowOpen 镜头快门开
 cameraIrisHollowClose 镜头快门关
 
 
 以下API效果请慎用 - 暂时还没有效果
 spewEffect 新版面在屏幕下方中间位置被释放出来覆盖旧版面.
 genieEffect 旧版面在屏幕左下方或右下方被吸走, 显示出下面的新版面
 unGenieEffect 新版面在屏幕左下方或右下方被释放出来覆盖旧版面.
 twist 版面以水平方向像龙卷风式转出来.
 tubey 版面垂直附有弹性的转出来.
 swirl 旧版面360度旋转并淡出, 显示出新版面.
 charminUltra 旧版面淡出并显示新版面.
 zoomyIn 新版面由小放大走到前面, 旧版面放大由前面消失.
 zoomyOut 新版面屏幕外面缩放出现, 旧版面缩小消失.
 oglApplicationSuspend 像按”home” 按钮的效果.
 
*************************
 随机调用动画方法

 NSString *types[2] = {@"rotate", @"rotate"};
 transtion.type = types[random() % 2];
 
 NSString *subtypes[4] = {kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
 transtion.subtype = subtypes[random() % 4];
 
 */
- (void)addAnimationWithType:(NSString *)type subtype:(NSString *)subtype;

@end

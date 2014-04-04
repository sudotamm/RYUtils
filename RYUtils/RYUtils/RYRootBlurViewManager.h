//
//  RYRootBlurViewManager.h
//  iCityYangzhou
//
//  Created by Ryan on 13-9-4.
//  Copyright (c) 2013年 YuLong. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 该类用户控制keywindow最前面的view的显示
 
---------------模糊处理备注
 1.方法选用
 -使用UIImage+RYBlurGlass的模糊处理效果不是很理想，iphone4设备耗时约0.2秒（网络第三方开源方法）
 -使用UIImage+ImageEffects的模糊处理效果较好，iphone4设备耗时约0.35秒（苹果wwdc2013提供示例方法）
 
 2.耗时测试
 -使用截图方法在iphone4设备大约需要0.25秒
 -使用模糊处理方法在iphone4设备大约需要0.35秒
 合计0.6秒左右 - iphone4
 这样使得iphone4的效果会有明显的卡顿
 
 解决方案：
 一： 判断设备版本，iphone4s或以上使用截图及背景模糊处理
 二： 使用异步线程去处理截图及模糊处理方法，成功之后去设置底图（这样如果弹出动画小于0.6秒则会明显有底图延迟显示的感觉

 */

@interface RYRootBlurViewManager : UIView

+ (RYRootBlurViewManager *)sharedManger;

/**
    使用抖动动画居中覆盖显示于keywindow之上
	@param image 需要显示的view的底图（可加入模糊处理）
	@param contentView 需要显示的内容view
    @param position 需要显示的内容view的位置，如果值是CGPointZero时，会居中显示
	@returns nil
 */
- (void)showWithBlurImage:(UIImage *)image
              contentView:(UIView *)contentView
                 position:(CGPoint)position;

/**
	使用抖动动画隐藏keywindow之上的覆盖view
	@returns nil
 */
- (void)hideBlurView;

@end

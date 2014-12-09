//
//  RYHUDManager.h
//  RYUtils
//
//  Created by Ryan Yuan on 2/9/12.
//  Copyright (c) 2012 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
    该类用于管理开源HUD进度条展示
    将一个全局的hud加入到keyWindow中，所有的show/hide操作只是设置hud的alpha属性
    hud一直存在于keyWindow的subviews中
 注：显示hud的时候一定要保证hud在keywindow的最上层，否则可能会被keywindow的上层view挡住
    尤其是在view load的过程中显示hud，此时要注意当前view有没有被加入到keywindow中，调用hud显示的时候会
    将hud移到keywindow的最上层，如果view在hud移动之后再加入到keywindow中的话还是会背遮住！
 */

@class MBProgressHUD;

@interface RYHUDManager : NSObject

+ (RYHUDManager *)sharedManager;

#if ! __has_feature(objc_arc)
@property (nonatomic, retain) MBProgressHUD *hud;
#else
@property (nonatomic, strong) MBProgressHUD *hud;
#endif

/**
	图文混杂（图在上，文字在下）的方式展示hud，并设置隐藏时间
    该方式显示hud是不会覆盖window下面view的touch事件，hud.userTouchEnable = NO
    该方法使用时每次切换customView的时候都会重新load全局hud的indicator，以保证hud的indicator在custom模式下即时更新
	@param message hud中显示的文字
	@param customView hud中显示的图片，可以是ActivitiView(MBProgressHUDModeIndeterminate),也可以是自定义的图片(MBProgressHUDModeCustomView),当customView是nil的时候隐藏上面的图片展示
	@param delay hud隐藏时间
 */
- (void)showWithMessage:(NSString *)message customView:(UIView *)customView hideDelay:(CGFloat)delay;

/**
    用ActivityView显示hud，永不隐藏，需要调用stop方法隐藏
    该方式显示hud是会覆盖window下面view的touch事件，hud.userTouchEnable = YES
 */
- (void)startedNetWorkActivityWithText:(NSString *)text;
- (void)stoppedNetWorkActivity;

/**
	加入MBProgressHUDModeDeterminate和MBProgressHUDModeCustomView混合使用的hud
	@param message MBProgressHUDModeDeterminate模式显示的文字
	@param endMessage MBProgressHUDModeCustomView-结束显示的文字
	@returns nil
 */
- (void)showMixedWithLoading:(NSString *)message end:(NSString *)endMessage;


@end

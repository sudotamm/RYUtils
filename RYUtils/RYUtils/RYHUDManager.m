//
//  RYHUDManager.m
//  RYUtils
//
//  Created by Ryan Yuan on 2/9/12.
//  Copyright (c) 2012 Ryan. All rights reserved.
//

#import "RYHUDManager.h"
#import "MBProgressHUD.h"

@implementation RYHUDManager

@synthesize hud;

- (id)init
{
    if(self = [super init])
    {
        //hud加载在alertview之后会加入alertview的window中
        //        UIWindow *hudWindow = [UIApplication sharedApplication].keyWindow;
        //        if(![hudWindow isMemberOfClass:[UIWindow class]])
        //        {
        UIWindow *hudWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
        //        }
        
        hud = [[MBProgressHUD alloc] initWithWindow:hudWindow];
        [hudWindow addSubview:hud];
        hud.userInteractionEnabled = NO;
    }
    return self;
}

+ (RYHUDManager *)sharedManager
{
    static RYHUDManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RYHUDManager alloc] init];
    });
    return manager;
}

#if ! __has_feature(objc_arc)
- (void)dealloc
{
    [hud release];
    [super dealloc];
}
#endif

#pragma mark - Public methdos
- (void)showWithMessage:(NSString *)message customView:(UIView *)customView hideDelay:(CGFloat)delay
{
    if(nil == message || [message isEqualToString:@""])
    {
        NSLog(@"RYHUD显示空信息.");
        [hud hide:YES];
        return;
    }
    UIWindow *hudWindow = (UIWindow *)hud.superview;
    [hudWindow bringSubviewToFront:hud];
    hud.userInteractionEnabled = NO;
#if ! __has_feature(objc_arc)
    UIView *cv = [[[UIView alloc] init] autorelease];
#else
    UIView *cv = [[UIView alloc] init];
#endif
    cv.backgroundColor = [UIColor clearColor];
    if(!customView)
        hud.customView = cv;
    else
        hud.customView = customView;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = message;
    [NSObject cancelPreviousPerformRequestsWithTarget:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:delay];
}

- (void)startedNetWorkActivityWithText:(NSString *)text
{
    if(nil == text || [text isEqualToString:@""])
    {
        NSLog(@"RYHUD显示空信息.");
        [hud hide:YES];
        return;
    }
    UIWindow *hudWindow = (UIWindow *)hud.superview;
    [hudWindow bringSubviewToFront:hud];
    hud.userInteractionEnabled = YES;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
    [NSObject cancelPreviousPerformRequestsWithTarget:hud];
    [hud show:YES];
}

- (void)stoppedNetWorkActivity
{
    [hud hide:YES];
}

- (void)showMixedWithLoading:(NSString *)message end:(NSString *)endMessage
{
    if(nil == message || [message isEqualToString:@""])
    {
        NSLog(@"RYHUD-mixed显示空信息(startMessage).");
        [hud hide:YES];
        return;
    }
    if(nil == endMessage || [endMessage isEqualToString:@""])
    {
        NSLog(@"RYHUD-mixed显示空信息(endMessage).");
        [hud hide:YES];
        return;
    }
    UIWindow *hudWindow = (UIWindow *)hud.superview;
    [hudWindow bringSubviewToFront:hud];
    hud.userInteractionEnabled = YES;
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = message;
    [NSObject cancelPreviousPerformRequestsWithTarget:hud];
    [hud showWhileExecuting:@selector(myProgressTask:) onTarget:self withObject:endMessage animated:YES];
}

#pragma mark - Private methods

- (void)myProgressTask:(NSString *)endMessage {
    // This just increases the progress indicator in a loop
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        hud.progress = progress;
        usleep(10000);
    }
#if ! __has_feature(objc_arc)
    hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
#else
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
#endif
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = endMessage;
}
@end

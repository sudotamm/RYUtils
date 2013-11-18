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
        hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:hud];
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

- (void)dealloc
{
    [hud release];
    [super dealloc];
}

#pragma mark - Public methdos
- (void)showWithMessage:(NSString *)message customView:(UIView *)customView hideDelay:(CGFloat)delay
{
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:hud];
    hud.userInteractionEnabled = NO;
    UIView *cv = [[[UIView alloc] init] autorelease];
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
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:hud];
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
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:hud];
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
    hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    hud.labelText = endMessage;
    hud.mode = MBProgressHUDModeCustomView;
    usleep(500000);
}
@end

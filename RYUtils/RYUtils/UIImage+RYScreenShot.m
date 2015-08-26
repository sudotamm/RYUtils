//
//  UIImage+RYScreenShot.m
//  SuZhouWeather
//
//  Created by Ryan on 13-3-12.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "UIImage+RYScreenShot.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (RYScreenShot)

+ (UIImage *)screenShotForView:(UIView *)shotView
{
    UIGraphicsBeginImageContextWithOptions(shotView.frame.size, NO, [UIScreen mainScreen].scale);
    [shotView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *shareImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return shareImage;
}

+ (UIImage *) screenShotForScrollView:(UIScrollView *)scrollView
{
    if(scrollView.contentSize.height <= 0)
        return nil;
    
    UIImage* image = nil;
    
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, [UIScreen mainScreen].scale);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    return image;
}

@end

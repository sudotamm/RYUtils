//
//  RYAsynImageView.h
//  RYUtils
//
//  Created by Ryan Yuan on 4/18/12.
//  Copyright (c) 2012 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RYImageDownloader;

@interface RYAsynImageView : UIImageView
{
    RYImageDownloader *aysnLoader_;
}
#if ! __has_feature(objc_arc)
@property (nonatomic, retain) RYImageDownloader *aysnLoader;
#else
@property (nonatomic, strong) RYImageDownloader *aysnLoader;
#endif

/**
    加载后的图片是否根据ImageView的frame来缩放，默认为NO
    shouldResize  - 是否需要根据图片实际大小resize view
    originalFrame - resize view时所基于的view的frame，默认使用view初始化的frame
    注：1. shouldResize = NO时，无须关注originalFrame
       2. shouldResize = YES时，如果手动修改了frame，必须要将新的frame赋值给originalFrame
 */
@property (nonatomic, assign) BOOL shouldResize;
@property (nonatomic, assign) CGRect originalFrame;
//使用誉隆加密地址 - 使用时需要去掉aysnLoadImageWithUrl中ylAppmManager的注释
@property (nonatomic, assign) BOOL forYulong;
//占位图名称
@property (nonatomic, copy) NSString *placeholderName;

//网络下载图片的缓存目录,不设置则默认缓存到app documents目录下
@property (nonatomic, copy) NSString *cacheDir;

/**
	异步加载图片，加载过程中预加载placeholder图片
	@param url 异步加载图片地址
	@param placeHolder 图片加载过程中的默认图，placeholder不可为空
 */
- (void)aysnLoadImageWithUrl:(NSString *)url placeHolder:(NSString *)placeHolder;


@end

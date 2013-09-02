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
    BOOL shouldResize_;
}

@property (nonatomic, retain) RYImageDownloader *aysnLoader;
//加载后的图片是否根据ImageView的frame来缩放，默认为NO
@property (nonatomic, assign) BOOL shouldResize;
//
@property (nonatomic, assign) BOOL forYulong;
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

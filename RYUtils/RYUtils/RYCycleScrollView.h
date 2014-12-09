//
//  RYCycleScrollView.h
//  NOAHWM
//
//  Created by Ryan on 13-6-17.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RYCycleScrollViewDelegate;

@interface RYCycleScrollView : UIScrollView<UIScrollViewDelegate>

#if ! __has_feature(objc_arc)
@property (nonatomic, retain) NSMutableArray *cycleArray;
@property (nonatomic, assign) id<RYCycleScrollViewDelegate> cycleDelegate;
#else
@property (nonatomic, strong) NSMutableArray *cycleArray;
@property (nonatomic, weak) id<RYCycleScrollViewDelegate> cycleDelegate;
#endif

/**
	首尾相连滚动异步加载头条图
    注：没有采用reuse加载图片数量，所以需要保证图片总量不能产生memory warning
	@param images 需要加载的头条图http路径
	@param placeHolder 异步加载图片使用的占位显示图
	@param cacheDir 加载成功之后的缓存目录
	@returns nil
 */
- (void)reloadWithImages:(NSArray *)images
             placeHolder:(NSString *)placeHolder
                cacheDir:(NSString *)cacheDir;

@end

@protocol RYCycleScrollViewDelegate <UIScrollViewDelegate>

- (void)didCycleScrollViewTappedWithIndex:(NSInteger)index;

@end
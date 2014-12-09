//
//  RYCycleScrollView.m
//  NOAHWM
//
//  Created by Ryan on 13-6-17.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "RYCycleScrollView.h"
#import "RYAsynImageView.h"

@interface RYCycleScrollView()

@end

@implementation RYCycleScrollView

@synthesize cycleArray,cycleDelegate;

-(void)asyncImageViewTappedWithGesture:(UITapGestureRecognizer *)gesture
{
    RYAsynImageView *asynImgView = (RYAsynImageView *)(gesture.view);
    if(asynImgView.tag < 0 || asynImgView.tag >= self.cycleArray.count)
        return;
    if(asynImgView.tag == 0)
        [self.cycleDelegate didCycleScrollViewTappedWithIndex:(self.cycleArray.count-2)];
    else if(asynImgView.tag == self.cycleArray.count-1)
        [self.cycleDelegate didCycleScrollViewTappedWithIndex:0];
    else
        [self.cycleDelegate didCycleScrollViewTappedWithIndex:(asynImgView.tag-1)];
    
}

#pragma mark - Public methods
- (void)reloadWithImages:(NSArray *)images
             placeHolder:(NSString *)placeHolder
                cacheDir:(NSString *)cacheDir
{
    for(id v in self.subviews)
    {
        if([v isKindOfClass:[RYAsynImageView class]])
        {
            RYAsynImageView *asynImgView = (RYAsynImageView *)v;
            [asynImgView removeFromSuperview];
        }
    }
    self.cycleArray = [NSMutableArray arrayWithArray:images];
    if(images.count > 0)
    {
        [self.cycleArray insertObject:[images objectAtIndex:([images count]-1)] atIndex:0];
        [self.cycleArray addObject:[images objectAtIndex:0]];
        
        NSInteger index = 0;
        for(NSString *str in self.cycleArray)
        {
            //设置frame
            RYAsynImageView *asynImgView = [[RYAsynImageView alloc] init];
            CGRect rect = self.bounds;
            rect.size.width = self.frame.size.width;
            rect.origin.x = index*self.frame.size.width;
            asynImgView.frame = rect;
            //加载图片
            asynImgView.cacheDir = cacheDir;
//            asynImgView.forYulong = YES;
            [asynImgView aysnLoadImageWithUrl:str placeHolder:placeHolder];
            //加载手势
            asynImgView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(asyncImageViewTappedWithGesture:)];
            [asynImgView addGestureRecognizer:tapGesture];
            asynImgView.tag = index;
#if ! __has_feature(objc_arc)
            [tapGesture release];
#endif
            [self addSubview:asynImgView];
#if ! __has_feature(objc_arc)
            [asynImgView release];
#endif
            index++;
        }
        [self setContentSize:CGSizeMake(self.frame.size.width*self.cycleArray.count, self.frame.size.height)];
        [self setContentOffset:CGPointMake(self.frame.size.width, 0)];
    }
    else
    {
        [self setContentSize:CGSizeZero];
        [self setContentOffset:CGPointZero];
        NSLog(@"CycyleScrollView 的元素为0.");
    }
}

#pragma mark - UIView methods

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.pagingEnabled = YES;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.pagingEnabled = YES;
}

#if ! __has_feature(objc_arc)
- (void)dealloc
{
    [cycleArray release];
    [super dealloc];
}
#endif

@end

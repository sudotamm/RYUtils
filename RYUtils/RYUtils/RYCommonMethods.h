//
//  RYCommonMethods.h
//  p_yl_sz_ios
//
//  Created by Ryan on 13-11-6.
//  Copyright (c) 2013年 YuLong. All rights reserved.
//

/*
    该类集中了一些通用的方法，这些方法不适合加入到category中，集中到该类中统一管理
    该类中的方法会不定期更新
 */

#import <Foundation/Foundation.h>

@interface RYCommonMethods : NSObject

/**
	该方法用于计算UITextView更新text之后的contentSize.height,ios7中contentSize.height的高度获取返回不准确
    解决方案：ios7 之前：contentSize.height
            ios7 之后：重新计算
 
	@param textView 更新text之后需要计算高度的textView
	@returns 返回兼容ios6,7的实际内容高度
 */
+ (CGFloat)measureHeightOfUITextView:(UITextView *)textView;


@end

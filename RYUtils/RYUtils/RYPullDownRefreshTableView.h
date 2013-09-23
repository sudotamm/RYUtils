//
//  RYPullDownRefreshTableView.h
//  NOAHWM
//
//  Created by Ryan on 13-5-29.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

/**
 Ryan 基于EGORefreshTableHeaderView写的一个继承UIView的下拉刷新view，主view是tableview
 ios 6.0之前: 使用EGORefresh
 ios 6.0之后: 使用UITableViewController-refreshControl 新功能
 delegate   继续UITableViewDelegate, 添加触发下拉刷新的回调方法
 datasource UITableViewDataSource
 */

#import <UIKit/UIKit.h>

@class EGORefreshTableHeaderView;
@protocol RYPullDownRefreshTableViewDelegate;

@interface RYPullDownRefreshTableView : UIView<UITableViewDelegate>
{
    BOOL _reloading;
}

@property (nonatomic, retain) UITableView *refreshTableView;
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, retain) UITableViewController *refreshTableViewController;

@property (nonatomic, assign) IBOutlet id<RYPullDownRefreshTableViewDelegate> delegate;
@property (nonatomic, assign) IBOutlet id<UITableViewDataSource> datasource;

/**
	停止tableview的下拉刷新状态
 */
- (void)doneLoadingTableViewData;

/**
	手动（代码控制）下拉刷新，触发下拉delegate回调
 */
- (void)startManualLoading;

@end

@protocol RYPullDownRefreshTableViewDelegate <UITableViewDelegate>

- (void)didTriggerPullDownRefresh;

@end

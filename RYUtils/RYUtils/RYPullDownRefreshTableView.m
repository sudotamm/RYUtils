//
//  RYPullDownRefreshTableView.m
//  NOAHWM
//
//  Created by Ryan on 13-5-29.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "RYPullDownRefreshTableView.h"
#import "EGORefreshTableHeaderView.h"

@interface RYPullDownRefreshTableView()<EGORefreshTableHeaderDelegate>

@end

@implementation RYPullDownRefreshTableView

@synthesize refreshHeaderView,refreshTableView,refreshTableViewController;
@synthesize delegate,datasource;

#pragma mark - UIView methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self addSubview:self.refreshTableView];
    self.refreshTableView.frame = self.bounds;
    self.refreshTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}

- (void)dealloc
{
    [refreshTableViewController release];
    [refreshHeaderView release];
    [refreshTableView release];
    [super dealloc];
}

#pragma mark - iOS6.0 Refresh Control
- (void)refreshTrigger:(UIRefreshControl *)refreshControl
{
    if(refreshControl.isRefreshing)
    {
        refreshTableViewController.refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:@"加载中..."] autorelease];
        [self reloadTableViewDataSource];
    }
}

- (UITableViewController *)refreshTableViewController
{
    if(nil == refreshTableViewController)
    {
        refreshTableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        refreshTableViewController.refreshControl = [[[UIRefreshControl alloc] init] autorelease];
        refreshTableViewController.refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉开始刷新..."] autorelease];
//        refreshTableViewController.refreshControl.tintColor = kAppCommonColor;
        refreshTableViewController.tableView.frame = self.bounds;
        refreshTableViewController.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [refreshTableViewController.refreshControl addTarget:self action:@selector(refreshTrigger:) forControlEvents:UIControlEventValueChanged];
    }
    return refreshTableViewController;
}

#pragma mark - EGORefreshHeaderView methods
- (EGORefreshTableHeaderView *)refreshHeaderView
{
    if(nil == refreshHeaderView)
    {
        refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.refreshTableView.bounds.size.height, self.frame.size.width, self.refreshTableView.bounds.size.height)];
        refreshHeaderView.delegate = self;
        refreshHeaderView.backgroundColor = [UIColor clearColor];
    }
    return refreshHeaderView;
}

- (UITableView *)refreshTableView
{
    if(nil == refreshTableView)
    {
        if([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0)
        {
            refreshTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
            refreshTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [refreshTableView addSubview:self.refreshHeaderView];
            //  update the last update date
            [refreshHeaderView refreshLastUpdatedDate];
        }
        else
        {
            refreshTableView = [self.refreshTableViewController.tableView retain];
        }
        refreshTableView.delegate = self;
        refreshTableView.dataSource = self.datasource;
    }
    return refreshTableView;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
        return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
        return [self.delegate tableView:tableView heightForHeaderInSection:section];
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
        return [self.delegate tableView:tableView viewForHeaderInSection:section];
    return nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)])
        return [self.delegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)])
        return [self.delegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if([self.delegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath])
        return [self.delegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    else
        return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0)
        [refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0)
        [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0)
        _reloading = YES;
    if([self.delegate respondsToSelector:@selector(didTriggerPullDownRefresh)])
        [self.delegate didTriggerPullDownRefresh];
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0)
    {
        _reloading = NO;
        [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.refreshTableView];
    }
    else
    {
//        UIFont *font = [UIFont systemFontOfSize:10.f];
//        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
//                                                                    forKey:NSFontAttributeName];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy HH:mm"];
        NSString *lastUpdated = [NSString stringWithFormat:@"上次更新: %@", [formatter stringFromDate:[NSDate date]]];
        self.refreshTableViewController.refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:lastUpdated /*attributes:attrsDictionary*/] autorelease];
        [formatter release];
        
        [self.refreshTableViewController.refreshControl endRefreshing];
    }
	
}

- (void)startManualLoading
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0)
    {
        _reloading = YES;
        [refreshHeaderView egoRefreshScrollViewDataSourceStartManualLoading:self.refreshTableView];
    }
    else
    {
        [self.refreshTableViewController.refreshControl beginRefreshing];
        [self refreshTrigger:self.refreshTableViewController.refreshControl];
    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    //	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


@end

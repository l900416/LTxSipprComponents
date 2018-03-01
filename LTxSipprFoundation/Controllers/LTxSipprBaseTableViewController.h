//
//  LTxSipprBaseTableViewController.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/2/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTxSipprGifRefresh.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "LTxSipprConfig.h"
#import "LTxSipprCategories.h"
#import "LTxSipprPopup.h"

@interface LTxSipprBaseTableViewController : UITableViewController

#pragma mark - 画面提示
@property(nonatomic,strong) NSString* errorTips;

#pragma mark - ActivityView
-(void)showAnimatingActivityView;
-(void)showAnimatingActivityViewWithStyle:(UIActivityIndicatorViewStyle)style;
-(void)hideAnimatingActivityView;

#pragma mark - 刷新
//下拉刷新
-(void)addPullDownRefresh:(LTxSipprCallbackBlock)pullDownRefresh;
//上拉加载更多
-(void)addPullUpRefresh:(LTxSipprCallbackBlock)pullUpRefresh;
//下拉刷新，上拉加载更多
-(void)addPullDownRefresh:(LTxSipprCallbackBlock)pullDownRefresh
         andPullUpRefresh:(LTxSipprCallbackBlock)pullUpRefresh;
//停止刷新数据
-(void)finishSipprRefreshing;
@end

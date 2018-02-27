//
//  LTxSipprGifRefresh.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/2/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprGifRefresh.h"

#pragma mark - Header
@implementation LTxSipprRefreshHeader

- (void)prepare{
    [super prepare];
    
    //设置普通状态的动画图片
    [self setImages:[NSArray arrayWithObject:[UIImage imageNamed:@"table_refresh_pulling"]]
           forState:MJRefreshStateIdle];
    [self setImages:[NSArray arrayWithObject:[UIImage imageNamed:@"table_refresh_pulling"]]
           forState:MJRefreshStatePulling];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 1; i <= 33; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"table_refresh_loading_%d", i]];
        [refreshingImages addObject:image];
    }
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages
           duration:1.f
           forState:MJRefreshStateRefreshing];
}
@end

#pragma mark - Footer
@implementation LTxSipprRefreshFooter

- (void)prepare{
    [super prepare];
    
    [self setImages:[NSArray arrayWithObject:[UIImage imageNamed:@"table_refresh_pulling"]]
           forState:MJRefreshStateIdle];
    [self setImages:[NSArray arrayWithObject:[UIImage imageNamed:@"table_refresh_pulling"]]
           forState:MJRefreshStatePulling];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 1; i <= 33; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"table_refresh_loading_%d", i]];
        [refreshingImages addObject:image];
    }
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages
           duration:1.f
           forState:MJRefreshStateRefreshing];
    
    [self setTitle:@"————这是底线————" forState:MJRefreshStateNoMoreData];
}

@end
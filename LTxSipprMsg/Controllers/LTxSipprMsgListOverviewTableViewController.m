//
//  LTxSipprMsgListOverviewTableViewController.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/2/2.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprMsgListOverviewTableViewController.h"
#import "LTxSipprMsgTypeDetailTableViewCell.h"
#import "LTxSipprMsgViewModel.h"
@interface LTxSipprMsgListOverviewTableViewController ()

@property (nonatomic, strong) NSMutableArray* dataSource;

@end

static NSString* LTxSipprMsgTypeDetailTableViewCellIdentifier = @"LTxSipprMsgTypeDetailTableViewCellIdentifier";

@implementation LTxSipprMsgListOverviewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefaultConfig];
    
    [self showAnimatingActivityView];
    [self msgListFetch];
}

-(void)setupDefaultConfig{
    self.tableView.estimatedRowHeight = 60.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"LTxSipprMsgTypeDetailTableViewCell" bundle:nil] forCellReuseIdentifier:LTxSipprMsgTypeDetailTableViewCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak __typeof(self) weakSelf = self;
    [self addPullDownRefresh:^{
        [weakSelf msgListFetch];
    } andPullUpRefresh:^{
        [weakSelf msgListPullup];
    }];
}

-(void)msgListFetch{
    __weak __typeof(self) weakSelf = self;
    [LTxSipprMsgViewModel msgListFetchWithMsgType:_msgTypeCode currentPage:1 maxResult:[LTxSipprConfig sharedInstance].pageSize complete:^(NSArray *msgList, NSString *errorTips) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.dataSource = [msgList mutableCopy];
        strongSelf.errorTips = errorTips;
        [strongSelf finishSipprRefreshing];
        if ([msgList count] == [LTxSipprConfig sharedInstance].pageSize) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView.mj_footer resetNoMoreData];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            });
        }
    }];
}

-(void)msgListPullup{
    __weak __typeof(self) weakSelf = self;
    NSInteger currentPage = self.dataSource.count / [LTxSipprConfig sharedInstance].pageSize + 1;
    [LTxSipprMsgViewModel msgListFetchWithMsgType:_msgTypeCode currentPage:currentPage maxResult:[LTxSipprConfig sharedInstance].pageSize complete:^(NSArray *msgList, NSString *errorTips) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.errorTips = errorTips;
        if ([msgList count] > 0) {
            [strongSelf.dataSource addObjectsFromArray:msgList];
        }
        [strongSelf finishSipprRefreshing];
        if (msgList.count < [LTxSipprConfig sharedInstance].pageSize) {//禁用加载更多
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            });
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LTxSipprMsgTypeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LTxSipprMsgTypeDetailTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[LTxSipprMsgTypeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LTxSipprMsgTypeDetailTableViewCellIdentifier];
    }
    NSDictionary* msgTypeDic = [self.dataSource objectAtIndex:indexPath.row];
    cell.model = [LTxSipprMsgOverviewModel instanceWithDictionary:msgTypeDic];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSIndexPath *indexPath =  [self.tableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
//    NSLog(@"%td行，%td列 , 总行：%td",indexPath.section,indexPath.row,self.dataSource.count);
    if (indexPath.row >= (self.dataSource.count - 10)) {
        if ((self.dataSource.count < [LTxSipprConfig sharedInstance].pageSize || self.dataSource.count % [LTxSipprConfig sharedInstance].pageSize != 0 )) {
            return ;
        }else{
            if (!self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer beginRefreshing];
            }
        }
    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end

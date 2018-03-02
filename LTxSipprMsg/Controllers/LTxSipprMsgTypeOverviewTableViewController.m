//
//  LTxSipprMsgTypeOverviewTableViewController.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/2/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprMsgTypeOverviewTableViewController.h"
#import "LTxSipprMsgTypeTableViewCell.h"
#import "LTxSipprMsgViewModel.h"
#import "LTxSipprMsgListOverviewTableViewController.h"
@interface LTxSipprMsgTypeOverviewTableViewController ()

@property (nonatomic, strong) NSMutableArray* dataSource;

@end


static NSString* LTxSipprMsgTypeTableViewCellIdentifier = @"LTxSipprMsgTypeTableViewCellIdentifier";

@implementation LTxSipprMsgTypeOverviewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LTxSipprLocalizedStringWithKey(@"text_message_mine");
    
    [self setupDefaultConfig];
    
    [self showAnimatingActivityView];
    [self msgTypeListFetch];
}

-(void)setupDefaultConfig{
    self.tableView.estimatedRowHeight = 60.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"LTxSipprMsgTypeTableViewCell" bundle:nil] forCellReuseIdentifier:LTxSipprMsgTypeTableViewCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak __typeof(self) weakSelf = self;
    [self addPullDownRefresh:^{
        [weakSelf msgTypeListFetch];
    }];
}

-(void)msgTypeListFetch{
    __weak __typeof(self) weakSelf = self;
    [LTxSipprMsgViewModel msgTypeOverviewListFetchComplete:^(NSArray *msgTypeList, NSString *errorTips) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.dataSource = [msgTypeList mutableCopy];
        strongSelf.errorTips = errorTips;
        [strongSelf finishSipprRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LTxSipprMsgTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LTxSipprMsgTypeTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[LTxSipprMsgTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LTxSipprMsgTypeTableViewCellIdentifier];
    }
    NSDictionary* msgTypeDic = [self.dataSource objectAtIndex:indexPath.row];
    cell.model = [LTxSipprMsgTypeModel instanceWithDictionary:msgTypeDic];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    LTxSipprMsgTypeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    LTxSipprMsgTypeModel* model = cell.model;
    
    if (model.msgCount > 0) {//刷新本页数据
        NSMutableDictionary* msgTypeDic = [[self.dataSource objectAtIndex:indexPath.row] mutableCopy];
        [msgTypeDic setObject:@0 forKey:@"unHandledCount"];
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:msgTypeDic];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    }
    
    //跳转页面
    LTxSipprMsgListOverviewTableViewController* msgListVC = [[LTxSipprMsgListOverviewTableViewController alloc] init];
    msgListVC.title = model.msgTypeName;
    msgListVC.msgTypeCode = model.msgTypeId;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:msgListVC animated:true];
    });
}
@end

//
//  LTxSipprSetAboutHistoryTableViewController.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/2/28.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprSetAboutHistoryTableViewController.h"
#import "LTxSipprSetViewModel.h"
#import "LTxSipprSetAboutHistoryTableViewCell.h"

@interface LTxSipprSetAboutHistoryTableViewController ()

@property (nonatomic, strong) NSMutableArray* dataSource;

@end

static NSString* LTxSipprSetAboutHistoryTableViewCellIdentifier = @"LTxSipprSetAboutHistoryTableViewCellIdentifier";

@implementation LTxSipprSetAboutHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefaultConfig];
    
    [self showAnimatingActivityView];
    [self updateHistoryFetch];
}

-(void)setupDefaultConfig{
    
    self.title = LTxLocalizedString(@"text_setting_about_history");
    
    self.tableView.estimatedRowHeight = 60.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"LTxSipprSetAboutHistoryTableViewCell" bundle:SelfBundle] forCellReuseIdentifier:LTxSipprSetAboutHistoryTableViewCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak __typeof(self) weakSelf = self;
    [self addPullDownRefresh:^{
        [weakSelf updateHistoryFetch];
    }];
}

-(void)updateHistoryFetch{
    __weak __typeof(self) weakSelf = self;
    [LTxSipprSetViewModel appUpdateHistoryFetchComplete:^(NSArray *updateHistory, NSString *errorTips) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.dataSource = [updateHistory mutableCopy];
        strongSelf.errorTips = errorTips;
        [strongSelf finishSipprRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LTxSipprSetAboutHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LTxSipprSetAboutHistoryTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[LTxSipprSetAboutHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LTxSipprSetAboutHistoryTableViewCellIdentifier];
    }
    NSDictionary* updateDic = [self.dataSource objectAtIndex:indexPath.row];
    cell.model = [LTxSipprSetUpdateHistoryModel instanceWithDictionary:updateDic];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end

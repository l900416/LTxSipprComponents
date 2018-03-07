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

#import "LTQuickPreviewViewController.h"//网页等预览
#import "LTxSipprMsgAttachmentListPopup.h"//附件弹出框
@interface LTxSipprMsgListOverviewTableViewController ()

@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, strong) UIVisualEffectView * effectView;//附件展示时的毛玻璃特效
@property (nonatomic, strong) LTxSipprMsgAttachmentListPopup* popView;//附件列表弹出框

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
    [self.tableView registerNib:[UINib nibWithNibName:@"LTxSipprMsgTypeDetailTableViewCell" bundle:SelfBundle] forCellReuseIdentifier:LTxSipprMsgTypeDetailTableViewCellIdentifier];
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
    NSDictionary* msgDic = [self.dataSource objectAtIndex:indexPath.row];
    cell.model = [LTxSipprMsgOverviewModel instanceWithDictionary:msgDic];
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
    
    NSDictionary* msgDic = [self.dataSource objectAtIndex:indexPath.row];
    [self ltxHandleMessage:msgDic];
}

-(void)ltxHandleMessage:(NSDictionary*)msgDic{
    
    //先判断消息是否是通用消息，如果是通用类型，则直接处理，否则发送全局通知供其他处理
    
    NSString* msgTypeCode = [msgDic objectForKey:@"msgTypeCode"];
    if ([msgTypeCode isEqualToString:@"announcement"] || [msgTypeCode isEqualToString:@"notification"] || [msgTypeCode isEqualToString:@"systemNotification"]) {//公告、通知、系统提醒
        int extraFileCount = [[msgDic objectForKey:@"extraFileCount"] intValue];//附件数量
        if (extraFileCount == 0) {//没有附件
            return;
        }
        if ([msgTypeCode isEqualToString:@"systemNotification"]) {//系统提醒，打开网页
            NSString* urlString = [msgDic objectForKey:@"linkUrl"];
            //预览网页
            LTQuickPreviewViewController* webPreview = [LTQuickPreviewViewController instanceWithURL:[NSURL URLWithString:urlString]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:webPreview animated:true];
            });
        }else{//公告、通知，打开附件列表
            NSString* rowGuid = [msgDic objectForKey:@"rowGuid"];
            //根据业务编码，获取消息详情（附件列表）,弹框展示列表，供用户选择查看
            /*父级节目使用 UIBlurEffect 毛玻璃特效类型
             *  UIBlurEffectStyleExtraLight,
             *  UIBlurEffectStyleLight,
             *  UIBlurEffectStyleDark
             */
            __weak __typeof(self) weakSelf = self;
            [self showAnimatingActivityView];
            [LTxSipprMsgViewModel msgDetailWithMsgRowGuid:rowGuid complete:^(NSDictionary *msgDic, NSString *errorTips) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf hideAnimatingActivityView];
                strongSelf.errorTips = errorTips;
                if (!errorTips) {
                    NSArray* fileList = [msgDic objectForKey:@"files"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strongSelf showMsgAttachmentList:fileList];
                    });
                }
            }];
        }
    }else{
        NSNotification *notification = [NSNotification notificationWithName:LTX_NOTIFICATION_MSG_DID_SELECT_KEY object:msgDic];
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
    }
}

#pragma mark - 附件列表

-(void)showMsgAttachmentList:(NSArray*)attachmentList{
    if ([attachmentList count] == 0) {//无附件时，不展示弹出框
        return;
    }
    if (_effectView) {
        [_effectView removeFromSuperview];
    }
    if (_popView) {
        [_popView removeFromSuperview];
    }
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _effectView.alpha = 0.5;
    _effectView.frame =self.navigationController.view.bounds;
    [_effectView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMsgAttachmentListView)]];
    [self.view addSubview:_effectView];
    
    //此处将附件框添加到view中
    NSArray *nibContents = [[NSBundle bundleForClass:self.class] loadNibNamed:@"LTxSipprMsgAttachmentListPopup" owner:nil options:nil];
    _popView = [nibContents lastObject];
    
    [_popView setupWithFileList:attachmentList];
    __weak __typeof(self) weakSelf = self;
    _popView.closeAction = ^{
        [weakSelf hideMsgAttachmentListView];
    };
    _popView.filePreviewBlock = ^(NSDictionary * fileItem) {
        //跳转页面，预览附件即可
        NSString* fileUrl = [fileItem objectForKey:@"fileUrl"];
        LTQuickPreviewViewController* webPreview = [LTQuickPreviewViewController instanceWithURL:[NSURL URLWithString:fileUrl]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController pushViewController:webPreview animated:true];
        });
    };
    
    [self.view addSubview:_popView];
    CGPoint center = self.navigationController.view.center;
    _popView.frame = CGRectMake(center.x - 140, center.y - 200, 280, 320);
    _popView.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        _popView.alpha = 1;
    }completion:^(BOOL finished) {
        self.tableView.scrollEnabled = NO;
    }];
}


- (void)hideMsgAttachmentListView{
    [UIView animateWithDuration:0.4 animations:^{
        _popView.alpha = 0;
    }completion:^(BOOL finished) {
        [_popView removeFromSuperview];
        [_effectView removeFromSuperview];
        self.tableView.scrollEnabled = YES;
    }];
    
}

@end

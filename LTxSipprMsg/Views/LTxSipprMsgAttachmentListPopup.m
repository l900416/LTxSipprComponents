//
//  LTxSipprMsgAttachmentListPopup.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/2/26.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprMsgAttachmentListPopup.h"

@interface LTxSipprMsgAttachmentListPopup()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray* fileList;

@end

@implementation LTxSipprMsgAttachmentListPopup

-(void)setupWithFileList:(NSArray*)fileList{
    [self setup];
    _fileList = fileList;
}

-(void)setup{
    self.layer.cornerRadius = 8.f;
    self.clipsToBounds = YES;
    
    NSBundle* selfBundle = [NSBundle bundleForClass:self.class];
    
    [self.closeBtn setImage:[UIImage imageWithContentsOfFile: [selfBundle pathForResource:@"LTxComponentsForSippr.bundle/Images/ic_msg_extra_attachment_close" ofType:@"png"]] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(void)closeBtnPressed:(UIButton*)btn{
    if (_closeAction) {
        _closeAction();
    }
}

#pragma mark -- UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_filePreviewBlock) {
        NSDictionary* fillItem = [_fileList objectAtIndex:indexPath.row];
        _filePreviewBlock(fillItem);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_fileList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"LTxSipprMsgAttachmentListPopupCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary* cellItem =  [_fileList objectAtIndex:indexPath.row];
    cell.textLabel.text = [cellItem objectForKey:@"title"];
    return cell;
}
@end

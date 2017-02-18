//
//  LeaveMessageListCtl.m
//  jobClient
//
//  Created by 一览ios on 14/12/8.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//留言联系人列表

#import "LeaveMessageListCtl.h"
#import "MessageContact_DataModel.h"
#import "LeaveMessageList_Cell.h"
#import "MessageDailogListCtl.h"
#import "MessageListCell.h"
#import "MessageDelTipsCtl.h"
#import "ELNewNewsListVO.h"

@interface LeaveMessageListCtl ()<UIGestureRecognizerDelegate>
{
    BOOL shouldRefresh_;
    RequestCon *_deleteMsgCon;
}
@end

@implementation LeaveMessageListCtl

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"私信";
    [self setNavTitle:@"私信"];
    bFooterEgo_ = YES;
    bHeaderEgo_ = YES;
//    [tableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    validateSeconds_ = 600;
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tableViewPan:)];
//    panGesture.delegate = self;
//    [tableView_ addGestureRecognizer: panGesture];
    
    tableView_.separatorInset = UIEdgeInsetsZero;
    if (IOS8) {
        tableView_.layoutMargins = UIEdgeInsetsZero;
    }
    
    UIView *view = [[UIView alloc]init];
    tableView_.tableFooterView = view;
}

- (void)viewDidLayoutSubviews
{
    [self.view layoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//-----------数据请求与刷新－－－－－－－－－－


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ((requestCon_ && [Manager shareMgr].isFromMessage_)||[requestCon_.dataArr_ count] == 0 || shouldRefresh_) {
        [self refreshLoad:nil];
        [Manager shareMgr].isFromMessage_ = NO;
    }
//    self.navigationItem.title = @"私信";
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_  egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        shouldRefresh_ = YES;
    }
    
}


-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}


- (void)receiveNewMessage:(NSNotification *)info
{
    NSDictionary *markDic = info.object;
    if (markDic != nil) {
        [self refreshLoad:nil];
    }
}

-(void)getDataFunction:(RequestCon *)con
{
    //int temp = [Manager shareMgr].isFromMessage_;
    if (!con) {
        con = [self getNewRequestCon:YES];
    }
    NSString *myId = [Manager getUserInfo].userId_;
    if (!myId) {
        [BaseUIViewController showAutoDismissFailView:@"登录后才能查看留言" msg:nil seconds:2.0];
        return;
    }
    [con getContactListWithUserId:myId pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:10];
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    
    if (con == requestCon_) {
        
    }
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetContactList:
        {
            shouldRefresh_ = NO;
        }
            break;
         case Request_DeletePersonAllMsg:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            [BaseUIViewController showAutoDismissSucessView:@"" msg:dataModal.des_];
            if( [dataModal.status_ isEqualToString:Success_Status] ){//发送留言成功
                [tableView_ reloadData];
            }
        }
        default:
            break;
    }
}

#pragma mark 选择行
-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    MessageContact_DataModel * dataModal = selectData;
    //是新消息点击后需要对redcount做处理
    if ([dataModal.isNew isEqualToString:@"1"]) {
        /*
        [Manager shareMgr].messageCountDataModal.messageCnt = [Manager shareMgr].messageCountDataModal.messageCnt - 1;
        if ([Manager shareMgr].messageCountDataModal.messageCnt < 0) {
            [Manager shareMgr].messageCountDataModal.messageCnt = 0;
        }
        [[Manager shareMgr].tabView_ setTabBarNewMessage];
         */
        if (self._redCountBlock) {
            self._redCountBlock();
        }
    }
    dataModal.isNew = @"0";
    [tableView_ reloadData];
    
    MessageDailogListCtl *ctl = [[MessageDailogListCtl alloc]init];
    //    [Manager shareMgr].messageDailogListCtl = ctl;
    ctl.isHr = NO;
    ctl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctl animated:YES];
    [ctl beginLoad:selectData exParam:nil];
  

}


//---------------datasource--------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return requestCon_.dataArr_.count;
}
 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentify = @"Cell";
    @try {
        MessageContact_DataModel *contact = requestCon_.dataArr_[indexPath.row];
        LeaveMessageList_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LeaveMessageList_Cell" owner:self options:nil] lastObject];
            [cell setAttr];
//            UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(cellLeftSwipe:)];
//            gesture.direction = UISwipeGestureRecognizerDirectionLeft;
//            gesture.delegate = self;
//            [cell addGestureRecognizer:gesture];
//            UISwipeGestureRecognizer *rightGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(cellLeftSwipe:)];
//            rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
//            rightGesture.delegate = self;
//            [cell addGestureRecognizer:rightGesture];
            
           // [cell.hideUserBtn addTarget:self action:@selector(hideUserBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
//        cell.separatorInset = UIEdgeInsetsZero;
//        if (IOS8) {
//            cell.layoutMargins = UIEdgeInsetsZero;
//        }
//        cell.hideUserBtn.tag = indexPath.row;
//        cell.delBtn.tag = indexPath.row;
//        cell.tag = indexPath.row;
        
        [self setMessageContact:contact cell:cell];
        return cell;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)setMessageContact:(MessageContact_DataModel *)contact cell:(LeaveMessageList_Cell *)cell
{
    [cell.picImg sd_setImageWithURL:[NSURL URLWithString:contact.pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    cell.picImg.frame = CGRectMake(10, 13, 40, 40);
    cell.numRedIcon.hidden = YES;
    CGRect frame = cell.userName.frame;
    
    if (![contact.isExpert isEqualToString:@"1"]) {
        cell.isExpertImg.hidden = YES;
        cell.userNameLeftToImg.constant = 8;
    }else{
        cell.isExpertImg.hidden = NO;
        cell.userNameLeftToImg.constant = 25;
    }
    cell.userName.frame = frame;
    cell.userName.font = FOURTEENFONT_CONTENT;
    cell.userName.text = contact.userIname;
    
    CGSize size = CGSizeZero;
    
    size = [contact.userIname sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FOURTEENFONT_CONTENT,NSFontAttributeName, nil]];
    
    CGRect rect = cell.userName.frame;
    rect.size.width = size.width;
    [cell.userName setFrame:rect];
    [cell.userName sizeToFit];
    //需要判断一下是否是Hr  gw
    if (contact.boolGWFlag) {
        CGRect hrMarkImageRect = cell.hrMarkImagev.frame;
        hrMarkImageRect.origin.x = rect.size.width + rect.origin.x + 2;
        [cell.hrMarkImagev setFrame:hrMarkImageRect];
        cell.hrMarkImagev.layer.cornerRadius = 2.0;
        cell.hrMarkImagev.layer.masksToBounds = YES;
        [cell.hrMarkImagev setHidden:NO];
        [cell.hrMarkImagev setText:@"顾问"];
    } else if (contact.boolHrFlag){
        cell.hrMarkImagev.layer.cornerRadius = 2.0;
        cell.hrMarkImagev.layer.masksToBounds = YES;
        CGRect hrMarkImageRect = cell.hrMarkImagev.frame;
        hrMarkImageRect.origin.x = rect.size.width + rect.origin.x + 2;
        [cell.hrMarkImagev setFrame:hrMarkImageRect];
        [cell.hrMarkImagev setHidden:NO];
        [cell.hrMarkImagev setText:@"企业"];
    }else{
        [cell.hrMarkImagev setHidden:YES];
    }
    
    
    cell.dateTime.font = TWEELVEFONT_COMMENT;
    cell.dateTime.text = [contact.lastDateTime substringWithRange:NSMakeRange(5,11)];
    UIView *view = [cell.contentView viewWithTag:222];
    if (view) {
        [view removeFromSuperview];
        
    }
    NSString *tempStr = [[contact.message componentsSeparatedByString:@"#"] firstObject];
    if ([tempStr hasPrefix:@"http://"] && [tempStr hasSuffix:@".aac"]) {
        tempStr = @"[语音消息]";
    }else{
        tempStr = contact.message;
    }
    MLEmojiLabel *emojiLabel = [self emojiLabel:tempStr numberOfLines:1 textColor:[UIColor colorWithRed:160.0/255 green:160.0/255 blue:160.0/255 alpha:1.0]];
    emojiLabel.frame = CGRectMake(0, 0, 238, 0);
    [emojiLabel sizeToFit];
    emojiLabel.frame = CGRectMake(65,34,238,emojiLabel.frame.size.height+4);
    emojiLabel.tag = 222;
    [cell.contentView addSubview: emojiLabel];
    cell.msgLb.hidden = YES;
}

- (MLEmojiLabel *)emojiLabel:(NSString *)text numberOfLines:(int)num textColor:(UIColor *)color
{
    MLEmojiLabel * emojiLabel;
    emojiLabel = [[MLEmojiLabel alloc]init];
    emojiLabel.numberOfLines = num;
    emojiLabel.font = TWEELVEFONT_COMMENT;
    emojiLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    if (color) {
        emojiLabel.textColor = color;
    }
    emojiLabel.backgroundColor = [UIColor clearColor];
    emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    emojiLabel.isNeedAtAndPoundSign = YES;
    emojiLabel.customEmojiRegex = Custom_Emoji_Regex;
    emojiLabel.customEmojiPlistName = @"emoticons.plist";
    [emojiLabel setEmojiText:text];
    return emojiLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [requestCon_.dataArr_ removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)reloadTableView
{
    [tableView_ reloadData];
}

#if 0
#pragma mark 屏蔽此人或者取消屏蔽
- (void)hideUserBtnClick:(UIButton *)sender
{
    MessageDelTipsCtl *msgDelTipsCtl = [[MessageDelTipsCtl alloc]init];
    msgDelTipsCtl.row = sender.tag;
    msgDelTipsCtl.msgTipsType = MsgTipsTypeHideUser;
    //    __weak typeof(LeaveMessageListCtl) *weakSelf = self;
    msgDelTipsCtl.delMessageBlock = ^(NSInteger row){
        //        NSLog(@"%ld", row);
    };
    msgDelTipsCtl.view.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:msgDelTipsCtl.view];
    _tipsCtl = msgDelTipsCtl;
}

#pragma mark 删除此人
- (void)delBtnClick:(UIButton *)sender
{
    NSInteger index = sender.tag;
    MessageContact_DataModel *contact;
    if (index < requestCon_.dataArr_.count) {
        contact  = requestCon_.dataArr_[index];
        [requestCon_.dataArr_ removeObjectAtIndex:index ];
    }
    
    if (!_deleteMsgCon) {
        _deleteMsgCon = [self getNewRequestCon:NO];
    }
    NSString *myId = [Manager getUserInfo].userId_;
    NSString *anotherId = contact.userId;
    [_deleteMsgCon deletePersonAllMsg:myId fromId:anotherId];
}

#pragma mark 左右滑动
- (void)cellLeftSwipe:(UISwipeGestureRecognizer *)sender
{
    LeaveMessageList_Cell *cell = (LeaveMessageList_Cell *)sender.view;
    
    NSInteger index = cell.tag;
    MessageContact_DataModel *contact;
    if (index < requestCon_.dataArr_.count) {
        contact = requestCon_.dataArr_[index];
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (!cell.inEditing) {
            return;
        }
        cell.inEditing = NO;
        _selectCell = nil;
        contact.inEditing = NO;
        [self layoutTableviewCell:cell inEditing:NO animation:YES];
    }else if (sender.direction == UISwipeGestureRecognizerDirectionLeft){
        if (cell.inEditing) {
            return;
        }
        tableView_.scrollEnabled = NO;
        UIView *view = [[UIView alloc]initWithFrame:tableView_.frame];
        view.tag = cell.delBtn.tag;
        view.backgroundColor = [UIColor clearColor];
        _maskView = view;
        view.userInteractionEnabled = YES;
        [self.view addSubview:view];
        [_maskView addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewPan:)]];
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewTap:)]];
        
        cell.inEditing = YES;
        _selectCell = cell;
        contact.inEditing = YES;
        [self layoutTableviewCell:cell inEditing:YES animation:YES];
    }
}

- (void)maskViewPan:(UIPanGestureRecognizer *)sender
{
    [_maskView removeFromSuperview];
    tableView_.scrollEnabled = YES;
    _selectCell.inEditing = NO;
    [self layoutTableviewCell:_selectCell inEditing:NO animation:YES];
    _selectCell = nil;
}

- (void)maskViewTap:(UIGestureRecognizer *)sender
{
    _selectCell.inEditing = NO;
    tableView_.scrollEnabled = YES;
    CGRect delBtnRect = [_selectCell.delBtn convertRect:_selectCell.delBtn.bounds toView:tableView_];
    delBtnRect.origin.y = delBtnRect.origin.y- tableView_.contentOffset.y;
    CGPoint touchPoint = [sender locationInView:_maskView];
    if (touchPoint.x>delBtnRect.origin.x && touchPoint.x<CGRectGetMaxX(delBtnRect) && touchPoint.y>delBtnRect.origin.y && touchPoint.y<CGRectGetMaxY(delBtnRect)) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = sender.view.tag;
        [self delBtnClick:btn];
    }
    [self layoutTableviewCell:_selectCell inEditing:NO animation:YES];
    [_maskView removeFromSuperview];
    _selectCell = nil;
}


- (void)layoutTableviewCell:(LeaveMessageList_Cell *)cell inEditing:(BOOL)inEditing animation:(BOOL)animation
{
    cell.inEditing = inEditing;
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            if (inEditing) {
                for (UIView *view in cell.contentView.subviews) {
                    CGRect frame = view.frame;
                    frame.origin.x -= 70;
                    view.frame = frame;
                }
            }else{
                
                for (UIView *view in cell.contentView.subviews) {
                    CGRect frame = view.frame;
                    frame.origin.x += 70;
                    view.frame = frame;
                }
            }
        }];
    }else{
        if (inEditing) {
            for (UIView *view in cell.contentView.subviews) {
                CGRect frame = view.frame;
                frame.origin.x -= 70;
                view.frame = frame;
            }
        }else{
            for (UIView *view in cell.contentView.subviews) {
                CGRect frame = view.frame;
                frame.origin.x += 70;
                view.frame = frame;
            }
        }
        
    }
}
#endif

@end

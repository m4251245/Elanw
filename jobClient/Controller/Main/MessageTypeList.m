//
//  MessageTypeList.m
//  jobClient
//
//  Created by 一览ios on 15/4/23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MessageTypeList.h"
#import "MessageListCell.h"
#import "MessageTypeListDataModel.h"
#import "MessageCenterDataModel.h"
#import "NewPublishCtl.h"
#import "YLWhoLikeMeListCtl.h"
#import "ELInterViewListCtl.h"
#import "ELMyRewardRecordListCtl.h"
#import "ELOfferPartyMessageCtl.h"
#import "ELOAWebCtl.h"

@interface MessageTypeList ()
{
    NSMutableArray    *dataArray;
    NSInteger   messageCnt;
    NSInteger   leaveCnt;
    NSInteger   phoneCnt;
    BOOL shouldRefresh_;
    RequestCon  *oaCon;
}

@end

@implementation MessageTypeList

#pragma mark - LifeCycle
- (void)dealloc
{
    NSLog(@"%s",__func__);
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"通知"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    validateSeconds_ = 600;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ((requestCon_ && [Manager shareMgr].isFromMessage_)||[requestCon_.dataArr_ count] == 0 || shouldRefresh_) {
        [self refreshLoad:nil];
        [Manager shareMgr].isFromMessage_ = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_  egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        shouldRefresh_ = YES;
    }
}

#pragma mark - NetWork
- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

- (void)getDataFunction:(RequestCon *)con
{
    NSString *userId = [Manager getUserInfo].userId_;
    if (userId == nil) {
        userId = @"";
    }
    if (!con) {
        con = [self getNewRequestCon:YES];
    }
    [con getMessageWith:userId];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetApplicationList:
        {
            WS(weakSelf);
            AD_dataModal *dataModal = [[AD_dataModal alloc]init];
            
            for (AD_dataModal *model in dataArr) {
                if ([model.title_ isEqualToString:@"我的办公OA"]) {
                    dataModal.url_ = model.url_;
                }
            }
            dataModal.title_ = @"我的办公OA";
            dataModal.pic_ = [Manager getUserInfo].img_;
            dataModal.type_ = @"1";
            dataModal.shareUrl = dataModal.url_;
            ELOAWebCtl *oaWebCtl = [[ELOAWebCtl alloc] init];
            oaWebCtl.hidesBottomBarWhenPushed = YES;
            oaWebCtl.myBlock = ^(BOOL isRefresh){
                if (isRefresh) {
                    [weakSelf refreshLoad:nil];
                }
            };
            [self.navigationController pushViewController:oaWebCtl animated:YES];
            [oaWebCtl beginLoad:dataModal exParam:nil];
        }
            break;
        case getMessageWithId:
        {
            MessageCenterDataModel *oaVO;
            dataArray = [dataArr mutableCopy];
            NSDictionary *dic = [dataArray lastObject];
            messageCnt = [dic[@"messageCnt"] integerValue];
            leaveCnt = [dic[@"leaveCnt"] integerValue];
            phoneCnt =[dic[@"phoneCnt"] integerValue];
            [dataArray removeLastObject];
            
            for(MessageCenterDataModel *model in dataArray){
                if ([model.type isEqualToString:@"oa_msg"]) {
                    if (model.count.integerValue > 0) {
                        oaVO = model;
                    }
                    break;
                }
            }
            if (oaVO) {
                [dataArray removeObject:oaVO];
                [dataArray insertObject:oaVO atIndex:0];
            }
            
            if (self._block) {
                self._block(messageCnt, leaveCnt, phoneCnt);
            }
            shouldRefresh_ = NO;
        }
            break;
        default:
            break;
    }
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageListCell *messageCell = (MessageListCell *)cell;
   
    [messageCell.timeLable setHidden:YES];
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MessageListCell";
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageListCell" owner:self options:nil] lastObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xe0e0e0);;
    }
     MessageCenterDataModel *model = dataArray[indexPath.row];
     [cell setMessageType:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageCenterDataModel *model = dataArray [indexPath.row];
    
    if ([model.type isEqualToString:@"sys_msg"]) {//系统通知
        SystemNotificationCtl *sysCtl= [[SystemNotificationCtl alloc] init];
        sysCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sysCtl animated:YES];
        [sysCtl beginLoad:nil exParam:nil];
    }
    else if ([model.type isEqualToString:@"aide_msg"]) {//
        MessageContact_DataModel * dataModal = [[MessageContact_DataModel alloc] init];
        dataModal.userId = @"15476338";
        dataModal.isExpert = @"1";
        dataModal.userIname = @"一览小助手";
        dataModal.pic = @"http://img105.job1001.com/myUpload2/201503/10/1425978515_391.gif";
        dataModal.gzNum = @"10.0";
        dataModal.userZW = @"产品经理";
        dataModal.age = @"10";
        dataModal.sameCity = @"1";
        dataModal.sex = @"女";
        MessageDailogListCtl *ctl = [[MessageDailogListCtl alloc]init];
        ctl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctl animated:YES];
        [ctl beginLoad:dataModal exParam:nil];
    
    }else if ([model.type isEqualToString:@"group_msg"]) {//社群消息
        InviteListCtl *inviteList = [[InviteListCtl alloc] init];
        inviteList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:inviteList animated:YES];
        [inviteList beginLoad:nil exParam:nil];
        
    }else if ([model.type isEqualToString:@"article_cnt"]) {//新的发表
        NewPublishCtl *newCtl = [[NewPublishCtl alloc] init];
        newCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newCtl animated:YES];
        [newCtl beginLoad:nil exParam:nil];
    }else if ([model.type isEqualToString:@"comment_msg"]) { //评论
        CommentMessageListCtl *commentMessageListCtl_ = [[CommentMessageListCtl alloc] init];
        commentMessageListCtl_.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commentMessageListCtl_ animated:YES];
        [commentMessageListCtl_ beginLoad:nil exParam:nil];
    }else if ([model.type isEqualToString:@"follow_msg"]) {
        MyAudienceListCtl *listCtl = [[MyAudienceListCtl alloc]init];
        [listCtl beginLoad:@"2" exParam:nil];  //我的听众 2
        listCtl.hideDynamic = YES;
        listCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:listCtl animated:YES];
    }else if ([model.type isEqualToString:@"praise_msg"])
    {
        YLWhoLikeMeListCtl *wlmCtl = [[YLWhoLikeMeListCtl alloc] init];
        [wlmCtl beginLoad:nil exParam:nil];
        wlmCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wlmCtl animated:YES];
    }else if ([model.type isEqualToString:@"oa_msg"]){
        if (!oaCon) {
            oaCon = [self getNewRequestCon:NO];
        }
        [oaCon getApplicationList:[Manager getUserInfo].userId_ page:requestCon_.pageInfo_.currentPage_ pageSize:15 phoneType:1];
    }
    else if ([model.type isEqualToString:@"yuetan_msg"])//打赏
    {
        ELInterViewListCtl *sysCtl= [[ELInterViewListCtl alloc] init];
        [sysCtl beginLoad:nil exParam:nil];
        sysCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sysCtl animated:YES];
    }
    else if ([model.type isEqualToString:@"dashang_msg"])
    {
        ELMyRewardRecordListCtl *rewardCtl= [[ELMyRewardRecordListCtl alloc] init];
        rewardCtl.personId = [Manager getUserInfo].userId_;
        rewardCtl.personImg = [Manager getUserInfo].img_;
        [rewardCtl beginLoad:nil exParam:nil];
        rewardCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rewardCtl animated:YES];
    }
    else if ([model.type isEqualToString:@"offerpai_msg"])
    {
        ELOfferPartyMessageCtl *offerpartyMsgCtl = [[ELOfferPartyMessageCtl alloc] init];
        offerpartyMsgCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:offerpartyMsgCtl animated:YES];
        [offerpartyMsgCtl beginLoad:nil exParam:nil];
    }
    
    //红点处理
    if (model.count != 0) {
        messageCnt -= [model.count integerValue];
        [Manager shareMgr].messageCountDataModal.messageCnt = [Manager shareMgr].messageCountDataModal.messageCnt - [model.count integerValue] ;
        if ([Manager shareMgr].messageCountDataModal.messageCnt < 0) {
            [Manager shareMgr].messageCountDataModal.messageCnt = 0;
        }
//        [[Manager shareMgr].tabView_ setTabBarNewMessage];
         model.count = 0;
        [tableView reloadData];
        if (self._block) {
            self._block(messageCnt,leaveCnt,phoneCnt);
        }
    }
    if (model.count > 0) {
         [tableView_ reloadData];
    }
    NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",model.title,NSStringFromClass([self class])]};
    [MobClick event:@"buttonClick" attributes:dict];
}

-(void)refreshLeaveCount
{
    leaveCnt = 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

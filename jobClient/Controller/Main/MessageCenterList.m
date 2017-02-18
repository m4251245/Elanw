//
//  MessageCenterList.m
//  jobClient
//
//  Created by 一览ios on 15/4/23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MessageCenterList.h"
#import "MessageTypeList.h"
#import "LeaveMessageListCtl.h"
#import "TheContactListCtl.h"
#import "YLFriendListCtl.h"

#import "LeaveMessageList_Cell.h"
#import "ELAddSelView.h"
#import "ELTodayFocusSearchCtl.h"

#import "ELNewNewsListVO.h"
#import "ELNewNewsInfoVO.h"

#import "ELInterViewListCtl.h"
#import "ELMyRewardRecordListCtl.h"
#import "ELOAWebCtl.h"

#import "ELNewsListDAO.h"
//#import "ZBarScanLoginCtl.h"
//#import "ELOfferPartyMessageCtl.h"


#define kTag 6768
@interface MessageCenterList ()<UITableViewDelegate,UITableViewDataSource,AddselDelegate>
{
    MessageTypeList *typeListCtl;
    LeaveMessageListCtl    *msgListCtl;

    NSInteger             centerMessageCnt;
    NSInteger             centerLeaveMsgCnt;
    NSInteger             centerPhoneCnt;

    BOOL isHaveMessage;
    RequestCon *delectMessageCon;
    UIImageView *_redLineImagev;
    IBOutlet UIView *countLb;
    ELAddSelView *selBtnView;
    BOOL status;
    NSDictionary *vcDic;
    RequestCon *oaCon;
    NSMutableArray *dataArray;
    NSInteger all;
}
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@end

@implementation MessageCenterList
#pragma mark - LifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isHaveMessage = NO;
    }
    return self;
}

-(void)viewDidLayoutSubviews{
    [self.view layoutIfNeeded];//iOS7上不加这句可能奔溃
}
#pragma mark--life
- (void)viewWillAppear:(BOOL)animated
{
    //[super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self getDataFunction:nil];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  
    
    if (status) {
        status = !status;
        selBtnView.hidden = YES;
    }
}


-(void)viewDidLoad{
    [super viewDidLoad];
    [self confingUI];
    [self loadData];
    [self beginLoad:nil exParam:nil];
    [self addNotify];
}

#pragma mark--配置界面
-(void)confingUI{
    [self setNavTitle:@"消息"];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:_peopleView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    NSInteger width = -10;
    negativeSpacer.width = width;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];
    backBarBtn_.hidden = YES;
    leftBarBtn_.hidden = YES;
    myLeftBarBtnItem_.hidden = YES;
    tableView_.tableFooterView = [[UIView alloc]init];
    
    [self configSelBtnView];
}

-(void)configSelBtnView{
    NSArray *arr = @[@{@"title":@"发起群聊",@"img":@"chat_more@2x.png"},@{@"title":@"发起会话",@"img":@"chat_one@2x.png"},@{@"title":@"扫一扫",@"img":@"chat_code@2x.png"}];
    selBtnView = [[ELAddSelView alloc]initWithFrame:CGRectMake(ScreenWidth - 160, 5, 150, 168) arr:arr];
    selBtnView.delegate = self;
    [self.view addSubview:selBtnView];
    [self.view bringSubviewToFront:selBtnView];
    selBtnView.userInteractionEnabled = YES;
    selBtnView.hidden = YES;
}

#pragma mark--加载数据
-(void)showNoDataOkView:(BOOL)flag{
    if (dataArray.count > 0) {
        [[self getNoDataView] removeFromSuperview];
    }
}

-(void)showErrorView:(BOOL)flag{
    [[self getErrorView] removeFromSuperview];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    vcDic = @{@"sys_msg":@"SystemNotificationCtl",@"comment_msg":@"CommentMessageListCtl",@"article_msg":@"NewPublishCtl",@"follow_msg":@"MyAudienceListCtl",@"praise_msg":@"YLWhoLikeMeListCtl",@"yuetan_msg":@"ELInterViewListCtl",@"dashang_msg":@"ELMyRewardRecordListCtl",@"spec_private_msg":@"LeaveMessageListCtl",@"group_msg":@"InviteListCtl"};
}

-(void)loadData{
    ELNewsListDAO *DAO = [ELNewsListDAO new];
    NSArray *arr = [self findAllDealedNews:[DAO showAll:[Manager getUserInfo].userId_]];
    if (!requestCon_) {
        requestCon_ = [self getNewRequestCon:YES];
    }
    dataArray = [NSMutableArray array];
    if (arr.count>0) {
        for (ELNewNewsListVO *vo in arr) {
            if (vo.jsonStr.length > 0) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[vo.jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                ELNewNewsInfoVO *infovo = [ELNewNewsInfoVO new];
                [infovo setValuesForKeysWithDictionary:dic];
                vo.info = infovo;
            }
            else{
                vo.info = nil;
            }
            
            [dataArray addObject:vo];
        }
        [tableView_ reloadData];
    }
}

-(NSArray *)findAllDealedNews:(NSArray *)allDatas{
    if (allDatas.count > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        ELNewNewsListVO *specVO = nil;
        for (ELNewNewsListVO *newsVO in allDatas) {
            if (!([newsVO.type isEqualToString:@"spec_private_msg"] || [newsVO.type isEqualToString:@"oa_msg"] || [newsVO.type isEqualToString:@"private_msg"])) {
                [arr addObject:newsVO];
            }
            else if([newsVO.type isEqualToString:@"oa_msg"]){
                if ([newsVO.action isEqualToString:@"upsert"]) {
                    [arr addObject:newsVO];
                }
            }
            else if([newsVO.type isEqualToString:@"spec_private_msg"]){
                if ([newsVO.action isEqualToString:@"upsert"]) {
                    specVO  = newsVO;
                    [arr addObject:newsVO];
                }
            }
            else if([newsVO.type isEqualToString:@"private_msg"]){
                [arr addObject:newsVO];
            }
        }
        
        if ([arr containsObject:specVO]) {
            for (NSUInteger i = arr.count - 1; i<arr.count; i--) {
                ELNewNewsListVO *VO = arr[i];
                if ([VO.type isEqualToString:@"private_msg"]) {
                    [arr removeObject:VO];
                }
            }
        }
        return arr;
    }
    return [NSArray array];
}


#pragma mark--通知
-(void)addNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLoadData:) name:@"receiveNewsMsg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewMessage:) name:@"receiveNewMessageFromPush" object:nil];
}

-(void)refreshLoadData:(NSNotification *)notify{
    [self getDataFunction:nil];
}

-(void)receiveNewMessage:(NSNotification *)notify{
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf getDataFunction:nil];
    });
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"receiveNewsMsg" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"receiveNewMessageFromPush" object:nil];
}

#pragma mark--请求数据
-(void)getDataFunction:(RequestCon *)con{
    if (!con) {
        con = [self getNewRequestCon:NO];
    }
    NSString *myId = [Manager getUserInfo].userId_;
    if (!myId) {
        [BaseUIViewController showAutoDismissFailView:@"登录后才能查看留言" msg:nil seconds:2.0];
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [con getNewNewsListWithUserId:myId pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:200];
    });
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetNewNewsList:
        {
            if (dataArr.count > 0) {
                shouldRefresh_ = NO;
                [dataArray removeAllObjects];
                [dataArray addObjectsFromArray:dataArr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView_ reloadData];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"msgNewsNum" object:nil userInfo:nil];
                });
            }
        }
        break;
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
        default:
            break;
    }

}

#pragma mark--代理
#pragma mark--tableview代理
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
        ELNewNewsListVO * newsVO = dataArray[indexPath.row];
        NSInteger nowNum = [newsVO.cnt integerValue];
        ELNewsListDAO *DAO = [ELNewsListDAO new];
        [DAO deleteData:newsVO.infoId type:newsVO.type];
        [dataArray removeObjectAtIndex:indexPath.row];
        
        if (!(dataArray.count > 0)) {
            [tableView_ addSubview:[self getNoDataView]];
        }
        else{
            [[self getNoDataView] removeFromSuperview];
        }
        
        NSArray *arr = [self findAllDealedNews:[DAO showAll:[Manager getUserInfo].userId_]];
        if (arr.count > 0) {
            NSInteger allNums = [getUserDefaults(kAllNums) integerValue];
            allNums -= nowNum;
            kUserDefaults(@(allNums), kAllNums);
            kUserSynchronize;
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"msgNewsNum" object:nil userInfo:nil];
        });
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(dataArray.count > 0){
        return dataArray.count;
    }
    else
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row > dataArray.count - 1) {
        return [UITableViewCell new];
    }
    
    static NSString *identifier = @"LeaveMessageList_Cell";
    LeaveMessageList_Cell *cell = (LeaveMessageList_Cell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LeaveMessageList_Cell" owner:self options:nil][0];
    }
    ELNewNewsListVO *newsVO = nil;
   
    if(dataArray.count > 0){
        newsVO = dataArray[indexPath.row];
    }
    [cell setMessageContact:newsVO];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    ELNewNewsListVO *newsVO = nil;
    if(dataArray.count > 0){
        newsVO = dataArray[indexPath.row];
    }
    else{
        newsVO = selectData;
    }
        if ([newsVO.type isEqualToString:@"oa_msg"]) {
            if (!oaCon) {
                oaCon = [self getNewRequestCon:NO];
            }
            [oaCon getApplicationList:[Manager getUserInfo].userId_ page:requestCon_.pageInfo_.currentPage_ pageSize:15 phoneType:1];
        }
        else if([newsVO.type isEqualToString:@"private_msg"]){
            ELNewNewsInfoVO *infoVo = newsVO.info;
            MessageContact_DataModel *chatVO = [MessageContact_DataModel new];
            chatVO.userId = infoVo.newsInfoId;
            chatVO.userIname = newsVO.title;
            MessageDailogListCtl *ctl = [[MessageDailogListCtl alloc]init];
            ctl.isHr = NO;
            ctl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ctl animated:YES];
            [ctl beginLoad:chatVO exParam:nil];
        }
        else if([newsVO.type isEqualToString:@"group_chat_msg"]){
            ELGroupDetailCtl *cvc = [[ELGroupDetailCtl alloc]init];
            cvc.hidesBottomBarWhenPushed = YES;
            /*cvc.isSwipe = YES;*/
            [self.navigationController pushViewController:cvc animated:YES];
            [cvc beginLoad:newsVO.infoId exParam:nil];
        }
    else{
        [self pushVC:vcDic[newsVO.type] newsVO:newsVO];
    }
    
    NSInteger nowNum = [newsVO.cnt integerValue];
    ELNewsListDAO *DAO = [ELNewsListDAO new];
    newsVO.cnt = @(0);
    [DAO updateOneData:newsVO];
    
    NSInteger allNums = [getUserDefaults(kAllNums) integerValue];
    allNums -= nowNum;
    kUserDefaults(@(allNums), kAllNums);
    kUserSynchronize;
    [tableView_ reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"msgNewsNum" object:nil userInfo:nil];
    });
}

#pragma mark--scrollDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (status) {
        status = !status;
        [UIView animateWithDuration:0.5 animations:^{
            selBtnView.alpha = 0;
        } completion:^(BOOL finished) {
            selBtnView.hidden = YES;
        }];
        
    }
}

#pragma mark--AddSelViewDelegate
-(void)addSelClick:(UIButton *)sender{
    if (sender.tag == kTag) {//群聊
        TheContactListCtl *contactCtl = [[TheContactListCtl alloc] init];
        contactCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contactCtl animated:YES];
        [contactCtl beginLoad:nil exParam:nil];
    }
    else if(sender.tag == kTag + 1){//会话
        TheContactListCtl *contactCtl = [[TheContactListCtl alloc] init];
        contactCtl.hidesBottomBarWhenPushed = YES;
        contactCtl.isPersonChat = YES;
        [self.navigationController pushViewController:contactCtl animated:YES];
        [contactCtl beginLoad:nil exParam:nil];

    }
    else{//扫一扫
//        ZBarScanLoginCtl *ctl = [[ZBarScanLoginCtl alloc] init];
        ELScanQRCodeCtl *ctl = [[ELScanQRCodeCtl alloc] init];
        ctl.type = @"1";
        ctl.isZbar = YES;
        ctl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

#pragma mark--事件
-(void)btnResponse:(id)sender{
    if (sender == _rightBarBtn)//搜索
    {
        ELTodayFocusSearchCtl *ctl = [[ELTodayFocusSearchCtl alloc] init];
        ctl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if(sender == _addBtn){
        if (!status) {
            [UIView animateWithDuration:0.1 animations:^{
                selBtnView.alpha = 1;
            } completion:^(BOOL finished) {
                selBtnView.hidden = NO;
            }];
        }
        else{
            [UIView animateWithDuration:0.3 animations:^{
                selBtnView.alpha = 0;
            } completion:^(BOOL finished) {
                selBtnView.hidden = YES;
            }];
        }
        status = !status;
    }
}

#pragma mark--业务逻辑
-(void)pushVC:(NSString *)vcStr newsVO:(ELNewNewsListVO *)newsVO{
    id vc = [[NSClassFromString(vcStr) alloc]init];
    [vc setHidesBottomBarWhenPushed:YES];
    if ([vcStr isEqualToString:@"MyAudienceListCtl"]) {
        [vc beginLoad:@"2" exParam:nil];
    }
    else if([vcStr isEqualToString:@"ELMyRewardRecordListCtl"]){
        ELMyRewardRecordListCtl *rVC = vc;
        rVC.personId = [Manager getUserInfo].userId_;
        rVC.personImg = [Manager getUserInfo].img_;
        [vc beginLoad:nil exParam:nil];
    }
    else{
        [vc beginLoad:nil exParam:nil];
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}


#if 0
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRedCount) name:@"leaveMessageCount" object:nil];

    [self setNavTitle:@"消息"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    _redLineImagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 42, ScreenWidth / 2, 2)];
    _redLineImagev.backgroundColor = [UIColor redColor];
    [_topView addSubview:_redLineImagev];
    
    backBarBtn_.hidden = YES;
    
    _leftCountLb.layer.cornerRadius = 10.0;
    _leftCountLb.layer.masksToBounds = YES;
    _leftCountLb.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"info_01"]];
    _rightCountLb.layer.cornerRadius = 10.0;
    _rightCountLb.layer.masksToBounds = YES;
    _rightCountLb.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"info_01"]];
    countLb.clipsToBounds = YES;
    countLb.layer.cornerRadius = 6;
    [_peopleView bringSubviewToFront:countLb];
    
    CGRect rectOne = _contentScrollView.frame;
    rectOne.size.height = rectOne.size.height -44;
    _contentScrollView.frame = rectOne;
    
    _redDotLb.layer.cornerRadius = 7.0;
    _redDotLb.layer.masksToBounds = YES;
    
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:_peopleView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    NSInteger width = -10;
    negativeSpacer.width = width;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];
    
    if (!typeListCtl) {
        typeListCtl = [[MessageTypeList alloc] init];
        __block MessageTypeList *typeList = typeListCtl;
        typeList._block = ^(NSInteger messageCnt, NSInteger leaveCnt, NSInteger phoneCnt){
            centerMessageCnt = messageCnt;
            centerLeaveMsgCnt = leaveCnt;
            centerPhoneCnt = phoneCnt;
            [self refreshRedCount];
            if (leaveCnt != 0) {
                [msgListCtl refreshLoad:nil];
            }
        };
    }
    [typeListCtl beginLoad:nil exParam:nil];
    
    if (!msgListCtl) {
        msgListCtl = [[LeaveMessageListCtl alloc] init];
        __block LeaveMessageListCtl *msgList = msgListCtl;
        msgList._redCountBlock = ^(){
            
        };
    }
    [msgListCtl beginLoad:nil exParam:nil];

    [_contentScrollView setContentSize:CGSizeMake(ScreenWidth * 2, 0)];
    [self addChildViewController:typeListCtl];
    [self addChildViewController:msgListCtl];
    [_contentScrollView addSubview:typeListCtl.view];
    [_contentScrollView addSubview:msgListCtl.view];

//    [typeListCtl.view setFrame:_contentScrollView.bounds];
//    CGRect rect = msgListCtl.view.frame;
//    rect.origin.x = ScreenWidth;
//    [msgListCtl.view setFrame:rect];
//    [msgListCtl.view setFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, _contentScrollView.bounds.size.height)];

    [typeListCtl.view setFrame:CGRectMake(0, 0, _contentScrollView.bounds.size.width, _contentScrollView.bounds.size.height)];
    [msgListCtl.view setFrame:CGRectMake(ScreenWidth, 0, _contentScrollView.bounds.size.width, _contentScrollView.bounds.size.height)];

    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
    [self.view addSubview:imageView];
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapSquare);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 0.5);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 199.0/255.0, 199.0/255.0, 199.0/255.0, 1.0);  //颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0.5, 0.5);  //起点坐标
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),ScreenWidth+0.5,0.5);   //终点坐标
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _contentScrollView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:animated];
    }
    
    if (_isRight && [Manager shareMgr].isFromMessage_) {
        [self rightBtnClick:_rightBtn];
        [Manager shareMgr].isFromMessage_ = NO;
    }
    
    if(_contentScrollView.contentOffset.x > 0){
        _rightBarBtn.hidden = NO;
        if (centerLeaveMsgCnt > 0) {
            centerLeaveMsgCnt = 0;
            [self refreshRedCount];
            if (!delectMessageCon) {
                delectMessageCon = [self getNewRequestCon:NO];
            }
            [delectMessageCon delegateMessageShow:[Manager getUserInfo].userId_];
        }
    }
    else
    {
        _rightBarBtn.hidden = NO;
    }
    if (isHaveMessage && _contentScrollView.contentOffset.x > 0)
    {
    if (msgListCtl) {
            [msgListCtl refreshLoad:nil];
        }
        isHaveMessage = NO;
    }
    _isThisCtl = YES;

    if (msgListCtl) {
        [msgListCtl viewWillAppear:animated];
    }
    if (typeListCtl) {
        [typeListCtl viewWillAppear:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"receiveNewMessageFromPush" object:nil];
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = YES;
    if (msgListCtl) {
        [msgListCtl viewWillDisappear:animated];
    }
    if (typeListCtl) {
        [typeListCtl viewWillDisappear:animated];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [_contentScrollView setContentSize:CGSizeMake(ScreenWidth * 2, 0)];
}


#pragma mark - 收到推送处理
- (void)receiveNewMessage:(NSNotification *)nofity
{
    if(_contentScrollView.contentOffset.x > 0 && _isThisCtl){
        [msgListCtl refreshLoad:nil];
        [self refreshRedCount];
    }
    isHaveMessage = YES;
    [typeListCtl refreshLoad:nil];
}


-(void)refreshCtl
{
    
}

-(void)refreshViewTwoCtl
{
    [typeListCtl refreshLoad:nil];
    [msgListCtl refreshLoad:nil];
}

- (void)getDataFunction:(RequestCon *)con
{

}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

- (void)updateCom:(RequestCon *)con
{
    if (con == requestCon_) {
        if ([Manager shareMgr].haveLogin) {
            [_userImg sd_setImageWithURL:[NSURL URLWithString:[Manager getUserInfo].img_] placeholderImage:[UIImage imageNamed:@"bt_ch"]];
            [_personCenterBtn setTitle:@"" forState:UIControlStateNormal];
            _userImg.layer.cornerRadius = 11.0;
            _userImg.layer.masksToBounds = YES;
            _userImg.layer.borderWidth = 1.f;
            _userImg.layer.borderColor = [UIColor whiteColor].CGColor;
            if ([Manager getUserInfo].haveNewMessage_) {
                _redDotLb.alpha = 1.0;
                _redDotLb.text = [Manager shareMgr].totalCount;
            }
            else
                _redDotLb.alpha = 0.0;
        }
        else
        {
            _userImg.clipsToBounds = YES;
            _userImg.layer.cornerRadius = 11.0;
            [_userImg setImage:[UIImage imageNamed:@"bt_ch"]];
            [_personCenterBtn setTitle:@"我" forState:UIControlStateNormal];
            _redDotLb.alpha = 0.0;
        }
    }
    [super updateCom:con];
}

-(void)setNewMessage
{
    if ([Manager getUserInfo].haveNewMessage_) {
        if ([[Manager shareMgr].totalCount integerValue] > 0) {
            [_redDotLb setHidden:NO];
            if ([[Manager shareMgr].totalCount integerValue] > 99) {
                [_redDotLb setText:@"N"];
            }else{
                [_redDotLb setText:[Manager shareMgr].totalCount];
            }
        }else{
            [_redDotLb setHidden:YES];
        }
    }else{
        [_redDotLb setHidden:YES];
    }
}

- (void)refreshRedCount
{
    if(_contentScrollView.contentOffset.x > 0 && _isThisCtl)
    {
        centerLeaveMsgCnt = 0;
        if (!delectMessageCon) {
            delectMessageCon = [self getNewRequestCon:NO];
        }
        [delectMessageCon delegateMessageShow:[Manager getUserInfo].userId_];
    }
    if (centerMessageCnt > 0) {
        if (centerMessageCnt <= 99) {
            [_leftCountLb setText:[NSString stringWithFormat:@"%ld",(long)centerMessageCnt]];
        }else{
            [_leftCountLb setText:@"···"];
        }
        [_leftCountLb setHidden:NO];
    }else{
        [_leftCountLb setHidden:YES];
    }
    
    
    if (centerLeaveMsgCnt > 0) {
        if (centerLeaveMsgCnt <= 99) {
            [_rightCountLb setText:[NSString stringWithFormat:@"%ld",(long)centerLeaveMsgCnt]];
        }else{
            [_rightCountLb setText:@"···"];
        }
        [_rightCountLb setHidden:NO];
    }else{
        [_rightCountLb setHidden:YES];
    }
    if (centerPhoneCnt > 0)
    {
        countLb.hidden = NO;
    }
    else
    {
        countLb.hidden = YES;
    }
    [Manager shareMgr].messageCountDataModal.messageCnt = centerMessageCnt + centerLeaveMsgCnt + centerPhoneCnt;
    if ([Manager shareMgr].messageCountDataModal.messageCnt < 0) {
        [Manager shareMgr].messageCountDataModal.messageCnt = 0;
    }
//    [[Manager shareMgr].tabView_ setTabBarNewMessage];
    
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"msgNewsNum" object:nil userInfo:@{@"num":@([Manager shareMgr].messageCountDataModal.messageCnt)}];
}

-(void)refreshAddressBookRedDot
{
    centerPhoneCnt = 0;
    [self refreshRedCount];
}

- (void)changToRightModel
{
    if (centerLeaveMsgCnt > 0) {
        centerLeaveMsgCnt = 0;
        [self refreshRedCount];
    }
    [msgListCtl beginLoad:nil exParam:nil];
    [_rightBtn setTitleColor:[UIColor colorWithRed:223.0/255.0 green:61.0/255.0 blue:65.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    CGRect rect = _redLineImagev.frame;
    rect.origin.x = rect.size.width;
    [_redLineImagev setFrame:rect];
    [_contentScrollView setContentOffset:CGPointMake(_contentScrollView.frame.size.width, 0) animated:YES];
}

- (IBAction)leftBtnClick:(id)sender {
    [self changBtnStauts:sender];
}

- (IBAction)rightBtnClick:(id)sender {
    [self changBtnStauts:sender];
}

#pragma mark - 刷新小红点
- (void)freshRedCountStatus
{
    
}

- (void)changBtnStauts:(id)sender
{
    UIButton *button = sender;
    if (button == _leftBtn)
    {
        [_leftBtn setTitleColor:[UIColor colorWithRed:223.0/255.0 green:61.0/255.0 blue:65.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        CGRect rect = _redLineImagev.frame;
        rect.origin.x = 0;
        [_redLineImagev setFrame:rect];
        [_contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        _rightBarBtn.hidden = NO;
    }
    else if (button == _rightBtn)
    {
        if (centerLeaveMsgCnt > 0) {
            centerLeaveMsgCnt = 0;
            [self refreshRedCount];
            if (!delectMessageCon) {
                delectMessageCon = [self getNewRequestCon:NO];
            }
            [delectMessageCon delegateMessageShow:[Manager getUserInfo].userId_];
        }
        [_rightBtn setTitleColor:[UIColor colorWithRed:223.0/255.0 green:61.0/255.0 blue:65.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        CGRect rect = _redLineImagev.frame;
        rect.origin.x = ScreenWidth-rect.size.width;
        [_redLineImagev setFrame:rect];
        [_contentScrollView setContentOffset:CGPointMake(_contentScrollView.frame.size.width, 0) animated:YES];
        _rightBarBtn.hidden = NO;
        [typeListCtl refreshLeaveCount];
    }
}

-(void)btnResponse:(id)sender
{
    if (sender == _personCenterBtn) {

    }
    else if (sender == _rightBarBtn)
    {
        NSLog(@"search");
//        YLFriendListCtl *friendCtl = [[YLFriendListCtl alloc] init];
//        friendCtl.phoneCount = centerPhoneCnt;
//        friendCtl.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:friendCtl animated:YES];
        
        
    }
    else if(sender == _addBtn){
        NSLog(@"add");
    }
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (msgListCtl && !msgListCtl.mIsFinishFresh) {
//        [msgListCtl refreshLoad:nil];
//        msgListCtl.mIsFinishFresh = YES;
//    }
//}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#endif

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

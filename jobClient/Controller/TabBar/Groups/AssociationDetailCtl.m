//
//  AssociationDetailCtl.m
//  Association
//
//  Created by 一览iOS on 14-1-15.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "AssociationDetailCtl.h"
#import "GroupArticle_Cell.h"
#import "RecommendArticleCell.h"
#import "NoLoginPromptCtl.h"
#import "TodayFocusFrame_DataModal.h"
#import "TodayFocus_Cell.h"
#import "UIButton+WebCache.h"

@interface AssociationDetailCtl () <NoLoginDelegate,ELShareManagerDelegate>
{
    NSString *_groupId;
    CGFloat _move;   //tableview的滚动距离
    BOOL isPingLunRefresh;
    __weak IBOutlet UIButton *publishBtn;
}

@end

@implementation AssociationDetailCtl

@synthesize isMine_,type_,delegate_;
- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        bFooterEgo_ = YES;
        self.noShowNoDataView = YES;
        groupsDataModal_ = [[ELGroupDetailModal alloc]init];
        //刷新列表
        [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(shareArticleSuccess) name:@"ASSOCIATIONDETAILFRESH" object:nil];
        _isZbar = NO;
        _isCompanyGroup = NO;
        isPingLunRefresh = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_isGroupPop) {
        self.fd_interactivePopDisabled = YES;
    }
    
    articleDetailArray_ = [[NSMutableArray alloc]init];
    topArticleArray_ = [[NSMutableArray alloc]init];
    
    tableView_.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
    tableView_.backgroundView = nil;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    noArticleView_.alpha = 0.0;
    publishBtn.hidden = YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateCom:(RequestCon *)con{
    [super updateCom:con];
    if (con == nil ) {
        return;
    }

    if (con == requestCon_ && groupsDataModal_){
#pragma mark - 群主判断
        if ([[Manager getUserInfo].userId_ isEqualToString:groupsDataModal_.personId]) {
            isCreate_ = YES;
        }
    }
    
    if ([groupsDataModal_.code isEqualToString:@"200"]
        ||[groupsDataModal_.code isEqualToString:@"201"]
        ||[groupsDataModal_.code isEqualToString:@"202"]
        ||[groupsDataModal_.code isEqualToString:@"203"]
        ||[groupsDataModal_.code isEqualToString:@"199"]){
        //禁止查看评论的操作
        for (TodayFocusFrame_DataModal * dataModal in articleDetailArray_) {
            ELSameTrameArticleModel *model = dataModal.sameTradeArticleModel;
            [model._comment_list removeAllObjects];
            dataModal.sameTradeArticleModel = model;
        }
    }
    
    if (groupsDataModal_){//已加入社群
        if ([groupsDataModal_.code isEqualToString:@"11"] 
            || [groupsDataModal_.code isEqualToString:@"10"] 
            || [groupsDataModal_.code isEqualToString:@"12"])
        {
            publishBtn.hidden = NO;
        }
    }
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam{
    [super beginLoad:dataModal exParam:exParam];
    
    if ([dataModal isKindOfClass:[Groups_DataModal class]]){
        Groups_DataModal *modal = dataModal;
        _groupId = modal.id_;
    }else{
        _groupId = dataModal;
    }
    
    //获取社群详情和与社群关系
    groupsDataModal_ = exParam;
}

-(void)getDataFunction:(RequestCon *)con{
    NSString * userId = [Manager getUserInfo].userId_;
    if (!userId || [userId isEqualToString:@""]){
        userId = @"";
    }
    if (!con){
        con = [self getNewRequestCon:YES];
    }
    if(isPingLunRefresh){
        con = [self getNewRequestCon:YES];
        [articleDetailArray_ removeAllObjects];
    }
    [con getGroupsArticleList:_groupId user:userId keyWord:nil page:requestCon_.pageInfo_.currentPage_ pageSize:20 topArticle:@"1"];
    isPingLunRefresh = NO;
}

-(void)refreshLoad:(RequestCon *)con{
    [super refreshLoad:con];
}

-(void)showNoMoreDataView:(BOOL)flag{
    [super showNoMoreDataView:NO];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_GroupsArticle:
        {
            
            if (requestCon_.pageInfo_.currentPage_ == 1) {
                [articleDetailArray_ removeAllObjects];
            }
            [articleDetailArray_ addObjectsFromArray:dataArr];
            if ([[articleDetailArray_ lastObject] isKindOfClass:[NSMutableArray class]]) {
                NSMutableArray *array = [articleDetailArray_ lastObject];
                 topArticleArray_ = [array objectAtIndex:0];
                 [articleDetailArray_ removeLastObject];
            }
            noArticleView_.alpha = 0.0;
            if ([articleDetailArray_ count] == 0 && [topArticleArray_ count] == 0) {
                noArticleView_.alpha = 1.0;
            }
            [tableView_ reloadData];
        }
            break;
        case Request_JoinGroup:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                if ([dataModal.code_ isEqualToString:@"200"]) {
                    //审核中
                    groupsDataModal_.code = @"199";
                    [BaseUIViewController showAutoDismissSucessView:@"申请成功,等待审核" msg:nil];
                    if ([delegate_ respondsToSelector:@selector(refresh)]) {
                        [delegate_ refresh];
                    }
                    if ([delegate_ respondsToSelector:@selector(joinSuccess)]) {
                        [delegate_ joinSuccess];
                    }
                }
                else if ([dataModal.code_ isEqualToString:@"100"]){
                    groupsDataModal_.code = @"11";
                    [BaseUIViewController showAutoDismissSucessView:@"加入成功" msg:nil];
                    if ([delegate_ respondsToSelector:@selector(refresh)]) {
                        [delegate_ refresh];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CREATEGROUPSUCCESS" object:nil];
                    if (!permissionCon_) {
                        permissionCon_ = [self getNewRequestCon:NO];
                    }
                    [permissionCon_ getPermissionInGroup:groupsDataModal_.group_id userId:[Manager getUserInfo].userId_];
                    [self refreshLoad:nil];
                }
            }
            else
            {
                [BaseUIViewController showAutoDismissSucessView:dataModal.des_ msg:nil];
            }
        }
            break;
        case Request_JoinGroupTwo:
        {
            if ([delegate_ respondsToSelector:@selector(refresh)]) {
                [delegate_ refresh];
            }
        }
            break;
        case Request_PermissionInGroup:
        {
            NSArray * array = [dataArr objectAtIndex:0];
            @try {
                groupsDataModal_.topic_publish = [array objectAtIndex:0];
            }
            @catch (NSException *exception) {
                groupsDataModal_.topic_publish = @"";
                groupsDataModal_.member_invite = @"";
            }
            @finally {
                
            }
            @try {
                groupsDataModal_.member_invite = [array objectAtIndex:1];
            }
            @catch (NSException *exception) {
                groupsDataModal_.member_invite = @"";
            }
            @finally {
                
            }
        }
            break;
        case Request_DeleteGroupArticle:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"]) {
                [BaseUIViewController showAutoDismissSucessView:@"删除成功" msg:nil seconds:0.5];
                TodayFocusFrame_DataModal * dataModal = nil;
                if (clickIndexPath.section == 0) {
                    dataModal = [topArticleArray_ objectAtIndex:clickIndexPath.row];
                    [topArticleArray_ removeObject:dataModal];
                }else{
                    dataModal = [articleDetailArray_ objectAtIndex:clickIndexPath.row];
                    [articleDetailArray_ removeObject:dataModal];
                }
                groupsDataModal_.group_article_cnt = [NSString stringWithFormat:@"%ld",(long)([groupsDataModal_.group_article_cnt integerValue]-1)];
                [tableView_ reloadData];
                if ([delegate_ respondsToSelector:@selector(refresh)]) {
                    [delegate_ refresh];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CREATEGROUPSUCCESS" object:nil];
            }else{
                [BaseUIViewController showAutoDismissFailView:@"删除失败" msg:nil seconds:0.5];
            }
        }
            break;
        default:
            break;
    }
}

-(void)joinSuccessRefresh{
    groupsDataModal_.code = @"11";
    if ([delegate_ respondsToSelector:@selector(refresh)]) {
        [delegate_ refresh];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CREATEGROUPSUCCESS" object:nil];
    if (!permissionCon_) {
        permissionCon_ = [self getNewRequestCon:NO];
    }
    [permissionCon_ getPermissionInGroup:groupsDataModal_.group_id userId:[Manager getUserInfo].userId_];
    [self refreshLoad:nil];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if ([topArticleArray_ count] != 0) {
            return [topArticleArray_ count];
        }
        return 0;
    }else if (section == 1){
        if ([articleDetailArray_ count] !=0) {
            return [articleDetailArray_ count];
        }
        return 0;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"RecommendArticleCell";
        RecommendArticleCell *cell = (RecommendArticleCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RecommendArticleCell" owner:self options:nil] lastObject];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        @try {
            TodayFocusFrame_DataModal * dataModal = [topArticleArray_ objectAtIndex:indexPath.row];
            [cell initCellWithTitle:dataModal.groupRecommentModel.title personImg:dataModal.groupRecommentModel.person_pic content:dataModal.groupRecommentModel.summary indexPath:indexPath];
            
            if ([dataModal.groupRecommentModel.fujian_flag isEqualToString:@"1"]) {
                cell.imageLeftWidth.constant = 22;
                cell.attentionImage.hidden = NO;
            }else{
                cell.imageLeftWidth.constant = 2;
                cell.attentionImage.hidden = YES;
            }
        }
        @catch (NSException *exception){
        
        }
        @finally {
        
        }
        return cell;
    }
    else {
        TodayFocusFrame_DataModal *modal = articleDetailArray_[indexPath.row];
        static NSString *reuseIdentifier = @"TodayFocus_Cell";
        TodayFocus_Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"TodayFocus_Cell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
//            UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            commentBtn.frame = CGRectMake(ScreenWidth - 80, CGRectGetMaxY(modal.showImgvFrame) + 8, 60, 25);
//            commentBtn.tag = 9999;
//            commentBtn.userInteractionEnabled = NO;
//            commentBtn.titleLabel.textAlignment = NSTextAlignmentRight;
//            commentBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
//            [commentBtn setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateNormal];
//            [commentBtn setImage:[UIImage imageNamed:@"groups_comment.png"] forState:UIControlStateNormal];
//            [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
//            [cell.backView addSubview:commentBtn];
            
        }
        cell.model = modal;
        cell.tipsLb.hidden = YES;
        cell.formLeftLb.hidden = YES;
        if ([groupsDataModal_.group_open_status isEqualToString:@"3"]) {
            cell.shareBtn.hidden = YES;
            
        }else{
            cell.shareBtn.hidden = NO;
        }
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
        if (isCreate_) {
            [cell.deleteBtn setHidden:NO];
        }
        else{
            if ([modal.sameTradeArticleModel.personId isEqualToString:[Manager getUserInfo].userId_]) {
                [cell.deleteBtn setHidden:NO];
            }else{
                [cell.deleteBtn setHidden:YES];
            }
        }
        
        UIButton *btn = [cell.backView viewWithTag:9999];
        if ([modal.sameTradeArticleModel._pic_list isKindOfClass:[NSArray class]]) {
            btn.frame = CGRectMake(ScreenWidth - 80, CGRectGetMaxY(cell.imgShowView.frame) + 8, 60, 25);
        }
        else
        {
            btn.frame = CGRectMake(ScreenWidth - 80, CGRectGetMaxY(cell.contentLb.frame) + 8, 60, 25);
        }
        
//        cell.toolBarView.hidden = YES;
        cell.commentView.hidden = YES;
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) 
    {
        return 84;
    }
    else{
        TodayFocusFrame_DataModal *modal = articleDetailArray_[indexPath.row];
        return modal.height - modal.toolBarFrame.size.height - modal.commentViewFrame.size.height + 25;
    }
    return 0.1;
}


-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    if(![groupsDataModal_.group_open_status isEqualToString:@"100"]){
        if ([Manager shareMgr].haveLogin){
            if ([groupsDataModal_.code isEqualToString:@"11"]
                || [groupsDataModal_.code isEqualToString:@"10"]
                || [groupsDataModal_.code isEqualToString:@"12"]){
            }else{
                [self showChooseAlertView:11 title:@"查看社群文章需要加入社群" msg:nil okBtnTitle:@"加入" cancelBtnTitle:@"取消"];
                return;
            }
        }else{
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            return;
        }
    }
    
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    NSDictionary *dic = @{@"Function":@"ArticleDetailCtl"};
    [MobClick event:@"buttonClick" attributes:dic];
    
    ArticleDetailCtl *articleDetailCtl_ = [[ArticleDetailCtl alloc] init];
    articleDetailCtl_.joinGroupDelegate = self;
    articleDetailCtl_.isFromGroup_ = YES;
    articleDetailCtl_.isEnablePop = YES;
    articleDetailCtl_.isFromCompanyGroup = _isCompanyGroup;
    
    if (indexPath.section == 0) {
        TodayFocusFrame_DataModal * dataModel = [topArticleArray_ objectAtIndex:indexPath.row];
        [articleDetailCtl_ beginLoad:dataModel.groupRecommentModel.article_id exParam:nil];
        
        if (isMine_) {
            [self.navigationController pushViewController:articleDetailCtl_ animated:YES];
        }else{
            [self.navigationController pushViewController:articleDetailCtl_ animated:YES];
        }
    }
    else {
        TodayFocusFrame_DataModal * dataModel = [articleDetailArray_ objectAtIndex:indexPath.row];
        articleDetailCtl_.addCommentSuccessBlock = ^(BOOL likeFlag,BOOL commentFlag){
            if (likeFlag) {
                dataModel.isLike_ = YES;
                dataModel.sameTradeArticleModel.like_cnt = [NSString stringWithFormat:@"%ld",(long)([dataModel.sameTradeArticleModel.like_cnt integerValue]+1)];
            }
            [tableView_ reloadData];
            [self refreshLoad:nil];
        };
        [articleDetailCtl_ beginLoad:dataModel.sameTradeArticleModel.article_id exParam:nil];
        if (isMine_) {
            [self.navigationController pushViewController:articleDetailCtl_ animated:YES];
        }else{
            [self.navigationController pushViewController:articleDetailCtl_ animated:YES];
        }
    }
}

#pragma mark - 自己创建的社群卡片右上角删除按钮点击事件
- (void)deleteBtnClick:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:tableView_];
    NSIndexPath *indexPath = [tableView_ indexPathForRowAtPoint: currentTouchPosition];
    clickIndexPath = indexPath;
    
    [self showChooseAlertView:13 title:@"温馨提示" msg:@"是否删除该篇文章？" okBtnTitle:@"确认" cancelBtnTitle:@"取消"];
}

-(void)viewDidLayoutSubviews
{
    [self.view layoutSubviews];
}

-(IBAction)publishArticleBtnRespone:(id)sender
{
    if (![groupsDataModal_.topic_publish boolValue]) {
        [BaseUIViewController showAlertView:@"无发表权限" msg:@"请告知群主开通权限" btnTitle:@"确定"];
        return;
    }
    PublishArticle *Ctl_ = [[PublishArticle alloc] init];
    Ctl_.delegate_ = self;
    Ctl_.type_ = Topic;
    if ([groupsDataModal_.group_source isEqualToString:@"3"]) {
        Ctl_.isCompanyGroup = YES;
    }
    [self.navigationController pushViewController:Ctl_ animated:YES];
    [Ctl_ beginLoad:groupsDataModal_.group_id exParam:nil];
}

-(void)joinGroup:(NSString*)groupId{
    if (!joinCon_) {
        joinCon_ = [self getNewRequestCon:NO];
    }
    //私密社群
    if ([groupsDataModal_.group_open_status isEqualToString:@"3"]) {
        JionGroupReasonCtl *jionGroupCtl = [[JionGroupReasonCtl alloc]init];
        jionGroupCtl.delegate = self;
        [jionGroupCtl beginLoad:groupsDataModal_.group_id exParam:nil];
        [self.navigationController pushViewController:jionGroupCtl animated:YES];
    }else{
        [joinCon_ joinGroup:[Manager getUserInfo].userId_ group:groupsDataModal_.group_id content:@""];
    }
}

//show/hide no data but load ok view
//-(void) showNoDataOkView:(BOOL)flag{
//    [MyLog Log:[NSString stringWithFormat:@"showNoDataOkView flag=%d",flag] obj:self];
//    
//    if( flag ){
//        UIView *noDataOkSuperView = [self getNoDataSuperView];
//        UIView *noDataOkView = [self getNoDataView];
//        if( noDataOkSuperView && noDataOkView ){
//            [noDataOkSuperView addSubview:noDataOkView];
//            
//            //set the rect
//            CGRect rect = noDataOkView.frame;
//            rect.origin.x = (int)((noDataOkSuperView.frame.size.width - rect.size.width)/2.0);
//            rect.origin.y = (int)(noDataOkSuperView.frame.size.height - rect.size.height);
//            [noDataOkView setFrame:rect];
//        }else{
//            [MyLog Log:@"noDataSuperView or noDataView is null,if you want to show noDataOkView, please check it" obj:self];
//        }
//    }else{
//        [[self getNoDataView] removeFromSuperview];
//    }
    
//    [self.view bringSubviewToFront:publishBtn];
//}

#pragma ShareArticleSuccess
-(void)shareArticleSuccess{
    [self refreshLoad:nil];
}

-(void)publishSuccess{
    [topArticleArray_ removeAllObjects];
    groupsDataModal_.group_article_cnt = [NSString stringWithFormat:@"%ld",(long)([groupsDataModal_.group_article_cnt integerValue]+1)];
    [self refreshLoad:nil];
    if ([delegate_ respondsToSelector:@selector(refresh)]) {
        [delegate_ refresh];
    }
}
#pragma mark - NoLoginDelegate未登录提示代理
-(void)loginDelegateCtl{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_GroupDetailPublish:
        {
            [self refreshLoad:nil];
        }
            break;
            
        default:
            break;
    }
}

-(void)alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type{
    [super alertViewChoosed:alertView index:index type:type];
    switch (type) {
        case 1:
        {
            [[Manager shareMgr] loginOut];
            [Manager shareMgr].haveLogin = NO;
        }
            break;
        case 11:
        {
            if ([groupsDataModal_.code isEqualToString:@"199"]) {
                [BaseUIViewController showAlertView:@"温馨提示" msg:@"您已经提交过申请，请耐心等待审核" btnTitle:@"知道了"];
                return;
            }
            [self joinGroup:groupsDataModal_.group_id];
        }
            break;
        case 13:
        {
            TodayFocusFrame_DataModal * dataModal = nil;
            if (clickIndexPath.section == 0) {
                dataModal = [topArticleArray_ objectAtIndex:clickIndexPath.row];
            }else{
                dataModal = [articleDetailArray_ objectAtIndex:clickIndexPath.row];
            }
            
            if (!deleteCon_) {
                deleteCon_ = [self getNewRequestCon:NO];
            }
            [deleteCon_ deleteGroupArticle:[Manager getUserInfo].userId_ groupId:groupsDataModal_.group_id articleId:dataModal.sameTradeArticleModel.article_id];
        }
        default:
            break;
    }
}

#pragma mark- 加入社群成功回调
-(void)joinGroupSuccess{
    groupsDataModal_.code = @"199";
    [self updateCom:nil];
    if ([delegate_ respondsToSelector:@selector(refresh)]) {
        [delegate_ refresh];
    }
    if ([delegate_ respondsToSelector:@selector(joinSuccess)]) {
        [delegate_ joinSuccess];
    }
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

@end

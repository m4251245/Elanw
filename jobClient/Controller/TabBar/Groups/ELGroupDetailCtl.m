//
//  ELGroupDetailCtl.m
//  jobClient
//
//  Created by YL1001 on 16/12/21.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELGroupDetailCtl.h"
#import "ELGroupDetailCtl.h"
#import "GroupsDetailCtl.h"
#import "AssociationDetailCtl.h"
#import "ELGroupIMListCtl.h"
#import "NoLoginPromptCtl.h"

@interface ELGroupDetailCtl ()<QuitGroupDelegate,JionGroupReasonCtlDelegate,AssociationDetailCtlDelegate,UIScrollViewDelegate,NoLoginDelegate,QuitGroupDelegate>
{
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet UIButton *_articleBtn;
    __weak IBOutlet UIButton *_talkBtn;
    __weak IBOutlet UIView *_redLine;
    __weak IBOutlet NSLayoutConstraint *_redLineLeftMargin;
    UIButton *selectBtn;
    
    NSString *_groupId;
    UIButton *_rightBtn;
    ELGroupDetailModal  *_groupsDataModal;
    
    
    CGFloat startContentOffsetX;
    CGFloat willEndContentOffsetX;
    CGFloat endContentOffsetX;
}
@end

@implementation ELGroupDetailCtl

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    self.headerRefreshFlag = NO;
    self.footerRefreshFlag = NO;
    self.showNoDataViewFlag = NO;
    self.showNoMoreDataViewFlag = NO;
    [super viewDidLoad];
    _scrollView.contentSize = CGSizeMake(ScreenWidth*2, ScreenHeight - 64 - 44);
    _articleBtn.enabled = NO;
    _talkBtn.enabled = NO;
    
    [self addChildViewController];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGroupName:) name:@"kChangeGroupName" object:nil];
}


#pragma mark - 添加子控制器
- (void)addChildViewController
{
    AssociationDetailCtl *detailCtl = [[AssociationDetailCtl alloc] init];
    detailCtl.delegate_ = self;
    detailCtl.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44);
    [self addChildViewController:detailCtl];
    
    
    ELGroupIMListCtl *groupChatCtl = [[ELGroupIMListCtl alloc] init];
    groupChatCtl.view.frame = CGRectMake(ScreenWidth, 0, self.view.frame.size.width, self.view.frame.size.height-44);
    [self addChildViewController:groupChatCtl];
    
}

#pragma mark - QuitGroupDelegate
- (void)updateGroupImgSuccess:(NSString *)img{
    _groupsDataModal.group_pic = img;
    if ([_delegate respondsToSelector:@selector(updateGroupImgSuccess:)]) {
        [_delegate updateGroupImgSuccess:img];
    }
}

-(void)quitGroupSuccess{
    [self refreshLoad];
    if ([_delegate respondsToSelector:@selector(quitGroupSuccess)]) {
        [_delegate quitGroupSuccess];
    }
}

#pragma mark- 加入社群成功回调
-(void)joinGroupSuccess{
    _groupsDataModal.code = @"199";
    [self updateNavTitle];
    if ([_delegate respondsToSelector:@selector(refresh)]) {
        [_delegate refresh];
    }
    if ([_delegate respondsToSelector:@selector(joinSuccess)]) {
        [_delegate joinSuccess];
    }
}

#pragma mark - AssociationDetailCtlDelegate
-(void)refresh{
    [self refreshLoad];
}

-(void)joinSuccess{
    [self refreshLoad];
}

#pragma mark - 数据请求
-(void)beginLoad:(id)dataModal exParam:(id)exParam{
    [super beginLoad:dataModal exParam:exParam];
    
    if (_groupId == nil) {
        if ([dataModal isKindOfClass:[Groups_DataModal class]]){
            Groups_DataModal *modal = dataModal;
            _groupId = modal.id_;
        }else{
            _groupId = dataModal;
        }
    }
    
    [self requestGroupMessage];
}

- (void)requestGroupMessage
{
    NSString * function = @"getGroupsInfoAndJoinInfo";
    NSString * op = @"groups_busi";
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"1" forKey:@"get_top_article"];
    [conditionDic setObject:@"1" forKey:@"get_summary_flag"];
    [conditionDic setObject:@"1" forKey:@"get_content_img_flag"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    NSString * userId = [Manager getUserInfo].userId_;
    if (!userId || [userId isEqualToString:@""]){
        userId = @"";
    }
    
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:@"ture" forKey:@"re_comment"];
    [searchDic setObject:@"1" forKey:@"re_person_detail"];
    [searchDic setObject:userId forKey:@"login_person_id"];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    NSString *searchStr = [jsonWriter2 stringWithObject:searchDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&conditionArr=%@&searchArr=%@",_groupId,conditionStr,searchStr];
    
    [BaseUIViewController showLoadView:YES content:@"" view:self.view];
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *groupDic = [result objectForKey:@"group"];
        ELGroupDetailModal *groupMessageDataModal = [[ELGroupDetailModal alloc] initWithDictionary:groupDic];
        _groupsDataModal = groupMessageDataModal;
        [self updateNavTitle];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma maek  -- groupName noti
- (void)updateGroupName:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
    NSString *groupName = dic[@"groupName"];
    NSString *setcode = dic[@"groupPushSet"];
    if (groupName.length > 0) {
        _groupsDataModal.group_name = groupName;
    }
    _groupsDataModal.setcode = setcode;
    
    [self configTitleView:_groupsDataModal];
}

#pragma mark - title
- (void)configTitleView:(ELGroupDetailModal *)model
{
    NSString *title = [NSString stringWithFormat:@"%@(%@)",model.group_name,[NSString changeNullOrNil:model.group_person_cnt]];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.center = CGPointMake(ScreenWidth/2, self.navigationController.navigationBar.height/2);
    titleView.bounds = CGRectMake(0, 0, ScreenWidth-120, 44);
    
    CGSize rectSize = [title sizeNewWithFont:[UIFont systemFontOfSize:17]];
    UILabel *titleLabel = [[UILabel alloc] init];
    if (rectSize.width >= titleView.width-12) {
        rectSize.width = titleView.width-12;
    }
    titleLabel.frame = CGRectMake((titleView.width-rectSize.width)/2, (titleView.height-rectSize.height)/2, rectSize.width, rectSize.height);
    titleLabel.text = title;
    titleLabel.textColor = UIColorFromRGB(0xffffff);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [titleView addSubview:titleLabel];
    
    if ([model.setcode isEqualToString:@"2"] && ([model.code isEqualToString:@"10"] || [model.code isEqualToString:@"11"] || [model.code isEqualToString:@"12"]))
    {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shielding"]];
        imgView.frame = CGRectMake(titleLabel.right, 17, 11, 12);
        [titleView addSubview:imgView];
    }
    
    self.navigationItem.titleView = titleView;
}

- (void)updateNavTitle
{
    if (![_groupsDataModal.group_name isKindOfClass:[NSNull class]] && _groupsDataModal.group_name) {
        [self configTitleView:_groupsDataModal];
    }
    
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setFrame:CGRectMake(0, 0, 40, 40)];
        _rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
        _rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    }
    
    if (_groupsDataModal && [Manager shareMgr].haveLogin){//已加入社群
        if ([_groupsDataModal.code isEqualToString:@"11"]
            || [_groupsDataModal.code isEqualToString:@"10"]
            || [_groupsDataModal.code isEqualToString:@"12"])
        {
            [_rightBtn setTitle:@"" forState:UIControlStateNormal];
            [_rightBtn setImage:[UIImage imageNamed:@"groups_member.png"] forState:UIControlStateNormal];
            _rightBtn.enabled = YES;
        }
        else if([_groupsDataModal.code isEqualToString:@"199"])
        {
            [_rightBtn setTitle:@"审核中" forState:UIControlStateNormal];
            _rightBtn.enabled = NO;
        }
        else if ([_groupsDataModal.code isEqualToString:@"200"]
                 ||[_groupsDataModal.code isEqualToString:@"201"]
                 ||[_groupsDataModal.code isEqualToString:@"202"]
                 ||[_groupsDataModal.code isEqualToString:@"203"])
        {
            [_rightBtn setTitle:@"加入" forState:UIControlStateNormal];
            _rightBtn.enabled = YES;
        }
    }
    else {
        [_rightBtn setTitle:@"加入" forState:UIControlStateNormal];
        _rightBtn.enabled = YES;
    }
    
    _articleBtn.enabled = YES;
    _talkBtn.enabled = YES;
    
    [BaseUIViewController showLoadView:NO content:@"" view:self.view];
    [self swipeOneOrTwo];
}

- (void)joinGroup:(NSString *)groupId
{
    //私密社群
    if ([_groupsDataModal.group_open_status isEqualToString:@"3"]) {
        JionGroupReasonCtl *jionGroupCtl = [[JionGroupReasonCtl alloc]init];
        jionGroupCtl.delegate = self;
        [jionGroupCtl beginLoad:_groupsDataModal.group_id exParam:nil];
        [self.navigationController pushViewController:jionGroupCtl animated:YES];
    }else{
        [self joinGroup:[Manager getUserInfo].userId_ group:_groupsDataModal.group_id content:@""];
    }
}

-(void)joinGroup:(NSString*)userId  group:(NSString*)groupId content:(NSString *)content
{
    NSString * bodyMsg = nil;
    //非私密社群
    if ([content isEqualToString:@""]) {
        bodyMsg = [NSString stringWithFormat:@"group_id=%@&request_person_id=%@",groupId,userId];
    }else{
        NSMutableDictionary *insertDic = [[NSMutableDictionary alloc]init];
        [insertDic setObject:content forKey:@"reason"];
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        NSString *insertStr = [jsonWriter stringWithObject:insertDic];
        bodyMsg = [NSString stringWithFormat:@"group_id=%@&request_person_id=%@&insertArr=%@",groupId,userId,insertStr];
    }
    //组装请求参数
    NSString * function = Table_Func_JoinGroup;
    NSString * op = Table_Op_JoinGroup;
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dic = result;
        Status_DataModal * dataModal = [[Status_DataModal alloc] init];
        dataModal.code_ = [dic objectForKey:@"code"];
        dataModal.status_ = [dic objectForKey:@"status"];
        dataModal.des_ = [dic objectForKey:@"status_desc"];
        dataModal.status_ = [dataModal.status_ uppercaseString];
        if([dataModal.status_ isEqualToString:@"OK"])
        {
            [[Manager shareMgr] showSayViewWihtType:2];
        }
        
        if ([dataModal.status_ isEqualToString:Success_Status]) {
            if ([dataModal.code_ isEqualToString:@"200"]) {
                //审核中
                _groupsDataModal.code = @"199";
                [BaseUIViewController showAutoDismissSucessView:@"申请成功,等待审核" msg:nil];
                if ([_delegate respondsToSelector:@selector(refresh)]) {
                    [_delegate refresh];
                }
                if ([_delegate respondsToSelector:@selector(joinSuccess)]) {
                    [_delegate joinSuccess];
                }
                [self requestGroupMessage];
            }
            else if ([dataModal.code_ isEqualToString:@"100"]){
                _groupsDataModal.code = @"11";
                [BaseUIViewController showAutoDismissSucessView:@"加入成功" msg:nil];
                if ([_delegate respondsToSelector:@selector(refresh)]) {
                    [_delegate refresh];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CREATEGROUPSUCCESS" object:nil];
                [self getPermissionInGroup];
                [self requestGroupMessage];
            }
        }
        else
        {
            [BaseUIViewController showAutoDismissSucessView:dataModal.des_ msg:nil];
        }

        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (void)getPermissionInGroup
{
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&member_id=%@",_groupsDataModal.group_id, [Manager getUserInfo].userId_];
    [ELRequest postbodyMsg:bodyMsg op:@"groups" func:@"getGroupMemberPermission" requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dic = result;
        _groupsDataModal.topic_publish = [dic objectForKey:@"topic_publish"];
        _groupsDataModal.member_invite = [dic objectForKey:@"member_invite"];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark - buttonClick
- (void)rightBtnClick
{
    if (![Manager shareMgr].haveLogin){
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_GroupDetailPublish;
        return;
    }
    
    if ([_groupsDataModal.code isEqualToString:@"11"]
        ||[_groupsDataModal.code isEqualToString:@"10"]
        ||[_groupsDataModal.code isEqualToString:@"12"])
    {//查看社群成员
        GroupsDetailCtl *groupDetailCtl = [[GroupsDetailCtl alloc] init];
        groupDetailCtl.delegate_ = self;
        [self.navigationController pushViewController:groupDetailCtl animated:YES];
        [groupDetailCtl beginLoad:_groupsDataModal.group_id exParam:nil];
        
    }
    else if ([_groupsDataModal.code isEqualToString:@"200"]
             || [_groupsDataModal.code isEqualToString:@"202"]
             || [_groupsDataModal.code isEqualToString:@"203"]
             || [_groupsDataModal.code isEqualToString:@"201"])
    {
        //加入
        [self joinGroup:_groupsDataModal.group_id];
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
            [self refreshLoad];
        }
            break;
        default:
            break;
    }
}

- (IBAction)buttonClick:(UIButton *)sender {
    
    if (sender == _talkBtn) {
        if ([_groupsDataModal.code isEqualToString:@"200"]
            || [_groupsDataModal.code isEqualToString:@"201"]
            || [_groupsDataModal.code isEqualToString:@"202"]
            || [_groupsDataModal.code isEqualToString:@"203"]
            || [_groupsDataModal.code isEqualToString:@"199"]
            || [_groupsDataModal.code isEqualToString:@""])
        {
            [BaseUIViewController showAlertView:nil msg:@"加入社群后\n才能使用该功能" btnTitle:@"确定"];
            return;
        }
    }
    
    selectBtn.selected = NO;
    selectBtn = sender;
    selectBtn.selected = YES;
    
    NSInteger index = sender.tag - 100;
    [self setUpOneChildViewController:index];
    [_scrollView setContentOffset:CGPointMake(index*ScreenWidth, 0) animated:YES];
    [self changeRedLineFrame:sender.frame];
}

-(void)swipeOneOrTwo
{
    if (_isSwipe) {
        [self buttonClick:[self.view viewWithTag:101]];
    }
    else{
        [self buttonClick:[self.view viewWithTag:100]];
    }
}

- (void)setUpOneChildViewController:(NSUInteger)i
{
    UIViewController *vc = self.childViewControllers[i];
    
    if (vc.view.superview) {
        return;
    }
    
    if ([vc isKindOfClass:[AssociationDetailCtl class]]) {
        AssociationDetailCtl *detailCtl = (AssociationDetailCtl *)vc;
        detailCtl.isZbar = _isZbar;
        detailCtl.isMine_ = _isMine;
        detailCtl.isGroupPop = _isGroupPop;
        [detailCtl beginLoad:_groupId exParam:_groupsDataModal];
    }
    else if([vc isKindOfClass:[ELGroupIMListCtl class]]) {
        ELGroupIMListCtl *groupChatCtl = (ELGroupIMListCtl *)vc;
        [groupChatCtl beginLoad:_groupsDataModal exParam:nil];
    }
    
    vc.view.frame = CGRectMake(i*ScreenWidth, 0, self.view.frame.size.width, _scrollView.frame.size.height);
    [_scrollView addSubview:vc.view];
}

- (void)changeRedLineFrame:(CGRect)btnFrame
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = _redLine.frame;
        frame.origin.x = btnFrame.origin.x;
        _redLine.frame = frame;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x <= ScreenWidth && scrollView.contentOffset.x > ScreenWidth-10) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"startScroll" object:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

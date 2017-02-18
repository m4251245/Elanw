//
//  GroupsDetailCtl.m
//  Association
//
//  Created by YL1001 on 14-5-9.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "GroupsDetailCtl.h"
#import "UPdateGroupTagsCtl.h"
#import "RecommendArticleListCtl.h"
#import "GroupsZbarDetailCtl.h"
#import "ELPersonCenterCtl.h"
#import "ELGroupPersonDetialModel.h"
#import "ELGroupDetailModal.h"
#import "ELCreatChangeCtl.h"
#import "EditorPersonInfo.h"
#import "ELGroupDetailCtl.h"
#import "ELEditInfoCtl.h"
#import "ELNewsListDAO.h"

#import "InviteFansCtl.h"

@interface GroupsDetailCtl ()
{
    UIView  * memberListView_;
    NSMutableArray * btonArr_;
    NSString *groupId;
    
    __weak IBOutlet NSLayoutConstraint *introHeight;
    __weak IBOutlet NSLayoutConstraint *introViewHeight;
    __weak IBOutlet NSLayoutConstraint *permissionTopHeight;
    
    ELGroupDetailModal        *myDataModal_;
    __weak IBOutlet UISwitch *pushSwitch;
}

@end

@implementation GroupsDetailCtl

@synthesize delegate_,isQuitMember_;
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        imageConArr_ = [[NSMutableArray alloc] init];
        btonArr_ = [[NSMutableArray alloc] init];
//        rightNavBarStr_ = @"邀请成员";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"社群详情"];
    
    [createrDescLb_ setFont:FOURTEENFONT_CONTENT];
    [createrDescLb_ setTextColor:BLACKCOLOR];
    [createrLb_ setFont:FOURTEENFONT_CONTENT];
    [createrLb_ setTextColor:BLACKCOLOR];
    [memberCntLb_ setFont:FOURTEENFONT_CONTENT];
    [memberCntLb_ setTextColor:BLACKCOLOR];
    
    [groupNumDescLb_ setFont:FOURTEENFONT_CONTENT];
    [groupNumDescLb_ setTextColor:BLACKCOLOR];
    [groupNumLb_ setFont:FOURTEENFONT_CONTENT];
    [groupNumLb_ setTextColor:BLACKCOLOR];
    
    [tagsDescLb_ setFont:FOURTEENFONT_CONTENT];
    [tagsDescLb_ setTextColor:BLACKCOLOR];
    [tagsLb_ setFont:FOURTEENFONT_CONTENT];
    [tagsLb_ setTextColor:BLACKCOLOR];
    
    [introDescLb_ setFont:FOURTEENFONT_CONTENT];
    [introDescLb_ setTextColor:UIColorFromRGB(0x666666)];
    [introLb_ setFont: [UIFont fontWithName:@"STHeitiSC-Light" size:15]];
    [introLb_ setTextColor:UIColorFromRGB(0x666666)];
    
    groupPicImgv_.layer.cornerRadius = 2.0;
    groupPicImgv_.layer.masksToBounds = YES;
    
    [permissionLb_ setTextColor:BLACKCOLOR];
    [permissionLb_ setFont:FOURTEENFONT_CONTENT];
    
    [articleSetTitleLb_ setTextColor:BLACKCOLOR];
    [articleSetTitleLb_ setFont:FOURTEENFONT_CONTENT];
    
    [permissionBtn_.titleLabel setFont:FOURTEENFONT_CONTENT];
    [permissionBtn_ setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    
    [groupNameLb_ setTextColor:BLACKCOLOR];
    [groupNameLb_ setFont:FOURTEENFONT_CONTENT];
    
    [zbLb_ setFont:FOURTEENFONT_CONTENT];
    [zbLb_ setTextColor:BLACKCOLOR];
    
    memberView_.layer.cornerRadius = 4.0;
    detailView_.layer.cornerRadius = 4.0;
    introView_.layer.cornerRadius = 4.0;
    memberView_.layer.masksToBounds = YES;
    detailView_.layer.masksToBounds = YES;
    introView_.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGroupName:) name:@"kChangeGroupName" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.navigationItem.title = @"社群详情";
}

#pragma mark - 刷新舍长信息
- (void)personCenterUserInfoChang:(User_DataModal *)userModel
{
    myDataModal_.group_person_detail.person_iname = [Manager getUserInfo].name_;
    [createrLb_ setText:[Manager getUserInfo].name_];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    if ([dataModal isKindOfClass:[Groups_DataModal class]]) {
        Groups_DataModal *model = dataModal;
        groupId = model.id_;
    }else{
        groupId = dataModal;
    }
    
    [self requestGroupDetail];
    [self requestGroupPeopleList];

    [btonArr_ removeAllObjects];
    [memberListView_ removeFromSuperview];
}


-(void)getDataFunction:(RequestCon *)con
{
    
}

-(void)requestGroupDetail{
    NSString * userId = [Manager getUserInfo].userId_;
    if (!userId) {
        userId = @"";
    }
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"1" forKey:@"get_group_perm"];
    [conditionDic setObject:userId forKey:@"login_person_id"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&conditionArr=%@",groupId,conditionStr];
    NSString * function = @"getGroupInfoById";
    NSString * op = @"groups_busi";
    [BaseUIViewController showLoadView:YES content:@"正在加载" view:self.view];
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        [BaseUIViewController showLoadView:NO content:nil view:nil];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            myDataModal_ = [[ELGroupDetailModal alloc] initWithGroupDictionary:dic];
            [self refreshGroupDeital];
        }else{
            [BaseUIViewController showAlertViewContent:@"出错了，请稍后再试" toView:self.view second:1.0 animated:YES];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
        [BaseUIViewController showAlertViewContent:@"出错了，请稍后再试" toView:self.view second:1.0 animated:YES];
    }];
}

-(void)requestGroupPeopleList{
    NSString * userId = [Manager getUserInfo].userId_;
    if (!userId) {
        userId = @"";
    }
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"0" forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:@"1" forKey:@"re_person_detail"];
    [conditionDic setObject:userId forKey:@"re_person_rel"];
    [conditionDic setObject:@"1" forKey:@"re_permission"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
  
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:@"all" forKey:@"user_role"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&conditionArr=%@&searchArr=%@",groupId,conditionStr,searchStr];
    NSString * function = @"getGroupMember";
    NSString * op = @"groups_person";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            memberArr_ = [[NSMutableArray alloc] init];
            PageInfo *pageInfo = [[PageInfo alloc] initWithPageInfoDictionary:dic];
            NSArray *arr = [dic objectForKey:@"data"];
            if (![arr isKindOfClass:[NSNull class]]) {
                for ( NSDictionary *subDic in arr ) {
                    ELGroupPersonDetialModel *dataModal = [[ELGroupPersonDetialModel alloc] initWithDictionary:subDic];
                    dataModal.pageCnt_ = pageInfo.pageCnt_ ;
                    dataModal.totalCnt_ = pageInfo.totalCnt_;
                    [memberArr_ addObject:dataModal];
                }
            }
            [self updateMemberView:memberArr_];
            [memberView_ addSubview:memberListView_];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)refreshGroupDeital
{
    if (isQuitMember_) {
        permissionBtn_.alpha = 0.0;
    }
    else
    {
        if ([myDataModal_.group_person_detail.personId isEqualToString:[Manager getUserInfo].userId_]) {
            [permissionLb_ setText:@"社群设置"];
            [permissionBtn_ setTitle:@"" forState:UIControlStateNormal];
            inviteBtn_.alpha = 1.0;
            [introJianTou_ setHidden:NO];
            [tagsJianTou_ setHidden:NO];
            [rightBarBtn_ setHidden:NO];
            [groupSetImgv_ setHidden:NO];
            [groupPicBtn_ setUserInteractionEnabled:YES];
            groupNameArrow.hidden = NO;
        }
        else
        {
            [permissionLb_ setText:@""];
            [permissionBtn_ setTitle:@"退出社群" forState:UIControlStateNormal];
            [introJianTou_ setHidden:YES];
            [tagsJianTou_ setHidden:YES];
            [groupSetImgv_ setHidden:YES];
            [groupPicBtn_ setUserInteractionEnabled:NO];
            groupNameArrow.hidden = YES;
        }
    }
    
    myDataModal_.group_name = [MyCommon translateHTML:myDataModal_.group_name];
    myDataModal_.group_person_detail.person_iname = [MyCommon translateHTML:myDataModal_.group_person_detail.person_iname];
    myDataModal_.group_tag_names = [MyCommon translateHTML:myDataModal_.group_tag_names];
    myDataModal_.group_intro = [MyCommon translateHTML:myDataModal_.group_intro];
    
    [groupNameLb_ setText:myDataModal_.group_name];
    createrLb_.text = [NSString stringWithFormat:@"%@",myDataModal_.group_person_detail.person_iname];
    tagsLb_.text = [NSString stringWithFormat:@"%@",myDataModal_.group_tag_names];
    groupNumLb_.text = myDataModal_.group_number;
    memberCntLb_.text = [NSString stringWithFormat:@"群成员(%@)",[NSString changeNullOrNil:myDataModal_.group_person_cnt]];
    if ([myDataModal_.group_intro isEqualToString:@""] || myDataModal_.group_intro == nil) {
        [introLb_ setText:@"这是一个神秘的社群，什么也没透露！"];
        [introLb_ setTextColor:GRAYCOLOR];
    }else{
        [introLb_ setText:myDataModal_.group_intro];
        [introLb_ setTextColor:BLACKCOLOR];
    }
    [self changFrame];
    [groupPicImgv_ sd_setImageWithURL:[NSURL URLWithString:myDataModal_.group_pic] placeholderImage:[UIImage imageNamed:@"icon_zhiysq.png"]];
    [myscrollView_ setHidden:NO];
    
    
    //消息免打扰  1接收 2不接收
    if([myDataModal_.setcode isEqualToString:@"1"]){
        [pushSwitch setOn:NO];
    }
    else if([myDataModal_.setcode isEqualToString:@"2"]){
        [pushSwitch setOn:YES];
    }

}

-(void)errorGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type{
    [super errorGetData:requestCon code:code type:type];
    [BaseUIViewController showLoadView:NO content:nil view:nil];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_QuitGroup:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [BaseUIViewController showAutoDismissAlertView:@"退出成功" msg:nil seconds:1.0];
                if ([delegate_ respondsToSelector:@selector(quitGroupSuccess)]) {
                    [delegate_ quitGroupSuccess];
                }
                ELNewsListDAO *listDao = [ELNewsListDAO new];
                [listDao deleteData:groupId type:@"group_chat_msg"];
                
                UIViewController *tmpCtl = nil;
                for ( UIViewController *ctl in self.navigationController.viewControllers ) {
                    if( [ctl isKindOfClass:[ELGroupDetailCtl class]] ){
                        break;
                    }else{
                        tmpCtl = ctl;
                    }
                }
                
                [self.navigationController popToViewController:tmpCtl animated:YES];
            }
            else
            {
                [BaseUIViewController showAlertView:@"退出失败" msg:dataModal.des_ btnTitle:@"确定"];
            }
        }
            break;
        default:
            break;
    }
}


-(void)updateMemberView:(NSArray*)array
{
    static int max = 0;
    memberListView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 70, ScreenWidth-16, 70)];
    for (int i = 0; i < [array count]; ++i) {
        if (i >= 3) {
            break;
        }
        max = i+1;
        ELGroupPersonDetialModel *dataModal = [array objectAtIndex:i];
        UIButton * bton = [UIButton buttonWithType:UIButtonTypeCustom];
        bton.layer.cornerRadius = 4.0;
        bton.layer.masksToBounds = YES;
        [bton sd_setImageWithURL:[NSURL URLWithString:dataModal.group_person_detail.person_pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
        [bton setFrame:CGRectMake(9+59*(i%6), 8+75*(i/6), 50, 50)];
        bton.tag = i+1000;
        [bton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel  * nameLb = [[UILabel alloc] initWithFrame:CGRectMake(bton.frame.origin.x, bton.frame.origin.y+50, 50, 14)];
        [nameLb setTextColor:GRAYCOLOR];
        [nameLb setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10]];
        nameLb.textAlignment = NSTextAlignmentCenter;
//        if (dataModal.nickname_ == nil || ![dataModal.nickname_ isKindOfClass:[NSString class]]||[dataModal.nickname_ isEqual:[NSNull null]]|| [dataModal.nickname_ isEqualToString:@""]) {
//            dataModal.nickname_ = dataModal.iname_;
//        }
//        if ([dataModal.nickname_ isKindOfClass:[NSNumber class]]) {
//            dataModal.nickname_ = @"";
//        }
        nameLb.text = dataModal.group_person_detail.person_iname;
        [btonArr_ addObject:bton];
        [memberListView_ addSubview:bton];
        [memberListView_ addSubview:nameLb];
    }
    
    UIButton *abutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [abutton setFrame:CGRectMake(9+59*(max%6), 8+75*(max/6), 50, 50)];
//    [abutton setBackgroundColor:[UIColor clearColor]];
    [abutton setBackgroundImage:[UIImage imageNamed:@"group_addmember@2x"] forState:UIControlStateNormal];
    abutton.tag = 5001;
    [abutton addTarget:self action:@selector(addbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [memberListView_ addSubview:abutton];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(260, 0, [UIScreen mainScreen].bounds.size.width-280, 70)];
    [button setBackgroundColor:[UIColor clearColor]];
    button.tag = 5000;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [memberListView_ addSubview:button];
}

#pragma mark - event response
- (void)updateGroupName:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
    groupNameLb_.text = dic[@"groupName"];
}

- (void)rightBarBtnResponse:(id)sender
{
    if ([myDataModal_.member_invite boolValue]) {
        if (!groupInviteCtl_) {
            groupInviteCtl_ = [[GroupsInviteCtl alloc] init];
        }
        [self.navigationController pushViewController:groupInviteCtl_ animated:YES];
        [groupInviteCtl_ beginLoad:myDataModal_ exParam:nil];
    }
    else {
        [BaseUIViewController showAutoDismissSucessView:nil msg:@"您还没有邀请权限\n请联系社长吧！"];
    }
}

#pragma mark-- '+'加人
- (void)addbtnClick:(id)sender{
    InviteFansCtl * inviteFansCtl_ = [[InviteFansCtl alloc] init];
    [self.navigationController pushViewController:inviteFansCtl_ animated:YES];
    inviteFansCtl_.myDataModal = myDataModal_;
    [inviteFansCtl_ beginLoad:nil exParam:nil];
}

-(void)btnResponse:(id)sender
{
    if (sender == createrBtn_) {
        ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
        [self.navigationController pushViewController:personCenterCtl animated:NO];
        [personCenterCtl beginLoad:myDataModal_.group_person_detail.personId exParam:nil];
    }
    else if (sender == inviteBtn_)
    {
        if (!groupInviteCtl_) {
            groupInviteCtl_ = [[GroupsInviteCtl alloc] init];
        }
        [self.navigationController pushViewController:groupInviteCtl_ animated:YES];
        [groupInviteCtl_ beginLoad:myDataModal_ exParam:nil];
    }
    else if(sender == permissionBtn_)
    {
        if ([myDataModal_.group_person_detail.personId isEqualToString:[Manager getUserInfo].userId_]) {
            ELCreatChangeCtl *changeCtl = [[ELCreatChangeCtl alloc] init];
            changeCtl.selectModel = [[ELGroupChangeTypeModel alloc] init];
            changeCtl.dataType = AllType;
            changeCtl.isFromGroup = YES;
            changeCtl.groupId = myDataModal_.group_id;
            [self.navigationController pushViewController:changeCtl animated:YES];
            //设置权限
//            if (!groupPermissionCtl_) {
//                groupPermissionCtl_ = [[GroupPermissionCtl alloc] init];
//            }
//            [self.navigationController  pushViewController:groupPermissionCtl_ animated:YES];
//            [groupPermissionCtl_ beginLoad:myDataModal_.group_id exParam:nil];
        }
        else
        {
            //退出社群
            [self showChooseAlertView:1 title:@"确认退出？" msg:@"退出社群后将无法查看该社群信息" okBtnTitle:@"退出" cancelBtnTitle:@"取消"];
        }
    } else if (sender == tagsBtn_){
        if (![myDataModal_.group_person_detail.personId isEqualToString:[Manager getUserInfo].userId_]) {
            return;
        }
        UPdateGroupTagsCtl *ctl = [[UPdateGroupTagsCtl alloc]init];
        [ctl beginLoad:myDataModal_ exParam:nil];
        ctl.delegate_ = self;
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (sender == introBtn_){
        if (![myDataModal_.group_person_detail.personId isEqualToString:[Manager getUserInfo].userId_]) {
            return;
        }
        UpdateGroupIntroCtl *ctl = [[UpdateGroupIntroCtl alloc]init];
        [ctl beginLoad:myDataModal_ exParam:nil];
        ctl.delegate_ = self;
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (sender == articleSetBtn_){
        if ([myDataModal_.group_person_detail.personId isEqualToString:[Manager getUserInfo].userId_]) {
            if ([myDataModal_.group_article_cnt integerValue] ==0) {
                [BaseUIViewController showAlertView:@"温馨提示" msg:@"没有可管理的文章,快去发表文章吧!" btnTitle:@"知道了"];
                return;
            }
            
            RecommendArticleListCtl *recommendClt = [[RecommendArticleListCtl alloc]init];
            [recommendClt beginLoad:myDataModal_.group_id exParam:nil];
            [self.navigationController pushViewController:recommendClt animated:YES];
        }else{
            [BaseUIViewController showAlertView:@"没有管理话题权限" msg:nil btnTitle:@"知道了"];
        }
        
    }else if (sender == groupPicBtn_){
        //修改社群头像
        UpdateGroupPhotoCtl *updateGroupCtl = [[UpdateGroupPhotoCtl alloc]init];
        updateGroupCtl.inType = UPDATEGROUPPHOTO;
        [updateGroupCtl beginLoad:myDataModal_ exParam:nil];
        updateGroupCtl.delegate = self;
        [self.navigationController pushViewController:updateGroupCtl animated:YES];
    }else if(sender == zbarBtn_){
        GroupsZbarDetailCtl *zbarCtl = [[GroupsZbarDetailCtl alloc] init];
       // zbarCtl.groupImage.image = groupPicImgv_.image;
        zbarCtl.myDataModal = myDataModal_;
        [self.navigationController pushViewController:zbarCtl animated:YES];
    }else if (sender == changeGroupNameBtn){//修改社群名称
        if (![myDataModal_.group_person_detail.personId isEqualToString:[Manager getUserInfo].userId_]) {
            
            return;
        }
        ELEditInfoCtl *editorCtl = [[ELEditInfoCtl alloc] init];
        [self.navigationController pushViewController:editorCtl animated:YES];
        [editorCtl beginLoad:myDataModal_ exParam:nil];
    }
    
    else{
        UIButton * bton = (UIButton*)sender;
        NSLog(@"%ld",(long)bton.tag);
        NSLog(@"%lu",(unsigned long)[btonArr_ count]);
        if (bton.tag < [btonArr_ count]+1000) {
            ELGroupPersonDetialModel *dataModal = [memberArr_ objectAtIndex:bton.tag-1000];
            if ([dataModal.group_person_detail.personId isEqualToString:[Manager getUserInfo].userId_]) {
                return;
            }
            ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
            [self.navigationController pushViewController:personCenterCtl animated:NO];
            [personCenterCtl beginLoad:dataModal.group_person_detail.personId exParam:nil];
        }
        else if(bton.tag == 5000)
        {
            if (!groupMemberCtl_) {
                groupMemberCtl_ = [[GroupMemberCtl alloc] init];
            }
            groupMemberCtl_.myDataModal = myDataModal_;
            [self.navigationController pushViewController:groupMemberCtl_ animated:YES];
            [groupMemberCtl_ beginLoad:myDataModal_.group_id exParam:nil];
        }
    }
}

- (IBAction)pushSwitchClick:(id)sender {
    
    if (sender == pushSwitch) {
        if (pushSwitch.isOn == YES) {
            pushSwitch.on = YES;
            [self pushSet:@"2"];
        }
        else
        {
            pushSwitch.on = NO;
            [self pushSet:@"1"];
        }
    }
}

- (void)pushSet:(NSString *)str
{
    NSString *op= @"groups_busi";
    NSString *func= @"set_group_push_setting";
    
    NSString *body = [NSString stringWithFormat:@"group_id=%@&person_id=%@&setcode=%@", myDataModal_.group_id, [Manager getUserInfo].userId_, str];
    
    [ELRequest postbodyMsg:body op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dic = result;
        Status_DataModal *statusModal = [[Status_DataModal alloc] init];
        statusModal.status_ = [dic objectForKey:@"status"];
        statusModal.code_ = [dic objectForKey:@"code"];
        statusModal.status_desc = [dic objectForKey:@"status_desc"];
        
        if ([statusModal.code_ isEqualToString:@"200"]) {
            myDataModal_.setcode = str;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kChangeGroupName" object:nil userInfo:@{@"groupPushSet":str,@"groupName":myDataModal_.group_name}];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch (type) {
        case 1:
        {
            if (!quitCon_) {
                quitCon_ = [self getNewRequestCon:NO];
            }
            [quitCon_ quitGroups:groupId userId:[Manager getUserInfo].userId_];
        }
            break;
            
        default:
            break;
    }
}

- (void)changFrame
{
    //社群简介不为空
       CGSize size = [myDataModal_.group_intro sizeNewWithFont:FIFTEENFONT_TITLE constrainedToSize:CGSizeMake(ScreenWidth-104,100000)];
       
       CGRect  introLbRect =  introLb_.frame;
       if (![myDataModal_.group_intro isEqualToString:@""] && myDataModal_.group_intro != nil) {
           if (size.height > 72) {
               introLbRect.size.height = size.height;
           }else{
               introLbRect.size.height = 72;
           }
       }else{
           introLbRect.size.height = 72;
       }
       introViewHeight.constant = introLbRect.size.height+61;
       introHeight.constant = introLbRect.size.height;
       
       if (![myDataModal_.group_person_detail.personId isEqualToString:[Manager getUserInfo].userId_]){
           articleSetView_.hidden = YES;
           permissionTopHeight.constant = 8;
       }else{
           articleSetView_.hidden = NO;
           permissionTopHeight.constant = 56;
       }

}

#pragma mark --delegate
- (void)updateGroupIntroSuccess
{
    introLb_.text = myDataModal_.group_intro;
    [self changFrame];
}

- (void)updateTagsSuccess
{
    tagsLb_.text = [NSString stringWithFormat:@"%@",myDataModal_.group_tag_names];
}

- (void)updateGroupPhotoSuccess:(NSString *)groupImg
{
    [groupPicImgv_ sd_setImageWithURL:[NSURL URLWithString:groupImg]];
    myDataModal_.group_pic = groupImg;
    if ([delegate_ respondsToSelector:@selector(updateGroupImgSuccess:)]) {
        [delegate_ updateGroupImgSuccess:groupImg];
    }
}

@end

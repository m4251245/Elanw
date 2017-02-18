//
//  GroupsInviteCtl.m
//  Association
//
//  Created by YL1001 on 14-5-12.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "GroupsInviteCtl.h"
#import "Inviteinfo_DataModal.h"
#import "GroupsInviterCell.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "YLAddressBookListCtl.h"
#import "ELGroupDetailModal.h"

#import "InviteFansCtl.h"

@interface GroupsInviteCtl ()
{
    BOOL _isWXAppInstalled;
    BOOL _isQQInstalled;
    YLAddressBookListCtl *addressBookCtl;
    Groups_DataModal     * inModal_;
    InviteFansCtl        * inviteFansCtl_;
}

@end

@implementation GroupsInviteCtl

-(id)init
{
    self  = [super init];
    
    bFooterEgo_ = NO;
    bHeaderEgo_ = NO;
    
    if ([WXApi isWXAppInstalled]) {
        _isWXAppInstalled = YES;
    }
    
    if ([QQApiInterface isQQInstalled]) {
        _isQQInstalled = YES;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"邀请好友";
    [self setNavTitle:@"邀请好友"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    if ([dataModal isKindOfClass:[ELGroupDetailModal class]]) {
        ELGroupDetailModal *modal = dataModal;
        inModal_ = [[Groups_DataModal alloc] init];
        inModal_.id_ = modal.group_id;
        inModal_.name_ = modal.group_name;
        inModal_.groupCode_ = modal.group_number;
    }else{
       inModal_ = dataModal; 
    }
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    //[con getInviteSMS:inModal_.id_ name:inModal_.name_ number:inModal_.groupCode_];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    switch (section ) {
        case 0:
        {
            return 15;
        }
            break;
        case 1:
        case 2:
        {
            return 0.000001;
        }
            break;
        default:
            break;
    }
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.000001)];
    view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupsInviterCell";
    
    GroupsInviterCell *cell = (GroupsInviterCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GroupsInviterCell" owner:self options:nil] lastObject];

    }
    [cell.itemLb_ setTextColor:BLACKCOLOR];
    [cell.itemLb_ setFont:SEVENTEENFONT_FRISTTITLE];
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                [cell.itemImgv_ setImage:[UIImage imageNamed:@"weixin.png"]];
                [cell.itemLb_ setText:@"微信邀请"];
            }else if (indexPath.row == 1){
                [cell.itemImgv_ setImage:[UIImage imageNamed:@"pengyou.png"]];
                [cell.itemLb_ setText:@"朋友圈邀请"];
//                [cell.rightImgv_ setHidden:YES];
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                [cell.itemImgv_ setImage:[UIImage imageNamed:@"QQiocn.png"]];
                [cell.itemLb_ setText:@"QQ好友邀请"];
            }else if (indexPath.row == 1){
                [cell.itemImgv_ setImage:[UIImage imageNamed:@"tongxunlu.png"]];
                [cell.itemLb_ setText:@"通讯录邀请"];
                [cell.rightImgv_ setHidden:YES];
            }
            
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                [cell.itemImgv_ setImage:[UIImage imageNamed:@"yl.png"]];
                [cell.itemLb_ setText:@"一览站内邀请"];
            }else if (indexPath.row == 1){
                [cell.itemImgv_ setImage:[UIImage imageNamed:@"link.png"]];
                [cell.itemLb_ setText:@"复制链接"];
                [cell.rightImgv_ setHidden:YES];
            }
        }
            break;
        default:
            break;
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (!_isWXAppInstalled) {
            return 0;
        }
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        if (!_isQQInstalled) {
            return 0;
        }
    }
    return 48;
}


-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                //微信好友
                [self share:UMSocialPlatformType_WechatSession];
            }else if (indexPath.row == 1){
                //微信朋友圈
                [self share:UMSocialPlatformType_WechatTimeLine];
            }
        }
            break;
        case 1:
        {
            
            if (indexPath.row == 0) {
                //QQ好友
                
                [self share:UMSocialPlatformType_QQ];
            }else if (indexPath.row == 1){
                if ([MFMessageComposeViewController canSendText])
                {
                    ABAddressBookRef addressBooks = nil;
                    
                    addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
                    
                    //获取通讯录权限
                    
                    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                    
                    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
                    
                    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                    
                    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized)
                    {
                        [BaseUIViewController showAlertView:@"无权访问通讯录" msg:@"请在系统设置中设置访问权限" btnTitle:@"确定"];
                        return ;
                    }
                    if (!addressBooks)
                    {
                        return ;
                    }
                    BOOL isFirst = NO;
                    if (!addressBookCtl) {
                        addressBookCtl = [[YLAddressBookListCtl alloc] init];
                        isFirst = YES;
                    }
                    addressBookCtl.groupModal = inModal_;
                    addressBookCtl.whereForm = @"GROUP";
                    //_phoneCount = 0;
                    //[tableView_ reloadData];
                    //[[Manager shareMgr].messageCenterListCtl refreshAddressBookRedDot];
                    [self.navigationController pushViewController:addressBookCtl animated:YES];
                    
                    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"addressBookTelephoneList"];
                    NSArray *arrOne = [[NSUserDefaults standardUserDefaults] objectForKey:@"userListId"];
                    NSString *currentPersonId = [[NSUserDefaults standardUserDefaults] objectForKey:@"addressBookCurrentPersonId"];
                    if (arr == nil || arrOne == nil || ![arrOne containsObject:[Manager getUserInfo].userId_])
                    {
                        
                    }
                    else if(isFirst || ![currentPersonId isEqualToString:[Manager getUserInfo].userId_])
                    {
                        [BaseUIViewController showLoadView:YES content:nil view:nil];
                    }
                }
                else
                {
                    [BaseUIViewController showAlertView:@"设备没有短信功能" msg:nil btnTitle:@"关闭"];
                }
            }
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                if (!inviteFansCtl_) {
                    inviteFansCtl_ = [[InviteFansCtl alloc] init];
                }
                [self.navigationController pushViewController:inviteFansCtl_ animated:YES];
                [inviteFansCtl_ beginLoad:inModal_ exParam:nil];
            }else if (indexPath.row == 1){
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = [NSString stringWithFormat:@"http://m.yl1001.com/group/v/%@/",inModal_.id_];
                [BaseUIViewController showAlertView:@"复制社群链接成功" msg:nil btnTitle:@"确定"];
            }
        }
            break;
        default:
            break;
    }
    
}

//按类型进行分享
-(void)share:(NSInteger)shareType
{
    UIImage *image = nil;
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1024"  ofType:@"png"];
    
    if (inModal_.pic_ && ![inModal_.pic_ isEqualToString:@""]) {
        imagePath = inModal_.pic_;
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:inModal_.pic_]]];
    }else{
        image = [UIImage imageWithContentsOfFile:imagePath];
    }
    
    NSString * sharecontent = @"点我加入吧~（点我点我点我~）";
    
    NSString * titlecontent = [NSString stringWithFormat:@"我邀请你加入一览社群“%@”，群号%@.",inModal_.name_,inModal_.groupCode_];
    
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/group/v/%@/",inModal_.id_];
    
    //调用分享
    [[ShareManger sharedManager] shareSingleWithType:[NSString stringWithFormat:@"%ld",(long)shareType] ctl:self title:titlecontent content:sharecontent image:image url:url];
}

-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
}

-(void)backBarBtnResponse:(id)sender
{
    if (_fromCreatGroup) {
        if ([Manager shareMgr].creatGroupStartIndex > 0)
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[Manager shareMgr].creatGroupStartIndex-1]animated:YES];
        }
        else
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
    }
    else
    {
        [super backBarBtnResponse:sender];
    }
}

-(void)btnResponse:(id)sender
{
    
}


@end

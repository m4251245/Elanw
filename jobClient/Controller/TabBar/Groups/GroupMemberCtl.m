//
//  GroupMemberCtl.m
//  Association
//
//  Created by YL1001 on 14-5-13.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "GroupMemberCtl.h"
#import "InviteFansCtl_Cell.h"
#import "NoLoginPromptCtl.h"
#import "ELPersonCenterCtl.h"
#import "SameTradeCell.h"

#import "ELGroupDetailModal.h"

@interface GroupMemberCtl () <NoLoginDelegate>
{
    NSInteger index_;
    NSString *groupId;
}

@end

@implementation GroupMemberCtl

-(id)init
{
    self = [super init];
    imageConArr_ = [[NSMutableArray alloc] init];
    bFooterEgo_ = YES;
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
    [self setNavTitle:@"社群成员"];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    groupId = dataModal;
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    NSString * userId = [Manager getUserInfo].userId_;
    [con getGroupMember:groupId page:requestCon_.pageInfo_.currentPage_ pageSize:20 userId:userId userRole:@"all"];
}


-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELSameTradePeopleFrameModel *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    static NSString *identifier = @"cell";
    SameTradeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SameTradeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.hideDynamic = YES;
    cell.peopleModel = model;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"移除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self removeMembersOfGroup:indexPath];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}


-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    ELSameTradePeopleFrameModel * model = selectData;
    if ([model.peopleModel.person_id isEqualToString:[Manager getUserInfo].userId_]) {
        return;
    }
    ELPersonCenterCtl *detailCtl = [[ELPersonCenterCtl alloc]init];
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:model.peopleModel.person_id exParam:nil];

    
}

- (void)removeMembersOfGroup:(NSIndexPath *)index
{
    ELSameTradePeopleFrameModel * model = [requestCon_.dataArr_ objectAtIndex:index.row];
    NSString *bodyMsg = [NSString stringWithFormat:@"group_id=%@&request_person_id=%@&respone_person_id=%@&conditionArr=", groupId, [Manager getUserInfo].userId_, model.peopleModel.person_id];
    
    [BaseUIViewController showLoadView:YES content:@"正在移除成员" view:self.view];
    [ELRequest postbodyMsg:bodyMsg op:@"groups_person" func:@"doRequestRemove" requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
        
        [BaseUIViewController showLoadView:NO content:nil view:self.view];
        
        NSDictionary *dic = result;
        Status_DataModal *model = [[Status_DataModal alloc] init];
        model.code_ = [dic objectForKey:@"code"];
        model.status_ = [dic objectForKey:@"status"];
        model.des_ = [dic objectForKey:@"status_desc"];
        
        if (model.code_.integerValue == 200) {
            [requestCon_.dataArr_ removeObjectAtIndex:index.row];
            [tableView_ reloadData];
        }
        
        [BaseUIViewController showAutoDismissSucessView:nil msg:model.des_ seconds:2.0];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:self.view];
    }];
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}
- (IBAction)addBtnClick:(id)sender {
    if ([_myDataModal.member_invite boolValue]) {
        GroupsInviteCtl * groupInviteCtl_ = [[GroupsInviteCtl alloc] init];
        [self.navigationController pushViewController:groupInviteCtl_ animated:YES];
        [groupInviteCtl_ beginLoad:_myDataModal exParam:nil];
    }
    else {
        [BaseUIViewController showAutoDismissSucessView:nil msg:@"您还没有邀请权限\n请联系社长吧！"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

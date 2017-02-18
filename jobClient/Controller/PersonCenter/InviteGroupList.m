//
//  InviteGroupList.m
//  jobClient
//
//  Created by 一览ios on 14-12-31.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "InviteGroupList.h"
#import "InveteGroupCell.h"
#import "Groups_DataModal.h"

@interface InviteGroupList ()

@end

@implementation InviteGroupList

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        bHeaderEgo_ = YES;
        bFooterEgo_ = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//     self.navigationItem.title = @"邀请加入";
    [self setNavTitle:@"邀请加入"];
}

-(void)reciveNewMesageAction:(NSNotificationCenter *)notifcation
{
    
}
- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    _personCenterModel = dataModal;
}

- (void)getDataFunction:(RequestCon *)con
{
    [con getInveteGroupWithUserId:[Manager getUserInfo].userId_ vistorId:_personCenterModel.userModel_.id_];
}

#pragma mark  UITableViewCell 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELLIDENTIFIER = @"InveteGroupCell";
    InveteGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InveteGroupCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    Groups_DataModal *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    [cell initCellWithGroupData:model indexPath:indexPath inviteGroupList:self];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (void)inveteBtnClick:(UIButton *)button
{
    _indexValue = button.tag-1000;
   Groups_DataModal *model =  [requestCon_.dataArr_ objectAtIndex:_indexValue];
    if (!inviteCon_) {
        inviteCon_ = [self getNewRequestCon:NO];
    }
     [inviteCon_ inviteFans:model.id_ userId:[Manager getUserInfo].userId_ fansId:_personCenterModel.userModel_.id_];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_InviteFans:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.code_ isEqualToString:@"3"] || [dataModal.code_ isEqualToString:@"200"]) {
                [BaseUIViewController showAlertView:@"发送邀请成功" msg:@"请耐心等待回应！" btnTitle:@"确定"];
                Groups_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:_indexValue];
                dataModal.invitePerm_ = YES;
                [tableView_ reloadData];
            }else if([dataModal.code_ isEqualToString:@"201"]){
                [BaseUIViewController showAutoDismissSucessView:@"发送邀请成功" msg:nil];
                Groups_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:_indexValue];
                dataModal.invitePerm_ = YES;
                [tableView_ reloadData];
            }else{
                [BaseUIViewController showAlertView:@"发送邀请失败" msg:@"请稍后再试" btnTitle:@"确定"];
            }
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

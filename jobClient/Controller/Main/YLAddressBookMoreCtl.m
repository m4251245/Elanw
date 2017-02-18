//
//  YLAddressBookMoreCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/6/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "YLAddressBookMoreCtl.h"


@interface YLAddressBookMoreCtl ()
{
    RequestCon *attentionCon_;
    UIButton *followBtn;
    RequestCon *sendCon;
    RequestCon *inviteCon_;
}
@end

@implementation YLAddressBookMoreCtl

-(instancetype)init
{
    self = [super init];
    if (self) {
        bFooterEgo_ = YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"一览通讯录好友";
    [self setNavTitle:@"一览通讯录好友"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}
-(void)getDataFunction:(RequestCon *)con
{
    if (!con) {
        con = [self getNewRequestCon:NO];
    }
    
    NSString *groupId = @"";
    if ([_whereForm isEqualToString:@"GROUP"]) {
        groupId = _groupModal.id_;
    }
    
    [con addressBookListPage:requestCon_.pageInfo_.currentPage_ pageSize:15 personId:[Manager getUserInfo].userId_ ylPerson:NO groupId:groupId];
}
-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_AddressBookList:
        {
            NSMutableArray *arrData = [[NSMutableArray alloc] initWithArray:requestCon_.dataArr_];
            [requestCon_.dataArr_ removeAllObjects];
            for (YLAddressBookModal *modalOne in arrData) {
                if ([_listDataDic objectForKey:modalOne.phoneNumber]) {
                    [requestCon_.dataArr_ addObject:modalOne];
                }
            }
            [tableView_ reloadData];
        }
            break;
        case Request_Follow:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"])
            {
                YLAddressBookModal *modal = requestCon_.dataArr_[followBtn.tag];
                [_addFollowDelegate addressBookAddFollew:modal.personId];
                modal.follow_rel = @"1";
                [followBtn setTitle:@"已添加" forState:UIControlStateNormal];
                [followBtn setBackgroundColor:WhiteColor];
                [followBtn setTitleColor:UIColorFromRGB(0xb9b9b9) forState:UIControlStateNormal];
                followBtn.userInteractionEnabled = NO;
                followBtn.layer.borderColor = 0;
                followBtn.layer.borderColor = [UIColor whiteColor].CGColor;
                [BaseUIViewController showAutoDismissSucessView:@"添加成功" msg:nil seconds:0.5];
            }else{
                [BaseUIViewController showAutoDismissFailView:@"添加失败" msg:nil seconds:0.5];
            }
        }
            break;
        default:
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"YLAddressBookTwoCell";
    YLAddressBookTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YLAddressBookTwoCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleImage.clipsToBounds = YES;
        cell.titleImage.layer.cornerRadius = 4.0f;
        cell.nameLb.font = TWEELVEFONT_COMMENT;
        cell.contentLable.font = FOURTEENFONT_CONTENT;
    }
    YLAddressBookModal *modal = requestCon_.dataArr_[indexPath.row];
    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:modal.pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    
    cell.nameLb.text = [NSString stringWithFormat:@"手机联系人：%@",[self.listDataDic objectForKey:modal.phoneNumber]];
    cell.contentLable.text = modal.name;
    
    if (![modal.follow_rel isEqualToString:@"1"] || [_whereForm isEqualToString:@"GROUP"]) {
        [cell.addBtn setBackgroundColor:UIColorFromRGB(0xfafafa)];
        [cell.addBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
        if ([_whereForm isEqualToString:@"GROUP"]) {
             [cell.addBtn setTitle:@"邀请" forState:UIControlStateNormal];
        }
        else
        {
            [cell.addBtn setTitle:@"添加" forState:UIControlStateNormal];
        }
        cell.addBtn.userInteractionEnabled = YES;
        cell.addBtn.tag = indexPath.row;
        [cell.addBtn addTarget:self action:@selector(addFollew:) forControlEvents:UIControlEventTouchUpInside];
        cell.addBtn.layer.borderWidth = 1.0;
        cell.addBtn.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
        cell.addBtn.clipsToBounds = YES;
        cell.addBtn.layer.cornerRadius = 3.0;
    }
    else
    {
        cell.addBtn.userInteractionEnabled = NO;
        [cell.addBtn setBackgroundColor:[UIColor whiteColor]];
        [cell.addBtn setTitle:@"已添加" forState:UIControlStateNormal];
        [cell.addBtn setTitleColor:UIColorFromRGB(0xb9b9b9) forState:UIControlStateNormal];
        cell.addBtn.layer.borderColor = 0;
        cell.addBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}
-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    if ([_whereForm isEqualToString:@"GROUP"]) {
        return;
    }
    YLAddressBookModal *dataModal = requestCon_.dataArr_[indexPath.row];
    MessageContact_DataModel *modal = [[MessageContact_DataModel alloc] init];
    modal.userId = dataModal.personId;
    modal.userIname = dataModal.name;
    MessageDailogListCtl *ctl = [[MessageDailogListCtl alloc]init];
    [self.navigationController pushViewController:ctl animated:YES];
    [ctl beginLoad:modal exParam:nil];
    
    if (!sendCon) {
        sendCon = [self getNewRequestCon:NO];
    }
    [sendCon sendAddressBookFriend:[Manager getUserInfo].userId_ contactId:dataModal.personId];
}
-(void)addFollew:(UIButton *)sender
{
    YLAddressBookModal *modal = requestCon_.dataArr_[sender.tag];
    if ([_whereForm isEqualToString:@"GROUP"])
    {
        if ([modal.group_rel isEqualToString:@"20"]) {
            [BaseUIViewController showAlertView:@"该联系人已经是社群成员" msg:nil btnTitle:@"确定"];
            return;
        }
        if (!inviteCon_) {
            inviteCon_ = [self getNewRequestCon:NO];
        }
        [inviteCon_ inviteFans:_groupModal.id_ userId:[Manager getUserInfo].userId_ fansId:modal.personId];
        [BaseUIViewController showAutoDismissSucessView:@"发送邀请成功" msg:nil];
        return;
    }
    followBtn = sender;
    
    if (!attentionCon_) {
        attentionCon_ = [self getNewRequestCon:NO];
    }
    [attentionCon_ followExpert:[Manager getUserInfo].userId_ expert:modal.personId];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

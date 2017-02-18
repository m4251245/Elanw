//
//  YLWhoLikeMeListCtl.m
//  jobClient
//
//  Created by 一览iOS on 15-5-15.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "YLWhoLikeMeListCtl.h"
#import "MessageListCell.h"
#import "MessageContact_DataModel.h"
//#import "MessageDailogListCtl.h"
#import "ELPersonCenterCtl.h"

@interface YLWhoLikeMeListCtl ()
{
    RequestCon *deleteMessageCon;
}
@end

@implementation YLWhoLikeMeListCtl

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.navigationItem.title = @"谁赞了我";
    [self setNavTitle:@"谁赞了我"];
    bFooterEgo_ = YES;
    
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
    NSString *userId = @"";
    if ([Manager getUserInfo].userId_) {
        userId = [Manager getUserInfo].userId_;
    }
    [con getWhoLikeMeListPersonId:userId page:requestCon_.pageInfo_.currentPage_ pageSize:15];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_deleteWhoLikeMeMessage:
        {

        }
            break;
        default:
            break;
    }
    
}

#pragma amrk - UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MessageListCell";
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageListCell" owner:self options:nil] lastObject];
        cell.countLbWidth.constant = 8;
        cell.countLbLeading.constant = 36;
        cell.countLb.layer.cornerRadius = 4.0;
        cell.countLb.layer.masksToBounds = YES;
        cell.countLb.hidden = YES;
        ELLineView *line = [[ELLineView alloc] initWithFrame:CGRectMake(16,66,ScreenWidth-10,1) WithColor:UIColorFromRGB(0xe0e0e0)];
        [cell.contentView addSubview:line];
    }
    [cell giveDataModal:requestCon_.dataArr_[indexPath.row]];
//    cell.countLb.hidden = NO;
    cell.imagev.tag = 100+indexPath.row;
    cell.imagev.userInteractionEnabled = YES;
    [cell.imagev addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personImageBtnRespone:)]];
    return cell;
}

-(void)personImageBtnRespone:(UITapGestureRecognizer *)sender
{
    WhoLikeMeDataModal *model = requestCon_.dataArr_[sender.view.tag-100];
    if (model.personId.length > 0)
    {
        ELPersonCenterCtl *ctl = [[ELPersonCenterCtl alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
        [ctl beginLoad:model.personId exParam:nil];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}
-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    WhoLikeMeDataModal *dataModal = requestCon_.dataArr_[indexPath.row];
    if(![dataModal.personId isEqualToString:[Manager getUserInfo].userId_] && dataModal.article_id.length > 0)
    {
        Article_DataModal * dataModalOne = [[Article_DataModal alloc] init];
        dataModalOne.id_ = dataModal.article_id;
        ArticleDetailCtl * articleCtl = [[ArticleDetailCtl alloc] init];
        [articleCtl beginLoad:dataModalOne exParam:nil];
        [self.navigationController pushViewController:articleCtl animated:YES];
        dataModal.isNewMessage = NO;
        [tableView_ reloadData];
    }
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

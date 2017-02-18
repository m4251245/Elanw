//
//  ELActivityPeopleListCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/9/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELActivityPeopleListCtl.h"
#import "ELActivityPeopleCell.h"
#import "MsgDetail_DataModal.h"
#import "ELPersonCenterCtl.h"
#import "ELActivityPeopleFrameModel.h"

@interface ELActivityPeopleListCtl ()
{
    Article_DataModal *modal_;
    BOOL isCreatGroup;
}
@end

@implementation ELActivityPeopleListCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
        bFooterEgo_ = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = [NSString stringWithFormat:@"已有%ld人报名",(long)self.joinPeopleCount];
    [self setNavTitle:[NSString stringWithFormat:@"已有%ld人报名",(long)self.joinPeopleCount]];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    modal_ = dataModal;
    if ([modal_._activity_info.is_create_group isEqualToString:@"1"]) {
        isCreatGroup = YES;
    }
}

-(void)getDataFunction:(RequestCon *)con
{
    if (!con) {
        con = [self getNewRequestCon:NO];
    }
    [con getActivityPeopleListWithPersonId:[Manager getUserInfo].userId_ articleId:modal_.id_ page:[NSString stringWithFormat:@"%ld",(long)requestCon_.pageInfo_.currentPage_] pageSize:@"20"];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELActivityPeopleFrameModel *modal = requestCon_.dataArr_[indexPath.row];
    static NSString *cellStr = @"ELActivityPeopleCell";
    ELActivityPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ELActivityPeopleCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSInteger count = modal.arrListData.count;
        for (NSInteger i= count;i < 5; i++)
        {
            UIImageView *imageView = (UIImageView *)[cell viewWithTag:121+i];
            imageView.hidden = YES;
            UILabel *label = (UILabel *)[cell viewWithTag:221+i];
            label.hidden = YES;
        }
    }
    cell.isCreatGroup = isCreatGroup;
    cell.modal = modal;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELActivityPeopleFrameModel *model = requestCon_.dataArr_[indexPath.row];
    if (isCreatGroup) {
        return model.cellHeight+38;
    }
    return model.cellHeight;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    ELActivityPeopleFrameModel *modal = requestCon_.dataArr_[indexPath.row];
    ELPersonCenterCtl *detailCtl = [[ELPersonCenterCtl alloc]init];
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:modal.peopleModel.person_id exParam:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

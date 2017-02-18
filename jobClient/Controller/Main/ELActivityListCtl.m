//
//  ELActivityListCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/9/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELActivityListCtl.h"
#import "ELActivityListCell.h"
#import "MsgDetail_DataModal.h"
#import "ELActivityModel.h"

@interface ELActivityListCtl ()
{
    
}
@end

@implementation ELActivityListCtl

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
    NSString * userId = [Manager getUserInfo].userId_;
    if (![Manager shareMgr].haveLogin) {
        userId = @"";
    }
    [con getActivityListWithPersonId:userId page:[NSString stringWithFormat:@"%ld",(long)requestCon_.pageInfo_.currentPage_] pageSize:@"20" type:_listType];
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
    static NSString *cellStr = @"ELActivityListCell";
    ELActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ELActivityListCell" owner:self options:nil][0];
    }
    ELActivityModel *modal = requestCon_.dataArr_[indexPath.row];
    cell.listType = _listType;
    cell.dataModel = modal;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 162;
}


//-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewRowAction *likeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        // 实现相关的逻辑代码
//        // ...
//        // 在最后希望cell可以自动回到默认状态，所以需要退出编辑模式
//        tableView.editing = NO;
//    }];
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        // 首先改变model
//        [requestCon_.dataArr_ removeObjectAtIndex:indexPath.row];
//        // 接着刷新view
//        [tableView_ deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        // 不需要主动退出编辑模式，上面更新view的操作完成后就会自动退出编辑模式
//    }];
//    return @[deleteAction, likeAction];
//}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"";
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    ELActivityModel *modal = requestCon_.dataArr_[indexPath.row];
    ArticleDetailCtl *articleDetail = [[ArticleDetailCtl alloc] init];
    [self.navigationController pushViewController:articleDetail animated:YES];
    [articleDetail beginLoad:modal.article_id exParam:nil];
    NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"文章详情",NSStringFromClass([self class])]};
    [MobClick event:@"buttonClick" attributes:dict];
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

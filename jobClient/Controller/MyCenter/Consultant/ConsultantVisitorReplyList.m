//
//  ConsultantVisitorReplyList.m
//  jobClient
//
//  Created by 一览ios on 15/6/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ConsultantVisitorReplyList.h"
#import "ConsultantSearchCell.h"
#import "ConsultantReplayCell.h"
#import "ExRequetCon.h"
#import "ConsultantAddVisitCtl.h"

@interface ConsultantVisitorReplyList ()<ConsultantAddVisitCtlDelegate>
{
    User_DataModal *inModel;
}
@end

@implementation ConsultantVisitorReplyList

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"回访记录";
    [self  setNavTitle:@"回访记录"];
//    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
//    UIButton *footBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [footBtn setFrame:CGRectMake(60, 10, 200, 30)];
//    footBtn.layer.cornerRadius = 4.0;
//    footBtn.layer.borderColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0].CGColor;
//    footBtn.layer.borderWidth = 0.5;
//    [footBtn setTitle:@"添加新的回访记录" forState:UIControlStateNormal];
//    [footBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
//    [footBtn.titleLabel setFont:THIRTEENFONT_CONTENT];
//    [footView addSubview:footBtn];
//    [footBtn addTarget:self action:@selector(footBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    tableView_.tableFooterView = footView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"添加回访" forState:UIControlStateNormal];
    [button.titleLabel setFont:THIRTEENFONT_CONTENT];
    [button setFrame:CGRectMake(10, 0, 60, 40)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarBtnResponse:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [_noDataView setHidden:YES];
    _noDataAddBtn.layer.cornerRadius = 4.0;
    _noDataAddBtn.layer.borderColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0].CGColor;
    _noDataAddBtn.layer.borderWidth = 0.5;
    // Do any additional setup after loading the view from its nib.
}

//- (void)footBtnClick:(UIButton *)button
//{
//    ConsultantAddVisitCtl *addVisitCtl = [[ConsultantAddVisitCtl alloc] init];
//    addVisitCtl.delegate = self;
//    [addVisitCtl beginLoad:inModel exParam:nil];
//    [self.navigationController pushViewController:addVisitCtl animated:YES];
//}

- (void)rightBarBtnResponse:(id)sender
{
    ConsultantAddVisitCtl *addVisitCtl = [[ConsultantAddVisitCtl alloc] init];
    addVisitCtl.delegate = self;
    [addVisitCtl beginLoad:inModel exParam:nil];
    [self.navigationController pushViewController:addVisitCtl animated:YES];
}

- (void)addSuccess
{
    [self refreshLoad:nil];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inModel = dataModal;
}

-(void)getDataFunction:(RequestCon *)con
{
    if (!con){
        con = [self getNewRequestCon:YES];
    }
    [con getReplyList:inModel.userId_ type:@"0" pageSize:requestCon_.pageInfo_.currentPage_ pageIndex:20];
}

- (void)btnResponse:(id)sender
{
    if (sender == _noDataAddBtn) {
        ConsultantAddVisitCtl *addVisitCtl = [[ConsultantAddVisitCtl alloc] init];
        addVisitCtl.delegate = self;
        [addVisitCtl beginLoad:inModel exParam:nil];
        [self.navigationController pushViewController:addVisitCtl animated:YES];
    }
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case request_GetReplyList:
        {
            if ([dataArr count] != 0) {
                [_noDataView setHidden:YES];
            }else{
                [_noDataView setHidden:NO];
            }
        }
            break;
        default:
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    ConsultantReplayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ConsultantReplayCell" owner:self options:nil] lastObject];
    }
    Comment_DataModal *model = requestCon_.dataArr_[indexPath.row];
    CGRect rect = cell.contentLb.frame;
    rect.size.height = model.contentHeight;
    rect.size.width = ScreenWidth - 30;
    [cell.contentLb setFrame:rect];
    [cell.contentLb setText:model.content_];
    
    CGRect rect1 = cell.timeLb.frame;
    rect1.origin.y = rect.origin.y + rect.size.height + 10;
    [cell.timeLb setFrame:rect1];
    [cell.timeLb setText:[NSString stringWithFormat:@"回访时间:%@",model.datetime_]];

    CGRect rect2 = cell.lineImgv.frame;
    rect2.origin.y = rect1.size.height + rect1.origin.y + 14;
    rect2.size.width = ScreenWidth -10;
    [cell.lineImgv setFrame:rect2];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment_DataModal *model = requestCon_.dataArr_[indexPath.row];
    return model.contentHeight + 55;
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

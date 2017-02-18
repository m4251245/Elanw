//
//  MyFvoritePositionList.m
//  jobClient
//
//  Created by 一览ios on 15/8/14.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MyFvoritePositionList.h"
#import "MyJobSearchCtlCell.h"
#import "ExRequetCon.h"
#import "JobSearch_DataModal.h"
#import "NewPositionCollectDataModel.h"
#import "ELMyCollectNoDataView.h"

@interface MyFvoritePositionList ()
{
    RequestCon *deleteCon_;
}
@end

@implementation MyFvoritePositionList

- (void)viewDidLoad {
    [super viewDidLoad];
    bHeaderEgo_ = YES;
    bFooterEgo_ = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

- (void)noDataView
{
    ELMyCollectNoDataView *noDataView = [[ELMyCollectNoDataView alloc] initWithFrame:tableView_.frame];
    noDataView.tag = 1000;
    [self.view addSubview:noDataView];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    
}

- (void)getDataFunction:(RequestCon *)con
{
    [con getPositionApplyCollectList:[Manager getUserInfo].userId_ pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:20];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyJobSearchCtlCell";
    MyJobSearchCtlCell *cell = (MyJobSearchCtlCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyJobSearchCtlCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView = bgView;
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
    NewPositionCollectDataModel *dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];

    BOOL isky = NO;
    if ([dataModal.is_ky isEqualToString:@"2"]) {
        isky = YES;
    }
    else{
        isky = NO;
    }
    [cell cellInitWithImage:dataModal.logo positionName:dataModal.jtzw time:dataModal.addtime companyName:dataModal.cname salary:dataModal.xzdy welfare:dataModal.fldy region:dataModal.region gznum:nil edu:nil count:nil  tagColor:nil isky:isky];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyJobSearchCtlCell *cell = (MyJobSearchCtlCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([tableView_ isEditing]) {
        [cell.regionLb_ setHidden:YES];
    }else{
        [cell.regionLb_ setHidden:NO];
    }
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark 删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        //删除一条条目时，更新numberOfRowsInSection
        NewPositionCollectDataModel *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
        [requestCon_.dataArr_ removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationBottom];
        if (!deleteCon_) {
            deleteCon_ = [self getNewRequestCon:NO];
        }
        [deleteCon_ deleteCollectPosition:[Manager getUserInfo].userId_ positionId:model.pf_id];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewPositionCollectDataModel *dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    if (dataModal.fldy == nil || [dataModal.fldy isKindOfClass:[NSNull class]]) {
        return 95;
    }else{
        return 118;
    }
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
 
    NewPositionCollectDataModel *tempData = selectData;
    ZWDetail_DataModal *model = [[ZWDetail_DataModal alloc] init];
    model.zwID_ = tempData.positionId;
    model.zwName_ = tempData.jtzw;
    model.companyID_ = tempData.uid;
    model.companyName_ = tempData.cname;
    model.companyLogo_ = tempData.logo;
    
    if (_fromMessageList) {
        [_shareDelegate sharePositionMessageModal:model];
        return;
    }
    
    PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:model exParam:nil];
    NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"职位详情",NSStringFromClass([self class])]};
    [MobClick event:@"buttonClick" attributes:dict];
}

- (void)stopEditro
{
    [tableView_ setEditing:NO];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
}


- (void)showNoDataView
{
    if ([requestCon_.dataArr_ count] == 0) {
        UIView *view = [self.view viewWithTag:1000];
        if (view != nil) {
            [view removeFromSuperview];
        }
        [self noDataView];
//        super.noDataTips = @"";
    }else{
        UIView *view = [self.view viewWithTag:1000];
        if (view != nil) {
            [view removeFromSuperview];
        }
    }
}


-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_GetPositionApplyCollectList:
        {
            [self showNoDataView];
        }
            break;
        case Request_DeleteCollectPosition:
        {
            Status_DataModal *statusModel = [dataArr objectAtIndex:0];
            if ([statusModel.status_ isEqualToString:@"OK"]) {
                [BaseUIViewController showAutoDismissSucessView:@"删除职位成功" msg:nil];
                [self showNoDataView];
            }else{
                [BaseUIViewController showAutoDismissFailView:@"删除职位失败" msg:nil];
            }
        }
            break;
        default:
            break;
    }
}

- (void)startEditor
{
    BOOL isEditing = tableView_.isEditing;
    //     开启\关闭编辑模式
    if (self.block) {
        self.block(isEditing);
    }
    [tableView_ setEditing:!isEditing animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

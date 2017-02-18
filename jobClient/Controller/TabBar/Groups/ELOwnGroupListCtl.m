//
//  ELOwnGroupListCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/7/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELOwnGroupListCtl.h"
#import "ELGroupListDetailModel.h"
#import "MyGroups_Cell.h"
#import "ELGroupRecommentModel.h"
#import "ELWebSocketManager.h"

#import "GroupsDetailCtl.h"
#import "ELGroupDetailCtl.h"

@interface ELOwnGroupListCtl () <UITableViewDelegate,UITableViewDataSource,ELGroupDetailCtlDelegate,QuitGroupDelegate,ELWebSocketManagerDelegate>
{
    NSMutableArray *_interestedGroupArr;//存放登录状态下可能感兴趣社群
    NSInteger selectIndexPathRow;
}

@property (nonatomic, strong) ELWebSocketManager *socketManager;

@end

@implementation ELOwnGroupListCtl

- (void)viewDidLoad {
    self.showNoDataViewFlag = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)beginLoad:(id)param exParam:(id)exParam{
    [super beginLoad:param exParam:exParam];
    if ([Manager shareMgr].haveLogin) {
        [self requestLoadData];
    }else{
        [self requestNologinLoadData];
    }
    if ((!_interestedGroupArr && [Manager shareMgr].haveLogin) || self.pageInfo.currentPage_ == 0) {
        [self requestInterestedGroupLoadData];
    }
    self.showNoDataViewFlag = NO;
}

#pragma mark - 请求未登录状态下感兴趣社群的数据
-(void)requestNologinLoadData{
    NSString * userId = [Manager getUserInfo].userId_;
    if (!userId || [userId isEqualToString:@""] || ![Manager shareMgr].haveLogin) {
        userId = @"";
    }
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    
    [searchDic setObject:userId forKey:@"person_id"];
    [searchDic setObject:userId forKey:@"login_person_id"];
    NSString *searchDicStr = [jsonWriter stringWithObject:searchDic];
    
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@&", searchDicStr, conditionDicStr];
    NSString * function = @"getGroupByPersonNew";
    NSString * op = @"groups_busi";
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dic = result;
         NSArray *dicData = dic[@"data"];
         NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] initWithDictionary:dic];
         NSMutableDictionary *dicPageParam = [[NSMutableDictionary alloc] initWithDictionary:dicOne[@"pageparam"]];
         [dicPageParam setObject:@"0" forKey:@"pages"];
         [dicOne setObject:dicPageParam forKey:@"pageparam"];
         [self parserPageInfo:dicOne];
         if ([dicData isKindOfClass:[NSArray class]])
         {
             NSMutableArray *arr = [[NSMutableArray alloc] init];
             for (NSDictionary *subDic in dicData)
             {
                 ELGroupRecommentModel *modal = [[ELGroupRecommentModel alloc] initWithDictionary:subDic];
                 [arr addObject:modal];
             }
             [_dataArray removeAllObjects];
             [_dataArray addObjectsFromArray:arr];
             [self.tableView reloadData];
             if (_dataArray.count > 0) {
                 self.finishRefresh = YES; 
             }
         }
         [self finishReloadingData];
         [self refreshEGORefreshView];
         
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         
         self.showNoDataViewFlag = YES;
     }];
}

#pragma mark - 请求登录状态下感兴趣社群的数据
-(void)requestInterestedGroupLoadData{
    NSString * userId = [Manager getUserInfo].userId_;
    if (!userId || [userId isEqualToString:@""] || ![Manager shareMgr].haveLogin) {
        userId = @"";
    }
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    
    [searchDic setObject:userId forKey:@"person_id"];
    [searchDic setObject:userId forKey:@"login_person_id"]; 
    NSString *searchDicStr = [jsonWriter stringWithObject:searchDic];
    
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)0] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@&", searchDicStr, conditionDicStr];
    NSString * function = @"getGroupByPersonNew";
    NSString * op = @"groups_busi";
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dic = result;
         NSArray *dicData = dic[@"data"];
         if ([dicData isKindOfClass:[NSArray class]])
         {
             _interestedGroupArr = [[NSMutableArray alloc] init];
             for (NSDictionary *subDic in dicData)
             {
                 ELGroupRecommentModel *modal = [[ELGroupRecommentModel alloc] initWithDictionary:subDic];
                 [_interestedGroupArr addObject:modal];
             }
             [self.tableView reloadData];
             if(![Manager shareMgr].haveLogin || self.pageInfo.lastPageFlag){
                 [self refreshEGORefreshView]; 
             }
         }
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         self.showNoDataViewFlag = YES;
     }];
}

#pragma mark - 请求登录状态下我的社群数据
-(void)requestLoadData{
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:[Manager getUserInfo].userId_ forKey:@"login_person_id"];
    //组装分页参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:Request_Version forKey:@"version"];
    [conditionDic setObject:@"1" forKey:@"get_group_flag"];
    [conditionDic setObject:@"allList_page" forKey:@"listtype"];
    // [conditionDic setObject:@"1" forKey:@"get_group_cnt"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *insertStr = [jsonWriter2 stringWithObject:conditionDic];
    NSString *searchStr = [jsonWriter2 stringWithObject:searchDic];
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"user_id=%@&searchArr=%@&conditionArr=%@",[Manager getUserInfo].userId_,searchStr,insertStr];
    NSString * function = Table_Func_GetMyGroup;
    NSString * op = Table_Op_GetMygroup;
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dic = result;
         [self parserPageInfo:dic];
         if([dic isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *subDic = [dic objectForKey:@"data"];
             NSArray *arr = [subDic objectForKey:@"group_list"];
             if ([arr isKindOfClass:[NSArray class]]) {
                 for (NSDictionary *dicOne in arr){
                     ELGroupListDetailModel *model = [[ELGroupListDetailModel alloc] initWithDictionary:dicOne];
                     [_dataArray addObject:model];
                 }
             }
             [self.tableView reloadData];
             if (_dataArray.count > 0) {
                 self.finishRefresh = YES; 
             }
         }
         
//         //请求结束后刷新长连接，避免用户加入新的招聘群
//         [self.socketManager openServer];
         
         [self finishReloadingData];
         [self refreshEGORefreshView];
     }failure:^(NSURLSessionDataTask *operation, NSError *error){
         
         [self finishReloadingData];
         [self refreshEGORefreshView];
     }];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _dataArray.count;
    }else if (section == 1){
        return _interestedGroupArr.count;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.pageInfo.lastPageFlag && [Manager shareMgr].haveLogin){
        return 2;
    }
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,30)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:13];
    lable.textColor = UIColorFromRGB(0x666666);
    lable.backgroundColor = UIColorFromRGB(0xf0f0f0);
    if (section == 0 && _dataArray.count > 0 && ![Manager shareMgr].haveLogin) {
        lable.frame = CGRectMake(12,0,ScreenWidth,30);
        lable.text = @"你可能感兴趣的社群";
    }else if (section == 1 && _interestedGroupArr.count > 0){
        lable.text = @"你可能感兴趣的社群";
        lable.frame = CGRectMake(12,0,ScreenWidth,30);
    }
    [view addSubview:lable];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && _dataArray.count > 0 && ![Manager shareMgr].haveLogin){
        return 30;
    }else if(section == 1 && _interestedGroupArr.count > 0){
        return 30;
    }
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    static NSString *CellIdentifier = @"MyGroupsCtlCell";
    
    MyGroups_Cell *cell = (MyGroups_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyGroups_Cell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    id dataModal;
    switch (indexPath.section) {
        case 0:
        {
            dataModal = [_dataArray objectAtIndex:indexPath.row];
        }
            break;
        case 1:
        {
            dataModal = [_interestedGroupArr objectAtIndex:indexPath.row];
        }
            break;
            
        default:
            break;
    }
    
    if ([dataModal isKindOfClass:[ELGroupListDetailModel class]])
    {
        [cell cellGiveDataWithModal:dataModal];
    }
    else{
        ELGroupRecommentModel *model = (ELGroupRecommentModel *)dataModal;
        cell.nameLb_.text = model.group_name;
        [cell.nameLb_ setTextColor:UIColorFromRGB(0x333333)];
        
        cell.msgCnt_.alpha = 0.0;
        
        if (model.article_id.length > 0){
            NSString *str = [NSString stringWithFormat:@"%@发表了:%@",model.own_name,model.title];
            [cell.contentLb_ setText:str];
        }else{
            cell.contentLb_.text = @"暂无新动态";
        }
        cell.contentLb_.lineBreakMode = NSLineBreakByTruncatingTail;
        cell.privacyImage.hidden = YES;
        
        [cell.imgView_ sd_setImageWithURL:[NSURL URLWithString:model.group_pic] placeholderImage:[UIImage imageNamed:@"icon_zhiysq"] options:SDWebImageAllowInvalidSSLCertificates];
        NSDate * date = [MyCommon getDate:model.updatetime_act_last];
        cell.timeLb.text = [MyCommon compareCurrentTime:date];
    }
    cell.lineImageLeft.constant = -10;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *groupId = @"";
    
    ELGroupListDetailModel *groupModel;
    if (indexPath.section == 0) {
        id dataModal = [_dataArray objectAtIndex:indexPath.row];
        if ([dataModal isKindOfClass:[ELGroupListDetailModel class]]) {
            ELGroupListDetailModel *model = dataModal;
            if ([model._dynamic_cnt integerValue] >0 && [Manager shareMgr].haveLogin) {
                [Manager shareMgr].messageCountDataModal.toolBarGroupCnt = [Manager shareMgr].messageCountDataModal.toolBarGroupCnt - [model._dynamic_cnt integerValue] ;
                model._dynamic_cnt = @"";
                if ([Manager shareMgr].messageCountDataModal.toolBarGroupCnt < 0) {
                    [Manager shareMgr].messageCountDataModal.toolBarGroupCnt = 0;
                }
                [self.tableView reloadData];
            }
            groupId = model.group_id;
            
            groupModel = model;
        }
        else{
            ELGroupRecommentModel *model = dataModal;
            groupId = model.group_id;
        }
    }
    else if (indexPath.section == 1){
        ELGroupRecommentModel *model = [_interestedGroupArr objectAtIndex:indexPath.row];
        groupId = model.group_id;
    }
    if (groupId.length <= 0) {
        return;
    }

    selectIndexPathRow = indexPath.row;

    ELGroupDetailCtl *detailCtl = [[ELGroupDetailCtl alloc] init];
    detailCtl.delegate = self;
    [detailCtl beginLoad:groupId exParam:nil];
    detailCtl.isMine = YES;
    detailCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailCtl animated:YES];
    
    NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"社群详情",NSStringFromClass([self class])]};
    [MobClick event:@"buttonClick" attributes:dict];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - ELGroupDetailCtlDelegate
-(void)refresh{
    [self refreshLoad];
}

-(void)joinSuccess{
    [self refreshLoad];
}

#pragma 退出社群成功代理
-(void)quitGroupSuccess{
    if (selectIndexPathRow < _dataArray.count) {
        [_dataArray removeObjectAtIndex:selectIndexPathRow];
        [self.tableView reloadData];
        [self adjustFooterViewFrame];
    }
}
#pragma mark - 修改头像成功代理
-(void)updateGroupImgSuccess:(NSString *)img{
    id dataModal;
    if (selectIndexPathRow < _dataArray.count) {
        dataModal = [_dataArray objectAtIndex:selectIndexPathRow];
        if (dataModal && img && ![img isEqualToString:@""]) {
            if ([dataModal isKindOfClass:[ELGroupListDetailModel class]]) {
                ELGroupListDetailModel *model = dataModal;
                model.group_pic = img;
            }else{
                ELGroupRecommentModel *model = dataModal;
                model.group_pic = img;
            }
            [self.tableView reloadData];
            [self adjustFooterViewFrame];
        }
    }
}

//#pragma mark - 跳转社群详情页
//- (void)cellBtnClick:(UIButton *)sender
//{
//    ELGroupListDetailModel *dataModal = [_dataArray objectAtIndex:sender.tag];
//    GroupsDetailCtl *detailCtl = [[GroupsDetailCtl alloc] init];
//    detailCtl.delegate_ = self;
//    selectIndexPathRow = sender.tag;
//    detailCtl.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detailCtl animated:YES];
//    [detailCtl beginLoad:dataModal.group_id exParam:nil];
//}

-(void)refreshLoad:(RequestCon *)con{
    [self refreshLoad];
}

-(void)tableViewContentSizeZero{
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

- (ELWebSocketManager *)socketManager
{
    _socketManager = [ELWebSocketManager defaultManager];
    _socketManager.delegate = self;
    return _socketManager;
}

- (void)chatManager:(ELWebSocketManager *)manager didReceiceMessage:(NSDictionary *)messageDic
{
    NSString *idStr = [[messageDic objectForKey:@"data"] objectForKey:@"id"];
    ELGroupListDetailModel *dataModel;
    if ([_dataArray isKindOfClass:[NSMutableArray class]] && _dataArray.count > 0)
    {
        for (ELGroupListDetailModel *model in _dataArray)
        {
            if ([model.group_id isEqualToString:idStr])
            {
                dataModel = model;
                [_dataArray removeObject:model];
                break;
            }
        }
        
        [_dataArray insertObject:dataModel atIndex:0];
        [self.tableView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.socketManager.delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.socketManager.delegate = self;
}

@end

//
//  MyAudienceListCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-10-27.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "MyAudienceListCtl.h"
#import "ExRequetCon.h"
#import "SameTradeCell.h"
#import "ELPersonCenterCtl.h"

@interface MyAudienceListCtl ()

@property (nonatomic, strong)NSMutableArray *dataSourceArr;

@end

@implementation MyAudienceListCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        bHeaderEgo_ = YES;
        bFooterEgo_ = YES;
        
        type_ = [[NSString alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addLikeSuccessNotification) name:@"addLikeSuccessNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leslikeSuccessNotification) name:@"leslikeSuccessNotification" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
    
    [self setNavTitle:@"谁关注了我"];
    [tableView_ setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSMutableArray *)dataSourceArr
{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc] init];
    }
    
    return _dataSourceArr;
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    
    if ([type_ isEqualToString:@"1"])
    {
        //我的关注
        [self setNavTitle:@"我关注的人"];
    }else if(_isMyCenter){
        //听众
        if (!_isOthercenterFlag) {
            [self setNavTitle:@"关注我的人"];
        }
        else
        {
            [self setNavTitle:@"关注TA的人"];
        }
    }
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    type_ = dataModal;
}

- (void)getDataFunction:(RequestCon *)con
{
    if (!con) {
        con = [self getNewRequestCon:YES];
    }
    //type = 2 听众     1新的
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSString *homeTime = [defaults objectForKey:@"HOMETIMEUSERDEFAULT"];
    
    if (_isOthercenterFlag) {
        [con getFriendWithUserId:_personModel.userModel_.id_ followType:type_ visitorPid:[Manager getUserInfo].userId_ isnew:@"1" loginLastTime:homeTime pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:15];
    }else{
        [con getFriendWithUserId:[Manager getUserInfo].userId_ followType:type_ visitorPid:[Manager getUserInfo].userId_ isnew:@"1" loginLastTime:homeTime pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:15];
    }

}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetFriend:
        {
            if (_dataSourceArr.count > 0) {
                [_dataSourceArr removeAllObjects];
            }
            
            _dataSourceArr = [requestCon_.dataArr_ mutableCopy];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArr.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SameTradeCell *sameTradeCell = (SameTradeCell *)cell;
    ELSameTradePeopleFrameModel *model = _dataSourceArr[indexPath.row];
    sameTradeCell.showMessageButton = YES;
    sameTradeCell.hideDynamic = YES;
    sameTradeCell.peopleModel = model;
    if (!_isOthercenterFlag)
    {
        sameTradeCell.dynamicLb_.text = [MyCommon getWhoLikeMeListCurrentTime:[MyCommon getDate:model.peopleModel.addtime] currentTimeString:model.peopleModel.addtime];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    SameTradeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SameTradeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    selectedIndexpath_  = indexPath;
    ELSameTradePeopleFrameModel *model = [_dataSourceArr objectAtIndex:indexPath.row];
    ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
    [self.navigationController pushViewController:personCenterCtl animated:NO];
    [personCenterCtl beginLoad:model.peopleModel.personId exParam:nil];
   
    NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"个人主页",NSStringFromClass([self class])]};
    [MobClick event:@"buttonClick" attributes:dict];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

#pragma mark - 通知刷新界面
- (void)addLikeSuccessNotification
{
    [self refreshLoad:nil];
    [_delegate addLikePersonSuccess];
}

- (void)leslikeSuccessNotification
{
    [_dataSourceArr removeObjectAtIndex:selectedIndexpath_.row];
    [tableView_ reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

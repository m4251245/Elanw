//
//  SubscribedJobsCtl.m
//  Association
//
//  Created by 一览iOS on 14-4-17.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "SubscribedJobsCtl.h"
#import "SubscribedJobsCtl_Cell.h"
#import "ZWDetail_DataModal.h"
#import "CondictionListCtl.h"
#import "SearchParam_DataModal.h"

@interface SubscribedJobsCtl ()
{
    BOOL bEditMode_;
    NSIndexPath * indexPath_;
    NSString * newJobsId_;
    
}

@end

@implementation SubscribedJobsCtl
@synthesize type_;

-(id)init
{
    self = [super init];
    
    
    
//    rightNavBarStr_ = @"编辑";
    
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
//    self.navigationItem.title = @"职位订阅";
    [self setNavTitle:@"职位订阅"];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    newJobsId_ = dataModal;
    [super beginLoad:dataModal exParam:exParam];
    bEditMode_ = NO;
    [tableView_ setEditing:NO];
}

-(void)updateCom:(RequestCon *)con
{
    if ([requestCon_.dataArr_ count] !=0) {
        [rightBarBtn_ setHidden:NO];
    }else{
        [rightBarBtn_ setHidden:YES];
    }
    
    if (type_ == 1) {
        //推送入口
        searchBtn_.alpha = 0.0;
    }
    else
    {
        searchBtn_.alpha = 1.0;
    }
    [super updateCom:con];
    if (con == deleteCon_) {
        if ([requestCon_.dataArr_  count] == 0) {
            [self refreshLoad:nil];
        }
    }
}

-(void)getDataFunction:(RequestCon *)con
{
    [con getJobSubscribedList:[Manager getUserInfo].userId_];
    
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_DeleteJobSubscribed:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
           
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [requestCon_.dataArr_ removeObjectAtIndex:indexPath_.row];//移除数据源的数据
                [tableView_ deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath_] withRowAnimation:UITableViewRowAnimationLeft];
                [BaseUIViewController showAutoDismissSucessView:@"删除成功" msg:nil];
                [tableView_ reloadData];
            }
            else
            {
                [BaseUIViewController showAutoDismissFailView:dataModal.des_ msg:nil];
            }
        }
            break;
            
        default:
            break;
    }
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SubscribedJobsCtlCell";
    
    SubscribedJobsCtl_Cell *cell = (SubscribedJobsCtl_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        //cell = [[MainCtl_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SubscribedJobsCtl_Cell" owner:self options:nil] lastObject];
        
        cell.backgroundColor = [UIColor clearColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    }
    
    ZWDetail_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    
    NSString * tradeStr = [CondictionListCtl getTradeStr:dataModal.tradeId_];
    if ([tradeStr isEqualToString:@"暂无"]) {
        cell.jobnameLb_.text = dataModal.keyword_;
    }
    else if([dataModal.keyword_ isEqualToString:@""])
    {
        cell.jobnameLb_.text = tradeStr;
    }
    else
        cell.jobnameLb_.text = [NSString stringWithFormat:@"%@--%@",dataModal.keyword_,tradeStr];
    
    if ([dataModal.zwID_ isEqualToString:newJobsId_]) {
        cell.haveNewLb_.alpha = 1.0;
    }
    else
        cell.haveNewLb_.alpha = 0.0;
    
    NSString * region = [CondictionListCtl getRegionStr:dataModal.regionId_];
    if ([region isEqualToString:@"暂无"]) {
        region = @"全国";
    }
    cell.regionLb_.text = region;
    
    
    
    return cell;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        indexPath_ = indexPath;
        ZWDetail_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
        if (!deleteCon_) {
            deleteCon_ = [self getNewRequestCon:NO];
            
        }
        [deleteCon_ deleteJobSubscribed:dataModal.personId_ jobId:dataModal.zwID_];
    }
}



-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    ZWDetail_DataModal * zwModal = selectData;
    SearchParam_DataModal * searchModal = [[SearchParam_DataModal alloc] init];
    searchModal.regionId_ = zwModal.regionId_;
    searchModal.tradeId_ = zwModal.tradeId_;
    searchModal.regionStr_ = [CondictionListCtl getRegionStr:zwModal.regionId_];
    if ([searchModal.regionStr_ isEqualToString:@"暂无"]) {
        searchModal.regionStr_ = @"全国";
    }
    searchModal.searchType_ = 3;
    searchModal.bCampusSearch_ = NO;
    searchModal.searchKeywords_ = zwModal.keyword_;
    
    //求职
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGSEARCHCODICTION" object:searchModal];
}

-(void)btnResponse:(id)sender
{
    if (sender == searchBtn_) {
        [self backBarBtnResponse:nil];
    }
}

-(void)rightBarBtnResponse:(id)sender
{
    bEditMode_ = !bEditMode_;
    if (bEditMode_) {
        [tableView_ setEditing:YES];
    }
    else
        [tableView_ setEditing:NO];
}


@end

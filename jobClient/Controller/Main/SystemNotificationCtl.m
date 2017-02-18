//
//  SystemNotificationCtl.m
//  jobClient
//
//  Created by YL1001 on 14/10/31.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "SystemNotificationCtl.h"
#import "SystemNotification_Cell.h"
#import "SysNotification_DataModal.h"
#import "ELPersonCenterCtl.h"
#import "InterViewListCtl.h"
#import "SalaryIrrigationDetailCtl.h"
#import "SalaryGuideCtl.h"

#import "CommentMessage_Cell.h"
#import "GroupsMessage_Cell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface SystemNotificationCtl ()<ELGroupDetailCtlDelegate>
{
    NSInteger btnTag;
}
@end

@implementation SystemNotificationCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
    
    [self setNavTitle:@"系统通知"];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];

    UIView *view = [[UIView alloc]init];
    self.tableView .tableFooterView = view;
    
    self.tableView .separatorInset = UIEdgeInsetsZero;
    if (IOS8) {
        self.tableView .layoutMargins = UIEdgeInsetsZero;
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupsMessage_Cell" bundle:nil] forCellReuseIdentifier:@"GroupsMessageCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id dataModal = [_dataArray objectAtIndex:indexPath.row];
    
    //社群邀请
    if ([dataModal isKindOfClass:[GroupInvite_DataModal class]]) {
        GroupInvite_DataModal *inviteModel = dataModal;
        
        if ([inviteModel.msg_type isEqualToString:@"201"] || [inviteModel.msg_type isEqualToString:@"202"])
        {
            GroupsMessage_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupsMessageCell"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell.dataModel = inviteModel;
            
            return  cell;
        }
        else if ([inviteModel.msg_type isEqualToString:@"310"])
        {
            static NSString *CellIdentifierOne = @"CommentMessageCell";
            CommentMessage_Cell *cell = (CommentMessage_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierOne];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentMessage_Cell" owner:self options:nil] lastObject];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            cell.dataModalOne = inviteModel;
            
            return cell;
        }
    }
    
    SysNotification_DataModal *systemModel = dataModal;
    static NSString *CellIdentifier = @"SystemNotification_Cell";
    SystemNotification_Cell *cell = (SystemNotification_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SystemNotification_Cell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell.userImg_ sd_setImageWithURL:[NSURL URLWithString:systemModel.userImg_] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    [cell.contentLb_ setText:[NSString stringWithFormat:@"%@",systemModel.content_]];
    [cell.timeLb_ setText:systemModel.datetime_];
    cell.expertImg_.alpha = 0.0;
    cell.conLabLeftToImg.constant = 13;
    cell.detailLable.text = systemModel.detailContent;
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id dataModal = [_dataArray objectAtIndex:indexPath.row];
    
    if ([dataModal isKindOfClass:[GroupInvite_DataModal class]]) {
        GroupInvite_DataModal *model = dataModal;
        if ([model.msg_type isEqualToString:@"310"]){
            return model.cellHeight;
        }
        else
        {
            CGFloat height = [tableView fd_heightForCellWithIdentifier:@"GroupsMessageCell" cacheByIndexPath:indexPath configuration:^(GroupsMessage_Cell *cell) {
                
                cell.reasonLb.text = model.reason;
                cell.reasonLb.textAlignment = NSTextAlignmentLeft;
            }];
            
            return height + 85;
        }
    }
    

    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    '301' => '推荐行家', // 活动
//    '302' => '推荐社群', // 活动
//    '303' => '推荐URL', // 活动
//    '500' => '完善语音',
//    '501' => '上传职业风采照',
//    '502' => '鼓励发表',
//    '503' => '回答小编专访',
//    '515' => '灌薪水',
//    '516' => '职位',
//    '517' => '文章',
//    '518' => '薪指比拼',
//    '529' => '微分享'
    
    id dataModal = [_dataArray objectAtIndex:indexPath.row];
    //社群邀请
    if ([dataModal isKindOfClass:[GroupInvite_DataModal class]]) {
        
        GroupInvite_DataModal *inviteModel = dataModal;
        if (!inviteModel.group_id) {
            return;
        }
        
        ELGroupDetailCtl *detailCtl_ = [[ELGroupDetailCtl alloc] init];
        detailCtl_.delegate = self;
        [detailCtl_ beginLoad:inviteModel.group_id exParam:nil];
        detailCtl_.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailCtl_ animated:YES];
    }
    else {
        SysNotification_DataModal *model = dataModal;
        if ([model.type_ isEqualToString:@"301"]||[model.type_ isEqualToString:@"502"]||[model.type_ isEqualToString:@"501"]||[model.type_ isEqualToString:@"500"]) {
            ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
            [self.navigationController pushViewController:personCenterCtl animated:YES];
            [personCenterCtl beginLoad:model.userId_  exParam:nil];
            NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"个人主页",NSStringFromClass([self class])]};
            [MobClick event:@"buttonClick" attributes:dict];
        }
        if ([model.type_ isEqualToString:@"503"])
        {
            InterViewListCtl *listCtl = [[InterViewListCtl alloc]init];
            listCtl.block = ^(){
                //[self refreshAboutListView];
            };
            [listCtl setIsMyCenter:YES];
            [listCtl beginLoad:model.userId_ exParam:nil];
            [self.navigationController pushViewController:listCtl animated:YES];
        }
        if ([model.type_ isEqualToString:@"302"]) {
            Groups_DataModal * groupModal = [[Groups_DataModal alloc] init];
            groupModal.id_ = model.groupId_;
            ELGroupDetailCtl * groupDetailCtl = [[ELGroupDetailCtl alloc] init];
            [self.navigationController pushViewController:groupDetailCtl animated:YES];
            [groupDetailCtl beginLoad:groupModal exParam:nil];
            NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"社群详情",NSStringFromClass([self class])]};
            [MobClick event:@"buttonClick" attributes:dict];
        }
        if ([model.type_ isEqualToString:@"303"]) {
            PushUrlCtl * pushurlCtl = [[PushUrlCtl alloc] init];
            [self.navigationController pushViewController:pushurlCtl animated:YES];
            [pushurlCtl beginLoad:model.url_ exParam:@"最新活动"];
        }
        if ([model.type_ isEqualToString:@"515"]) {
            ELSalaryModel *dataModal = [[ELSalaryModel alloc] init];
            dataModal.article_id = model.productId_;
            dataModal.content = model.content_;
            dataModal.bgColor_ = [UIColor whiteColor];
            SalaryIrrigationDetailCtl *detailCtl = [[SalaryIrrigationDetailCtl alloc] init];
            [self.navigationController pushViewController:detailCtl animated:YES];
            [detailCtl beginLoad:dataModal exParam:nil];
            NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"帖子详情",NSStringFromClass([self class])]};
            [MobClick event:@"buttonClick" attributes:dict];
        }
        if ([model.type_ isEqualToString:@"516"]) {
            ZWDetail_DataModal *pushCompany_ =[[ZWDetail_DataModal alloc] init];
            pushCompany_.zwID_ = model.productId_;
            pushCompany_.companyID_ = model.companyId_;
            pushCompany_.companyLogo_ = model.userImg_;
            pushCompany_.companyName_ = model.companyName_;
            PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
            [self.navigationController pushViewController:positionCtl animated:YES];
            [positionCtl beginLoad:pushCompany_ exParam:nil];
            NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"职位详情",NSStringFromClass([self class])]};
            [MobClick event:@"buttonClick" attributes:dict];
        }
        if ([model.type_ isEqualToString:@"517"] || [model.type_ isEqualToString:@"524"] || [model.type_ isEqualToString:@"529"]) {
            Article_DataModal * dataModal = [[Article_DataModal alloc] init];
            dataModal.id_ = model.productId_;
            ArticleDetailCtl * articleCtl = [[ArticleDetailCtl alloc] init];
            [self.navigationController pushViewController:articleCtl animated:YES];
            [articleCtl beginLoad:dataModal exParam:nil];
            NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"文章详情",NSStringFromClass([self class])]};
            [MobClick event:@"buttonClick" attributes:dict];
        }
        if ([model.type_ isEqualToString:@"518"]) {
            User_DataModal * dataModal = [[User_DataModal alloc] init];
            dataModal.userId_ = model.userId_;
            dataModal.salary_ = model.salary_;
            dataModal.zym_ = model.kw_;
            dataModal.regionId_ = model.regionId_;
            SalaryGuideCtl * salaryGuideCtl = [[SalaryGuideCtl alloc] init];
            salaryGuideCtl.kwFlag_ = @"1";
            salaryGuideCtl.regionId_ = model.regionId_;
            [self.navigationController pushViewController:salaryGuideCtl animated:YES];
            [salaryGuideCtl beginLoad:dataModal exParam:nil];
        }
        if ([model.type_ isEqualToString:@"160"])
        {
            Article_DataModal * dataModal = [[Article_DataModal alloc] init];
            dataModal.id_ = model.productId_;
            ArticleDetailCtl *ctl = [[ArticleDetailCtl alloc] init];
            ctl.isFromNews = YES;
            [self.navigationController pushViewController:ctl animated:YES];
            [ctl beginLoad:dataModal exParam:nil];
            NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"文章详情",NSStringFromClass([self class])]};
            [MobClick event:@"buttonClick" attributes:dict];
        }

    }
}

- (void)beginLoad:(id)param exParam:(id)exParam
{
    [super beginLoad:param exParam:exParam];
    
    [self loadData];
}

- (void)loadData
{
    //组件搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:searchDic];
    
    //组件条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_] forKey:@"page"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *condition = [jsonWriter2 stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",conditionStr,condition];
    
    
    [ELRequest postbodyMsg:bodyMsg op:@"yl_app_push_busi" func:@"getSysNoticeList" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        [self parserPageInfo:result];
        
        NSDictionary *dic = result;
        NSArray * arr = [dic objectForKey:@"data"];
        
        for (NSDictionary * subDic in arr)
        {
            NSString *msgType = [subDic objectForKey:@"msg_type"];
            
            /**
             *邀请加入社群 201
             *申请加入社群成功 310
             *申请加入社群 202
             **/
            if ([msgType isEqualToString:@"201"] || [msgType isEqualToString:@"202"] || [msgType isEqualToString:@"310"])
            {
                GroupInvite_DataModal * dataModal;
                if ([msgType isEqualToString:@"310"]){
                    dataModal = [[GroupInvite_DataModal alloc] initWithGroupMessageOneDictionary:subDic];
                }else{
                    dataModal = [[GroupInvite_DataModal alloc] initWithDictionary:subDic];
                }
                
                [_dataArray addObject:dataModal];
            }
            else{
                SysNotification_DataModal * dataModal = [[SysNotification_DataModal alloc] initWithDictionary:subDic];
                [_dataArray addObject:dataModal];
            }
        }
        
        [self.tableView reloadData];
        [self finishReloadingData];
        [self refreshEGORefreshView];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        [self finishReloadingData];
        [self refreshEGORefreshView];
        
    }];
}


#pragma mark - ELGroupDetailCtlDelegate
-(void)refresh{
    [self refreshLoad];
}

-(void)joinSuccess{
    [self refreshLoad];
}

@end

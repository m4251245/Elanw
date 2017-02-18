//
//  InviteListCtl.m
//  Association
//
//  Created by YL1001 on 14-5-15.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "InviteListCtl.h"
#import "InviteListCtl_Cell.h"
#import "GroupsMessage_Cell.h"
#import "YLGroupMessageReplyVIew.h"
#import "CommentMessage_Cell.h"
#import "ELPersonCenterCtl.h"
#import "ReplyCommentCtl.h"
#import "ELGroupDetailCtl.h"

@interface InviteListCtl () <GroupMessageReplyDelegete,AddReplyCommentDelegate,ELGroupDetailCtlDelegate>
{
    YLGroupMessageReplyVIew *messageViewCtl;
    GroupInvite_DataModal *selectModal;
    
    NSMutableArray *colorArr;
    NSMutableDictionary *cellDic;
    NSArray *topTitleArray;
    NSInteger _row;
    BOOL needHiddenMark;//是否需要隐藏小红点
}
@end

@implementation InviteListCtl
@synthesize type_;
#pragma mark - LifeCycle
- (instancetype)init
{
    if (self = [super init]) {

        imageConArr_ = [[NSMutableArray alloc] init];
        btnTag = 0;
        bFooterEgo_ = YES;
        needHiddenMark = NO;
        topTitleArray = @[@"全部",@"新发表",@"评论",@"申请",@"活动"];
    }
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
    
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
    
    [self setNavTitle:@"社群消息"];
    [tableView_ setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    cellDic = [[NSMutableDictionary alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取没有数据时的视图
-(UIView *) getNoDataView
{
    UIView *view = nil;
    
    if( !noDataOkCtl_ ){
        noDataOkCtl_ = [[NoDataOkCtl alloc] init];
    }
    
    view = noDataOkCtl_.view;
    noDataOkCtl_.txtLb_.textAlignment = NSTextAlignmentCenter;
    noDataOkCtl_.txtLb_.text = @"近一个月内未收到任何消息";

    return view;
}

#pragma mark - NetWork
-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    type_ = dataModal;
    [super beginLoad:dataModal exParam:exParam];
    
}

-(void)getDataFunction:(RequestCon *)con
{
    NSUserDefaults *homeDefaults = [[NSUserDefaults alloc]init];
    NSString * showtime = [homeDefaults objectForKey:@"HOMETIMEUSERDEFAULT"];
    if(!showtime)
    {
        showtime = @"";
    }
    [con getGroupMessageList:[Manager getUserInfo].userId_ pageSize:15 pageIndex:requestCon_.pageInfo_.currentPage_ showtime:showtime];
}


-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_MyInviteList:
        {
            
        }
            break;
        case Request_HandleGroupInvitation:
        {
//            Status_DataModal * dataModal = [[Status_DataModal alloc]init];
//            dataModal = [dataArr objectAtIndex:0];
//            [self updateView];
        }
            break;
            
        case Request_HandleGroupApply:
        {
//            Status_DataModal * dataModal = [[Status_DataModal alloc]init];
//            dataModal = [dataArr objectAtIndex:0];
//            [self updateView];
        }
            break;
        case Request_GroupsMessageList:
        {
            
        }
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupInvite_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    //本地隐藏小红点
    if (needHiddenMark) {
        dataModal.is_read = @"1";
        dataModal.bRead_ = YES;
        needHiddenMark = NO;
    }
    if ([dataModal.msg_type isEqualToString:@"251"] || [dataModal.msg_type isEqualToString:@"200"] || [dataModal.msg_type isEqualToString:@"310"])
    {
        static NSString *CellIdentifierOne = @"CommentMessageCell";
        CommentMessage_Cell *cell = (CommentMessage_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierOne];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentMessage_Cell" owner:self options:nil] lastObject];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        if ([dataModal.msg_type isEqualToString:@"200"]) {
            cell.dataModalTwo = dataModal;
            return cell;
        }else if ([dataModal.msg_type isEqualToString:@"310"]){
            cell.dataModalOne = dataModal;
            return cell;
        }
        cell.dataModal = dataModal;
        return cell;
    }
    
    static NSString *CellIdentifier = @"GroupsMessageCell";
    
    GroupsMessage_Cell *cell = (GroupsMessage_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GroupsMessage_Cell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    cell.nameLb_.text = dataModal.requestInfo_.iname_;
    cell.timeLb_.text = dataModal.idatetime_;
    cell.groupsNameLb_.text = dataModal.groupInfo_.name_;
    cell.userBtn_.tag = indexPath.row + 2000;
    [cell.userBtn_ addTarget:self action:@selector(userBtnClicl:) forControlEvents:UIControlEventTouchUpInside];
    
    if (!dataModal.requestInfo_.isExpert_) {
        cell.expertImg_.alpha = 0.0;
        cell.nameLeftToUimg.constant = 8;
    }
    else
    {
        cell.expertImg_.alpha = 1.0;
        cell.nameLeftToUimg.constant = 18;
    }
    
    CGRect  statusRect = cell.statusLb_.frame;
    if ([dataModal.type_ isEqualToString:@"201"] ) {
        //受邀加入某社群
        cell.statusLb_.text = [NSString stringWithFormat:@"邀请您加入："];
    }
    if ([dataModal.type_ isEqualToString:@"202"]) {
        cell.statusLb_.text = [NSString stringWithFormat:@"申请加入："];
    }
    [cell.statusLb_ setFrame:statusRect];
    
    
    if ([dataModal.resultStatus_ isEqualToString:@"agree"]) {
        [cell.myBtn_ setTitle:@"已同意" forState:UIControlStateSelected];
        [cell.myBtn_ setSelected:YES];
        [cell.myBtn_ setBackgroundColor:[UIColor clearColor]];
    }
    else if([dataModal.resultStatus_ isEqualToString:@"ignore"]){
        [cell.myBtn_ setTitle:@"已忽略" forState:UIControlStateSelected];
        [cell.myBtn_ setSelected:YES];
        [cell.myBtn_ setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [cell.myBtn_ setTitle:@"同意" forState:UIControlStateSelected];
        [cell.myBtn_ setSelected:NO];
        [cell.myBtn_ setBackgroundColor:[UIColor colorWithRed:196.0/255.0 green:0.0/255.0 blue:8.0/255.0 alpha:1.0]];
        cell.myBtn_.tag = indexPath.row + 1000;
        [cell.myBtn_ addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (dataModal.bRead_) {
        cell.markNewImg_.alpha = 0.0;
    }
    else{
        cell.markNewImg_.alpha = 1.0;
    }
    
    [cell.userImg_ sd_setImageWithURL:[NSURL URLWithString:dataModal.requestInfo_.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    
    
    if (dataModal.reason.length > 0) {
        [cell.reasonLb setHidden:NO];
        [cell.reasonLb setText:dataModal.reason];
        
    }else{
//        [cell.reasonLb setHidden:YES];
        cell.reasonLb.text = @"";
    }
    
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupInvite_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    if ([dataModal.msg_type isEqualToString:@"251"] || [dataModal.msg_type isEqualToString:@"200"] || [dataModal.msg_type isEqualToString:@"310"]){
        return dataModal.cellHeight;
    }
    
    GroupsMessage_Cell *cell = [cellDic objectForKey:@"cell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"GroupsMessage_Cell" owner:self options:nil].lastObject;
        [cellDic setObject:cell forKey:@"cell"];
    }

    cell.reasonLb.text = dataModal.reason;
    cell.reasonLb.textAlignment = NSTextAlignmentLeft;
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.reasonLb.preferredMaxLayoutWidth = ScreenWidth - 16 - 43 - 8;
    CGFloat setExpertHonorLbHeight = [cell.reasonLb systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    cell.reasonLb.numberOfLines = 0;
    
    return setExpertHonorLbHeight  + 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    _row = indexPath.row;
    GroupInvite_DataModal *modal = requestCon_.dataArr_[indexPath.row];
    if ([modal.msg_type isEqualToString:@"251"]) {
        if (!messageViewCtl) {
            messageViewCtl = [[YLGroupMessageReplyVIew alloc] init];
            messageViewCtl.messageReplyDelegate = self;
        }
        selectModal = modal;
        [messageViewCtl showMessageViewCtl];
    }else if ([modal.msg_type isEqualToString:@"200"]){
        selectModal = modal;
        [self pushArticleDetailCtl];
    }
    else if ([modal.msg_type isEqualToString:@"310"])
    {
        if (!modal.group_id) {
            return;
        }
        ELGroupDetailCtl *detailCtl_ = [[ELGroupDetailCtl alloc] init];
        detailCtl_.delegate = self;
        [detailCtl_ beginLoad:modal.group_id exParam:nil];
        detailCtl_.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailCtl_ animated:YES];
    }
}

-(void)updateView
{
    GroupInvite_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:btnTag-1000];
    dataModal.resultStatus_ = @"agree";
    [tableView_ reloadData];
}

-(IBAction)userBtnClicl:(id)sender
{
    UIButton* btn = sender;
    NSInteger index = btn.tag - 2000;
    GroupInvite_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:index];
   
    ELPersonCenterCtl *personCtl = [[ELPersonCenterCtl alloc] init];
    [self.navigationController pushViewController:personCtl animated:NO];
    [personCtl beginLoad:dataModal.requestInfo_.id_ exParam:nil];
    
    NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"个人主页",NSStringFromClass([self class])]};
    [MobClick event:@"buttonClick" attributes:dict];
}

-(void)btnResponse:(id)sender
{
    if (!con_) {
        con_ = [self getNewRequestCon:NO];
    }
    
    UIButton *btn = sender;
    btnTag = btn.tag;
    NSInteger  indexrow = btn.tag-1000;
    dealtypeStr = @"agree";
    GroupInvite_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexrow];
    if ([dataModal.type_ isEqualToString:@"201"]) {
        //处理邀请
        [con_ handleGroupInvitation:dataModal.groupInfo_.id_ reqUserId:dataModal.createrId_ resUserId:[Manager getUserInfo].userId_ dealType:dealtypeStr losgId:dataModal.id_];
    }else if([dataModal.type_ isEqualToString:@"202"]){
        //处理申请
        [con_ handleGroupApply:dataModal.groupInfo_.id_ reqUserId:dataModal.requestInfo_.id_ resUserId:[Manager getUserInfo].userId_ dealType:dealtypeStr losgId:dataModal.id_];
    }
    
    [self updateView];
    
}

#pragma mark - GroupMessageReplyDelegete

-(void)pushReplyViewCtl
{
    Comment_DataModal *selectDataModal_ = [[Comment_DataModal alloc] init];
    ReplyCommentCtl *replyCommentCtl = [[ReplyCommentCtl alloc] init];
    replyCommentCtl.delegate_ = self;
    replyCommentCtl.objId_ = selectModal.article_id;//文章id
    replyCommentCtl.proId_ = @"";
    selectDataModal_.id_ = selectModal.comment_id;
    [replyCommentCtl beginLoad:selectDataModal_ exParam:nil];

    needHiddenMark = YES;
    [tableView_ reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_row inSection:0], nil] withRowAnimation:UITableViewRowAnimationBottom];
    [self.navigationController pushViewController:replyCommentCtl animated:YES];
}

-(void)pushArticleDetailCtl
{
    if(!selectModal.article_id){
        return;
    }
    Article_DataModal *article = [[Article_DataModal alloc] init];
    article.id_ = selectModal.article_id;
    ArticleDetailCtl *articleDetailCtl = [[ArticleDetailCtl alloc]init];


    needHiddenMark = YES;
    [tableView_ reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_row inSection:0], nil] withRowAnimation:UITableViewRowAnimationBottom];
    [self.navigationController pushViewController:articleDetailCtl animated:YES];
    
    
    if (article.articleType_ == Article_Group)
    {
        articleDetailCtl.isFromGroup_ = YES;
    }
    [articleDetailCtl beginLoad:article exParam:nil];
    NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"文章详情",NSStringFromClass([self class])]};
    [MobClick event:@"buttonClick" attributes:dict];
}

-(void)addReplyCommentOK:(ReplyCommentCtl *)ctl dataModal:(Comment_DataModal *)dataModal
{
    [self refreshLoad:nil];
}

#pragma mark - ELGroupDetailCtlDelegate
-(void)refresh{
    [self refreshLoad:nil];
}

-(void)joinSuccess{
    [self refreshLoad:nil];
}

@end

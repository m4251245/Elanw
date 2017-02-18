//
//  ExpertPublishCtl.m
//  Association
//
//  Created by YL1001 on 14-6-20.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "ExpertPublishCtl.h"
#import "MyPubilshCtl_Cell.h"
#import "Article_DataModal.h"
#import "NoLoginPromptCtl.h"
#import "YLArticleAttachmentCtl.h"
#import "TodayFocus_Cell.h"
#import "TheContactListCtl.h"
#import "ELActivityListCell.h"
#import "PublishArticle.h"

@interface ExpertPublishCtl () <NoLoginDelegate,PublishArticleDelegate>
{
    IBOutlet UIButton *rightBtn_;
    IBOutlet UIView *headerView;
    Article_DataModal * _shareArticle;
    RequestCon *_shareCon;
}
@end

@implementation ExpertPublishCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bFooterEgo_ = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tableView_.backgroundView = nil;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
     
    if (_isMyCenter)
    {
        if(!_isShareArticle)
        {
            UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn_];
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            NSInteger width = -10;
            negativeSpacer.width = width;
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];
        }
        if (_isShareArticle) {
//            self.navigationItem.title = @"我的分享";
            [self setNavTitle:@"我的分享"];
            
        }
        else
        {
//            self.navigationItem.title = @"我的发表";
            [self setNavTitle:@"我的发表"];
//            tableView_.tableHeaderView = headerView;
        }
    }
    else
    {
        if(_isShareArticle)
        {
//            self.navigationItem.title = @"TA的分享";
            [self setNavTitle:@"TA的分享"];
        }
        else
        {
//            self.navigationItem.title = @"TA的发表";
            [self setNavTitle:@"TA的发表"];
        }
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (!_stateType) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    if ([dataModal isKindOfClass:[Expert_DataModal class]]) {
        inDataModal_ = dataModal;
    }else if ([dataModal isKindOfClass:[NSString class]]){
        inDataModal_.id_ = dataModal;
    }
}


-(void)getDataFunction:(RequestCon *)con
{
    if (_isMyCenter)
    {
        if(_isShareArticle)
        {
            [con getMyShareArticleList:[Manager getUserInfo].userId_ page:requestCon_.pageInfo_.currentPage_ pageSize:20 status:@""];
        }
        else
        {
           [con getMyPublishList:[Manager getUserInfo].userId_ page:requestCon_.pageInfo_.currentPage_ pageSize:20 status:@""];
        }
        
    }
    else{
        if(_isShareArticle)
        {
            [con getMyShareArticleList:inDataModal_.id_ page:requestCon_.pageInfo_.currentPage_ pageSize:20 status:@""];
        }
        else
        {
            [con getMyPublishList:inDataModal_.id_ page:requestCon_.pageInfo_.currentPage_ pageSize:20 status:@""];
        }
    }
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_MyPubilsh:
        {
            if (dataArr.count <= 0) {
                tableView_.tableHeaderView = nil;
            }
            
            if (_isMyCenter)
            {
                if (!_isShareArticle) {
                    tableView_.tableHeaderView = headerView;
                }
            }
            
            [tableView_ reloadData];
        }
            break;
        case Request_DeleteArticle:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"]) {
                TodayFocusFrame_DataModal *model = [requestCon_.dataArr_ objectAtIndex:indexPath_.row];
                [requestCon_.dataArr_ removeObject:model];
                [_delegate articleListDeleteSuccess];
                [BaseUIViewController showAutoDismissSucessView:@"删除成功" msg:nil seconds:0.5];
                [tableView_ reloadData];
                [self adjustFooterViewFrame];
            }else{
                [BaseUIViewController showAutoDismissSucessView:@"删除失败" msg:nil seconds:0.5];
            }
        }
            break;
        default:
            break;
    }
}

-(void)btnResponse:(id)sender
{
    if(sender == rightBtn_)
    {
        PublishArticle * publishArticleCtl = [[PublishArticle alloc] init];
        publishArticleCtl.type_ = Article;
        publishArticleCtl.isFromPublishList = YES;
        publishArticleCtl.delegate_ = self;
        [self.navigationController pushViewController:publishArticleCtl animated:YES];
        [publishArticleCtl beginLoad:nil exParam:nil];
    }
}

-(void)publishSuccess
{
    [self refreshLoad:nil];
    if([_delegate respondsToSelector:@selector(publishArticleSuccessRefressh)])
    {
        [_delegate publishArticleSuccessRefressh];
    }
}

-(void)showNoDataOkView:(BOOL)flag
{
    if( flag ){
        UIView *noDataOkSuperView = [self getNoDataSuperView];
        UIView *noDataOkView = [self getNoDataView];
        if( noDataOkSuperView && noDataOkView ){
            [noDataOkSuperView addSubview:noDataOkView];
            
            //set the rect
            CGRect rect = noDataOkView.frame;
			rect.origin.x = (int)((noDataOkSuperView.frame.size.width - rect.size.width)/2.0);
			rect.origin.y = (int)((noDataOkSuperView.frame.size.height - rect.size.height)/4.0);
			[noDataOkView setFrame:rect];
        }else{
            [MyLog Log:@"noDataSuperView or noDataView is null,if you want to show noDataOkView, please check it" obj:self];
        }
    }else{
        [[self getNoDataView] removeFromSuperview];
    }
    
}

- (void)backBarBtnResponse:(id)sender
{
    [tableView_ setEditing:NO];
    if (_isMyCenter && [_type isEqualToString:@"1"]) {
        NSArray *array = self.navigationController.viewControllers;
        [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
    }else{
        [tableView_ resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodayFocusFrame_DataModal *articleModel = requestCon_.dataArr_[indexPath.row];
    if (articleModel.isActivityArtcle)
    {
        static NSString *cellStr = @"ELActivityListCell";
        ELActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"ELActivityListCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
        }
        cell.dataModel = articleModel.sameTradeArticleModel._activity_info;
        cell.activityLable.hidden = NO;
        return cell;
    }
    
    static NSString *reuseIdentifier = @"TodayFocus_Cell";
    TodayFocus_Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"TodayFocus_Cell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView = bgView;
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
    cell.tipsLb.hidden = YES;
    cell.showStatusLable = YES;
    cell.showStatusShot = YES;
    cell.model = articleModel;
    return cell;    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TodayFocusFrame_DataModal *articleModel = requestCon_.dataArr_[indexPath.row];
    if (articleModel.isActivityArtcle)
    {
        if (requestCon_.dataArr_.count > indexPath.row+1) {
            TodayFocusFrame_DataModal *model = requestCon_.dataArr_[indexPath.row +1];
            if (model.isActivityArtcle) {
                return 162;
            }
        }
        return 170;
    }
    return articleModel.height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isMyCenter && !_isShareArticle) {
        return YES;
    }else{
        return NO;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        indexPath_ = indexPath;
        TodayFocusFrame_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
        if (!deleteCon_) {
            deleteCon_ = [self getNewRequestCon:NO];
        }
        [deleteCon_ deleteArticle:[Manager getUserInfo].userId_ articleId:dataModal.sameTradeArticleModel.article_id];
        
    }
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STOPVOICE" object:nil];
    TodayFocusFrame_DataModal * dataModal = selectData;
    if (dataModal.articleType_ == Article_File) {
        
//        YLMediaModal *modal = [[YLMediaModal alloc] init];
//        modal.filePages = [NSString stringWithFormat:@"%ld",(long)dataModal.filePages_];
//        modal.fileSwf = [MyCommon getWithFileSwf:dataModal.file_swf];
//        modal.articleId = dataModal.id_;
//        YLArticleAttachmentCtl *ctl = [[YLArticleAttachmentCtl alloc] init];
//        ctl.dataModal = modal;
//        [self.navigationController pushViewController:ctl animated:YES];
    }
    else
    {
        ArticleDetailCtl* contentDetailCtl = [[ArticleDetailCtl alloc] init];
        contentDetailCtl.type_ = @"1";
        [self.navigationController pushViewController:contentDetailCtl animated:YES];
        [contentDetailCtl beginLoad:dataModal.sameTradeArticleModel.article_id exParam:nil];
        NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"文章详情",NSStringFromClass([self class])]};
        [MobClick event:@"buttonClick" attributes:dict];
    }

}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void) alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch ( type ) {
        case 1:
        {
            [[Manager shareMgr] loginOut];
            [Manager shareMgr].haveLogin = NO;
        }
            
            break;
        default:
            break;
    }
}

@end

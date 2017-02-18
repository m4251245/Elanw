//
//  MyFavoriteArticleList.m
//  jobClient
//
//  Created by 一览ios on 15/8/14.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MyFavoriteArticleList.h"
#import "ExRequetCon.h"
#import "Article_DataModal.h"
#import "TodayFocus_Cell.h"
//#import "TheContactListCtl.h"
#import "ELActivityListCell.h"
#import "ELMyCollectNoDataView.h"

@interface MyFavoriteArticleList ()
{
    RequestCon *_cancelFavoriteCon;
}
@end

@implementation MyFavoriteArticleList

- (void)viewDidLoad {
    [super viewDidLoad];
    bHeaderEgo_ = YES;
    bFooterEgo_ = YES;
    
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
    [con getArticleFavoriteList:[Manager getUserInfo].userId_ type:@"1" pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:15];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView = bgView;
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
    cell.showStatusShot = YES;
    cell.model = articleModel;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
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
        TodayFocusFrame_DataModal *article = requestCon_.dataArr_[indexPath.row];
        [requestCon_.dataArr_ removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationBottom];
        [self doCancelFavorite:article.sameTradeArticleModel.article_id];
    }
}

- (void)doCancelFavorite:(NSString *)articleId
{
    if (!_cancelFavoriteCon) {
        _cancelFavoriteCon = [self getNewRequestCon:NO];
    }
    
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        [BaseUIViewController showAutoDismissFailView:nil msg:@"请登录后再取消收藏"];
        return;
    }
    [_cancelFavoriteCon addArticleFavorite:articleId userId:userId type:@"cancel"];
}

/*
- (void)doCancelMediaFavorite:(NSString *)articleId
{
    if (!_cancelFavoriteCon) {
        _cancelFavoriteCon = [self getNewRequestCon:NO];
    }
    
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        [BaseUIViewController showAutoDismissFailView:nil msg:@"请登录后再取消收藏"];
        return;
    }
    [_cancelFavoriteCon addArticleMediaFavorite:articleId userId:userId type:@"cancel"];
}
 */

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    TodayFocusFrame_DataModal *articleModel = (TodayFocusFrame_DataModal *)selectData;
    if (_fromMessageList) {
        Article_DataModal *modal = [[Article_DataModal alloc] init];
        modal.id_ = articleModel.sameTradeArticleModel.article_id;
        modal.title_ = articleModel.sameTradeArticleModel.title;
        modal.thum_ = articleModel.sameTradeArticleModel.thumb;
        modal.summary_ = articleModel.sameTradeArticleModel.summary;
        [_shareDelegate shareMessageDelegateModal:modal];
        return;
    }
    //文章分为 社群 新闻 和个人发表， 目前社群和个人发表是一个页面
    if ([articleModel.sameTradeArticleModel.yf_type isEqualToString:@"1"])
    {
        ArticleDetailCtl * articleDetailCtl = [[ArticleDetailCtl alloc] init];
        if ([articleModel.sameTradeArticleModel.yf_type_code isEqualToString:@"xinwen"])
        {
            articleDetailCtl.isFromNews = YES;
        }
        [self.navigationController pushViewController:articleDetailCtl animated:YES];
        [articleDetailCtl beginLoad:articleModel.sameTradeArticleModel.article_id exParam:nil];
        NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"文章详情",NSStringFromClass([self class])]};
        [MobClick event:@"buttonClick" attributes:dict];
    }
}


- (void)showNoDataView
{
    if ([requestCon_.dataArr_ count] == 0) {
        UIView *view = [self.view viewWithTag:1000];
        if (view != nil) {
            [view removeFromSuperview];
        }
        [self noDataView];
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
        case Request_GetArticleFavoriteList:
        {
            [self showNoDataView];
            [tableView_ reloadData];
        }
            break;
        case Request_AddArticleFavorite:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            if( [dataModal.status_ isEqualToString:Success_Status] ){
                if ([dataModal.code_ isEqualToString:@"200"]) {
                    [BaseUIViewController showAutoDismissAlertView:nil msg:@"取消收藏成功" seconds:2.0];
                    [self showNoDataView];
                }else{
                    [BaseUIViewController showAutoDismissAlertView:nil msg:dataModal.des_ seconds:2.0];
                }
            }
            else{
                [BaseUIViewController showAlertView:nil msg:@"取消收藏失败,请稍后再试" btnTitle:@"确定"];
            }
        }
        default:
            break;
    }
}

- (void)startEditor
{
    BOOL isEditing = tableView_.isEditing;
    if (self.block) {
        self.block(isEditing);
    }
    [tableView_ setEditing:!isEditing animated:YES];
}

- (void)stopEditro
{
    [tableView_ setEditing:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

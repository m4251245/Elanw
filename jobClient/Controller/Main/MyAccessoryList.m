//
//  MyAccessoryList.m
//  jobClient
//
//  Created by 一览ios on 15/8/14.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MyAccessoryList.h"
#import "ExRequetCon.h"
#import "ArticleFavoritListCell.h"
#import "YLMediaModal.h"
#import "YLArticleAttachmentCtl.h"
#import "ELMyCollectNoDataView.h"

@interface MyAccessoryList ()
{
    BOOL    _isEditing;
    RequestCon  *_cancelFavoriteCon;
}
@end

@implementation MyAccessoryList

- (void)viewDidLoad {
    [super viewDidLoad];
    bHeaderEgo_ = YES;
    bFooterEgo_ = YES;
    CGRect frame = tableView_.frame;
    frame.origin.y = 0;
    tableView_.frame = frame;
    // Do any additional setup after loading the view from its nib.
}


- (void)noDataView
{
    ELMyCollectNoDataView *noDataView = [[ELMyCollectNoDataView alloc] initWithFrame:tableView_.frame];
    noDataView.tag = 1000;
    [self.view addSubview:noDataView];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    if(con == requestCon_){
        NSString *myId = [Manager getUserInfo].userId_;
        if (!myId) {
            return;
        }
        [con getArticleFavoriteList:myId type:@"4" pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:10];
    }
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
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
        case Request_GetArticleFavoriteList:
        {
            [self showNoDataView];
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
            }else if( [dataModal.status_ isEqualToString:Fail_Status] ){
                //                [BaseUIViewController showAutoDismissAlertView:nil msg:dataModal.des_ seconds:2.0];
            }else{
                [BaseUIViewController showAlertView:nil msg:@"取消收藏失败,请稍后再试" btnTitle:@"确定"];
            }
        }
            break;
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [tableView_ setEditing:NO];
}

//---------------datasource--------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return requestCon_.dataArr_.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article_DataModal *article = requestCon_.dataArr_[indexPath.row];
    static NSString *str = @"cellOne";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imageTitle = [[UIImageView alloc] initWithFrame:CGRectMake(10,19,30,30)];
        imageTitle.clipsToBounds = YES;
        imageTitle.tag = 100;
        imageTitle.layer.cornerRadius = 4.0f;
        [cell.contentView addSubview:imageTitle];
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(50,24,self.view.frame.size.width-65,20)];
        titleLable.font = FIFTEENFONT_TITLE;
        titleLable.tag = 200;
        [cell.contentView addSubview:titleLable];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0,67,ScreenHeight,1)];
        image.image = [UIImage imageNamed:@"gg_home_line2@2x.png"];
        [cell.contentView addSubview:image];
        
        UIImageView *imageRight = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-15,27,7,13)];
        imageRight.image = [UIImage imageNamed:@"right_grey"];
        imageRight.tag = 1002;
        [cell.contentView addSubview:imageRight];
    }
    
    UIImageView *titleImage = (UIImageView *)[cell viewWithTag:100];
    titleImage.image = [UIImage imageNamed:[YLMediaModal getImageNameWithString:[YLMediaModal getStringWithPostfix:article.title_]]];
    
    UILabel *titleLb = (UILabel *)[cell viewWithTag:200];
    titleLb.text = article.title_;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleFavoritListCell *cell = (ArticleFavoritListCell *)[tableView cellForRowAtIndexPath:indexPath];
    Article_DataModal *modal = requestCon_.dataArr_[indexPath.row];
    if([modal.collectType isEqualToString:@"4"]){
        UIImageView *image = (UIImageView *)[cell viewWithTag:1002];
        if ([tableView_ isEditing]) {
            image.hidden = YES;
        }
        else
        {
            image.hidden = NO;
        }
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
        Article_DataModal *article = requestCon_.dataArr_[indexPath.row];
        [requestCon_.dataArr_ removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationBottom];
        if ([article.collectType isEqualToString:@"1"]) {
            [self doCancelFavorite:article.id_];
        }
        else if ([article.collectType isEqualToString:@"4"])
        {
            [self doCancelMediaFavorite:article.collectId];
        }
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


- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    //文章分为 社群 新闻 和个人发表， 目前社群和个人发表是一个页面
    Article_DataModal *articleModel = (Article_DataModal *)selectData;
    
    if ([articleModel.collectType isEqualToString:@"1"])
    {
        ArticleDetailCtl * articleDetailCtl = [[ArticleDetailCtl alloc] init];
        if ([articleModel.typeCode isEqualToString:@"xinwen"])
        {
            articleDetailCtl.isFromNews = YES;
        }
        [self.navigationController pushViewController:articleDetailCtl animated:YES];
        [articleDetailCtl beginLoad:selectData exParam:nil];
    }
    else if ([articleModel.collectType isEqualToString:@"4"])
    {
        YLMediaModal *modal = [[YLMediaModal alloc] init];
        modal.file_pages = articleModel.collectFilePage;
        modal.postfix = [YLMediaModal getStringWithPostfix:articleModel.collectSrc];
        if ([modal.postfix.lowercaseString isEqualToString:@"jpg"] || [modal.postfix.lowercaseString isEqualToString:@"png"] || [modal.postfix.lowercaseString isEqualToString:@"jpeg"] || [modal.postfix.lowercaseString isEqualToString:@"gif"] ||[modal.postfix.lowercaseString isEqualToString:@"bmp"])
        {
            modal.src = articleModel.collectSrc;
        }
        else
        {
            modal.file_swf = [MyCommon getWithFileSwf:articleModel.collectFileSwf];
        }
        
        YLArticleAttachmentCtl *ctl = [[YLArticleAttachmentCtl alloc] init];
        ctl.dataModal = modal;
        ctl.isPushFavoriteListCtl = YES;
        [self.navigationController pushViewController:ctl animated:YES];
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

- (void)stopEditro
{
    [tableView_ setEditing:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

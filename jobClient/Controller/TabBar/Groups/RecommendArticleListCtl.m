//
//  RecommendArticleListCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-11-30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "RecommendArticleListCtl.h"
#import "RecommentArticleListCell.h"

@interface RecommendArticleListCtl ()
{
    NSString *groupId;
    NSString *articleIdStr;
    
    //是否有置顶话题
    BOOL isHas;
}
@end

@implementation RecommendArticleListCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        bHeaderEgo_ = YES;
        bFooterEgo_ = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"话题管理"];
    articleIdStr = @"";
    topCount = 0;
    topView.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
    topView.layer.borderWidth = 0.5;
    [topLb_ setFont:FIFTEENFONT_TITLE];
    [topLb_ setTextColor:GRAYCOLOR];
    
    recommendBtn.layer.cornerRadius = 2.0;
    recommendBtn.layer.masksToBounds = YES;
    [recommendBtn.titleLabel setFont:FOURTEENFONT_CONTENT];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

- (void)getDataFunction:(RequestCon *)con
{
    [con setRecommendArticle:groupId pageSize:15 pageIndex:requestCon_.pageInfo_.currentPage_];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    if ([dataModal isKindOfClass:[Groups_DataModal class]]) {
        Groups_DataModal *modal = dataModal;
        groupId = modal.id_;
    }else{
        groupId = dataModal;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecommentArticleListCell";
    RecommentArticleListCell *cell = (RecommentArticleListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecommentArticleListCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    Article_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    if (dataModal.isTop_) {
        [cell.markBtn_ setHidden:NO];
    }else{
        [cell.markBtn_ setHidden:YES];
    }
    
    [cell.titleLb_ setFont:FOURTEENFONT_CONTENT];
    [cell.markBtn_ setTag:indexPath.row +1000];
    [cell.titleLb_ setTextColor:BLACKCOLOR];
    [cell.titleLb_ setText:dataModal.title_];
    return cell;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    Article_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    [self getTopCount];
    if (dataModal.isTop_ == YES) {
        dataModal.isTop_ = NO;
        topCount --;
    }else{
        if (topCount >= 2) {
            
            [BaseUIViewController showAutoDismissFailView:nil msg:@"最多选择2个话题置顶"];
            return;
        }
        dataModal.isTop_ = YES;
        topCount ++;
    }
    [tableView_ reloadData];

}

- (void)btnResponse:(id)sender
{
    if (sender == recommendBtn) {
        //置顶
        if (requestCon_.dataArr_.count > 0) {
            [self getTopCount];
            
            if (!isHas && topCount == 0) {
                [BaseUIViewController showAutoDismissFailView:nil msg:@"请选择置顶话题" seconds:1.0];
            }
            else
            {
                [self getArticleID];
                if (topCount <= 0) {
                    articleIdStr = @"";
                    [self showChooseAlertView:1 title:@"温馨提示" msg:@"是否取消所有置顶文章" okBtnTitle:@"确认" cancelBtnTitle:@"取消"];
                    return;
                }
                if (!recommendCon_) {
                    recommendCon_ = [self getNewRequestCon:NO];
                }
                [recommendCon_ saveRecommendSet:groupId userId:[Manager getUserInfo].userId_ articleId:articleIdStr type:@"top"];
            }
        }
    }
}

- (void)getTopCount
{
    topCount = 0;
    for (Article_DataModal *dataModal in requestCon_.dataArr_) {
        if (dataModal.isTop_) {
            topCount ++;
        }
    }
}

- (void)getArticleID
{
    BOOL  firstAdd = NO;
    articleIdStr = @"";
    for (int i=0; i <[requestCon_.dataArr_ count]; i++) {
        Article_DataModal *model = [requestCon_.dataArr_ objectAtIndex:i];
        if (model.isTop_) {
            if (firstAdd == NO) {
                articleIdStr = [articleIdStr stringByAppendingString:[NSString stringWithFormat:@"%@",model.id_]];
                firstAdd = YES;
            }else{
                articleIdStr = [articleIdStr stringByAppendingString:[NSString stringWithFormat:@",%@",model.id_]];
            }
        }
    }
}


-(void) alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch ( type ) {
        case 1:
        {
            if (!recommendCon_) {
                recommendCon_ = [self getNewRequestCon:NO];
            }
            [recommendCon_ saveRecommendSet:groupId userId:[Manager getUserInfo].userId_ articleId:@"" type:@"top"];
        }
            break;
        default:
            break;
    }
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_SetRecommendArticle:
        {
            [self getTopCount];
            if (topCount > 0) {
                isHas = YES;
            }
            else {
                isHas = NO;
            }
        }
            break;
        case Request_SaveRecommendSet:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ASSOCIATIONDETAILFRESH" object:nil];
                [BaseUIViewController showAutoDismissSucessView:model.des_ msg:nil seconds:0.5];
            }else{
                [BaseUIViewController showAutoDismissFailView:model.des_ msg:nil seconds:0.5];
            }
        }
            break;
        default:
            break;
    }
}

@end

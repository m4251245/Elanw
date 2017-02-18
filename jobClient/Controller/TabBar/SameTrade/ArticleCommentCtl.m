//
//  ArticleCommentCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-10-24.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "ArticleCommentCtl.h"
#import "ArticleCommentCell.h"
#import "NewCommentMsgModel.h"

@interface ArticleCommentCtl ()

@end

@implementation ArticleCommentCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bHeaderEgo_ = YES;
        bFooterEgo_ = YES;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"谁评论了我的文章"];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    [tableView_ setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
}

-(void)getDataFunction:(RequestCon *)con
{
    if (!con) {
        con = [self getNewRequestCon:YES];
    }
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSString *times = [defaults objectForKey:@"HOMETIMEUSERDEFAULT"];
    [con getMyArticleCommentList:[Manager getUserInfo].userId_ homeTime:times pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:20];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetMyArticleCommentList:
        {
            
        }
            break;
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArticleCommentCell";
    
    ArticleCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ArticleCommentCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundView_.layer.borderWidth = 0.5;
        cell.backgroundView_.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
        //样式
        cell.photoImgv_.layer.cornerRadius = 3.5;
        cell.photoImgv_.layer.masksToBounds = YES;
        cell.tipsNewImgv_.layer.cornerRadius = 5.0;
        cell.tipsNewImgv_.layer.masksToBounds = YES;
        [cell.nameLb_ setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13]];
        [cell.nameLb_ setTextColor:BLACKCOLOR];
        [cell.articleDescLb_ setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13]];
        [cell.articleDescLb_ setTextColor:LIGHTGRAYCOLOR];
        [cell.articleContentLb_ setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13]];
        [cell.articleContentLb_ setTextColor:LIGHTGRAYCOLOR];
        [cell.articleTimeLb_ setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:11]];
        [cell.articleTimeLb_ setTextColor:LIGHTGRAYCOLOR];
    }
    NewCommentMsgModel *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    [cell.articleDescLb_ setText:[NSString stringWithFormat:@"评论了:%@",model.articleTitle_]];
    [cell.articleTimeLb_ setText:model.createTime_];
    //是否新评论
    if ([model.isVisit_ isEqualToString:@"1"]) {
        [cell.tipsNewImgv_ setHidden:NO];
    }else{
        [cell.tipsNewImgv_ setHidden:YES];
    }
    
    [cell.photoImgv_ sd_setImageWithURL:[NSURL URLWithString:model.commentPhoto_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"] options:SDWebImageAllowInvalidSSLCertificates];
    //动态评论描述
    CGSize nameSize = [model.name_ sizeNewWithFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13] constrainedToSize:CGSizeMake(80, 0) lineBreakMode:NSLineBreakByWordWrapping];
    [cell.nameLb_ setText:model.name_];
    CGRect nameRect = cell.nameLb_.frame;
    nameRect.size.width = nameSize.width;
    [cell.nameLb_ setFrame:nameRect];
    //动态名字后面Lb位置
    CGRect descLbRect = cell.articleDescLb_.frame;
    descLbRect.origin.x = nameRect.origin.x + nameRect.size.width + 4;
    descLbRect.size.width = 290 - descLbRect.origin.x;
    [cell.articleDescLb_ setFrame:descLbRect];
    //动态内容Lb大小
    [Common setLbByText:cell.articleContentLb_ text:model.commentcontent_ font:[UIFont fontWithName:@"STHeitiSC-Medium" size:13] maxLine:3];
    CGRect contentLbRect = cell.articleContentLb_.frame;
    //时间位置
    CGRect timeRect = cell.articleTimeLb_.frame;
    timeRect.origin.y = contentLbRect.origin.y + contentLbRect.size.height + 4;
    [cell.articleTimeLb_ setFrame:timeRect];
    
    CGRect backgroundRect = cell.backgroundView_.frame;
    backgroundRect.size.height = timeRect.origin.y + timeRect.size.height + 10;
    [cell.backgroundView_ setFrame:backgroundRect];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewCommentMsgModel *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    float height = [Common getDynHeight:model.commentcontent_ objWidth:242 font:[UIFont fontWithName:@"STHeitiSC-Medium" size:13]];
    if (height <= 15) {
        return 75;   //原始大小
    }else if (height <=55){
        return 75 + height-15;
    }else if (height > 55){
        return 75 + 40;
    }
    return 0;
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    NewCommentMsgModel *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    Article_DataModal *articleModel = [[Article_DataModal alloc]init];
    articleModel.id_ = model.articleId_;
    articleModel.title_ = model.articleTitle_;
    ArticleDetailCtl * articleDetailCtl = [[ArticleDetailCtl alloc] init];
    [self.navigationController pushViewController:articleDetailCtl animated:YES];
    [articleDetailCtl beginLoad:articleModel exParam:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

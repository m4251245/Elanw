//
//  CommentMessageListCtl.m
//  jobClient
//
//  Created by YL1001 on 14/10/28.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "CommentMessageListCtl.h"
#import "Comment_DataModal.h"
#import "CommentMessage_Cell.h"
#import "MLEmojiLabel.h"
#import "ELPersonCenterCtl.h"
#import "SalaryIrrigationDetailCtl.h"

@interface CommentMessageListCtl ()

@end

@implementation CommentMessageListCtl
static NSString * pCommentType_ = @"250";     //发表的评论
static NSString * tCommentType_ = @"251";     //社群话题的评论

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
    [self setNavTitle:@"新的评论"];
    [tableView_ setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    [con getMyCommentList:[Manager getUserInfo].userId_ pageSize:20 pageIndex:requestCon_.pageInfo_.currentPage_];
}


-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetMyCommentList:
        {
            for (Comment_DataModal * dataModal in requestCon_.dataArr_) {
                if ([MyCommon checkMessageIsExistInDB:dataModal.id_ userId:[Manager getUserInfo].userId_]) {
                    dataModal.bRead_ = YES;
                }
            }
        }
            break;
            
        default:
            break;
    }
}

- (MLEmojiLabel *)emojiLabel:(NSString *)text numberOfLines:(int)num
{
    MLEmojiLabel * emojiLabel;
    emojiLabel = [[MLEmojiLabel alloc]init];
    emojiLabel.numberOfLines = num;
    emojiLabel.font = TWEELVEFONT_COMMENT;
    emojiLabel.textColor = [UIColor darkGrayColor];
    emojiLabel.backgroundColor = [UIColor clearColor];
    emojiLabel.lineBreakMode = NSLineBreakByWordWrapping;
    emojiLabel.isNeedAtAndPoundSign = YES;
    emojiLabel.customEmojiRegex = Custom_Emoji_Regex;
    emojiLabel.customEmojiPlistName = @"emoticons.plist";
    [emojiLabel setEmojiText:text];
    return emojiLabel;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentMessageCell";
    
    CommentMessage_Cell *cell = (CommentMessage_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentMessage_Cell" owner:self options:nil] lastObject];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.contentView_.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
        cell.contentView_.layer.borderWidth = 0.5;
        [cell.nameLb_ setFont:FOURTEENFONT_CONTENT];
        [cell.titleLb_ setFont:FOURTEENFONT_CONTENT];
        [cell.contentLb_ setFont:TWEELVEFONT_COMMENT];
        [cell.nameLb_ setTextColor:BLACKCOLOR];
        [cell.titleLb_ setTextColor:LIGHTGRAYCOLOR];
        [cell.contentLb_ setTextColor:GRAYCOLOR];
        [cell.timeLb_ setFont:NINEFONT_TIME];
        [cell.timeLb_ setTextColor:LIGHTGRAYCOLOR];
    }
    
    Comment_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    if (dataModal.bRead_) {
        [cell.markNewImg_ setHidden:NO];
    }else{
        [cell.markNewImg_ setHidden:YES];
    }
    
    [cell.userImg_ sd_setImageWithURL:[NSURL URLWithString:dataModal.imageUrl_] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    cell.userImg_.userInteractionEnabled = YES;
    cell.userImg_.tag = 2000+indexPath.row;
    [cell.userImg_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personCenterTap:)]];
    
    cell.nameLb_.text = dataModal.userName_;
    CGSize nameSize = [dataModal.userName_ sizeNewWithFont:FOURTEENFONT_CONTENT];
    CGRect rect = cell.nameLb_.frame;
    rect.size.width = nameSize.width;
    cell.nameLb_.frame = rect;
    
    if (dataModal.parentId.length > 5)
    {
        cell.titleLb_.text = [NSString stringWithFormat:@"回复了:%@",dataModal.parentContent];
    }
    else
    {
        cell.titleLb_.text = [NSString stringWithFormat:@"评论了:%@",dataModal.objectTitle_];
    }
    rect = cell.titleLb_.frame;
    rect.origin.x = cell.nameLb_.frame.origin.x + cell.nameLb_.frame.size.width + 5;
    rect.size.width = cell.contentView_.frame.size.width - rect.origin.x - 3;
    cell.titleLb_.frame = rect;
    
    NSString * content = [dataModal.content_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    MLEmojiLabel *emojiLabel = [self emojiLabel:content numberOfLines:3];
    emojiLabel.tag = 1001;
    emojiLabel.frame = CGRectMake(40, 30, 260, 0);
    [emojiLabel sizeToFit];
    UIView *oldView = [cell.contentView_ viewWithTag:1001];
    [oldView removeFromSuperview];
    
    [cell.contentView_ addSubview:emojiLabel];
    cell.contentLb_.hidden = YES;
    float height = emojiLabel.frame.size.height;
    cell.timeLb_.text = dataModal.datetime_;
    rect = cell.timeLb_.frame;
    rect.origin.y = emojiLabel.frame.origin.y + height ;
    cell.timeLb_.frame = rect;
    
    rect = cell.contentView_.frame;
    rect.size.height = cell.timeLb_.frame.origin.y + cell.timeLb_.frame.size.height;
    cell.contentView_.frame = rect;
    
    //NSLog(@"%f",cell.contentView_.frame.size.height + cell.contentView_.frame.origin.y);
    
    return cell;

}

-(void)personCenterTap:(UITapGestureRecognizer *)sender
{
    Comment_DataModal * dataModal = requestCon_.dataArr_[sender.view.tag-2000];
    dataModal.bRead_ = NO;
    [tableView_ reloadData];
   
    if ([dataModal.articleType isEqualToString:@"1"])//灌薪水评论
    {
        ELSalaryModel *model = [[ELSalaryModel alloc] init];
        model.article_id = dataModal.objectId_;
        model.title_ = dataModal.objectTitle_;
        model.bgColor_ = WhiteColor;
        SalaryIrrigationDetailCtl *detailCtl = [[SalaryIrrigationDetailCtl alloc] init];
        [self.navigationController pushViewController:detailCtl animated:YES];
        [detailCtl beginLoad:model exParam:nil];
    }
    else
    {
        Article_DataModal * article = [[Article_DataModal alloc] init];
        article.id_ = dataModal.objectId_;
        article.title_ = dataModal.objectTitle_;
        if (dataModal.userId_.length > 5)
        {
            ELPersonCenterCtl *ctl = [[ELPersonCenterCtl alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
            [ctl beginLoad:dataModal.userId_ exParam:nil];
        }
        else
        {
            ArticleDetailCtl * detailCtl = [[ArticleDetailCtl alloc] init];
            detailCtl.bScrollToComment_ = YES;
            detailCtl.isFromGroup_ = YES;
            [self.navigationController pushViewController:detailCtl animated:YES];
            [detailCtl beginLoad:article exParam:nil];
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    float totalHeight = 0;
    float height = 0.0;
    NSString * content = [dataModal.content_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    MLEmojiLabel *emojiLabel = [self emojiLabel:content numberOfLines:3];
    emojiLabel.frame = CGRectMake(0, 0, 260, 0);
    [emojiLabel sizeToFit];
    height = emojiLabel.frame.size.height;
    float contentViewY = 8;
    float contentLbY = 30;
    float timeLbHeight = 21;
    
    totalHeight = contentViewY + contentLbY + height + timeLbHeight;

    return totalHeight;
}



-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    Comment_DataModal * dataModal = selectData;

    
    dataModal.bRead_ = NO;
    [tableView_ reloadData];
   
    if ([dataModal.articleType isEqualToString:@"1"])//灌薪水评论
    {
        ELSalaryModel *model = [[ELSalaryModel alloc] init];
        model.article_id = dataModal.objectId_;
        model.title_ = dataModal.objectTitle_;
        model.bgColor_ = WhiteColor;
        SalaryIrrigationDetailCtl *detailCtl = [[SalaryIrrigationDetailCtl alloc] init];
        [self.navigationController pushViewController:detailCtl animated:YES];
        [detailCtl beginLoad:model exParam:nil];
        NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"帖子详情",NSStringFromClass([self class])]};
        [MobClick event:@"buttonClick" attributes:dict];
    }
    else
    {
        Article_DataModal * article = [[Article_DataModal alloc] init];
        article.id_ = dataModal.objectId_;
        article.title_ = dataModal.objectTitle_;
        ArticleDetailCtl * detailCtl = [[ArticleDetailCtl alloc] init];
        detailCtl.bScrollToComment_ = YES;
        detailCtl.isFromGroup_ = YES;
        [self.navigationController pushViewController:detailCtl animated:YES];
        [detailCtl beginLoad:article exParam:nil];
        
        NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"文章详情",NSStringFromClass([self class])]};
        [MobClick event:@"buttonClick" attributes:dict];
    }
}

//-(void)backBarBtnResponse:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:NO];
//    [[Manager shareMgr].mmdrawerCtl_ openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished){
//        
//    }];
//    
//}


@end

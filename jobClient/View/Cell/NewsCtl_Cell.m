//
//  NewsCtl_Cell.m
//  Association
//
//  Created by 一览iOS on 14-1-8.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "NewsCtl_Cell.h"
//#import "TheContactListCtl.h"
#import "NoLoginPromptCtl.h"


@interface NewsCtl_Cell() <ELShareManagerDelegate,NoLoginDelegate>

@end

@implementation NewsCtl_Cell
@synthesize imageView_,titleLb_,descLb_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataModalOne:(Article_DataModal *)dataModalOne
{
    _dataModalOne = dataModalOne;
    
    [self.titleLb_ setText:dataModalOne.title_];
    self.titleLb_.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:dataModalOne.summary_];
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc]init];
    pStyle.lineSpacing = 4.f;
    [attStr addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, attStr.length)];
    [self.descLb_ setAttributedText:attStr];
    [self.descLb_ sizeToFit];
    self.descLb_.lineBreakMode = NSLineBreakByTruncatingTail;
    
    if (dataModalOne.isLike_) {
        [_likeBtn setImage:[UIImage imageNamed:@"group_liketwo_Image_new"] forState:UIControlStateNormal];
        [_likeBtn setTitleColor:FONEREDCOLOR forState:UIControlStateNormal];
    }
    else{
        [_likeBtn setImage:[UIImage imageNamed:@"group_like_image_new"] forState:UIControlStateNormal];
        [_likeBtn setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
    }
    
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld",(long)dataModalOne.commentCount_] forState:UIControlStateNormal];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)dataModalOne.likeCount_] forState:UIControlStateNormal];
    [self.imageView_ sd_setImageWithURL:[NSURL URLWithString:dataModalOne.thum_] placeholderImage:[UIImage imageNamed:@"bg__xinwen2-1.png"]];
    
    [self.commentBtn addTarget:self action:@selector(commentBtnRespone:) forControlEvents:UIControlEventTouchUpInside];
    [self.likeBtn addTarget:self action:@selector(addArticleLike:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn addTarget:self action:@selector(shareArticle:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)shareArticle:(UIButton *)button
{
    Article_DataModal * article = _dataModalOne;
    if (!article) {
        return;
    }
    NSString *imagePath = article.thum_;
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
    
    NSString * sharecontent = article.summary_;
    
    NSString * titlecontent = [NSString stringWithFormat:@"%@",article.title_];
    
    sharecontent = [sharecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    titlecontent = [titlecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/article/%@.htm",article.id_];
    if (article.articleType_ == Article_Group) {
        url = [NSString stringWithFormat:@"http://m.yl1001.com/group_article/%@.htm",article.id_];
    }
    //调用分享
    [[ShareManger sharedManager] shareWithCtl:[self viewController].navigationController title:titlecontent content:sharecontent image:image url:url shareType:ShareTypeTwo];
    [[ShareManger sharedManager] setShareDelegare:self];
}

- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - shareDelegate
-(void)shareYlBtn
{
    NSString * userId = [Manager getUserInfo].userId_;
    if (![Manager shareMgr].haveLogin)
    {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        return;
    }
    NSString * bodyMsg = [NSString stringWithFormat:@"article_id=%@&person_id=%@",_dataModalOne.id_,userId];
    [BaseUIViewController showLoadView:YES content:nil view:nil];  
    [ELRequest postbodyMsg:bodyMsg op:@"groups_newsfeed_busi" func:@"shareArticle" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         [BaseUIViewController showLoadView:NO content:nil view:nil];
         NSDictionary *dic = result;
         Status_DataModal *dataModal = [[Status_DataModal alloc]init];
         dataModal.status_ = [dic objectForKey:@"status"];
         dataModal.code_ = [dic objectForKey:@"code"];
         dataModal.des_ = dic[@"status_desc"];
         if( [dataModal.status_ isEqualToString:Success_Status] ){
             if ([dataModal.code_ isEqualToString:@"200"]) {
                 [BaseUIViewController showAutoDismissAlertView:nil msg:@"分享成功" seconds:1.0];
             }else{
                 [BaseUIViewController showAutoDismissAlertView:nil msg:dataModal.des_ seconds:1.0];
             }
         }else if( [dataModal.status_ isEqualToString:Fail_Status] ){
             [BaseUIViewController showAutoDismissAlertView:nil msg:dataModal.des_ seconds:1.0];
         }else{
             [BaseUIViewController showAlertView:nil msg:@"分享失败,请稍后再试" btnTitle:@"确定"];
         }
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         [BaseUIViewController showLoadView:NO content:nil view:nil];
     }];
}

-(void)loginDelegateCtl{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)copyChaining
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/group_article/%@.htm",_dataModalOne.id_];
    pasteboard.string = url;
    if(url.length > 0)
    {
        [BaseUIViewController showAutoDismissSucessView:nil msg:@"复制链接成功" seconds:1.0];
    }
}

-(void)addArticleLike:(UIButton *)button
{
    if (_dataModalOne.isLike_)
    {
        return;
    }
    else
    {
        _dataModalOne.isLike_ = YES;
        [Manager saveAddLikeWithAticleId:_dataModalOne.id_];
        [_likeBtn setImage:[UIImage imageNamed:@"group_liketwo_Image_new"] forState:UIControlStateNormal];
        [_likeBtn setTitleColor:FONEREDCOLOR forState:UIControlStateNormal];
        _dataModalOne.likeCount_ += 1;
        [_likeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_dataModalOne.likeCount_] forState:UIControlStateNormal];
    }
    NSString *personId = @"";
    if ([Manager shareMgr].haveLogin) {
        personId = [Manager getUserInfo].userId_;
    }
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"article_id=%@&person_id=%@&type=%@",_dataModalOne.id_,personId,@"add"];
    NSString * function = @"addArticlePraise";
    NSString * op = @"yl_praise_busi";
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)commentBtnRespone:(UIButton *)sender
{
    Article_DataModal *modal = _dataModalOne;
    ArticleDetailCtl *articleDetailCtl = [[ArticleDetailCtl alloc]init];
    [[self viewController].navigationController pushViewController:articleDetailCtl animated:YES];
    articleDetailCtl.isFromNews = YES;
    articleDetailCtl.bScrollToComment_ = YES;
    [articleDetailCtl beginLoad:modal exParam:nil];
}

@end

//
//  ELArticleTitleView.m
//  jobClient
//
//  Created by 一览iOS on 16/5/9.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELArticleTitleView.h"
#import "TheContactListCtl.h"
#import "NoLoginPromptCtl.h"
#import "ELGroupDetailCtl.h"

@interface ELArticleTitleView() <ELShareManagerDelegate>
{
    __weak IBOutlet UIView *groupArticleView;
    
    __weak IBOutlet UIButton *seeCount;
    
    __weak IBOutlet UIButton *groupNameBtn;
    __weak IBOutlet UILabel *groupNameLable;
    __weak IBOutlet UILabel *timeLableTwo;
    
    MLEmojiLabel                * titleLb_;
    __weak IBOutlet  UILabel           * createtimeLb_;
    __weak IBOutlet  UILabel           * vCountLb_;
    __weak IBOutlet UIButton *likeBtnTwo;
    __weak IBOutlet UIButton *shareBtn2;
    __weak IBOutlet UIButton *favoriteBtn;
    
    __weak IBOutlet UIImageView *_titleImage;
    
    __weak IBOutlet UIImageView *attachmentImageView;
    __weak IBOutlet UIButton *backBtn;
    
    __weak IBOutlet UIButton *backBtnThree;
    __weak IBOutlet UIButton *favoriteBtnThree;
    __weak IBOutlet UIButton *shareBtnThree;
    __weak IBOutlet UIButton *likeBtnThree;
    
    ELArticleDetailModel *myDataModal_;

    BOOL addOrCancelFavorite;
    BOOL isGreaterThan;
}
@end

@implementation ELArticleTitleView

-(instancetype)initWithArticleCtl:(ArticleDetailCtl *)articleCtl
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ELArticleTitleView" owner:self options:nil];
    for (id ctl in arr) 
    {
        if ([ctl isKindOfClass:[ELArticleTitleView class]]) {
            self = ctl;
        }
    }
    if (self)
    {
        _articleDetailCtl = articleCtl;
        _titleImage.clipsToBounds = YES;
        _titleImage.layer.cornerRadius = 4.0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPersonCenterCtl:)];
        _titleImage.userInteractionEnabled = YES;
        [_titleImage addGestureRecognizer:tap];
        
       // [likeBtnTwo addTarget:self action:@selector(btnAddLike) forControlEvents:UIControlEventTouchUpInside];
        _coverView.hidden = NO;
    }
    return self;
}

-(void)tapPersonCenterCtl:(UITapGestureRecognizer *)sender
{
    [_articleDetailCtl tapPersonCenterCtl:nil];
}

-(void)setMyDataModal:(ELArticleDetailModel *)modal{
    myDataModal_ = modal;
    
    CGFloat heightY = 15;
    
    CGRect rect2 = backBtn.frame;
    rect2.origin.y = heightY;
    backBtn.frame = rect2;
    
    _backBtnHeight = rect2.origin.y;
    
    rect2 = likeBtnTwo.frame;
    rect2.origin.y = heightY;
    likeBtnTwo.frame = rect2;
    
    rect2 = favoriteBtn.frame;
    rect2.origin.y = heightY;
    favoriteBtn.frame = rect2;
    
    rect2 = shareBtn2.frame;
    rect2.origin.y = heightY;
    shareBtn2.frame = rect2;

    rect2 = _titleImage.frame;
    rect2.origin.y = CGRectGetMaxY(shareBtn2.frame) + 10;
    _titleImage.frame = rect2;
    
    
    titleLb_ = [[MLEmojiLabel alloc]init];
    titleLb_.numberOfLines = 0;
    titleLb_.font = [UIFont fontWithName:@"System Italic" size:18];
    titleLb_.textColor = [UIColor blackColor];
    titleLb_.backgroundColor = [UIColor clearColor];
    titleLb_.lineBreakMode = NSLineBreakByCharWrapping;
    titleLb_.isNeedAtAndPoundSign = YES;
    titleLb_.disableThreeCommon = YES;
    titleLb_.customEmojiRegex = Custom_Emoji_Regex;
    titleLb_.customEmojiPlistName = @"emoticons.plist";
    [titleLb_ setEmojiText:myDataModal_.title];
    
    CGFloat attachWidth = 0;
    if (myDataModal_._media.count > 0) {
        attachWidth = 20;
        attachmentImageView.hidden = NO;
    }else{
        attachmentImageView.hidden = YES;
    }
    
    titleLb_.frame = CGRectMake(58,CGRectGetMaxY(shareBtn2.frame) + 10,ScreenWidth-70-attachWidth,0);
    [titleLb_ sizeToFit];
    CGRect attFrame = attachmentImageView.frame;
    attFrame.origin.x = CGRectGetMaxX(titleLb_.frame)+3;
    attFrame.origin.y = titleLb_.frame.origin.y +3;
    attachmentImageView.frame = attFrame;
    
    [self addSubview:titleLb_];
    
    if (myDataModal_._group_source.length > 0)
    {
        createtimeLb_.hidden = YES;
        vCountLb_.hidden = YES;
        groupArticleView.hidden = NO;
        
        CGRect rectG = groupArticleView.frame;
        rectG.origin.x = 58;
        rectG.origin.y = titleLb_.frame.size.height +titleLb_.frame.origin.y;
        rectG.size.width = ScreenWidth - 58;
        groupArticleView.frame = rectG;
        
        heightY = groupArticleView.frame.size.height + groupArticleView.frame.origin.y;
        groupNameLable.text = myDataModal_._group_info.group_name;
        NSString * time = [myDataModal_.ctime substringToIndex:10];
        timeLableTwo.text = [NSString stringWithFormat:@"%@",time];
        [seeCount setTitle:[NSString stringWithFormat:@"%ld",(long)[myDataModal_.v_cnt integerValue]] forState:UIControlStateNormal];
        
        CGFloat groupNameW = rectG.size.width - 10 - 67 - 68 - 20 - 20;
        CGSize groupNameS = [groupNameLable.text sizeNewWithFont:groupNameLable.font];
        
        CGRect groupNameF = groupNameLable.frame;
        groupNameF.size.width = groupNameS.width <= groupNameW ? groupNameS.width:groupNameW;
        groupNameLable.frame = groupNameF;
        
        groupNameF = groupNameBtn.frame;
        groupNameF.size.width = groupNameLable.frame.size.width;
        groupNameBtn.frame = groupNameF;
        
        groupNameF = timeLableTwo.frame;
        groupNameF.origin.x = CGRectGetMaxX(groupNameLable.frame) + 20;
        timeLableTwo.frame = groupNameF;
        
        groupNameF = seeCount.frame;
        groupNameF.origin.x = CGRectGetMaxX(timeLableTwo.frame) + 10;
        seeCount.frame = groupNameF;
    }
    else
    {
         groupArticleView.hidden = YES;
        createtimeLb_.hidden = NO;
        vCountLb_.hidden = NO;
        CGRect rect3 = createtimeLb_.frame;
        rect3.origin.y = titleLb_.frame.size.height +titleLb_.frame.origin.y;
        createtimeLb_.frame = rect3;
        
        CGRect rect1 = vCountLb_.frame;
        rect1.origin.y = titleLb_.frame.size.height +titleLb_.frame.origin.y;
        vCountLb_.frame = rect1;
        
        NSString * time = [myDataModal_.ctime substringToIndex:10];
        createtimeLb_.text = [NSString stringWithFormat:@"%@",time];
        vCountLb_.text = [NSString stringWithFormat:@"%ld次浏览",(long)[myDataModal_.v_cnt integerValue]];
        
        heightY = vCountLb_.frame.size.height +vCountLb_.frame.origin.y;
    }
    _webViewY = heightY;
    
    [likeBtnTwo setTitle:[NSString stringWithFormat:@" 赞一下(%ld)",(long)[myDataModal_.like_cnt integerValue]] forState:UIControlStateNormal];
    
    [_titleImage sd_setImageWithURL:[NSURL URLWithString:myDataModal_.person_detail.person_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    
    if ([myDataModal_._is_favorite boolValue]) {
        [favoriteBtn setImage:[UIImage imageNamed:@"ios_icon_article_Collected"] forState:UIControlStateNormal];
        favoriteBtn.selected = YES;
        [favoriteBtnThree setImage:[UIImage imageNamed:@"ios_icon_article_Collected"] forState:UIControlStateNormal];
        favoriteBtnThree.selected = YES;
        addOrCancelFavorite = NO;
    }
    else
    {
        [favoriteBtn setImage:[UIImage imageNamed:@"ios_icon_article_Collection"] forState:UIControlStateNormal];
        favoriteBtn.selected = NO;
        [favoriteBtnThree setImage:[UIImage imageNamed:@"ios_icon_article_Collection"] forState:UIControlStateNormal];
        favoriteBtnThree.selected = NO;
        addOrCancelFavorite = YES;
    }

    if (myDataModal_.isLike_) 
    {
        likeBtnTwo.selected = YES;
        [likeBtnTwo setImage:[UIImage imageNamed:@"ios_icon_article_Praised"] forState:UIControlStateNormal];
        likeBtnThree.selected = YES;
        [likeBtnThree setImage:[UIImage imageNamed:@"ios_icon_article_Praised"] forState:UIControlStateNormal];
    }
    else
    {
        likeBtnTwo.selected = NO;
        [likeBtnTwo setImage:[UIImage imageNamed:@"ios_icon_article_Praise"] forState:UIControlStateNormal];
        likeBtnThree.selected = NO;
        [likeBtnThree setImage:[UIImage imageNamed:@"ios_icon_article_Praise"] forState:UIControlStateNormal];
    }
    
    if ([myDataModal_._group_info.group_open_status isEqualToString:@"3"]) {
        shareBtn2.hidden = YES;
        shareBtnThree.hidden = YES;
        CGRect frame = likeBtnTwo.frame;
        frame.origin.x = shareBtn2.frame.origin.x;
        likeBtnTwo.frame = frame;
        
        frame = likeBtnThree.frame;
        frame.origin.x = shareBtnThree.frame.origin.x;
        likeBtnThree.frame = frame;
    }
}


-(void)addFavoriteSueecss:(BOOL)addOrCancel
{
    if(addOrCancel)
    {
        [favoriteBtn setImage:[UIImage imageNamed:@"ios_icon_article_Collected"] forState:UIControlStateNormal];
        favoriteBtn.selected = YES;
        [favoriteBtnThree setImage:[UIImage imageNamed:@"ios_icon_article_Collected"] forState:UIControlStateNormal];
        
        favoriteBtnThree.selected = YES;
    }
    else
    {
        [favoriteBtn setImage:[UIImage imageNamed:@"ios_icon_article_Collection"] forState:UIControlStateNormal];
        favoriteBtn.selected = NO;
        [favoriteBtnThree setImage:[UIImage imageNamed:@"ios_icon_article_Collection"] forState:UIControlStateNormal];
        favoriteBtnThree.selected = NO;
    }
}

-(void)btnAddLike
{
    if (likeBtnTwo.selected || likeBtnThree.selected) {
        return;
    }
    NSString *personId = @"";
    if ([Manager shareMgr].haveLogin) {
        personId = [Manager getUserInfo].userId_;
    }
    NSString * bodyMsg = [NSString stringWithFormat:@"article_id=%@&person_id=%@&type=%@",myDataModal_.id_,personId,@"add"];
    [ELRequest postbodyMsg:bodyMsg op:@"yl_praise_busi" func:@"addArticlePraise" requestVersion:YES progressFlag:YES progressMsg:@"" success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        Status_DataModal * dataModal = [[Status_DataModal alloc] init];
        NSString * str = [dic objectForKey:@"status"];
        NSString *upperStr = [str uppercaseString];
        dataModal.status_ = upperStr;
        dataModal.des_ = [dic objectForKey:@"status_desc"];
        dataModal.code_ = [dic objectForKey:@"code"];
        if ([dataModal.status_ isEqualToString:Success_Status]) 
        {
            [likeBtnTwo setTitle:[NSString stringWithFormat:@" 赞一下(%ld)",(long)([myDataModal_.like_cnt integerValue]+1)] forState:UIControlStateNormal];
            likeBtnTwo.selected = YES;
            [likeBtnTwo setImage:[UIImage imageNamed:@"ios_icon_article_Praised"] forState:UIControlStateNormal];
            likeBtnThree.selected = YES;
            [likeBtnThree setImage:[UIImage imageNamed:@"ios_icon_article_Praised"] forState:UIControlStateNormal];
            [_articleDetailCtl addLikeSuccessRefresh]; 
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (IBAction)btnRespone:(UIButton *)sender 
{
    if (sender == likeBtnTwo || sender == likeBtnThree) {
        [self btnAddLike];
    }
    else if (sender == shareBtn2 || sender == shareBtnThree)
    {
        [self btnShareRespone];
    }
    else if (sender == favoriteBtn || sender == favoriteBtnThree) 
    {
        [self btnAddFavorite];
    }
    else if(sender == groupNameBtn)
    {
        if (myDataModal_._group_info.group_id.length > 0) {
            ELGroupDetailCtl *detailCtl = [[ELGroupDetailCtl alloc]init];
            Groups_DataModal *dataModal = [[Groups_DataModal alloc] init];
            dataModal.id_ = myDataModal_._group_info.group_id;
            [[self viewController].navigationController pushViewController:detailCtl animated:YES];
            [detailCtl beginLoad:dataModal exParam:nil];
        }
    }
    else if (sender == backBtn || sender == backBtnThree)
    {
        [_articleDetailCtl backBarBtnResponeTwo:nil];
    }
}

//获取父视图的控制器
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

-(void)btnAddFavorite
{
    NSString *userId = [Manager getUserInfo].userId_;
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:_articleDetailCtl] showNoLoginCtlView];
        return;
    }
    NSString *type = @"";
    if (!favoriteBtn.selected && !favoriteBtnThree.selected) {
        type = @"add";
    }
    else if (favoriteBtn.selected && favoriteBtnThree.selected)
    {
        type = @"cancel";
    }
    
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&article_id=%@&type=%@",userId, myDataModal_.id_, type];
    NSString *op = @"yl_favorite_busi";
    NSString *function = @"addArticleFavorite";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dic = result;
         Status_DataModal *dataModal = [[Status_DataModal alloc]init];
         dataModal.status_ = [dic objectForKey:@"status"];
         dataModal.des_ = dic[@"desc"];
         dataModal.code_ = dic[@"code"];
         if (addOrCancelFavorite) {
             if( [dataModal.status_ isEqualToString:Success_Status] ){
                 if ([dataModal.code_ isEqualToString:@"200"])
                 {
                     [self addFavoriteSueecss:YES];
                     addOrCancelFavorite = NO;
                     myDataModal_._is_favorite = @"1";
                     [BaseUIViewController showAutoDismissAlertView:nil msg:@"收藏成功" seconds:1.0];
                 }else{
                     [BaseUIViewController showAutoDismissAlertView:nil msg:dataModal.des_ seconds:1.0];
                 }
             }else if( [dataModal.status_ isEqualToString:Fail_Status] ){
                 [BaseUIViewController showAutoDismissAlertView:nil msg:dataModal.des_ seconds:1.0];
             }else{
                 [BaseUIViewController showAlertView:nil msg:@"收藏失败,请稍后再试" btnTitle:@"确定"];
             }
         }
         else
         {
             if( [dataModal.status_ isEqualToString:Success_Status] ){
                 if ([dataModal.code_ isEqualToString:@"200"])
                 {
                     myDataModal_._is_favorite = @"0";
                    
                     [self addFavoriteSueecss:NO];
                     
                     addOrCancelFavorite = YES;
                     [BaseUIViewController showAutoDismissAlertView:nil msg:@"取消收藏成功" seconds:1.0];
                 }else{
                     [BaseUIViewController showAutoDismissAlertView:nil msg:dataModal.des_ seconds:1.0];
                 }
             }else if( [dataModal.status_ isEqualToString:Fail_Status] ){
                 [BaseUIViewController showAutoDismissAlertView:nil msg:dataModal.des_ seconds:1.0];
             }else{
                 [BaseUIViewController showAlertView:nil msg:@"取消收藏失败,请稍后再试" btnTitle:@"确定"];
             }
         }

         
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)btnShareRespone
{
    [_articleDetailCtl viewSingleTap:nil];
    NSString *imagePath = myDataModal_.thumb;
    NSString * sharecontent = myDataModal_.summary;
    NSString * titlecontent = [NSString stringWithFormat:@"%@",myDataModal_.title];
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
    sharecontent = [sharecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    titlecontent = [titlecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/article/%@.htm",myDataModal_.id_];
    if (myDataModal_._group_info) {//社群文章
        url = [NSString stringWithFormat:@"http://m.yl1001.com/group_article/%@.htm",myDataModal_.id_];
    }
    //调用分享
    if (_isFromGroup_ || myDataModal_._group_info)
    {   //不分享到动态
        [[ShareManger sharedManager] shareWithCtl:[self viewController].navigationController title:titlecontent content:sharecontent image:image url:url shareType:ShareTypeThree];
        [[ShareManger sharedManager] setShareDelegare:self];
    }else{
        [[ShareManger sharedManager] shareWithCtl:[self viewController].navigationController title:titlecontent content:sharecontent image:image url:url shareType:ShareTypeTwo];
        [[ShareManger sharedManager] setShareDelegare:self];
    }
}

#pragma mark - shareDelegate
-(void)shareYlBtn
{
    NSString * userId = [Manager getUserInfo].userId_;
    if (![Manager shareMgr].haveLogin)
    {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:_articleDetailCtl] showNoLoginCtlView];
        return;
        userId = @"";
    }
    NSString * bodyMsg = [NSString stringWithFormat:@"article_id=%@&person_id=%@",myDataModal_.id_,userId];
    [BaseUIViewController showLoadView:YES content:@"正在分享" view:nil];
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

-(void)shareYLFriendBtn
{
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:_articleDetailCtl] showNoLoginCtlView];
        return;
    }
    TheContactListCtl *contact = [[TheContactListCtl alloc] init];
    contact.isPersonChat = YES;
    contact.isPushShareCtl = YES;
    ShareMessageModal *modal = [[ShareMessageModal alloc] init];
    modal.shareType = @"11";
    modal.shareContent = @"社群文章";
    if(myDataModal_.id_.length > 0)
    {
        modal.article_id = myDataModal_.id_;
    }
    else
    {
        modal.article_id = @"";
    }
    if (myDataModal_.summary.length > 0) {
        modal.article_summary = myDataModal_.summary;
    }
    else
    {
        modal.article_summary = @"";
    }
    
    if (myDataModal_.thumb.length > 0) {
        modal.article_thumb = myDataModal_.thumb;
    }
    else
    {
        modal.article_thumb = @"";
    }
    
    if (myDataModal_.title.length > 0) {
        modal.article_title = myDataModal_.title;
    }
    else
    {
        modal.article_title = @"";
    }

    contact.shareDataModal = modal;
    [[self viewController].navigationController pushViewController:contact animated:YES];
    [contact beginLoad:nil exParam:nil];
}

-(void)copyChaining
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/article/%@.htm",myDataModal_.id_];
    if (myDataModal_._group_info || _isFromGroup_) {//社群文章
        url = [NSString stringWithFormat:@"http://m.yl1001.com/group_article/%@.htm",myDataModal_.id_];
    }
    pasteboard.string = url;
    if(url.length > 0)
    {
        [BaseUIViewController showAutoDismissSucessView:nil msg:@"复制链接成功" seconds:1.0];
    }
}

-(void)scrollViewWithTitleView:(UIScrollView *)scrollView withHeight:(CGFloat)backViewHeight
{
    if (scrollView.contentOffset.y > backViewHeight - 15)
    {
        CGRect frame = _titleViewThree.frame;
        frame.origin.y = 15;
        _titleViewThree.frame = frame;
        
        backBtn.hidden = YES;
        favoriteBtn.hidden = YES;
        likeBtnTwo.hidden = YES;
        _titleViewThree.hidden = NO;
        shareBtn2.hidden = YES;
       
        if (![myDataModal_._group_info.group_open_status isEqualToString:@"3"]) {
            shareBtnThree.hidden = NO;
            CGRect rect2 = shareBtnThree.frame;
            rect2.origin.x = 100;
            CGRect rect3 = likeBtnThree.frame;
            rect3.origin.x = 145;
            [UIView animateWithDuration:0.3f animations:^{
                shareBtnThree.frame = rect2;
                likeBtnThree.frame = rect3;
            }];
        }else{
            shareBtnThree.hidden = YES;
            CGRect rect3 = likeBtnThree.frame;
            rect3.origin.x = 100;
            [UIView animateWithDuration:0.3f animations:^{
                likeBtnThree.frame = rect3;
            }];
        }
        isGreaterThan = YES;
    }
    else
    {
        if (_titleViewThree.hidden) {
            return;
        }
        CGRect frame = _titleViewThree.frame;
        frame.origin.y = favoriteBtn.frame.origin.y - scrollView.contentOffset.y;
        _titleViewThree.frame = frame;
        
        if (isGreaterThan) {
            if (![myDataModal_._group_info.group_open_status isEqualToString:@"3"]) {
                shareBtnThree.hidden = NO;
                CGRect rect2 = shareBtnThree.frame;
                rect2.origin.x = 122;
                
                CGRect rect3 = likeBtnThree.frame;
                rect3.origin.x = 186;
                
                [UIView animateWithDuration:0.3f animations:^{
                    shareBtnThree.frame = rect2;
                    likeBtnThree.frame = rect3;
                } completion:^(BOOL finished)
                 {
                     _titleViewThree.hidden = YES;
                     backBtn.hidden = NO;
                     favoriteBtn.hidden = NO;
                     shareBtn2.hidden = NO;
                     likeBtnTwo.hidden = NO;
                 }];
            }else{
                shareBtnThree.hidden = YES;
                CGRect rect3 = likeBtnThree.frame;
                rect3.origin.x = 122;
                
                [UIView animateWithDuration:0.3f animations:^{
                    likeBtnThree.frame = rect3;
                } completion:^(BOOL finished)
                 {
                     _titleViewThree.hidden = YES;
                     backBtn.hidden = NO;
                     favoriteBtn.hidden = NO;
                     likeBtnTwo.hidden = NO;
                 }];
            }
            isGreaterThan = NO;
        }
    }
}

@end

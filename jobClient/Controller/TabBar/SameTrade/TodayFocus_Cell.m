//
//  TodayFocus_Cell.m
//  jobClient
//
//  Created by 彭永 on 15-4-5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "TodayFocus_Cell.h"
#import "TodayFocusFrame_DataModal.h"
#import "Article_DataModal.h"
#import "ShowImageView.h"
#import "MyConfig.h"
#import "MLEmojiLabel.h"
#import "Comment_DataModal.h"
#import "Expert_DataModal.h"
#import <objc/runtime.h>
#import "ELPersonCenterCtl.h"
#import "ELGroupCommentModel.h"
#import "TheContactListCtl.h"
#import "UIButton+WebCache.h"
#import "ELImgClipHelper.h"
static char gsxOverview;

//随便定义的，可以随意修改
#define ClickCommentLinkId @"123456"

@interface TodayFocus_Cell()<ELShareManagerDelegate,NoLoginDelegate>
{
    MLLinkLabel *_selectedLinkLb;
}

@end

@implementation TodayFocus_Cell

- (void)awakeFromNib
{
    [super awakeFromNib];
// 方式一：通过贝塞尔曲线绘制圆角
    _personBtn = (UIButton *)[[[ELImgClipHelper alloc]init] imgView:_personBtn withClipSize:CGSizeMake(5, 5)] ;
/* 方式二：传统做法，在layer层设置，需要切割较多的圆角，必须layer.shouldRasterize = YES（layer被渲染成一个bitmap，并缓存起来，等下次使用时不会再重新去渲染）
    _personBtn.layer.cornerRadius = 5;
    _personBtn.layer.masksToBounds = YES;
    _personBtn.layer.shouldRasterize = YES;
*/
    
    _articleStatusLable.clipsToBounds = YES;
    
    _articleStatusLable = (UILabel *)[[[ELImgClipHelper alloc]init] imgView:_articleStatusLable withClipSize:CGSizeMake(2, 2)];
/*  
    _articleStatusLable.layer.cornerRadius = 2;
    _articleStatusLable.layer.masksToBounds = YES;
    _articleStatusLable.layer.shouldRasterize = YES;

*/
    
    _artilceTitleLb.font = [UIFont systemFontOfSize:17];
    
    UIImage *bgImage = [UIImage imageNamed:@"groupCommentackView.png"];
    commentViewbackImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(10,5,5,100)];
    _sameTradeHeaderView.layer.masksToBounds = YES;
        
    [self.personBtn addTarget:self action:@selector(personbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.personNameBtn addTarget:self action:@selector(personCenterClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.likeBtn addTarget:self action:@selector(addArticleLike:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn addTarget:self action:@selector(shareArticle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.deleteBtn setImage:[UIImage imageNamed:@"group_delete_on"] forState:UIControlStateHighlighted];
    
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += CELL_MARGIN_TOP;
    frame.size.height -= CELL_MARGIN_TOP;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)commentBtnResponeOne:(id)sender
{
    if([self judgeDisabledArticleStatus]){
        return;
    }
    
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        
        UITapGestureRecognizer *recognizer = (UITapGestureRecognizer *)sender;
        recognizer.cancelsTouchesInView = NO;
        _selectedLinkLb.backgroundColor = [UIColor clearColor];
        
    }
    
    if (_block) {
        _block(_model,@"comment");
        return;
    }
    
    if (_model.articleType_ == Article_Question) {
        AnswerDetailCtl *answerDetailCtl = [[AnswerDetailCtl alloc] init];
        answerDetailCtl.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:answerDetailCtl animated:YES];
        [answerDetailCtl beginLoad:_model.sameTradeArticleModel.question_id exParam:nil];
        return;
    }
    
    
    ArticleDetailCtl *articleDetailCtl = [[ArticleDetailCtl alloc]init];
    articleDetailCtl.hidesBottomBarWhenPushed = YES;
    [[self viewController].navigationController pushViewController:articleDetailCtl animated:YES];

    if (_model.articleType_ == Article_Group) {
        articleDetailCtl.isFromGroup_ = YES;
    }
    articleDetailCtl.bScrollToComment_ = YES;
    [articleDetailCtl beginLoad:_model.sameTradeArticleModel.article_id exParam:nil];
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


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[MLLinkLabel class]]){
        MLLinkLabel *label = (MLLinkLabel *)touch.view;
        if (![label linkAtPoint:[touch locationInView:label]]){
            label.backgroundColor = UIColorFromRGB(0xbdbdbd);
            _selectedLinkLb = label;
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[MLLinkLabel class]]){
        MLLinkLabel *label = (MLLinkLabel *)touch.view;
        if (![label linkAtPoint:[touch locationInView:label]]){
            label.backgroundColor = [UIColor clearColor];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[MLLinkLabel class]]){
        MLLinkLabel *label = (MLLinkLabel *)touch.view;
        if (![label linkAtPoint:[touch locationInView:label]]){
//            label.backgroundColor = [UIColor clearColor];
            [self performSelector:@selector(cancelLabelColor) withObject:self afterDelay:1.5];
        }
    }
}

- (void)cancelLabelColor
{
    _selectedLinkLb.backgroundColor = [UIColor clearColor];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[MLLinkLabel class]]){
        MLLinkLabel *label = (MLLinkLabel *)touch.view;
        if ([label linkAtPoint:[touch locationInView:label]]){
            return NO;
        }
        else{
//            label.backgroundColor = UIColorFromRGB(0xbdbdbd);
            _selectedLinkLb = label;
            return YES;
        }
    }
    else{
        return YES;
    }
}

- (void)setModel:(TodayFocusFrame_DataModal *)article
{
    _model = article;
    ELSameTrameArticleModel *dataModal = article.sameTradeArticleModel;
    
    [_commentCntBtn addTarget:self action:@selector(commentBtnResponeOne:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentBtnResponeOne:)];
    tap.delegate = self;
    [_commentView addGestureRecognizer:tap];
    
    TodayFocusFrame_DataModal *frameModel = article;
    _sameTradeHeaderView.frame = frameModel.sametradeHeadViewFrame;
    _titleLb.frame = frameModel.titleFrame;
    _artilceTitleLb.frame = frameModel.articleTitleFrame;
    _contentLb.frame = frameModel.contentLbFrame;
    _imgShowView.frame = frameModel.showImgvFrame;
    _toolBarView.frame = frameModel.toolBarFrame;
    _commentView.frame = frameModel.commentViewFrame;
    
     [_commentBackImage setImage:commentViewbackImage];
    _shareLable.hidden = YES;
    _sharePersonNameLb.hidden = YES;
    
    if (article.articleType_ == Article_Trade_Head)
    {//行业头条
        _tipsLb.hidden = YES;
        _titleLb.text = dataModal.person_iname;
        _titleLb.hidden = NO;
        _sameTradeHeaderView.hidden = YES;
    }
    else if (article.articleType_ == Article_GXS){//灌薪水
        _tipsLb.hidden = NO;
        _tipsLb.bounds = CGRectMake(0, 0, 64, 16);
        _tipsLb.text = @"匿名灌薪水";
        _tipsLb.backgroundColor = UIColorFromRGB(0x34c3b1);
        _titleLb.hidden = YES;
        _sameTradeHeaderView.hidden = YES;
    }
    else if (article.articleType_ == Article_Group)
    {//社群
        if ([dataModal._group_info.group_source isEqualToString:@"3"]) {
            _tipsLb.hidden = NO;
            _tipsLb.text = @"公司群";
            _tipsLb.backgroundColor = UIColorFromRGB(0x0cc67c);
        }else if ([dataModal._group_info.group_source isEqualToString:@"1"]) {
            _tipsLb.hidden = NO;
            _tipsLb.text = @"职业群";
            _tipsLb.backgroundColor = UIColorFromRGB(0xefb415f);
            
        }
        _tipsLb.bounds = CGRectMake(0, 0, 38, 16);

        _sameTradeHeaderView.hidden = NO;
        _sameTradeHeaderView.frame = CGRectMake(62, 14, CGRectGetMinX(_tipsLb.frame) - 62, _sameTradeHeaderView.bounds.size.height);
        _nameLb.frame = frameModel.nameLbFrame;
        _jobLb.frame = frameModel.jobLbFrame;
        
        NSString *zwStr = @"";
        if (dataModal.person_zw != nil && ![dataModal.person_zw isEqualToString:@""]) {
            zwStr = [@"/ " stringByAppendingString:dataModal.person_zw];
        }
        _jobLb.text = zwStr;
        _jobLb.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLb.text = dataModal.person_iname;
        if ([dataModal.is_expert boolValue]) {
            [_bExpertImg setHidden:NO];
        }else{
            [_bExpertImg setHidden:YES];
        }
        
    }
    else if (article.articleType_ == Article_Follower || article.articleType_ == Article_Share || article.articleType_ == Article_Topic)
    {//同行
        _titleLb.hidden = YES;
        _tipsLb.hidden = YES;
        _sameTradeHeaderView.hidden = NO;
        _sameTradeHeaderView.frame = CGRectMake(62, 14, _sameTradeHeaderView.bounds.size.width, _sameTradeHeaderView.bounds.size.height);
        _nameLb.frame = frameModel.nameLbFrame;
        _jobLb.frame = frameModel.jobLbFrame;
        
        NSString *zwStr = @"";
        if (dataModal.person_zw != nil && ![dataModal.person_zw isEqualToString:@""]) {
            zwStr = [@"/ " stringByAppendingString:dataModal.person_zw];
        }
        _jobLb.text = zwStr;
        _nameLb.text = dataModal.person_iname;
        _jobLb.lineBreakMode = NSLineBreakByTruncatingTail;
        if ([dataModal.is_expert boolValue]) {
            [_bExpertImg setHidden:NO];
        }else{
            [_bExpertImg setHidden:YES];
        }
        if (article.articleType_ == Article_Share) {
            _shareLable.frame = article.shareLableFrame;
            _shareLable.hidden = NO;
            if ([dataModal._person_detail isKindOfClass:[NSDictionary class]]) {
                NSString *sharePersonName = dataModal._person_detail[@"person_iname"];
                if (sharePersonName.length > 0) {
                    _sharePersonNameLb.hidden = NO;
                    _sharePersonNameLb.text = [NSString stringWithFormat:@"原文来自:%@",sharePersonName];
                }
            }
        }
    }
    else if (article.articleType_ == Article_Question)
    {//问答
        _titleLb.hidden = YES;
        _tipsLb.hidden = NO;
        _sameTradeHeaderView.hidden = YES;
        _tipsLb.bounds = CGRectMake(0, 0, 38, 16);
        _tipsLb.backgroundColor = UIColorFromRGB(0x75C1B1);
        _tipsLb.text = @"职导";
    }
    
    _fromRightLb.hidden = YES;
    _formLeftLb.hidden = YES;
    
    if (article.articleType_ == Article_Group){//社群
        if ([dataModal._group_info.group_source isEqualToString:@"1"]) {
            [_personBtn sd_setImageWithURL:[NSURL URLWithString:dataModal.person_pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
        }else if ([dataModal._group_info.group_source isEqualToString:@"3"]){
            [_personBtn sd_setImageWithURL:[NSURL URLWithString:dataModal._group_info.person_pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
        }else{
            [_personBtn sd_setImageWithURL:[NSURL URLWithString:dataModal.person_pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
        }
        _fromRightLb.hidden = NO;
        _formLeftLb.hidden = NO;
        _fromRightLb.text = dataModal._group_info.group_name;
        _fromRightLb.userInteractionEnabled = YES;
        [_fromRightLb addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personCenterTapClick:)]];
    }
    else if (article.articleType_ == Article_GXS)
    {
        //头像
        NSString *gsxImg = objc_getAssociatedObject(article, &gsxOverview);
        if (gsxImg) {
            [_personBtn setImage:[UIImage imageNamed:gsxImg] forState:UIControlStateNormal];
        }else{
            int index = arc4random_uniform(15) +1;
            NSString *imgName = [NSString stringWithFormat:@"guan_pay_%d.png", index];
            objc_setAssociatedObject(article, &gsxOverview, imgName, OBJC_ASSOCIATION_COPY_NONATOMIC);
            [_personBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        }
    }
    else
    {
        [_personBtn sd_setImageWithURL:[NSURL URLWithString:dataModal.person_pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    }
    
    _personNameBtn.frame = _nameLb.frame;

    [_artilceTitleLb setAttributedText:article.titleAttString];
    _artilceTitleLb.textAlignment = NSTextAlignmentLeft;
    [_artilceTitleLb sizeToFit];
    
    
    if (frameModel.showAttachmentImage) {
        self.attachmentStatusImage.hidden = NO;
        CGRect attFrame = self.attachmentStatusImage.frame;
        attFrame.origin.x = CGRectGetMaxX(_artilceTitleLb.frame)+2;
        attFrame.origin.y = CGRectGetMinY(_artilceTitleLb.frame)+2;
        self.attachmentStatusImage.frame = attFrame;
    }else{
        self.attachmentStatusImage.hidden = YES;
    }
    

    self.contentLb.numberOfLines = 3;
    [self.contentLb setAttributedText:article.contentAttString];
    self.contentLb.frame = frameModel.contentLbFrame;
    self.artilceTitleLb.lineBreakMode = NSLineBreakByTruncatingTail;
    self.contentLb.lineBreakMode = NSLineBreakByTruncatingTail;
    //展示图片
    for (UIView *buttonImg in [_imgShowView subviews]) {
        if ([buttonImg isKindOfClass:[ShowImageView class]]) {
            [buttonImg removeFromSuperview];
        }
    }
    BOOL isHaveImage = NO;
    if ([dataModal._pic_list isKindOfClass:[NSArray class]]) {
        if (dataModal._pic_list.count > 0) {
            isHaveImage = YES;
        }
    }
    
    if (isHaveImage) {
        ShowImageView *showView = [[ShowImageView alloc]init];
        showView.imageClickBlock = ^(){
        };
        [showView returnShowImageViewWith:dataModal._pic_list];
        [_imgShowView addSubview:showView];
    }
    
    
    [_likeBtn setTitle:[NSString stringWithFormat:@"%@",dataModal.like_cnt] forState:UIControlStateNormal];
    [_commentCntBtn setTitle:[NSString stringWithFormat:@"%@",dataModal.c_cnt] forState:UIControlStateNormal];
    
    //赞过
    if (article.isLike_) {
        [_likeBtn setImage:[UIImage imageNamed:@"group_liketwo_Image_new"] forState:UIControlStateNormal];
        [_likeBtn setTitleColor:FONEREDCOLOR forState:UIControlStateNormal];
    }
    else{
        [_likeBtn setImage:[UIImage imageNamed:@"group_like_image_new"] forState:UIControlStateNormal];
        [_likeBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
    }
    
    if (article.articleType_ == Article_Question){//问答
        _likeBtn.hidden = NO;
        [_likeBtn setImage:[UIImage imageNamed:@"jobCountNormal.png"] forState:UIControlStateNormal];
        [_likeBtn setEnabled:NO];
        _artilceTitleLb.text = dataModal.person_iname;
    }
    else{
        _likeBtn.hidden = NO;
        [_likeBtn setEnabled:YES];
    }
    
    if (_showStatusLable && ([dataModal.status isEqualToString:@"10"] || [_model.sameTradeArticleModel.status isEqualToString:@"15"])){
        _articleStatusLable.hidden = NO;
    }else{
        _articleStatusLable.hidden = YES;
    }
    
    //展示评论回复
    [self getCommentView:article];
    [self.backView bringSubviewToFront:_lineImgv];
    [self.backView bringSubviewToFront:_tipsLb];
    [self.backView bringSubviewToFront:_isNewImg];
    [self.backView bringSubviewToFront:_deleteBtn];
}


- (void)getCommentView:(TodayFocusFrame_DataModal *)model
{
    float totalHeight = 10;
    if (model.sameTradeArticleModel._comment_list) {
        if (model.sameTradeArticleModel._comment_list.count > 0) {
             _commentView.hidden = NO;
        }else{
             _commentView.hidden = YES;
        }
    }
    else{
        _commentView.hidden = YES;
    }
    
    for (UIView *view in _commentView.subviews) 
    {
        if (view != _commentBackImage) 
        {
           view.hidden = YES; 
        }
    }
    
    for (NSInteger i = 0; i < model.sameTradeArticleModel._comment_list.count; i++) {
        ELGroupCommentModel *commentModel = model.sameTradeArticleModel._comment_list[i];
        MLExpression *exp = [MLExpression expressionWithRegex:Custom_Emoji_Regex plistName:@"Expression" bundleName:@"emoticon"];
        
        NSString *commentStr = [NSString new];
        NSMutableAttributedString *mutableStr;
        UIColor *hightLightColor = UIColorFromRGB(0x4570aa);
        
        if (commentModel._parent_person_detail) {//有被评论者
            commentStr = [NSString stringWithFormat:@"%@回复%@：%@",commentModel.person_iname, commentModel._parent_person_detail.person_iname, commentModel.content];
            NSInteger rangeIndex = [commentModel.person_iname length];
            NSInteger rangeIndex2 = [commentModel._parent_person_detail.person_iname length];
            
            //commentStr = [[commentStr getHtmlAttString] string];
            mutableStr = (NSMutableAttributedString *)[commentStr expressionAttributedStringWithExpression:exp];
            
            [mutableStr setAttributes:@{NSForegroundColorAttributeName : hightLightColor, NSLinkAttributeName : commentModel.user_id} range:NSMakeRange(0, rangeIndex)];
            
            [mutableStr setAttributes:@{NSForegroundColorAttributeName : hightLightColor, NSLinkAttributeName : commentModel._parent_person_detail.personId} range:NSMakeRange(rangeIndex + 2, rangeIndex2)];
        }
        else{//无被评论者
            commentStr = [NSString stringWithFormat:@"%@：%@",commentModel.person_iname, commentModel.content];
            //commentStr = [[commentStr getHtmlAttString] string];
            mutableStr = (NSMutableAttributedString *)[commentStr expressionAttributedStringWithExpression:exp];
            
            if (commentModel.person_iname.length) {
                [mutableStr setAttributes:@{NSForegroundColorAttributeName : hightLightColor, NSLinkAttributeName : commentModel.user_id} range:NSMakeRange(0, commentModel.person_iname.length)];
            }
        }
        
        MLLinkLabel *mlLinkLabel;
        mlLinkLabel = (MLLinkLabel *)[_commentView viewWithTag:1006 +i];
        
        if (mlLinkLabel) {
            mlLinkLabel.hidden = NO;
        }
        else{
            mlLinkLabel = [self LinkLabel];
            mlLinkLabel.tag = 1006 +i;
            [_commentView addSubview:mlLinkLabel];
        }
        
        [mutableStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Light" size:13] range:NSMakeRange(0, mutableStr.length)];
        mlLinkLabel.attributedText = mutableStr;
        [mlLinkLabel invalidateDisplayForLinks];
        
        mlLinkLabel.frame = CGRectMake(5, 6, ScreenWidth - 84, 0);
        [mlLinkLabel sizeToFit];
        
        CGFloat height;
        if (mlLinkLabel.frame.size.height > 30) {
            height = 38;
        }
        else
        {
            height = 18;
        }
        [mlLinkLabel setFrame:CGRectMake(9, totalHeight, ScreenWidth-84, height)];
        
        totalHeight = totalHeight + mlLinkLabel.frame.size.height + 5;
    }
}


- (MLLinkLabel *)LinkLabel
{
    MLLinkLabel *mlLinkLabel;
    if (!mlLinkLabel) {
        mlLinkLabel = [[MLLinkLabel alloc] init];
        mlLinkLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:13];
        mlLinkLabel.textColor = UIColorFromRGB(0x333333);
        mlLinkLabel.numberOfLines = 2;
        mlLinkLabel.lineHeightMultiple = 0.0f;
        mlLinkLabel.lineSpacing = 3.0f;
        mlLinkLabel.dataDetectorTypes = MLDataDetectorTypeAttributedLink;
        mlLinkLabel.allowLineBreakInsideLinks = YES;
        mlLinkLabel.delegate = self;
    }
    return mlLinkLabel;
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink*)link linkText:(NSString*)linkText linkLabel:(MLLinkLabel*)linkLabel
{
    ELPersonCenterCtl *personCtl = [[ELPersonCenterCtl alloc] init];
    personCtl.hidesBottomBarWhenPushed = YES;
    [[self viewController].navigationController pushViewController:personCtl animated:YES];
    [personCtl beginLoad:link.linkValue exParam:nil];
}

-(void)personCenterTapClick:(UITapGestureRecognizer *)sender
{
    if (_model.sameTradeArticleModel._group_info.group_id.length > 0) 
    {
        ELGroupDetailCtl *detaliCtl = [[ELGroupDetailCtl alloc]init];
        detaliCtl.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:detaliCtl animated:YES];
        [detaliCtl beginLoad:_model.sameTradeArticleModel._group_info.group_id exParam:nil];
    }
}

#pragma mark 个人头像点击
- (void)personbtnClick:(UIButton *)button
{
    TodayFocusFrame_DataModal *article = _model;    
    if (article.articleType_ == Article_GXS) {
        ELSalaryModel *model = [[ELSalaryModel alloc] init];
        model.bgColor_ = [UIColor whiteColor];
        model.status = article.sameTradeArticleModel.status;
        model.article_id = article.sameTradeArticleModel.article_id;
        SalaryIrrigationDetailCtl * articleDetailCtl = [[SalaryIrrigationDetailCtl alloc] init];
        articleDetailCtl.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:articleDetailCtl animated:YES];
        [articleDetailCtl beginLoad:model exParam:nil];
        return;
    }
    if (article.articleType_ == Article_Group)
    {
        if ([article.sameTradeArticleModel._group_info.group_source isEqualToString:@"3"]) {
            //公司群
            ELPersonCenterCtl *detailCtl = [[ELPersonCenterCtl alloc]init];
            detailCtl.hidesBottomBarWhenPushed = YES;
            [[self viewController].navigationController pushViewController:detailCtl animated:YES];
            [detailCtl beginLoad:article.sameTradeArticleModel.personId exParam:nil];
            return;
        }
    }
    ELPersonCenterCtl *detailCtl = [[ELPersonCenterCtl alloc]init];
    detailCtl.hidesBottomBarWhenPushed = YES;
    [[self viewController].navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:article.sameTradeArticleModel.personId exParam:nil];
}

#pragma mark - 个人名字点击
- (void)personCenterClick:(UIButton *)sender
{
    ELPersonCenterCtl *detailCtl = [[ELPersonCenterCtl alloc]init];
    detailCtl.hidesBottomBarWhenPushed = YES;
    [[self viewController].navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:_model.sameTradeArticleModel.personId exParam:nil];
}

#pragma mark 点赞
-(void)addArticleLike:(UIButton *)button
{
    TodayFocusFrame_DataModal *article = _model;
    if (article.isLike_) {
        return;
    }
    if([self judgeDisabledArticleStatus]){
        return;
    }
    article.isLike_ = YES;
    [Manager saveAddLikeWithAticleId:article.sameTradeArticleModel.article_id];
    [_likeBtn setImage:[UIImage imageNamed:@"group_liketwo_Image_new"] forState:UIControlStateNormal];
    [_likeBtn setTitleColor:FONEREDCOLOR forState:UIControlStateNormal];
    article.sameTradeArticleModel.like_cnt = [NSString stringWithFormat:@"%ld",(long)([article.sameTradeArticleModel.like_cnt integerValue]+1)];
    [_likeBtn setTitle:[NSString stringWithFormat:@"%@",article.sameTradeArticleModel.like_cnt] forState:UIControlStateNormal];
    
    NSString *personId = @"";
    if ([Manager shareMgr].haveLogin) {
        personId = [Manager getUserInfo].userId_;
    }
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"article_id=%@&person_id=%@&type=%@",article.sameTradeArticleModel.article_id,personId,@"add"];
    NSString * function = @"addArticlePraise";
    NSString * op = @"yl_praise_busi";
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
#pragma mark - 文章分享
-(void)shareArticle:(UIButton *)button
{
    if([self judgeDisabledArticleStatus]){
        return;
    }
    if (_block) {
        _block(_model,@"share");
        return;
    }
    TodayFocusFrame_DataModal *shareArticle = _model;
    NSString *imagePath = shareArticle.sameTradeArticleModel.thumb;
    NSString * sharecontent = shareArticle.sameTradeArticleModel.summary;
    NSString * titlecontent = shareArticle.sameTradeArticleModel.title;
    if (shareArticle.articleType_ == Article_Question)
    {
        titlecontent = [NSString stringWithFormat:@"%@",shareArticle.sameTradeArticleModel.summary];
    }
    sharecontent = [sharecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    titlecontent = [titlecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/article/%@.htm",shareArticle.sameTradeArticleModel.article_id];
    if (shareArticle.articleType_ == Article_Group) {
        url = [NSString stringWithFormat:@"http://m.yl1001.com/group_article/%@.htm",shareArticle.sameTradeArticleModel.article_id];
    }else if(shareArticle.articleType_==Article_GXS){
        url = [NSString stringWithFormat:@"http://m.yl1001.com/gxs_article/%@.htm",shareArticle.sameTradeArticleModel.article_id];
    }
    else if(shareArticle.articleType_ == Article_Question)
    {
        url = [NSString stringWithFormat:@"http://m.yl1001.com/answer_detail/%@.htm?type=all",shareArticle.sameTradeArticleModel.article_id];
    }
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
    
    if (shareArticle.articleType_==Article_GXS || shareArticle.articleType_ == Article_Question) {
        //调用分享 不分享到一览动态中
        [[ShareManger sharedManager] shareWithCtl:[self viewController].navigationController title:titlecontent content:sharecontent image:image url:url];
        return;
    }
    else if (shareArticle.articleType_ == Article_Group) {
        [[ShareManger sharedManager] shareWithCtl:[self viewController].navigationController title:titlecontent content:sharecontent image:image url:url shareType:ShareTypeThree];
        [[ShareManger sharedManager] setShareDelegare:self];
        return;
    }
    
    //可以分享到一览动态
    [[ShareManger sharedManager] shareWithCtl:[self viewController].navigationController title:titlecontent content:sharecontent image:image url:url shareType:ShareTypeTwo];
    [[ShareManger sharedManager] setShareDelegare:self];
}

//myShareManager的代理方法
#pragma mark - myShareManager的代理方法
-(void)shareYlBtn
{
    NSString * userId = [Manager getUserInfo].userId_;
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        return;
    }
    NSString * bodyMsg = [NSString stringWithFormat:@"article_id=%@&person_id=%@",_model.sameTradeArticleModel.article_id,userId];
    NSString * function = @"shareArticle";
    NSString * op = @"groups_newsfeed_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES progressFlag:YES progressMsg:@"" success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        Status_DataModal *dataModal = [[Status_DataModal alloc]init];
        dataModal.status_ = [dic objectForKey:@"status"];
        dataModal.code_ = [dic objectForKey:@"code"];
        dataModal.des_ = dic[@"status_desc"];
        if( [dataModal.status_ isEqualToString:Success_Status] ){
            if ([dataModal.code_ isEqualToString:@"200"]) {
                [BaseUIViewController showAutoDismissAlertView:nil msg:@"分享成功" seconds:2.0];
            }else{
                [BaseUIViewController showAutoDismissFailView:nil msg:dataModal.des_ seconds:2.0];
            }
        }
        else if( [dataModal.status_ isEqualToString:Fail_Status] ){
            [BaseUIViewController showAutoDismissFailView:nil msg:dataModal.des_ seconds:2.0];
        }
        else{
            [BaseUIViewController showAlertView:nil msg:@"分享失败,请稍后再试" btnTitle:@"确定"];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showAlertView:nil msg:@"分享失败,请稍后再试" btnTitle:@"确定"];
    }];
}

//分享一览好友
-(void)shareYLFriendBtn
{
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        return;
    }
    TheContactListCtl *contact = [[TheContactListCtl alloc] init];
    contact.isPersonChat = YES;
    contact.isPushShareCtl = YES;
    ShareMessageModal *modal = [[ShareMessageModal alloc] init];
    modal.shareType = @"11";
    modal.shareContent = @"社群文章";
    modal.article_id = _model.sameTradeArticleModel.article_id.length>0 ? _model.sameTradeArticleModel.article_id:@"";
    modal.article_summary = _model.sameTradeArticleModel.summary.length>0 ? _model.sameTradeArticleModel.summary:@"";
    modal.article_thumb = _model.sameTradeArticleModel.thumb.length>0 ? _model.sameTradeArticleModel.thumb:@"";
    modal.article_title = _model.sameTradeArticleModel.title.length>0 ? _model.sameTradeArticleModel.title:@"";
    
    contact.shareDataModal = modal;
    contact.hidesBottomBarWhenPushed = YES;
    [[self viewController].navigationController pushViewController:contact animated:YES];
    [contact beginLoad:nil exParam:nil];
}

//复制链接
-(void)copyChaining
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/article/%@.htm",_model.sameTradeArticleModel.article_id];
    if (_model.articleType_ == Article_Group) {
        url = [NSString stringWithFormat:@"http://m.yl1001.com/group_article/%@.htm",_model.sameTradeArticleModel.article_id];
    }
    pasteboard.string = url;
    if(url.length > 0)
    {
        [BaseUIViewController showAutoDismissSucessView:nil msg:@"复制链接成功" seconds:1.0];
    }
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(BOOL)judgeDisabledArticleStatus{
    if (!_showStatusShot) {
        return NO;
    }
    if ([_model.sameTradeArticleModel.status isEqualToString:@"10"] || [_model.sameTradeArticleModel.status isEqualToString:@"15"]) {
        [BaseUIViewController showAutoDismissFailView:nil msg:@"文章已禁用"];
        return YES;
    }else if(!_model.sameTradeArticleModel.status || [_model.sameTradeArticleModel.status isEqualToString:@""]){
        [BaseUIViewController showAutoDismissFailView:nil msg:@"文章已删除"];
        return YES;
    }
    return NO;
}

@end

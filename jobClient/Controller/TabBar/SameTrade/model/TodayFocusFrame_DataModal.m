//
//  TodayFocusFrame_DataModal.m
//  jobClient
//
//  Created by 一览ios on 15/4/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#define X_OFFSET 62
#define Y_OFFSET 15
#define WIDTH [UIScreen mainScreen].bounds.size.width - 74
#import "TodayFocusFrame_DataModal.h"
#import "Article_DataModal.h"
#import "ShowImageView.h"
#import "Comment_DataModal.h"
#import "MyConfig.h"
#import "MLEmojiLabel.h"
#import "ELGroupPersonModel.h"
#import "ELGroupArticleCommentModel.h"
#import "ELGroupCommentModel.h"
#import "ELSameTrameArticleModel.h"

@implementation TodayFocusFrame_DataModal


-(void)setSameTradeArticleModel:(ELSameTrameArticleModel *)sameTradeArticleModel{
    if(!sameTradeArticleModel){
        return;
    }
    _sameTradeArticleModel = sameTradeArticleModel;
    CGFloat articleTitleLbY = 29;
    CGFloat titleWidth = WIDTH;
    if ([sameTradeArticleModel.fujian_flag isEqualToString:@"1"]) {
        titleWidth = WIDTH-20;
        _showAttachmentImage = YES;
    }
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(62, 15,titleWidth, 40)];
    titleLb.font = [UIFont fontWithName:@"Helvetica" size:17] ;
    titleLb.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyleOne = [[NSMutableParagraphStyle alloc] init];
    paragraphStyleOne.lineSpacing = 4;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:17],
                                 NSParagraphStyleAttributeName:paragraphStyleOne,
                                 NSForegroundColorAttributeName:UIColorFromRGB(0x333333)
                                 };
    NSMutableAttributedString *titleAttString = [[NSMutableAttributedString alloc] initWithString:sameTradeArticleModel.title];
    [titleAttString addAttributes:attributes range:NSMakeRange(0,titleAttString.length)];
    [titleLb setAttributedText:titleAttString];
    [titleLb sizeToFit];
    CGSize articleTitleSize = titleLb.frame.size;
    _titleAttString = titleAttString;
    
    BOOL nameLbImageShow = NO;
    if ([sameTradeArticleModel._is_new boolValue]){
        nameLbImageShow = YES;
    }
    
    if (_articleType_ == Article_GXS) {
        articleTitleLbY = 35;
        _articleTitleFrame = CGRectMake(X_OFFSET, articleTitleLbY, WIDTH, articleTitleSize.height+5);
        if (sameTradeArticleModel._comment_list) {
            for (ELGroupCommentModel * commentModal in sameTradeArticleModel._comment_list) {                   commentModal.person_iname = commentModal._floor_num;
            }
        }
    }
    else if (_articleType_ == Article_Follower || _articleType_ == Article_Group || _articleType_ == Article_Topic)
    {//同行
        CGFloat startX;
        if ([sameTradeArticleModel.is_expert boolValue]) {
            startX = 20;
        }else{
            startX = 0;
        }
        CGFloat LbWidth = 0;
        if (nameLbImageShow) {
            LbWidth = 40;
        }
        
        NSString *iname =  sameTradeArticleModel.person_iname;
        CGSize nameSize = [iname sizeNewWithFont:THIRTEENFONT_CONTENT];
        CGFloat nameW = (nameSize.width+3) > (WIDTH-LbWidth) ? (WIDTH-LbWidth):(nameSize.width+3);
        _nameLbFrame = CGRectMake(startX, 2,floorf(nameW)+1, 16);
        
        CGFloat jobX = CGRectGetMaxX(_nameLbFrame);
        if (jobX >= (WIDTH-LbWidth)){
            _jobLbFrame = CGRectZero;
        }else{
          _jobLbFrame = CGRectMake(jobX, 3, WIDTH - jobX -LbWidth, 15);  
        }
        _sametradeHeadViewFrame = CGRectMake(X_OFFSET, Y_OFFSET, WIDTH-LbWidth, 19);
        articleTitleLbY = CGRectGetMaxY(_sametradeHeadViewFrame);
        _articleTitleFrame = CGRectMake(X_OFFSET, articleTitleLbY + 5,articleTitleSize.width, articleTitleSize.height+5);
    }
    else if (_articleType_ == Article_Share){
        CGFloat startX;
        if ([sameTradeArticleModel.is_expert boolValue]) {
            startX = 20;
        }else{
            startX = 0;
        }
        NSString *iname =  sameTradeArticleModel.person_iname;
        CGSize nameSize = [iname sizeNewWithFont:THIRTEENFONT_CONTENT constrainedToSize:CGSizeMake(WIDTH-startX-60,100)];
        _nameLbFrame = CGRectMake(startX, 2, floorf(nameSize.width)+3, 16);
        
        if (((WIDTH-startX-60)-nameSize.width) > 20){
            NSString *zwStr = @"";
            if (sameTradeArticleModel.person_zw) {
                zwStr = [@"/ " stringByAppendingString:sameTradeArticleModel.person_zw];
            }
            CGSize jobSize = [zwStr sizeNewWithFont:ELEVEN_TIME];
            CGFloat jobX = CGRectGetMaxX(_nameLbFrame);
            CGFloat width = (WIDTH-startX-60)-nameSize.width; 
            if (width > jobSize.width) {
                width = jobSize.width;
            }
            _jobLbFrame = CGRectMake(jobX, 3,width+5, 15);
        }else{
            _jobLbFrame = CGRectZero;
        }
        _shareLableFrame = CGRectMake(CGRectGetMaxX(_nameLbFrame)+_jobLbFrame.size.width+3,0,65,18);
        _sametradeHeadViewFrame = CGRectMake(X_OFFSET, Y_OFFSET, WIDTH, 19);
        articleTitleLbY = CGRectGetMaxY(_sametradeHeadViewFrame);
        _articleTitleFrame = CGRectMake(X_OFFSET, articleTitleLbY + 5,articleTitleSize.width, articleTitleSize.height+5);
    }
    else if (_articleType_ == Article_Trade_Head)
    {//行业头条
        _titleFrame = CGRectMake(X_OFFSET, Y_OFFSET, WIDTH, 21);
        articleTitleLbY = CGRectGetMaxY(_titleFrame);
        _articleTitleFrame = CGRectMake(X_OFFSET, articleTitleLbY, WIDTH, articleTitleSize.height+5);
    }
    else if (_articleType_ == Article_Question){//问答，无任何标题
        _titleFrame = CGRectMake(X_OFFSET, Y_OFFSET, WIDTH,0);
        articleTitleLbY = CGRectGetMaxY(_titleFrame);
        _articleTitleFrame = CGRectMake(X_OFFSET, articleTitleLbY, WIDTH,26);
        _sameTradeArticleModel.article_id = _sameTradeArticleModel.question_id;
        _sameTradeArticleModel.like_cnt = _sameTradeArticleModel.question_view_count;
        _sameTradeArticleModel.c_cnt = _sameTradeArticleModel.question_replys_count;
        _sameTradeArticleModel.summary = _sameTradeArticleModel.question_title;
//        _sameTradeArticleModel._comment_list = _sameTradeArticleModel._answer_list;
    }

    //内容的高度
    CGFloat summaryY = CGRectGetMaxY(_articleTitleFrame);
    NSString *contentText = [MyCommon removeAllSpace:sameTradeArticleModel.summary];
    NSMutableAttributedString *contentAtt = [[Manager shareMgr] getEmojiStringWithString:contentText withImageSize:CGSizeMake(16,16)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;
    [contentAtt addAttributes:@{
                                NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Light" size:13],
                                NSParagraphStyleAttributeName:paragraphStyle,
                                NSForegroundColorAttributeName:UIColorFromRGB(0x888888)
                                } 
                                range:NSMakeRange(0,contentAtt.length)];
        
    _contentAttString = contentAtt;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 3;
    contentLabel.frame = CGRectMake(0, 0, WIDTH, 0);
    [contentLabel setAttributedText:contentAtt];
    [contentLabel sizeToFit];
    _contentLbFrame = CGRectMake(X_OFFSET, summaryY + 3, WIDTH, contentLabel.frame.size.height);
     CGFloat marginTop = 5;
    //图片View高度
    BOOL isHaveImage = NO;
    if ([sameTradeArticleModel._pic_list isKindOfClass:[NSArray class]]) {
        if (sameTradeArticleModel._pic_list.count > 0) {
            isHaveImage = YES;
        }
    }
    if (isHaveImage) {
        ShowImageView *showView = [[ShowImageView alloc]init];
        [showView returnShowImageSizeWith:sameTradeArticleModel._pic_list];
        
        CGFloat showImgvY = CGRectGetMaxY(_contentLbFrame) + marginTop;
        _showImgvFrame = CGRectMake(X_OFFSET, showImgvY, showView.frame.size.width, showView.frame.size.height);
    }else {
        _showImgvFrame = CGRectMake(X_OFFSET, 0, 0, 0);
    }
    
    //工具栏高度
    if (isHaveImage) {//有图片
        CGFloat toolBarY = CGRectGetMaxY(_showImgvFrame) +5;
        _toolBarFrame = CGRectMake(X_OFFSET, toolBarY, ScreenWidth-70, 36);
    }else{
        CGFloat toolBarY = CGRectGetMaxY(_contentLbFrame) +5;
        _toolBarFrame = CGRectMake(X_OFFSET, toolBarY, ScreenWidth-70, 36);
    }
    
    //评论高度
    CGFloat commentViewHeight = 8;
    CGFloat buttomHeight = 8;
    if (sameTradeArticleModel._comment_list) {
        for (ELGroupCommentModel * commentModal in sameTradeArticleModel._comment_list) {
            commentModal.content = [MyCommon removeHTML2:commentModal.content];
            commentModal.content = [MyCommon translateHTML:commentModal.content];
            commentModal.content = [commentModal.content stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            commentModal.content = [commentModal.content stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
            NSString * str = @"";
            if (!commentModal.person_iname || [commentModal.person_iname isEqualToString:@""]) {
                commentModal.person_iname = @"匿名";
            }
            if (commentModal._parent_person_detail) {
                str = [NSString stringWithFormat:@"%@回复%@：",commentModal.person_iname, commentModal._parent_person_detail.person_iname];
            }else{
                str = [NSString stringWithFormat:@"%@：",commentModal.person_iname];
            }
            str = [NSString stringWithFormat:@"%@%@",str,commentModal.content];
            
            MLExpression *exp = [MLExpression expressionWithRegex:Custom_Emoji_Regex plistName:@"Expression" bundleName:@"emoticon"];
            NSMutableAttributedString *mutableStr = (NSMutableAttributedString *)[str expressionAttributedStringWithExpression:exp];
            MLLinkLabel *linkLabel = [self LinkLabel];
            [mutableStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Light" size:13] range:NSMakeRange(0, mutableStr.length)];
            linkLabel.attributedText = mutableStr;
            linkLabel.frame = CGRectMake(5,commentViewHeight, WIDTH-10, 0);
            [linkLabel sizeToFit];
            
            CGFloat height;
            if (linkLabel.frame.size.height > 23) {
                height = 38;
            }else{
                height = 18;
            }
            commentViewHeight = commentViewHeight + height + 5;
        }
        if (sameTradeArticleModel._comment_list.count > 0) {
            CGFloat commentY = CGRectGetMaxY(_toolBarFrame);
            _commentViewFrame = CGRectMake(X_OFFSET, commentY, WIDTH, commentViewHeight);//+底部间距
            buttomHeight = 13;
        }else{
            CGFloat commentY = CGRectGetMaxY(_toolBarFrame);
            _commentViewFrame = CGRectMake(X_OFFSET, commentY, WIDTH, 0);
        }
    }else{
        CGFloat commentY = CGRectGetMaxY(_toolBarFrame);
        _commentViewFrame = CGRectMake(X_OFFSET, commentY, WIDTH, 0);
    }
    //总高度
    _height = CGRectGetMaxY(_commentViewFrame) + buttomHeight;
    _isLike_ = [Manager getIsLikeStatus:sameTradeArticleModel.article_id];
}

#pragma mark 初始化内容表情label
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
    }
    return mlLinkLabel;
}


-(void)setJoinGroupPeopleModel:(ELGroupListTwoModel *)joinGroupPeopleModel{
    _joinGroupPeopleModel = joinGroupPeopleModel;
    NSString *leftStr = [NSString stringWithFormat:@"%@来了 ",joinGroupPeopleModel.group_name];
    NSString *centerStr = @"";
    for (NSInteger i = 0; i< joinGroupPeopleModel.person_list.count;i++){
        ELGroupPersonModel *model = joinGroupPeopleModel.person_list[i];
        if (i == 0) {
            centerStr = model.person_name;
        }else{
            centerStr = [NSString stringWithFormat:@"%@,%@",centerStr,model.person_name];
        }
    }
    NSMutableAttributedString *string;
    if(joinGroupPeopleModel.person_list.count < 3){
        string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@ 小伙伴",leftStr,centerStr]];
    }else{
        string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@ 等小伙伴",leftStr,centerStr]];
    }
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:65.0/255.0 green:108.0/255.0 blue:162.0/255.0 alpha:1.0] range:NSMakeRange(leftStr.length,centerStr.length)];
    self.titleAttString = string;
    
    CGSize size = [self.titleAttString.string sizeNewWithFont:FOURTEENFONT_CONTENT constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20,MAXFLOAT)];
    self.titleFrame = CGRectMake(10,14,[UIScreen mainScreen].bounds.size.width-20,size.height +5);
    self.contentLbFrame = CGRectMake(10,CGRectGetMaxY(self.titleFrame)+5, [UIScreen mainScreen].bounds.size.width-54,35);
    self.height = CGRectGetMaxY(self.contentLbFrame)+5;
}

@end

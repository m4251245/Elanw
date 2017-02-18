//
//  ELAnswerListCell.m
//  jobClient
//
//  Created by 一览iOS on 16/9/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELAnswerListCell.h"
#import "JobGuideQuizModal.h"
#import "ELAnswerLableView.h"
#import "ELPersonCenterCtl.h"
#import "ELButtonView.h"
#import "ELAnswerEditorCtl.h"

@interface ELAnswerListCell() <ClickDelegate,NoLoginDelegate>
{
    UIImage *commentViewbackImage;
}
@end

@implementation ELAnswerListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.personNameLb.userInteractionEnabled = YES;
    [self.personNameLb addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personNameButtonResopne:)]];
    
    self.personImage.userInteractionEnabled = YES;
    [self.personImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personNameButtonResopne:)]];
    self.personImage.clipsToBounds = YES;
    self.personImage.layer.cornerRadius = 12.0;
    
    [self.answerBtn addTarget:self action:@selector(answerButtonRespone:) forControlEvents:UIControlEventTouchUpInside];
    
    _answerContentLb = [[UILabel alloc] initWithFrame:CGRectMake(16,48,ScreenWidth-28,0)];
    _answerContentLb.numberOfLines = 2;
    _answerContentLb.font = [UIFont systemFontOfSize:16];
    _answerContentLb.textColor = UIColorFromRGB(0x212121);
    [self.contentView addSubview:_answerContentLb];
    
    _answerDetailLb = [[UILabel alloc] initWithFrame:CGRectMake(16,48,ScreenWidth-28,0)];
    _answerDetailLb.numberOfLines = 3;
    _answerDetailLb.font = THIRTEENFONT_CONTENT;
    _answerDetailLb.textColor = UIColorFromRGB(0x9e9e9e);
    [self.contentView addSubview:_answerDetailLb];
    
    
    UIImage *bgImage = [UIImage imageNamed:@"question_comment_bg"];
    commentViewbackImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(10,5,5,100)];
    _commentView = [[UIView alloc] init];
    _commentView.hidden = YES;
    
    _commentBackImage = [[UIImageView alloc] init];
    [_commentView addSubview:_commentBackImage];
    
    [self.contentView addSubview:_commentView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)giveDataWithModal:(JobGuideQuizModal *)dataModal
{
    _modal = dataModal;
    
    [self.personImage sd_setImageWithURL:[NSURL URLWithString:dataModal.person_detail.person_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    
    if ([dataModal.person_detail.is_expert isEqualToString:@"1"]) {
        self.expertImage.hidden = NO;
        _nameLableLeftWidth.constant = 27;
    }
    else
    {
        self.expertImage.hidden = YES;
        _nameLableLeftWidth.constant = 10;
    }
    if (dataModal.personNameAttString) {
        [self.personNameLb setAttributedText:dataModal.personNameAttString];
    }else{
        self.personNameLb.text = dataModal.person_detail.person_iname;
    }
    self.personNameLb.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.answerContentLb.frame = CGRectMake(16,48,ScreenWidth-28,0);
    [self.answerContentLb setAttributedText:dataModal.contentAttString];
    [self.answerContentLb sizeToFit];
    self.answerContentLb.lineBreakMode = NSLineBreakByTruncatingTail;
    
    CGFloat startY = 0;
    if (dataModal.lableArr)
    {
        self.lableView.hidden = NO;
        if (!self.lableView) {
            self.lableView = [[ELAnswerLableView alloc] init];
            [self.contentView addSubview:self.lableView];
        }
        self.lableView.frame = CGRectMake(16,CGRectGetMaxY(self.answerContentLb.frame)+13,ScreenWidth-16,0);
        [self.lableView giveDataModalWithArr:dataModal.lableArr];
        startY = CGRectGetMaxY(self.lableView.frame)+18;
    }else{
        self.lableView.hidden = YES;
        startY = CGRectGetMaxY(self.answerContentLb.frame)+18;
    }
    
    if (dataModal.answerDetailAtt) {
        self.answerDetailLb.hidden = NO;
        self.answerDetailLb.frame = CGRectMake(16,startY,ScreenWidth-28,0);
        [self.answerDetailLb setAttributedText:dataModal.answerDetailAtt];
        [self.answerDetailLb sizeToFit];
        self.answerDetailLb.lineBreakMode = NSLineBreakByTruncatingTail;
    }else{
        self.answerDetailLb.hidden = YES;
    }
    
    [_seeCount setText:dataModal.question_view_count];
    self.commentCount.text = dataModal.question_replys_count;
    
    if (dataModal.commentOneAtt){
        _commentView.hidden = NO;
        _commentView.frame = dataModal.commentViewFrame;
        _commentBackImage.frame = CGRectMake(0,0,dataModal.commentViewFrame.size.width,dataModal.commentViewFrame.size.height);
        _commentBackImage.image = commentViewbackImage;
        if (!_commentOne) {
            _commentOne = [[ELButtonView alloc] initWithFrame:dataModal.commentOneFrame];
            [_commentView addSubview:_commentOne];
        }
        _commentOne.hidden = NO;
        _commentOne.frame = dataModal.commentOneFrame;
        [_commentOne setNumberlines:2];
        [_commentOne setAttributedText:dataModal.commentOneAtt];
        [_commentOne refreshClickWithArr:dataModal.commentOneArr];
        _commentOne.clickDelegate = self;
    }else{
        _commentView.hidden = YES;
    }
    if (dataModal.commentTwoAtt){
        if (!_commentTwo) {
            _commentTwo = [[ELButtonView alloc] initWithFrame:dataModal.commentTwoFrame];
            [_commentView addSubview:_commentTwo];
        }
        _commentTwo.hidden = NO;
        _commentTwo.frame = dataModal.commentTwoFrame;
        _commentTwo.clickDelegate = self;
        [_commentTwo setNumberlines:2];
        [_commentTwo setAttributedText:dataModal.commentTwoAtt];
        [_commentTwo refreshClickWithArr:dataModal.commentTwoArr];
    }else{
        _commentTwo.hidden = YES;
    }
    if (dataModal.commentViewFrame.size.height > 0) {
        _buttonHeight.constant = 16+dataModal.commentViewFrame.size.height+17;
    }else{
        _buttonHeight.constant = 25;
    }
}

-(void)clickDelegateWithModel:(TextSpecial *)model{
    if (model.key && ![model.key isEqualToString:@""]) {
        ELPersonCenterCtl *detailCtl = [[ELPersonCenterCtl alloc]init];
        detailCtl.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr].centerNav_ pushViewController:detailCtl animated:YES];
        detailCtl.isFromManagerCenterPop = YES;
        [detailCtl beginLoad:model.key exParam:nil];
    }else{
        AnswerDetailCtl *answerDetailCtl = [[AnswerDetailCtl alloc] init];
        answerDetailCtl.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr].centerNav_ pushViewController:answerDetailCtl animated:YES];
        [answerDetailCtl beginLoad:_modal.question_id exParam:nil];
    }
}

-(void)personNameButtonResopne:(UIButton *)sender{
    if (!_modal.person_detail.personId || [_modal.person_detail.personId isEqualToString:@""]) {
        return;
    }
    ELPersonCenterCtl *detailCtl = [[ELPersonCenterCtl alloc]init];
    detailCtl.hidesBottomBarWhenPushed = YES;
    [[Manager shareMgr].centerNav_ pushViewController:detailCtl animated:YES];
    detailCtl.isFromManagerCenterPop = YES;
    [detailCtl beginLoad:_modal.person_detail.personId exParam:nil];
}

-(void)answerButtonRespone:(UIButton *)sender{
//    AnswerDetailCtl *answerDetailCtl = [[AnswerDetailCtl alloc] init];
//    [[Manager shareMgr].centerNav_ pushViewController:answerDetailCtl animated:YES];
//    [answerDetailCtl beginLoad:_modal.question_id exParam:nil];
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_Answer_button;
        return;
    }
    ELAnswerEditorCtl *ctl = [[ELAnswerEditorCtl alloc] init];
    ctl.hidesBottomBarWhenPushed = YES;
    ctl.questionId = _modal.question_id;
    ctl.questionTitle = _modal.question_title;
    ctl.questionContent = _modal.question_content;
    [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
}

-(void)loginDelegateCtl{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_Answer_button:
        {
            ELAnswerEditorCtl *ctl = [[ELAnswerEditorCtl alloc] init];
            ctl.hidesBottomBarWhenPushed = YES;
            ctl.questionId = _modal.question_id;
            ctl.questionTitle = _modal.question_title;
            ctl.questionContent = _modal.question_content;
            [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end

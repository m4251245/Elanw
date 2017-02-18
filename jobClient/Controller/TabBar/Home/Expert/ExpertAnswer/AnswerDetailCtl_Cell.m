//
//  AnswerDetailCtl_Cell.m
//  Association
//
//  Created by 一览iOS on 14-3-7.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "AnswerDetailCtl_Cell.h"

@implementation AnswerDetailCtl_Cell 
{
    CGFloat lineImgY;
    UIView *statusView;
}

@synthesize imgView_,nameLb_,anserTimeLb_,expertMarkImgv_,imageLine;

+(AnswerDetailCtl_Cell *)getTableViewCellWithTableView:(UITableView *)tableView{
    static NSString *CellIdentifier = @"AnswerDetailCtl_Cell";
    AnswerDetailCtl_Cell *cell = (AnswerDetailCtl_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AnswerDetailCtl_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell creatUI];
    }
    return cell;
}

-(void)creatUI{
    //用户头像
    self.imgView_ = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10,30,30)];
    self.imgView_.layer.cornerRadius = 5;
    self.imgView_.layer.masksToBounds = YES;
    [self.contentView addSubview:self.imgView_];
    _imgViewBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
    _imgViewBtn_.frame = CGRectMake(10,10,30,30);
    [self.contentView addSubview:_imgViewBtn_];
    
    //打赏按钮
    
    _payBtn_ = [ELBaseButton getNewButtonWithFont:[UIFont systemFontOfSize:12] title:@"打赏" textColor:[UIColor whiteColor] Target:nil action:nil frame:CGRectMake(ScreenWidth-46,15,38,20)];
    [_payBtn_ setBackgroundColor:UIColorFromRGB(0xD72831)];
    [_payBtn_ setLayerCornerRadius:4.0];
    [_payBtn_ setBorderWidth:1 borderColor:UIColorFromRGB(0xE13F3F)];
    [self.contentView addSubview:_payBtn_];
    
    //行家标识
    self.expertMarkImgv_ = [[UIImageView alloc] initWithFrame:CGRectMake(50,18,14,15)];
    self.expertMarkImgv_.image = [UIImage imageNamed:@"expertsmark"];
    [self.contentView addSubview:self.expertMarkImgv_];
    //用户名
    nameLb_ = [[UILabel alloc] init];
    nameLb_.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:nameLb_];
    
    //时间、点赞、评论
    _timeBackView = [[UIView alloc] initWithFrame:CGRectMake(50,0,ScreenWidth-50,21)];
    _timeBackView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_timeBackView];
    
    anserTimeLb_ = [[UILabel alloc] initWithFrame:CGRectMake(0,0,80,21)];
    anserTimeLb_.textColor = UIColorFromRGB(0x878787);
    anserTimeLb_.font = [UIFont systemFontOfSize:12];
    [_timeBackView addSubview:anserTimeLb_];
    
    _commentCountBtn = [ELBaseButton getNewButtonWithFont:[UIFont systemFontOfSize:12] title:@"" textColor:UIColorFromRGB(0x878787) normalImageName:@"anser_commentnor_question_image" Target:nil action:nil frame:CGRectMake(_timeBackView.frame.size.width-57,0,53,21)];
    _commentCountBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,5);
    [_timeBackView addSubview:_commentCountBtn];
    
    _supportCountBtn_ = [ELBaseButton getNewButtonWithFont:[UIFont systemFontOfSize:12] title:@"" textColor:UIColorFromRGB(0x878787) normalImageName:@"zan_question" Target:nil action:nil frame:CGRectMake(_timeBackView.frame.size.width-118,0,53,21)];
    _supportCountBtn_.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,5);
    [_timeBackView addSubview:_supportCountBtn_];
    
    //回答内容
    _answerContent = [[ELButtonView alloc] initWithTwoTypeFrame:CGRectMake(0,0,ScreenWidth-60,30)];
    [self.contentView addSubview:_answerContent];
    
    //底部分割线
    imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,1)];
    imageLine.backgroundColor = UIColorFromRGB(0xe0e0e0);
    [self.contentView addSubview:imageLine];
}

-(void)giveAnswerListModel:(AnswerListModal *)answerListModal andAnswerDetialModal:(AnswerDetialModal *)answerDetialModal
{
    [self.imgView_ sd_setImageWithURL:[NSURL URLWithString:answerListModal.answer_person_detail.person_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"] options:SDWebImageAllowInvalidSSLCertificates];
    
    //评价按钮显示判断
     BOOL isExpert = [answerListModal.answer_person_detail.is_expert isEqualToString:@"1"];
    if (isExpert && ![answerListModal.answer_person_detail.person_id isEqualToString:answerDetialModal.person_id] && ![[Manager getUserInfo].userId_ isEqualToString:answerListModal.answer_person_detail.person_id]){
        if (!self.appraiseBtn_){
            _appraiseBtn_ = [ELBaseButton getNewButtonWithFont:[UIFont systemFontOfSize:12] title:@"评价" textColor:UIColorFromRGB(0xD72831) Target:nil action:nil frame:CGRectZero];
            [_appraiseBtn_ setBackgroundColor:[UIColor whiteColor]];
            [_appraiseBtn_ setLayerCornerRadius:4.0];
            [_appraiseBtn_ setBorderWidth:1 borderColor:UIColorFromRGB(0xE13F3F)];
            [self.contentView addSubview:_appraiseBtn_];
        }
        _appraiseBtn_.frame = CGRectMake(ScreenWidth-92,15,38,20);
        self.appraiseBtn_.hidden = NO;   
    }else{
        if (_appraiseBtn_) {
            _appraiseBtn_.hidden = YES;
        }
    }
    //打赏按钮显示判断
    if ([answerListModal.answer_person_detail.person_id isEqualToString:[Manager getUserInfo].userId_]) {
        self.payBtn_.hidden = YES;
    }else{
        self.payBtn_.hidden = NO;
    }

    //行家标识显示及用户名
    if (isExpert) {
        [self.expertMarkImgv_ setHidden:NO];
        self.nameLb_.frame = CGRectMake(CGRectGetMaxX(self.expertMarkImgv_.frame)+2,17,ScreenWidth - 165,16);
        [self.nameLb_ setTextColor:[UIColor redColor]];
        [self.nameLb_ setAttributedText:answerListModal.personNameAttString];
    }else{
        [self.expertMarkImgv_ setHidden:YES];
        self.nameLb_.frame = CGRectMake(50,17,ScreenWidth - 100,16);
        self.nameLb_.textColor = UIColorFromRGB(0x212121);
        [self.nameLb_ setAttributedText:answerListModal.personNameAttString];
    }
    
    //回答内容
    _answerContent.frame = answerListModal.answerFrame;
    _answerContent.clickDelegate = self;
    _answerContent.showLink = YES;
    _answerContent.linkCanClick = YES;
    [_answerContent setAttributedText:answerListModal.answerContentAttString];
    
    //动态时间位置
    CGRect anserTimeLbRect = self.timeBackView.frame;
    anserTimeLbRect.origin.y = CGRectGetMaxY(self.answerContent.frame)+ 4;
    [self.timeBackView setFrame:anserTimeLbRect];
    
    NSString *answerTime = [MyCommon getShortTime:answerListModal.answer_idate];
    [self.anserTimeLb_ setText:answerTime];
    
    //点赞
    [self.supportCountBtn_ setTitle:answerListModal.answer_support_count forState:UIControlStateNormal];
    if ([answerListModal.is_support isEqualToString:@"0"]) {
        [self.supportCountBtn_ setImage:[UIImage imageNamed:@"zan_question"] forState:UIControlStateNormal];
        [self.supportCountBtn_ setTitleColor:UIColorFromRGB(0x878787) forState:UIControlStateNormal];
    }
    else if ([answerListModal.is_support isEqualToString:@"1"]){
        [self.supportCountBtn_ setImage:[UIImage imageNamed:@"zan_question_red"] forState:UIControlStateNormal];
        [self.supportCountBtn_ setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    
    //评论个数
    [self.commentCountBtn setTitle:[NSString stringWithFormat:@"%ld",(long)[answerListModal.answer_comment_count integerValue]] forState:UIControlStateNormal];
    
    //打赏金额
    if (_rewardCountBtn) {
       _rewardCountBtn.hidden = YES; 
    }
    if ([answerDetialModal.is_recommend isEqualToString:@"1"]) {
        if (![answerListModal.dashang_total isEqualToString:@""] && answerListModal.dashang_total){
            if (!_rewardCountBtn){
                _rewardCountBtn = [ELBaseButton getNewButtonWithFont:[UIFont systemFontOfSize:12] title:@"" textColor:UIColorFromRGB(0x878787) normalImageName:@"answerD_gold" Target:nil action:nil frame:CGRectMake(_timeBackView.frame.size.width-173,0,53,21)];
                _rewardCountBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,5);
                [_timeBackView addSubview:_rewardCountBtn];
            }
            _rewardCountBtn.hidden = NO;
            [_rewardCountBtn setTitle:[NSString stringWithFormat:@"%@元",answerListModal.dashang_total] forState:UIControlStateNormal];
        }
    }
    
    if (_replyContentOne) {
        _replyContentOne.hidden = YES;
    }
    if (_replyContentTwo) {
        _replyContentTwo.hidden = YES;
    }
    if (_morePl) {
        _morePl.hidden = YES;
    }
    if (answerListModal.comment_list.count > 0){//某个回答的评论，最多显示两条
        NSInteger count = answerListModal.comment_list.count <= 2 ? answerListModal.comment_list.count:2;
        for (NSInteger i = 0; i < count; i++){
            ReplyCommentModal *commentModel = answerListModal.comment_list[i];
            if (i == 0) {
                if (!_replyContentOne) {
                    _replyContentOne = [[ELButtonView alloc] initWithFrame:commentModel.contentFrame];
                    [self.contentView addSubview:_replyContentOne];
                }
                _replyContentOne.hidden = NO;
                _replyContentOne.showLink = YES;
                _replyContentOne.linkCanClick = YES;
                _replyContentOne.clickDelegate = self;
                _replyContentOne.frame = commentModel.contentFrame;
                [_replyContentOne setNumberlines:0];
                [_replyContentOne setAttributedText:commentModel.contentAttString];
            }else if (i == 1) {
                if (!_replyContentTwo) {
                    _replyContentTwo = [[ELButtonView alloc] initWithFrame:commentModel.contentFrame];
                    [self.contentView addSubview:_replyContentTwo];
                }
                _replyContentTwo.hidden = NO;
                _replyContentTwo.showLink = YES;
                _replyContentTwo.linkCanClick = YES;
                _replyContentTwo.clickDelegate = self;
                _replyContentTwo.frame = commentModel.contentFrame;
                [_replyContentTwo setNumberlines:0];
                [_replyContentTwo setAttributedText:commentModel.contentAttString];
            }
            
            if (i == 1 && answerListModal.comment_list.count > 2) {
                //更多答复
                if (!self.morePl) {
                    self.morePl = [[UILabel alloc] initWithFrame:CGRectMake(50,CGRectGetMaxY(_replyContentTwo.frame)+5,150,20)];
                    self.morePl.textColor = UIColorFromRGB(0x0080FF);
                    self.morePl.font = [UIFont systemFontOfSize:13];
                    [self.contentView addSubview:self.morePl];
                }
                anserTimeLbRect = self.morePl.frame;
                anserTimeLbRect.origin.y = CGRectGetMaxY(_replyContentTwo.frame)+5;
                self.morePl.frame = anserTimeLbRect;
                
                self.morePl.hidden = NO;
                NSString *str = [NSString stringWithFormat:@"查看全部%ld条评论",(long)[answerListModal.answer_comment_count integerValue]];
                self.morePl.text = str;
                break;
            }
        }
    }
    
    //审核状态显示
    if([answerListModal.manage_status integerValue] == 0 ){
        if (!statusView) {
            [self creatStatus];
            [self.contentView addSubview:statusView];
        }
        statusView.frame = CGRectMake(0,answerListModal.cellHeight-48,ScreenWidth,46);
        statusView.hidden = NO;
    }else{
        if (statusView) {
            statusView.hidden = YES;
        }
    }
    //底部分割线
    CGRect frame = imageLine.frame;
    frame.origin.y = answerListModal.cellHeight-2;
    imageLine.frame = frame;
}

-(void)linkDelegateBtnRespone:(TextSpecial *)model{
    NSString *link = model.key;
    if (link && ![link isEqualToString:@""]) {
        NSArray *ylUrls = [[Manager shareMgr] getUrlArr];            
        for (NSString *url in ylUrls) {
            if ([link rangeOfString:url].location != NSNotFound) {
                PushUrlCtl *urlCtl = [[PushUrlCtl alloc]init];
                urlCtl.isThirdUrl = YES;
                urlCtl.hideShareButton = YES;
                [[Manager shareMgr].centerNav_ pushViewController:urlCtl animated:YES];
                if (![link hasPrefix:@"http://"]) {
                    link = [NSString stringWithFormat:@"http://%@",link];
                }
                [urlCtl beginLoad:link exParam:link];
                break;
            }
        }
    }

}

-(void)creatStatus{
    if (!statusView) {
        statusView = [[UIView alloc] initWithFrame:CGRectMake(0,16,ScreenWidth-32,46)];
        statusView.backgroundColor = UIColorFromRGB(0xfff8e3);
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(16,8,ScreenWidth-32,30)];
        lable.text = @"提交或修改的回答审核通过后，其他用户才能看到，请耐心等待，正在审核中...";
        lable.numberOfLines = 2;
        lable.font = [UIFont systemFontOfSize:12];
        lable.textColor = UIColorFromRGB(0xff6600);
        [statusView addSubview:lable];
    }
}

@end

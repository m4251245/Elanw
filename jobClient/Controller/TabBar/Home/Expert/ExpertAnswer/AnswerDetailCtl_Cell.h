//
//  AnswerDetailCtl_Cell.h
//  Association
//
//  Created by 一览iOS on 14-3-7.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"
#import "Answer_DataModal.h"
#import "Comment_DataModal.h"
#import "AnswerListModal.h"
#import "AnswerDetialModal.h"
#import "ReplyCommentModal.h"
#import "ELBaseButton.h"

@interface AnswerDetailCtl_Cell : UITableViewCell<MLEmojiLabelDelegate,ClickDelegate>

@property(nonatomic,strong) UIImageView * imgView_;
@property(strong,nonatomic) UIButton *imgViewBtn_;
@property(nonatomic,strong) UILabel * nameLb_;
@property(nonatomic,strong) UILabel * anserTimeLb_;
@property(nonatomic,strong) ELBaseButton * supportCountBtn_;
@property(nonatomic,strong) UIImageView * expertMarkImgv_;
@property(strong,nonatomic) ELBaseButton *appraiseBtn_;
@property(strong,nonatomic) ELBaseButton *payBtn_;
@property(strong,nonatomic) ELBaseButton *rewardCountBtn;
@property(strong,nonatomic) ELBaseButton *commentCountBtn;
@property(strong,nonatomic) UIImageView *imageLine;
@property(strong,nonatomic) UILabel *morePl;

@property (nonatomic,strong) ELButtonView *answerContent;
@property (nonatomic,strong) ELButtonView *replyContentOne;
@property (nonatomic,strong) ELButtonView *replyContentTwo;

@property (nonatomic,strong) UIView *timeBackView;

+(AnswerDetailCtl_Cell *)getTableViewCellWithTableView:(UITableView *)tableView;
-(void)giveAnswerListModel:(AnswerListModal *)answerListModal andAnswerDetialModal:(AnswerDetialModal *)answerDetialModal;

@end

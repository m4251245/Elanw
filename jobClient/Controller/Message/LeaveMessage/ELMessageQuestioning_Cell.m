//
//  ELMessageQuestioning_Cell.m
//  jobClient
//
//  Created by 一览iOS on 15/9/6.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELMessageQuestioning_Cell.h"


@implementation ELMessageQuestioning_Cell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleImage = [[UIImageView alloc] init];
        self.dateLb = [[UILabel alloc] init];
        self.bgBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backView = [[UIView alloc] init];
        
        _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(5,5,ScreenWidth-100,20)];
        _phoneLb = [[UILabel alloc] initWithFrame:CGRectMake(5,30,ScreenWidth-100,20)];
        _lineImgOne = [[UIImageView alloc] initWithFrame:CGRectMake(0,55,ScreenWidth-100,1)];
        _lineImgOne.image = [UIImage imageNamed:@"gg_home_line2"];
        _lineImgTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gg_home_line2"]];
        _lableOne = [[UILabel alloc] initWithFrame:CGRectMake(5,60,ScreenWidth-100,20)];
        _lableTwo = [[UILabel alloc] init];
        _answerLb = [[UILabel alloc] init];
        _questionLb = [[UILabel alloc] init];
        _tipsLb = [[UILabel alloc] init];
        
        _tipsLb.font = [UIFont systemFontOfSize:10];
        _tipsLb.clipsToBounds = YES;
        _tipsLb.layer.cornerRadius = 4.0;
        _tipsLb.backgroundColor = UIColorFromRGB(0xcecece);
        _tipsLb.textColor = [UIColor whiteColor];
        _tipsLb.numberOfLines = 0;
        _titleLb.font = FOURTEENFONT_CONTENT;
        
        _phoneLb.font = FOURTEENFONT_CONTENT;
        _lableOne.font = FOURTEENFONT_CONTENT;
        _lableTwo.font = FOURTEENFONT_CONTENT;
        _answerLb.font = FOURTEENFONT_CONTENT;
        _questionLb.font = FOURTEENFONT_CONTENT;
        _titleLb.textColor = FONEREDCOLOR;
        _answerLb.numberOfLines = 0;
        _questionLb.numberOfLines = 0;
        
        [self.backView addSubview:_titleLb];
        [self.backView addSubview:_phoneLb];
        [self.backView addSubview:_lineImgOne];
        [self.backView addSubview:_lineImgTwo];
        [self.backView addSubview:_lableOne];
        [self.backView addSubview:_lableTwo];
        [self.backView addSubview:_answerLb];
        [self.backView addSubview:_questionLb];
        [self.contentView addSubview:_tipsLb];
        
        CALayer *layer = _dateLb.layer;
        _dateLb.font = [UIFont systemFontOfSize:9];
        layer.masksToBounds = YES;
        layer.cornerRadius = 4.f;
        _dateLb.backgroundColor = UIColorFromRGB(0xcecece);
        _dateLb.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_titleImage];
        [self.contentView addSubview:_dateLb];
        [self.contentView addSubview:_bgBtnView];
        [self.contentView addSubview:_backView];
        [self.contentView sendSubviewToBack:_bgBtnView];
        self.titleImage.clipsToBounds = YES;
        self.titleImage.layer.cornerRadius = 4.0;
        _dateLb.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


-(void)giveDataModal:(LeaveMessage_DataModel *)modal
{
    UIImage *bgImage;
    
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:modal.personPic]];

    _phoneLb.text = [NSString stringWithFormat:@"手机号:%@",modal.questionMobile];
    _answerLb.text = modal.questionContent;
    _questionLb.text = modal.introContent;
    _tipsLb.text = modal.questionTips;
    
    CGSize size = [modal.questionContent sizeNewWithFont:_answerLb.font constrainedToSize:CGSizeMake(ScreenWidth-100,100000)];
    _answerLb.frame = CGRectMake(5,85,ScreenWidth-100,size.height);
    _lineImgTwo.frame = CGRectMake(0,CGRectGetMaxY(_answerLb.frame) + 5,ScreenWidth-100,1);
    _lableTwo.frame = CGRectMake(5,CGRectGetMaxY(_lineImgTwo.frame) + 5,ScreenWidth-100,20);
    
    size = [modal.introContent sizeNewWithFont:_questionLb.font constrainedToSize:CGSizeMake(ScreenWidth-100,100000)];
    _questionLb.frame = CGRectMake(5,CGRectGetMaxY(_lableTwo.frame) + 5,ScreenWidth-100,size.height);
    
    if ([modal.isSend isEqualToString:@"1"])
    {//ziji
        self.titleImage.frame = CGRectMake(ScreenWidth-50,29,40,40);
        bgImage = [UIImage imageNamed:@"icon_dailog1.png"];
        bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width*0.4 topCapHeight:bgImage.size.height*0.8];
        self.bgBtnView.frame = CGRectMake(265-241,30,ScreenWidth-80,CGRectGetMaxY(_questionLb.frame) + 10);
        self.backView.frame = CGRectMake(265-239,30,ScreenWidth-83,CGRectGetMaxY(_questionLb.frame) + 5);
        _lableTwo.text = @"你的情况";
        _lableOne.text = @"你想咨询的问题";
        _titleLb.text = @"你向行家发起了约谈";
    }
    else
    {
        self.titleImage.frame = CGRectMake(8,29,40,40);
        bgImage = [UIImage imageNamed:@"icon_dailog2.png"];
        bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width*0.6 topCapHeight:bgImage.size.height*0.8];
        self.bgBtnView.frame = CGRectMake(55,30,ScreenWidth-80,CGRectGetMaxY(_questionLb.frame) + 10);
        self.backView.frame = CGRectMake(65,30,ScreenWidth-83,CGRectGetMaxY(_questionLb.frame) + 5);
        _lableTwo.text = @"TA的情况";
        _lableOne.text = @"TA想咨询的问题";
        _titleLb.text = modal.questionTitle;
    }
    CGSize sizeOne = [modal.date sizeNewWithFont:[UIFont systemFontOfSize:9]];
    _dateLb.frame = CGRectMake((ScreenWidth-sizeOne.width-5)/2,10,sizeOne.width + 8,sizeOne.height);
    if (!modal.date) {
        _dateLb.hidden = YES;
    }else{
        _dateLb.hidden = NO;
        _dateLb.text = modal.date;
    }
    
    [self.bgBtnView setBackgroundImage:bgImage forState:UIControlStateNormal];

    size = [modal.questionTips sizeNewWithFont:_tipsLb.font constrainedToSize:CGSizeMake(ScreenWidth-50,100000)];
    CGRect frame = CGRectMake(25,CGRectGetMaxY(self.bgBtnView.frame) + 5,ScreenWidth-50,size.height+5);
    _tipsLb.frame = CGRectIntegral(frame);
}

@end

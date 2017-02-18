//
//  MyJobGuideCtl_Cell.m
//  jobClient
//
//  Created by 一览iOS on 15-1-20.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MyJobGuideCtl_Cell.h"


@implementation MyJobGuideCtl_Cell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}
-(void)giveDataWithModal:(JobGuideQuizModal *)dataModal
{
    self.bgView.layer.cornerRadius = 8;
    
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:dataModal.person_detail.person_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    
    if ([dataModal.person_detail.is_expert isEqualToString:@"1"]) {
        self.expertImage.hidden = NO;
        _titleNameLayout.constant = 27;
    }
    else
    {
        self.expertImage.hidden = YES;
        _titleNameLayout.constant = 8;
    }
    
    self.titleName.text = [MyCommon translateHTML:dataModal.person_detail.person_iname];
  
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:FOURTEENFONT_CONTENT,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.questLable.attributedText = [[NSAttributedString alloc] initWithString:[MyCommon translateHTML:dataModal.question_title] attributes:attributes];
    self.questLable.font = FOURTEENFONT_CONTENT;
    
    if (dataModal.tag_info.count == 0)
    {
        self.typeLableOne.hidden = YES;
        self.typeLableTwo.hidden = YES;
        self.typeLableThree.hidden = YES;
    }
    else
    {
        self.typeLableOne.hidden = NO;
        self.typeLableTwo.hidden = NO;
        self.typeLableThree.hidden = NO;
        
        switch (dataModal.tag_info.count) {
            case 0:
                self.typeLableOne.text = @"";
                self.typeLableTwo.text = @"";
                self.typeLableThree.text = @"";
                break;
            case 1:
                self.typeLableOne.text = [NSString stringWithFormat:@"#%@",dataModal.tag_info[0]];
                self.typeLableTwo.text = @"";
                self.typeLableThree.text = @"";
                break;
            case 2:
                self.typeLableOne.text = [NSString stringWithFormat:@"#%@",dataModal.tag_info[0]];
                self.typeLableTwo.text = [NSString stringWithFormat:@"#%@",dataModal.tag_info[1]];
                self.typeLableThree.text = @"";
                break;
            case 3:
                self.typeLableOne.text = [NSString stringWithFormat:@"#%@",dataModal.tag_info[0]];
                self.typeLableTwo.text = [NSString stringWithFormat:@"#%@",dataModal.tag_info[1]];
                self.typeLableThree.text = [NSString stringWithFormat:@"#%@",dataModal.tag_info[2]];
                break;
            default:
                break;
        }
    } 
    
    [_viewCountBtn setTitle:[NSString stringWithFormat:@" %@",dataModal.question_view_count] forState:UIControlStateNormal];
    
    if ([dataModal.question_replys_count isEqualToString:@"0"]) {
        self.replysCount.hidden = YES;
    }
    else
    {
        self.replysCount.hidden = NO;
        NSString *replyCountStr = [NSString stringWithFormat:@"已有%@个回答",dataModal.question_replys_count];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:replyCountStr];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xE4403A) range:NSMakeRange(2, dataModal.question_replys_count.length)];
        self.replysCount.attributedText = attributeStr;
    }
    
}

@end

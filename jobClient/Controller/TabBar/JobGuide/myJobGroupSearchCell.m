//
//  myJobGroupSearchCell.m
//  jobClient
//
//  Created by 一览iOS on 15-1-21.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "myJobGroupSearchCell.h"

@implementation myJobGroupSearchCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)giveDataWithModal:(Answer_DataModal *)dataModal
{
    self.quseLable.text = dataModal.questionTitle_;
    
    switch (dataModal.tagInfoArray.count) {
        case 0:
            self.typeLableOne.text = @"";
            self.typeLableTwo.text = @"";
            self.typeLableThree.text = @"";
            break;
        case 1:
            self.typeLableOne.text = [NSString stringWithFormat:@"#%@",dataModal.tagInfoArray[0]];
            self.typeLableTwo.text = @"";
            self.typeLableThree.text = @"";
            break;
        case 2:
            self.typeLableOne.text = [NSString stringWithFormat:@"#%@",dataModal.tagInfoArray[0]];
            self.typeLableTwo.text = [NSString stringWithFormat:@"#%@",dataModal.tagInfoArray[1]];
            self.typeLableThree.text = @"";
            break;
        case 3:
            self.typeLableOne.text = [NSString stringWithFormat:@"#%@",dataModal.tagInfoArray[0]];
            self.typeLableTwo.text = [NSString stringWithFormat:@"#%@",dataModal.tagInfoArray[1]];
            self.typeLableThree.text = [NSString stringWithFormat:@"#%@",dataModal.tagInfoArray[2]];
            break;
        default:
            break;
    }
    self.answeCount.text = dataModal.question_replys_count;
    if ([dataModal.question_replys_count isEqualToString:@"0"]) {
        self.answerImage.image = [UIImage imageNamed:@"icon_answer0.png"];
    }
    else
    {
        self.answerImage.image = [UIImage imageNamed:@"icon_answer.png"];
    }
}

@end

//
//  HeaderNotifyTableViewCell.m
//  jobClient
//
//  Created by 一览ios on 16/5/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "HeaderNotifyTableViewCell.h"
#import "UIImage+category.h"

@implementation HeaderNotifyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.recordNumlab.textColor = UIColorFromRGB(0x333333);
    _notifyLab.textColor = UIColorFromRGB(0x999999);
    _lookLab.textColor = UIColorFromRGB(0x999999);
    _recordLab.textColor = UIColorFromRGB(0x999999);
    
    [_interNotifyBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
    [_lookMeBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
    [_recordBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
  
//    _interNotifyBtn.enabled = NO;
//    _lookMeBtn.enabled = NO;
//    _recordBtn.enabled = NO;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:[touch view]];
//    
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

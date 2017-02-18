//
//  SelectionTableViewCell.m
//  jobClient
//
//  Created by 一览ios on 16/8/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "SelectionTableViewCell.h"

@implementation SelectionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    _selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selBtn.frame = CGRectMake(16, 34, 16, 16);
    [_selBtn setBackgroundImage:[UIImage imageNamed:@"check_box"] forState:UIControlStateNormal];
    [self.contentView addSubview:_selBtn];
    
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(38, 36, 199, 14)];
    lb.textColor = UIColorFromRGB(0x666666);
    lb.text = @"愿意推荐一览";
    [self.contentView addSubview:lb];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

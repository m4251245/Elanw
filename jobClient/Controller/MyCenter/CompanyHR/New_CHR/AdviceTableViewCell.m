//
//  AdviceTableViewCell.m
//  jobClient
//
//  Created by 一览ios on 16/8/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "AdviceTableViewCell.h"
#define kLeftTo ScreenWidth - 16 - 56 - 29
@implementation AdviceTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    UILabel *titleLB = [[UILabel alloc]initWithFrame:CGRectMake(16, 36, 56, 14)];
    titleLB.textColor = UIColorFromRGB(0x333333);
    titleLB.text = @"服务建议";
    titleLB.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:titleLB];
    
    for (int i = 0; i < 2; i++) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, 49 * i, ScreenWidth - 16, 1)];
        line.backgroundColor = UIColorFromRGB(0xecedec);
        [self.contentView addSubview:line];
    }
    
    UITextView *txtView = [[UITextView alloc]initWithFrame:CGRectMake(kLeftTo, 36, kLeftTo - 16, 14)];
    [self.contentView addSubview:txtView];
    
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 14)];
    lb.text = @"您的宝贵建议，是我们前进的动力";
    lb.textColor = UIColorFromRGB(0xaaaaaa);
    lb.font = [UIFont systemFontOfSize:14];
    [txtView addSubview:lb];
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

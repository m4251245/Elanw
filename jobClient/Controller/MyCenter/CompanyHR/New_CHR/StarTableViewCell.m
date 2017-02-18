//
//  StarTableViewCell.m
//  jobClient
//
//  Created by 一览ios on 16/8/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "StarTableViewCell.h"

#define kAllStarWidth 180
#define kOneStarWidth 36

@implementation StarTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUIWithTitle:title];
    }
    return self;
}

-(void)configUIWithTitle:(NSString *)title{
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, 100, 20)];
    titleLb.text = title;
    titleLb.font = [UIFont systemFontOfSize:14];
    titleLb.textColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:titleLb];
    
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(ScreenWidth - kAllStarWidth + kOneStarWidth * i, 10, 20, 20);
        [btn setBackgroundImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(starBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1111110 + i;
        [self.contentView addSubview:btn];
    }
}

-(void)starBtnClick:(UIButton *)btn{
    NSLog(@"aaaaaaaa");
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

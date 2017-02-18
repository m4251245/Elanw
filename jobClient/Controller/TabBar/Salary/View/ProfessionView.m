//
//  ProfessionView.m
//  jobClient
//
//  Created by 一览ios on 15/4/28.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ProfessionView.h"
#import "personTagModel.h"
#import "MyConfig.h"

#define kColumn 3
#define kPadding 4
#define kItemHeight 29
#define kItemWidth (ScreenWidth-8)/3.0

@implementation ProfessionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:240.f/255 green:240.f/255 blue:240.f/255 alpha:1.f];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setTagArray:(NSArray *)tagArray
{
    _tagArray = tagArray;
    for (int i=0; i<tagArray.count; i++) {
        int line = i/kColumn;
        int column = i%kColumn;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"con_salary_board.png"] forState:UIControlStateNormal];
        CGFloat x = kPadding +column*kItemWidth -column*1;
        CGFloat y = kPadding+line*kItemHeight -line*1;
        button.frame = CGRectMake(x, y, kItemWidth, kItemHeight);
        personTagModel *tagModel = tagArray[i];
        [button setTitle:tagModel.tagName_ forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.titleLabel.font = TWEELVEFONT_COMMENT;
        button.tag = i;
        [button addTarget:self action:@selector(professionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    int temp = tagArray.count%kColumn;
    if (temp) {
        for (int i=temp; i<kColumn; i++) {
            NSInteger line = (tagArray.count+i-1)/kColumn;
            NSInteger column = i%kColumn;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:@"con_salary_board.png"] forState:UIControlStateNormal];
            CGFloat x = kPadding +column*kItemWidth -column*1;
            CGFloat y = kPadding+line*kItemHeight -line*1;
            button.frame = CGRectMake(x, y, kItemWidth, kItemHeight);
            [self addSubview:button];
        }
    }
    NSInteger totalLine = tagArray.count%kColumn == 0 ? tagArray.count/kColumn : tagArray.count/kColumn+1;
    self.bounds = CGRectMake(0, 0,ScreenWidth, totalLine*kItemHeight);
}

#pragma mark 
- (void)professionBtnClick:(UIButton *)sender
{
    NSInteger index = sender.tag;
    personTagModel *tagModel = _tagArray[index];
    if (_professionBtnBlock) {
        _professionBtnBlock(tagModel);
    }
}

@end

//
//  TxtSearchView.m
//  jobClient
//
//  Created by 一览ios on 16/8/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "TxtSearchView.h"

@implementation TxtSearchView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

#pragma mark--初始化
-(void)configUI{
    _txt = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, self.frame.size.width - 60, self.frame.size.height - 10)];
    _txt.backgroundColor = [UIColor whiteColor];
    _txt.tintColor = UIColorFromRGB(0xe13e3e);
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = UIColorFromRGB(0xcccccc);
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:@"输入人才姓名" attributes:attrs];
    _txt.attributedPlaceholder = placeholder;
    _txt.layer.cornerRadius = 3;
    _txt.layer.masksToBounds = YES;
    _txt.returnKeyType = UIReturnKeySearch;
    _txt.font = [UIFont systemFontOfSize:15];
    [self addSubview:_txt];
    
    UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8, 36, 18)];
    leftImg.image = [UIImage imageNamed:@"search_small_grey"];
    _txt.leftView = leftImg;
    _txt.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 8, 23, 18);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"delete_new"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clearClick:) forControlEvents:UIControlEventTouchUpInside];
    _txt.rightView = rightBtn;
    _txt.rightViewMode = UITextFieldViewModeWhileEditing;
    
    UIButton *rightCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightCancelBtn.frame = CGRectMake(0, 0, 40, 16);
    rightCancelBtn.center = CGPointMake((2 * self.frame.size.width - 50)/2, self.center.y);
    [rightCancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [rightCancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightCancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:rightCancelBtn];
    [rightCancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark--事件
/**
 *  清除
 *
 *  @param btn btn description
 */
-(void)clearClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(searchViewClearBtnClick:)]) {
        [_delegate searchViewClearBtnClick:btn];
    }
}

/**
 *  取消
 *
 *  @param btn btn description
 */
-(void)cancelClick:(UIButton *)btn{
    [_txt resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(cancelBtnClick:)]) {
        [_delegate cancelBtnClick:btn];
    }
}

@end

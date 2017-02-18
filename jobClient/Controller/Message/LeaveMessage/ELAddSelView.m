//
//  ELAddSelView.m
//  jobClient
//
//  Created by 一览ios on 2016/12/21.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELAddSelView.h"

#define kWid self.frame.size.width
#define kHit self.frame.size.height

#define kTag 6768

@interface ELAddSelView(){
    NSArray *btnSelArr;
}

@end

@implementation ELAddSelView

-(instancetype)initWithFrame:(CGRect)frame arr:(NSArray*)selArr{
    if (self = [super initWithFrame:frame]) {
        [self configWithArr:selArr];
    }
    return self;
}

#pragma mark--配置界面
-(void)configWithArr:(NSArray *)selArr{
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWid, kHit)];
    [imgView setImage:[UIImage imageNamed:@"bton_chat@2x"]];
    imgView.userInteractionEnabled = YES;
    [self addSubview:imgView];
    
    for (int i = 0; i<selArr.count; i++) {
        NSDictionary *dic = selArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:dic[@"title"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:dic[@"img"]] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize: 16.0];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(16,8 + 53 * i, 134, 52);
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        btn.tag = i + kTag;
        [imgView addSubview:btn];
        
//        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 52, 134, 1)];
//        line.backgroundColor = UIColorFromRGB(0x1d1f20);
//        [btn addSubview:line];
        
        [btn addTarget:self action:@selector(selBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)selBtnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(addSelClick:)]) {
        [self.delegate addSelClick:sender];
    }
}

@end

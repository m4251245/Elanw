//
//  InbiddingJobCell.m
//  jobClient
//
//  Created by 一览ios on 15/10/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "InbiddingJobCell.h"


@implementation InbiddingJobCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _ctViw.layer.cornerRadius = 4.0;
    _ctViw.layer.borderColor = [UIColor clearColor].CGColor;
    CGRect frame = _ctViw.frame;
    frame.size.height = 85;
    _ctViw.frame = frame;
    _functionView.hidden = YES;
    
    ELLineView *line = [[ELLineView alloc] initWithFrame:CGRectMake(ScreenWidth-88, 4.5, 1, 9) WithColor:UIColorFromRGB(0xea7979)];
    [_ctViw addSubview:line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)perfectSelectBtn:(id)sender {
}

-(void)giveDataNormalJobModal:(ZWDetail_DataModal *)dataModal
{
    
    CGRect frame = _ctViw.frame;
    frame.size.height = 120;
    frame.size.width = ScreenWidth-16;
    _ctViw.frame = frame;
    _functionView.hidden = NO;
 
    _functionView.clipsToBounds = YES;
    _functionView.layer.cornerRadius = 2.0;
    _functionView.layer.borderWidth = 0.5;
    _functionView.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
    
    _leftBtn.hidden = NO;
    _centerBtn.hidden = NO;
    _rightBtn.hidden = NO;
    _leftLineView.hidden = NO;
    _rightLineView.hidden = NO;
    
    CGFloat width = (ScreenWidth-35)/3.0;
    
    _leftBtn.frame = CGRectMake(0,0,width,25);
    _centerBtn.frame = CGRectMake(width,0,width,25);
    _rightBtn.frame = CGRectMake(width*2,0,width,25);
    _leftLineView.frame = CGRectMake(width,2,1,20);
    _rightLineView.frame = CGRectMake(width*2,2,1,20);
    
    [_leftBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [_leftBtn setImage:[UIImage imageNamed:@"refresh_button_image"] forState:UIControlStateNormal];
    [_centerBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_centerBtn setImage:[UIImage imageNamed:@"editor_button_image"] forState:UIControlStateNormal];
    [_rightBtn setTitle:@"更多" forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"more_button_image"] forState:UIControlStateNormal];
}

-(void)giveDataStopJobModal:(ZWDetail_DataModal *)dataModal
{
    CGRect frame = _ctViw.frame;
    frame.size.height = 120;
    frame.size.width = ScreenWidth-16;
    _ctViw.frame = frame;
    _functionView.hidden = NO;
    
    _functionView.clipsToBounds = YES;
    _functionView.layer.cornerRadius = 2.0;
    _functionView.layer.borderWidth = 0.5;
    _functionView.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
    
    _leftBtn.hidden = NO;
    _centerBtn.hidden = NO;
    _rightBtn.hidden = YES;
    _leftLineView.hidden = NO;
    _rightLineView.hidden = YES;
    
    CGFloat width = (ScreenWidth-35)/2.0;
    _leftBtn.frame = CGRectMake(0,0,width,25);
    _centerBtn.frame = CGRectMake(width,0,width,25);
    _leftLineView.frame = CGRectMake(width,2,1,20);
    
    [_leftBtn setTitle:@"启用" forState:UIControlStateNormal];
    [_leftBtn setImage:[UIImage imageNamed:@"start_button_image"] forState:UIControlStateNormal];
    [_centerBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_centerBtn setImage:[UIImage imageNamed:@"delete_button_image"] forState:UIControlStateNormal];
}

@end

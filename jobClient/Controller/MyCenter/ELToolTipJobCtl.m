//
//  ELToolTipJobCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/1/13.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELToolTipJobCtl.h"

@interface ELToolTipJobCtl ()
{
    __weak IBOutlet UIView *blackBackView;
    
    IBOutlet UIView *changeTypeViewOne;
    IBOutlet UIView *changeTypeViewTwo;
    
    __weak IBOutlet UIButton *stopJovBtn;
    __weak IBOutlet UIButton *deleteJobBtn;
    
    __weak IBOutlet UIView *cancelView;
    
    __weak IBOutlet UILabel *contentLableOne;
    __weak IBOutlet UILabel *contentLableTwo;
}
@end


@implementation ELToolTipJobCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    blackBackView.userInteractionEnabled = YES;
    [blackBackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideViewCtl)]];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    blackBackView.frame = [UIScreen mainScreen].bounds;
    
    changeTypeViewOne.clipsToBounds = YES;
    changeTypeViewOne.layer.cornerRadius = 4.0;
    
    changeTypeViewTwo.clipsToBounds = YES;
    changeTypeViewTwo.layer.cornerRadius = 4.0;
    // Do any additional setup after loading the view from its nib.
}

-(void)showViewCtl
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.view];
    _isShow = YES;
}
-(void)hideViewCtl
{
    [self.view removeFromSuperview];
    _isShow = NO;
}

-(void)showViewCtlWithAttStringOne:(NSMutableAttributedString *)stringOne attStringTwo:(NSMutableAttributedString *)stringTwo btnRespone:(btnResponeBlock)block
{
    if (!stringOne || stringOne.string.length == 0)
    {
        return;
    }
    
    [changeTypeViewOne removeFromSuperview];
    [changeTypeViewTwo removeFromSuperview];
    
    _btnBlock = block;
    
    [self.view addSubview:changeTypeViewTwo];
    [self.view bringSubviewToFront:changeTypeViewTwo];
    
    [contentLableOne setAttributedText:stringOne];
    
    if(!stringTwo || stringTwo.string.length == 0)
    {
        CGRect frame = cancelView.frame;
        frame.origin.y = 85;
        cancelView.frame = frame;
    }
    else
    {
        CGRect frame = cancelView.frame;
        frame.origin.y = 105;
        cancelView.frame = frame;
        [contentLableTwo setAttributedText:stringTwo];
    }
    changeTypeViewTwo.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    if (!_isShow)
    {
        [self showViewCtl];
    }
}

-(void)showDeleteAndStopViewCtlBtnRespone:(btnResponeBlock)block
{
    _btnBlock = block;
    
    [changeTypeViewOne removeFromSuperview];
    [changeTypeViewTwo removeFromSuperview];
    [self.view addSubview:changeTypeViewOne];
    [self.view bringSubviewToFront:changeTypeViewOne];
    changeTypeViewOne.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    if (!_isShow)
    {
        [self showViewCtl];
    }
}

- (IBAction)btnRespone:(UIButton *)sender
{
    if (sender == _cancelBtn)
    {
        _btnBlock(1);
    }
    else if (sender == _confirmBtn)
    {
        _btnBlock(2);
    }
    else if (sender == stopJovBtn)
    {
        _btnBlock(3);
    }
    else if(sender == deleteJobBtn)
    {
        _btnBlock(4);
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

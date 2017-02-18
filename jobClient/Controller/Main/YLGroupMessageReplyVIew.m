//
//  YLGroupMessageReplyVIew.m
//  jobClient
//
//  Created by 一览iOS on 15/7/28.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "YLGroupMessageReplyVIew.h"

@interface YLGroupMessageReplyVIew ()
{
    __weak IBOutlet UIButton *seeArticle;
    __weak IBOutlet UIButton *replayBtn;
    __weak IBOutlet UIView *backView;
    CGPoint pointCenter;
    
    __weak IBOutlet NSLayoutConstraint *backBottom;
    __weak IBOutlet UIView *blackView;
}
@end

@implementation YLGroupMessageReplyVIew

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showMessageViewCtl
{
    self.view.frame = [UIScreen mainScreen].bounds;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self.view];
    
    [self.view sendSubviewToBack:blackView];
    
    if (pointCenter.x == 0) {
        pointCenter = backView.center;
    }
    CGPoint center = backView.center;
    center.y = pointCenter.y - 120;
    
    [UIView animateWithDuration:0.3 animations:^{
        backBottom.constant = 0;
//        backView.center = center;
        blackView.alpha = 0.4;
    }];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideMessageViewCtl];
}

-(void)hideMessageViewCtl
{
    [UIView animateWithDuration:0.3 animations:^{
//        backView.center = pointCenter;
        backBottom.constant = -120;
        blackView.alpha = 0;
    } completion:^(BOOL finished)
    {
        [self.view removeFromSuperview];
    }];
}

- (IBAction)btnRespone:(UIButton *)sender
{
    if (sender == seeArticle)
    {
        [_messageReplyDelegate pushArticleDetailCtl];
    }
    else if(sender == replayBtn)
    {
        [_messageReplyDelegate pushReplyViewCtl];
    }

    [self hideMessageViewCtl];
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

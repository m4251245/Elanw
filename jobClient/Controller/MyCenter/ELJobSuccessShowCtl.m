//
//  ELJobSuccessShowCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/3/4.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELJobSuccessShowCtl.h"

@interface ELJobSuccessShowCtl ()
{
    __weak IBOutlet UIImageView *showImage;
    
}

@end

@implementation ELJobSuccessShowCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view bringSubviewToFront:showImage];
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

-(void)showViewCtl
{
    self.view.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.view];
}

-(void)hideViewCtl
{
    [self.view removeFromSuperview];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideViewCtl];
}

@end

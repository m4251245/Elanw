//
//  ELArticleAbnormalCtl.m
//  jobClient
//
//  Created by 王新建 on 16/5/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELArticleAbnormalCtl.h"

@interface ELArticleAbnormalCtl ()
{
    IBOutlet UIView *articleAbnormalView;
    
    __weak IBOutlet UILabel *abnormalLableTitle;
    
    __weak IBOutlet UILabel *abnormalLableContent;
    
    __weak IBOutlet UIButton *abnormalBtn;
    
    IBOutlet UIView *publishRuleView;
    
    __weak IBOutlet UIButton *publishRuleBtn;
    
    __weak IBOutlet UIView *publishRuleBackView;
    
    __weak IBOutlet UIView *publishRuleContentView;
}
@end

@implementation ELArticleAbnormalCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    publishRuleContentView.clipsToBounds = YES;
    publishRuleContentView.layer.cornerRadius = 4.0;
    
    publishRuleBtn.clipsToBounds = YES;
    publishRuleBtn.layer.cornerRadius = 3.0;
    
    [publishRuleBackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePublishRuleView)]];
}

-(void)removePublishRuleView
{
    [publishRuleView removeFromSuperview];
}

-(void)showDeleteStatus:(BOOL)isDelete
{
    if (isDelete) 
    {
        abnormalLableTitle.text = @"文章已删除";
        abnormalLableContent.hidden = YES;
        abnormalBtn.hidden = YES;
    }
    else
    {
        abnormalLableTitle.text = @"文章已禁用";
        abnormalLableContent.hidden = NO;
        abnormalBtn.hidden = NO;
    }
}


- (IBAction)abnormalBtnResopne:(UIButton *)sender
{
    if (sender == publishRuleBtn)
    {
        [publishRuleView removeFromSuperview];
    }
    else if (sender == abnormalBtn)
    {
        publishRuleView.frame = [UIScreen mainScreen].bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:publishRuleView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:publishRuleView];
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

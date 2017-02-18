//
//  YLOfferApplyPromptCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/7/22.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "YLOfferApplyPromptCtl.h"

@interface YLOfferApplyPromptCtl ()
{
    
     IBOutlet UIImageView *titleImage;
     IBOutlet UIView *offerView;
     IBOutlet UILabel *lableOne;
     IBOutlet UILabel *lableTwo;
     IBOutlet UILabel *lableCenter;
    
     IBOutlet UILabel *lableThree;
    NSInteger type_;
}
@end

@implementation YLOfferApplyPromptCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    offerView.userInteractionEnabled = YES;
    offerView.clipsToBounds = YES;
    offerView.layer.cornerRadius = 5.0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [offerView addGestureRecognizer:tap];
    
    switch (type_) {
        case 1:
        {
            lableOne.text = @"";
            lableTwo.text = @"";
            lableCenter.text = @"登录即可参加offer派,轻松拿offer。";
            lableThree.text = @"好";
            titleImage.image = [UIImage imageNamed:@"ios_icon_xinshui_login"];
        }
            break;
        case 2:
        {
            lableOne.text = @"您的信息已提交成功，我们将24小";
            lableTwo.text = @"时内联系您！您可以先完善简历";
            lableOne.textColor = UIColorFromRGB(0x666666);
            lableTwo.textColor = UIColorFromRGB(0x666666);
            lableCenter.text = @"";
            lableThree.text = @"前往我的简历";
            titleImage.image = [UIImage imageNamed:@"ios_icon_apply_success"];
        }
            break;
        case 3:
        {
            lableOne.text = @"您的信息已提交成功，我们将";
            lableTwo.text = @"24小时内联系您！";
            lableOne.textColor = UIColorFromRGB(0x666666);
            lableTwo.textColor = UIColorFromRGB(0x666666);
            lableCenter.text = @"";
            lableThree.text = @"确定";
            titleImage.image = [UIImage imageNamed:@"ios_icon_apply_success"];
            
        }
            break;
        default:
            break;
    }
}

-(void)tap:(UITapGestureRecognizer *)sender
{
    [_applyDelegare applyDelegateCtlWithType:type_];
    [self hideApplyCtlView];
}

-(void)showApplyCtlViewType:(NSInteger)type
{
    type_ = type;
    switch (type) {
        case 1:
        {
            lableOne.text = @"";
            lableTwo.text = @"";
            lableCenter.text = @"登录即可参加offer派,轻松拿offer。";
            lableThree.text = @"好";
            titleImage.image = [UIImage imageNamed:@"ios_icon_xinshui_login"];
        }
            break;
        case 2:
        {
            lableOne.text = @"您的信息已提交成功，我们将24小";
            lableTwo.text = @"时内联系您！您可以先完善简历";
            lableOne.textColor = UIColorFromRGB(0x666666);
            lableTwo.textColor = UIColorFromRGB(0x666666);
            lableCenter.text = @"";
            lableThree.text = @"前往我的简历";
            titleImage.image = [UIImage imageNamed:@"ios_icon_apply_success"];
        }
            break;
        case 3:
        {
            lableOne.text = @"您的信息已提交成功，我们将";
            lableTwo.text = @"24小时内联系您！";
            lableOne.textColor = UIColorFromRGB(0x666666);
            lableTwo.textColor = UIColorFromRGB(0x666666);
            lableCenter.text = @"";
            lableThree.text = @"确定";
            titleImage.image = [UIImage imageNamed:@"ios_icon_apply_success"];
            
        }
            break;
        default:
            break;
    }
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self.view];
}
-(void)hideApplyCtlView
{
    [self.view removeFromSuperview];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
     [self hideApplyCtlView];
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

//
//  ELInterviewFeedBackView.m
//  jobClient
//
//  Created by YL1001 on 16/8/8.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELInterviewFeedBackView.h"
#import "Manager.h"
#import "MLLinkLabel.h"
#import "ELInterviewRefundCtl.h"
#import "ELAspectantDiscuss_Modal.h"

@interface ELInterviewFeedBackView ()<MLLinkLabelDelegate>
{
    ELAspectantDiscuss_Modal *_interviewModal;
}
@end

@implementation ELInterviewFeedBackView

- (instancetype)initWithFrame:(CGRect)frame Modal:(ELAspectantDiscuss_Modal *)modal
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _interviewModal = modal;
        [self configUI];
    }
    
    return self;
}

- (void)configUI
{
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, ScreenWidth - 16, 21)];
    titleLb.text = @"反馈";
    titleLb.textColor = UIColorFromRGB(0x666666);
    titleLb.font = [UIFont systemFontOfSize:14.0f];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLb];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 32, ScreenWidth - 45, 20)];
    label.text = @"已支付成功，可点击右侧私信按钮与行家私信沟通";
    label.textColor = UIColorFromRGB(0x666666);
    label.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:label];
    
    MLLinkLabel *linkLb = [[MLLinkLabel alloc] initWithFrame:CGRectMake(22, 53, ScreenWidth - 45, 20)];
    linkLb.numberOfLines = 0;
    linkLb.lineHeightMultiple = 0.0f;
    linkLb.lineSpacing = 3.0f;
    linkLb.dataDetectorTypes = MLDataDetectorTypeAttributedLink;
    linkLb.allowLineBreakInsideLinks = YES;
    linkLb.delegate = self;
    linkLb.textColor = UIColorFromRGB(0x666666);
    linkLb.font = [UIFont systemFontOfSize:12.0f];
    
    NSString *str = @"若约谈没有顺利完成，且约谈双方已自行沟通，您可[申请退款]";
    NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    if (_interviewModal.refund_id == nil && [_interviewModal.YTZ_id isEqualToString:[Manager getUserInfo].userId_])
    {
        [mutableStr setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xE4403A), NSLinkAttributeName : @"refund"} range:NSMakeRange(str.length - 6, 6)];
    }
    
    linkLb.attributedText = mutableStr;
    [linkLb sizeToFit];
    [linkLb invalidateDisplayForLinks];
    [self addSubview:linkLb];
}

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] && object != nil) {
        object = [object nextResponder];
    }
    UIViewController *superController = (UIViewController*)object;
    
    ELInterviewRefundCtl *refundCtl = [[ELInterviewRefundCtl alloc] init];
    [refundCtl beginLoad:_interviewModal exParam:nil];
    
    [superController.navigationController pushViewController:refundCtl animated:YES];
}

@end

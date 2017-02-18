//
//  ELActivitySuccessAlertView.m
//  jobClient
//
//  Created by 一览iOS on 16/5/17.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELActivitySuccessAlertView.h"
#import "NoLoginPromptCtl.h"
#import "TheContactListCtl.h"

@interface ELActivitySuccessAlertView() <ELShareManagerDelegate,NoLoginDelegate>
{
    __weak IBOutlet UIButton *deleteBtn;
    __weak IBOutlet UIButton *interviewBtn;
    __weak IBOutlet UIImageView *titleImage;
    __weak IBOutlet UILabel *titleLable;
    Article_DataModal *dataModal;
    BOOL isJoinStatus;
    
    __weak IBOutlet UILabel *lableTwo;
    __weak IBOutlet UILabel *lableOne;
    
    __weak IBOutlet NSLayoutConstraint *backViewHeight;
    
}

@end

@implementation ELActivitySuccessAlertView

+(ELActivitySuccessAlertView *)activitySuccessView
{
    static ELActivitySuccessAlertView *manager = nil;
    static  dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!manager) {
            manager = [[[NSBundle mainBundle] loadNibNamed:@"ELActivitySuccessAlertView" owner:self options:nil] lastObject];
        }
    });
    return manager;
}

- (IBAction)buttonRespone:(UIButton *)sender
{
    if(sender == deleteBtn){
        [self hideView];
    }
    else if(sender == interviewBtn)
    {
        [self hideView];
        NSString *imagePath = dataModal.thum_;
        NSString * sharecontent = @"";
        if (isJoinStatus) {
            @try {
                sharecontent = dataModal._activity_info.intro;
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }
        if (sharecontent.length <= 0) {
            sharecontent = dataModal.summary_;
        }
        
        NSString * titlecontent = [NSString stringWithFormat:@"【一览】%@ 邀请你参加:%@",[Manager getUserInfo].name_,dataModal.title_];
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
        sharecontent = [sharecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        titlecontent = [titlecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/article/%@.htm",dataModal.id_];
        [[ShareManger sharedManager] shareWithCtl:[self viewController].navigationController title:titlecontent content:sharecontent image:image url:url shareType:ShareTypeThree];
        [[ShareManger sharedManager] setShareDelegare:self];
    }
}
-(void)shareYLFriendBtn
{
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        return;
    }
    TheContactListCtl *contact = [[TheContactListCtl alloc] init];
    contact.isPersonChat = YES;
    contact.isPushShareCtl = YES;
    ShareMessageModal *modal = [[ShareMessageModal alloc] init];
    modal.shareType = @"11";
    modal.shareContent = @"社群文章";
    [modal setDataWithModal:dataModal];
    contact.shareDataModal = modal;
    [[Manager shareMgr] pushWithCtl:contact];
    [contact beginLoad:nil exParam:nil];
}

- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

-(void)copyChaining
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/article/%@.htm",dataModal.id_];
    pasteboard.string = url;
    if(url.length > 0)
    {
        [BaseUIViewController showAutoDismissSucessView:nil msg:@"复制链接成功" seconds:1.0];
    }
}

-(void)loginDelegateCtl{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)hideView{
    [self removeFromSuperview];
}

-(void)showView{
    self.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    //3秒钟之后自动消失
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self hideView];
    });
}

-(void)showWithPublishSuccessArticleModal:(Article_DataModal *)modal{
    if (!modal) {
        return;
    }
    isJoinStatus = NO;
    dataModal = modal;
    titleImage.image = [UIImage imageNamed:@"activity_success_publish_image"];
    titleLable.text = @"活动发布成功";
    lableOne.text = @"赶快邀请和分享给小伙伴吧";
    lableTwo.hidden = YES;
    backViewHeight.constant = 304;
    [self showView];
}

-(void)showWithJoinSuccessArticleModal:(Article_DataModal *)modal{
    if (!modal) {
        return;
    }
    isJoinStatus = YES;
    dataModal = modal;
    titleImage.image = [UIImage imageNamed:@"activity_success_joinimage"];
    titleLable.text = @"报名成功";
    lableOne.text = @"赶快邀请和分享给小伙伴吧";
    lableTwo.hidden = YES;
    backViewHeight.constant = 304;
    [self showView];
}

-(void)showWithGroupJoinSuccessArticleModal:(Article_DataModal *)modal{
    if (!modal) {
        return;
    }
    isJoinStatus = YES;
    dataModal = modal;
    titleImage.image = [UIImage imageNamed:@"activity_success_joinimage"];
    titleLable.text = @"申请已发送";
    lableOne.text = @"等待社长审核中";
    lableTwo.text = @"邀请你的小伙伴们一起加入吧！";
    lableTwo.hidden = NO;
    backViewHeight.constant = 330;
    [self showView];
}

@end

//
//  ELArticlePublishBtnCtl.m
//  jobClient
//
//  Created by 王新建 on 16/5/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELArticlePublishBtnCtl.h"
#import "ELJoinActivityCtl.h"
#import "ELActivityPeopleListCtl.h"

@interface ELArticlePublishBtnCtl () <PublishActivityDelegate>
{
    __weak IBOutlet UIButton *activityRightBtn;
    __weak IBOutlet UIButton *activityLeftBtn;
    
    ELJoinActivityCtl *publishActivityCtl;
    __weak ArticleDetailCtl *_delegateCtl;
    
    ELArticleDetailModel *myDataModal_;
}
@end

@implementation ELArticlePublishBtnCtl

-(instancetype)initWithArticleCtl:(ArticleDetailCtl *)articleCtl
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ELArticlePublishBtnCtl" owner:self options:nil] lastObject];
    if (self)
    {
        _delegateCtl = articleCtl;
        activityLeftBtn.clipsToBounds = YES;
        activityLeftBtn.layer.cornerRadius = 4.0;
        activityRightBtn.clipsToBounds = YES;
        activityRightBtn.layer.cornerRadius = 4.0;
    }
    return self;
}

-(void)setMyDataModal_:(ELArticleDetailModel *)myDataModal
{
    myDataModal_ = myDataModal;
    
    NSDictionary *dic = myDataModal_.dicJoinName;
    NSString *status = dic[@"status"];
    NSString *code = dic[@"code"];
    if ([status isEqualToString:@"OK"] && [Manager shareMgr].haveLogin)
    {
        _showViewCtl = YES;
        CGFloat btnWidth = (ScreenWidth - 114)/2;
        
        activityLeftBtn.userInteractionEnabled = NO;
        activityLeftBtn.backgroundColor = [UIColor lightGrayColor];
        activityLeftBtn.frame = CGRectMake(49,7,btnWidth,26);
        activityRightBtn.frame = CGRectMake(CGRectGetMaxX(activityLeftBtn.frame)+16,7,btnWidth,26);
        activityRightBtn.hidden = NO;
        
        if ([code integerValue] == 201)
        {
            activityRightBtn.userInteractionEnabled = NO;
            activityRightBtn.backgroundColor = [UIColor lightGrayColor];
            [activityRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [activityRightBtn setTitle:@"已报名" forState:UIControlStateNormal];
        }
        else if([code integerValue] == 300)
        {
            activityLeftBtn.userInteractionEnabled = YES;
            activityLeftBtn.backgroundColor = PINGLUNHONG;
            activityLeftBtn.frame = CGRectMake((ScreenWidth - btnWidth)/2,7,btnWidth,26);
            activityRightBtn.hidden = YES;
        }
        else if ([code integerValue] == 301)
        {
            if ([myDataModal_.person_detail.person_id isEqualToString:[Manager getUserInfo].userId_])
            {
                activityLeftBtn.userInteractionEnabled = YES;
                activityLeftBtn.backgroundColor = PINGLUNHONG;
                activityLeftBtn.frame = CGRectMake((ScreenWidth - btnWidth)/2,7,btnWidth,26);
                activityRightBtn.hidden = YES;
            }
        }
        else
        {
            activityRightBtn.userInteractionEnabled = YES;
            activityRightBtn.backgroundColor = PINGLUNHONG;
            [activityRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [activityRightBtn setTitle:@"报名参加" forState:UIControlStateNormal];
        }
        [activityLeftBtn setTitle:[NSString stringWithFormat:@"已有%@人报名",dic[@"info"][@"info"][@"cnt"]] forState:UIControlStateNormal];
        _showViewCtl = YES;
    }
    else
    {
        _showViewCtl = NO;
    }
}

- (IBAction)publishButtonRespone:(id)sender
{
    if (sender == activityLeftBtn)
    {
        ELActivityPeopleListCtl *ctl = [[ELActivityPeopleListCtl alloc] init];
        [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
        ctl.joinPeopleCount = [myDataModal_._activity_info.cnt integerValue];
        //NSArray *arr = [myDataModal_.dicJoinName[@"info"][@"info"][@"need_info"] componentsSeparatedByString:@","];
        //ctl.arrListData =[[NSMutableArray alloc] initWithArray:arr];
        [ctl beginLoad:myDataModal_ exParam:nil];
    }
    else if (sender == activityRightBtn)
    {
        if (!publishActivityCtl) {
            publishActivityCtl = [[ELJoinActivityCtl alloc] init];
        }
        publishActivityCtl.arrList = myDataModal_.dicJoinName[@"bitian"];
        publishActivityCtl.myDataModal_ = myDataModal_;
        publishActivityCtl.joinDelagete = self;
        [publishActivityCtl showCtlView];
        [_delegateCtl removeKeyBoardNotification];
    }
}

-(void)keyBoardNotification
{
   [_delegateCtl addKeyBoardNotification];
}
-(void)publishSuccessRefresh
{
    activityRightBtn.userInteractionEnabled = NO;
    activityRightBtn.backgroundColor = [UIColor lightGrayColor];
    [activityRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [activityRightBtn setTitle:@"已报名" forState:UIControlStateNormal];
    NSInteger count = [myDataModal_._activity_info.cnt integerValue];
    [activityLeftBtn setTitle:[NSString stringWithFormat:@"已有%ld人报名",(long)(count + 1)] forState:UIControlStateNormal];
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

//
//  TabView.m
//  MBA
//
//  Created by sysweal on 13-12-7.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "TabView.h"
#import "MyConfig.h"

@implementation TabView 

@synthesize type_,delegate_,fifthBtn_,fifthImg_,fifthLb_,firstBtn_,firstImg_,firstLb_,fourthBtn_,fourthImg_,fourthLb_,secondBtn_,secondImg_,secondLb_,thirdBtn_,thirdImg_,thirdLb_;

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"TabView" owner:self options:nil].firstObject;
        [firstImg_ setImage:[UIImage imageNamed:@"ios_icon_yilan_click.png"]];
        firstLb_.textColor = [UIColor colorWithRed:227.0/255 green:15.0/255 blue:25.0/255 alpha:1.0];
        [self addGesture];
    }
    return self;
}

//刷新tabbar小红点
-(void)setTabBarNewMessage
{
    _lbGroupModular.layer.cornerRadius = 10.0 ;
    _lbGroupModular.layer.masksToBounds = YES;
    _lbGroupModular.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"info_02"]];
    _lbMessageModular.layer.cornerRadius = 10.0 ;
    _lbMessageModular.layer.masksToBounds = YES;
    _lbMessageModular.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"info_02"]];
    _lbMineModular.layer.cornerRadius = 10.0 ;
    _lbMineModular.layer.masksToBounds = YES;
    _lbMineModular.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"info_02"]];
    _sameTradeMessageLb.layer.cornerRadius = 10.0;
    _sameTradeMessageLb.layer.masksToBounds = YES;

    _sameTradeMessageLb.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"info_02"]];
    //社群
//    if ([Manager  shareMgr].haveLogin && [Manager shareMgr].messageCountDataModal.toolBarGroupCnt >0) {
//        [_lbGroupModular setHidden:NO];
//        NSString *num =[NSString stringWithFormat:@"%ld",(long)[Manager shareMgr].messageCountDataModal.toolBarGroupCnt];
//        [_lbGroupModular setText:num];
//    }else{
//        [_lbGroupModular setHidden:YES];
//    }

    [_lbGroupModular setHidden:YES];
    //消息
    if ([Manager  shareMgr].haveLogin && [Manager shareMgr].messageCountDataModal.messageCnt > 0) {
        [_lbMessageModular setHidden:NO];
        [_lbMessageModular setText:[NSString stringWithFormat:@"%ld",(long)[Manager shareMgr].messageCountDataModal.messageCnt]];
        if ([Manager shareMgr].messageCountDataModal.messageCnt > 99) {
            [_lbMessageModular setText:@"···"];
        }
    }else{
        [_lbMessageModular setHidden:YES];
    }
    //我的管理中心
    if ([Manager  shareMgr].haveLogin) {
        NSInteger num = [Manager shareMgr].messageCountDataModal.resumeCnt + [Manager shareMgr].messageCountDataModal.companyCnt + [Manager shareMgr].messageCountDataModal.questionCnt + [Manager shareMgr].messageCountDataModal.myInterViewCnt;
        if (num > 0) {
            [_lbMineModular setHidden:NO];
            [_lbMineModular setText:[NSString stringWithFormat:@"%ld",(long)num]];
            if (num > 99) {
                [_lbMineModular setText:@"···"];
            }
        }else{
            [_lbMineModular setHidden:YES];
        }
    }else{
        [_lbMineModular setHidden:YES];
    }

    if ([Manager  shareMgr].haveLogin && [Manager shareMgr].messageCountDataModal.sameTradeMessageCnt > 0)
    {
        [_sameTradeMessageLb setHidden:NO];
        
        if ([Manager shareMgr].messageCountDataModal.friendMessageCnt > 0)
        {
            [_sameTradeMessageLb setText:[NSString stringWithFormat:@"%ld",(long)[Manager shareMgr].messageCountDataModal.friendMessageCnt]];
            if ([Manager shareMgr].messageCountDataModal.friendMessageCnt > 99) {
                [_sameTradeMessageLb setText:@"···"];
            }
        }
        else
        {
            [_sameTradeMessageLb setText:@" "];
        }
    }
    else
    {
        [_sameTradeMessageLb setHidden:YES];
    }
    [[Manager shareMgr].todayFocusListCtl reloadFriendMessageCount];
}

//改变模块
-(void) changeModel:(TabType)type
{
    type_ = type;
    NSArray *imageArr = @[];
    NSArray *selectedImgArr = @[];
    NSArray *btnImgArr = @[firstImg_,secondImg_,thirdImg_,fourthImg_,fifthImg_];
    NSArray *tltleLbArr = @[firstLb_,secondLb_,thirdLb_,fourthLb_,fifthLb_];
    for (int i = 0; i < 5; i++) {
        UIImageView *img = btnImgArr[i];
        UILabel *lb = tltleLbArr[i];
        if (i == type) {
            img.image = [UIImage imageNamed:selectedImgArr[i]];
            lb.textColor = [UIColor colorWithRed:227.0/255 green:15.0/255 blue:25.0/255 alpha:1.0];
        }
        else{
            img.image = [UIImage imageNamed:imageArr[i]];
            lb.textColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0];
        }
    }
}

-(IBAction) btnClick:(id)sender
{
    selectBtn = (UIButton *)sender;
    NSString *str = @"";
    if( sender == firstBtn_ ){
        type_ = Tab_First;
        str = firstLb_.text;
    }else if( sender == secondBtn_ ){
        type_ = Tab_Second;
        str = secondLb_.text;
    }
    else if( sender == thirdBtn_ ){
        type_ = Tab_Third;
        str = thirdLb_.text;
    }
    else if( sender == fourthBtn_ ){
        type_ = Tab_Fourth;
        str = fourthLb_.text;
    }
    else if (sender == fifthBtn_) {
        type_ = Tab_Fifth;
        str = fifthLb_.text;
    }
    
    NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",str,NSStringFromClass([self class])]};
    [MobClick event:@"buttonClick" attributes:dict];
    
    //告诉代理
    [delegate_ tabViewModalChanged:self type:type_];

}

- (void)addGesture
{
    UITapGestureRecognizer *todayGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewToTop)];
    todayGesture.numberOfTapsRequired = 2;
    [firstBtn_ addGestureRecognizer:todayGesture];
    
    UITapGestureRecognizer *myGroupGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myGroupScrollViewToTop)];
    myGroupGesture.numberOfTapsRequired = 2;
    [secondBtn_ addGestureRecognizer:myGroupGesture];
    
    UITapGestureRecognizer *jobFindGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findJobScrollViewToTop)];
    jobFindGesture.numberOfTapsRequired = 2;
    [thirdBtn_ addGestureRecognizer:jobFindGesture];
}


#pragma mark - tabview double click
- (void)scrollViewToTop
{
    if (selectBtn != firstBtn_) {
        [self btnClick:firstBtn_];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"statusBarTouchedAction" object:nil];
}

- (void)findJobScrollViewToTop
{
    if (selectBtn != thirdBtn_) {
        [self btnClick:thirdBtn_];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"statusBarTouchedAction" object:nil];
}

- (void)myGroupScrollViewToTop
{
    if (selectBtn != secondBtn_) {
        [self btnClick:secondBtn_];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"statusBarTouchedAction" object:nil];    
}

@end

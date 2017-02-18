//
//  OfferPartyDetailIndexCtlViewController.h
//  jobClient
//
//  Created by 一览ios on 15/8/3.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "MyOfferPartyDetailCtl.h"
#import "OfferPartyTalentsModel.h"
@class YLOfferApplyUrlCtl;

@interface OfferPartyDetailIndexCtl : BaseUIViewController<UIScrollViewDelegate>
{
    IBOutlet UIView *segmentView;
}

@property (retain, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic)MyOfferPartyDetailCtl *recommendDetail;
@property (nonatomic, strong) YLOfferApplyUrlCtl *offerApllyUrlCtl;

@property (weak, nonatomic) IBOutlet UIButton *allBtn;//
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;//已推荐的公司
@property (strong, nonatomic) OfferPartyTalentsModel *offerPartyModel;

@property (nonatomic, assign) BOOL isSignUp; /**<是否已报名 */
@property (nonatomic, assign) BOOL resumeComplete; /**<简历是否完善 */

@property (nonatomic, assign) BOOL isFromNotice;//来自推送通知

@property (nonatomic,assign) BOOL isFromZbar;//来自扫描签到跳转

@property (nonatomic,assign) BOOL isPop;

@end

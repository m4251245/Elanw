//
//  ConsultantCenterCtl.h
//  jobClient
//
//  Created by 一览ios on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "OfferPartyTalentsModel.h"
#import "CHROfferPartyDetailCtl.h"

@interface ConsultantCenterCtl : BaseListCtl
{
    
    __weak IBOutlet UIImageView *photoImagev;
    __weak IBOutlet UILabel *titleLb;
    __weak IBOutlet UILabel *resumeCount;
    __weak IBOutlet UILabel *contactCountLb;
}

//接收推送时用到
- (void)jumpCHROfferPartyDetailCtl;
@property (nonatomic, strong) OfferPartyTalentsModel *offerPartyModel;
@property (nonatomic, assign) BOOL isFromMessage;

@property(nonatomic,assign)BOOL islogin;

@end

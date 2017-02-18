//
//
//  jobClient
//
//  Created by 一览iOS on 15-2-27.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

@interface MyOfferPartyIndexCtl : BaseListCtl
{
    __weak IBOutlet UIButton *rightBtn;
}

@property (strong, nonatomic) RequestCon *signInCon;
@property (nonatomic, copy) NSString *offerPartyId;
@property (nonatomic, assign) BOOL isFromHome;  //yes来自首页   NO来自我的简历

//#pragma mark 刷新
//- (void)refresh:(RequestCon *)con;

@end

//
//  InviteGroupList.h
//  jobClient
//
//  Created by 一览ios on 14-12-31.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "PersonCenterDataModel.h"

@interface InviteGroupList : BaseListCtl
{
    PersonCenterDataModel           *_personCenterModel;
    NSInteger                                        _indexValue;
    RequestCon                           *inviteCon_;
}

- (void)inveteBtnClick:(UIButton *)button;
@end

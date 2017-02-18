//
//  JionGroupReasonCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-12-10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "Groups_DataModal.h"
#import "ExRequetCon.h"

@protocol  JionGroupReasonCtlDelegate <NSObject>

@optional
- (void)joinGroupSuccess;

@end

@interface JionGroupReasonCtl : BaseEditInfoCtl
{
    IBOutlet UITextView     *reasonTextView_;
    RequestCon              *joinCon_;
    IBOutlet    UILabel                 *tipsLb_;
}

@property (nonatomic,assign) id<JionGroupReasonCtlDelegate> delegate;

@end

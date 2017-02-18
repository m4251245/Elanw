//
//  UpdateGroupIntroCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-10-16.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "ELGroupDetailModal.h"
#import "ExRequetCon.h"

@protocol UpdateGroupIntroCtlDelegate <NSObject>

- (void)updateGroupIntroSuccess;

@end

@interface UpdateGroupIntroCtl : BaseEditInfoCtl
{
    IBOutlet    UIView      *gourpIntroView_;
    IBOutlet    UILabel     *gourpIntroLb_;
    IBOutlet    UITextField *groupIntroTfview_;
    
    IBOutlet UITextView *groupIntroView;
    
    __weak IBOutlet UILabel *tipsLb;
    
    ELGroupDetailModal        *inModel_;
    RequestCon          *updateCon_;
}

@property(nonatomic,weak) id <UpdateGroupIntroCtlDelegate> delegate_;

@end

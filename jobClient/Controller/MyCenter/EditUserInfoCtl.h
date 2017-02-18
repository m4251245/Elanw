//
//  EditUserInfoCtl.h
//  Association
//
//  Created by 一览iOS on 14-1-20.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "ExRequetCon.h"
#import "UserHYListCtl.h"
#import "TransparencyView.h"

@class EditUserInfoCtl;
@protocol EditOkDelegate <NSObject>

-(void)editUserInfoOk:(EditUserInfoCtl*) ctl ;

@end

@interface EditUserInfoCtl : BaseEditInfoCtl<UIActionSheetDelegate,ChooseHYDelegate,TransparencyViewDelegate>
{
    
    RequestCon  * editCon_;
    NSString    * hkaId_;
    UserHYListCtl   *  userHyListCtl_;
    TransparencyView *transparency_;
}

@property(nonatomic,weak) IBOutlet UITextField * nameTF_;
@property(nonatomic,weak) IBOutlet UITextField * nicknameTF_;
@property(nonatomic,weak) IBOutlet UITextField * sexTF_;
@property(nonatomic,weak) IBOutlet UITextField * jobTF_;
@property(nonatomic,weak) IBOutlet UITextField * tradeTF_;
@property(nonatomic,weak) IBOutlet UITextField * signatureTF_;
@property(nonatomic,weak) IBOutlet UITextField * companyTF_;
@property(nonatomic,weak) IBOutlet UIButton    *regionBtn_;
@property(nonatomic,weak) IBOutlet UILabel     *regionLb_;
@property(nonatomic,weak) IBOutlet UIButton    *hyBtn_;

@property(nonatomic,assign) id<EditOkDelegate> delegate_;


@end

//
//  EditorBasePersonInfoCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-11-3.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "PersonCenterDataModel.h"
#import "EditorPersonInfo.h"

@protocol EditorBasePersonInfoCtlDelegate <NSObject>

- (void)edtorBaseSuccess;

@end
@interface EditorBasePersonInfoCtl : BaseEditInfoCtl<EditorPersonInfoDelegate>
{
    IBOutlet    UIView          *bgView_;
    PersonCenterDataModel   *inModelOne;
    IBOutlet   UILabel      *ageLb_;
    IBOutlet   UILabel      *addrLb_;
    IBOutlet   UILabel      *workAgeLb_;
    IBOutlet   UILabel      *zyeLb_;
    IBOutlet   UILabel      *jobLb_;
    IBOutlet   UILabel      *genderLb_;
    IBOutlet   UIButton     *ageBtn_;
    IBOutlet   UIButton     *genderBtn_;
    IBOutlet   UIButton     *gznumBtn_;
    IBOutlet   UIButton     *workAddrBtn_;
    IBOutlet   UIButton     *jobBtn_;;
    IBOutlet   UIButton     *zwBtn_;
    IBOutlet   UILabel      *tradeLb_;
    IBOutlet   UIButton     *tradeBtn_;
    IBOutlet   UIButton     *nameBtn_;
    IBOutlet   UILabel      *nameLb_;
    IBOutlet   UIView       *introView_;
    IBOutlet   UILabel      *introLb_;
    IBOutlet   UIImageView  *rightImagev_;
    IBOutlet   UIButton     *introBtn_;
    
    IBOutlet   UIView       *expertIntroView_;
    IBOutlet   UILabel      *expertIntroLb_;
    IBOutlet   UIImageView  *expertRightImagev_;
    IBOutlet   UIButton     *expertIntroBtn_;
}

@property(nonatomic,assign) id<EditorBasePersonInfoCtlDelegate> delegate;

@end

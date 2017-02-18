//
//  UpdateGroupPhotoCtl.h
//  jobClient
//
//  Created by 一览ios on 14-12-12.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ExRequetCon.h"
#import "Groups_DataModal.h"
#import "CreateGroupStep2Ctl.h"
#import "CreateGroupDataModel.h"
#import "CreateGroupStep3Ctl.h"

@protocol UpdateGroupPhotoCtlDelegate <NSObject>

@optional
- (void)updateGroupPhotoSuccess:(NSString *)groupImg;

@end

typedef enum {
    CREATEGROUP = 0,
    UPDATEGROUPPHOTO = 1,
}INTYPE;

@interface UpdateGroupPhotoCtl : BaseUIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    IBOutlet UIImageView    *photoImgv_;
    IBOutlet UILabel        *tipsLb_;
    
    __weak IBOutlet UILabel *tipsDetailLb;
    
    __weak IBOutlet NSLayoutConstraint *lableTopHeight;
    
    __weak IBOutlet NSLayoutConstraint *imageTopHeight;
    
    __weak IBOutlet NSLayoutConstraint *imageWidh;
    
    __weak IBOutlet NSLayoutConstraint *imageHeight;
    
    RequestCon     *updateImgCon_;
    RequestCon              *uploadMyImgCon_;
    Groups_DataModal    *inModel_;
    NSString       *groupImgUrl_;
    UIImage        *groupImg_;
    CreateGroupStep2Ctl  *step2Ctl_;
    RequestCon      *createCon_;
    CreateGroupStep3Ctl   *step3Ctl_;
    NSString                        *groupPhotoUrl;
}

@property(nonatomic,assign) id<UpdateGroupPhotoCtlDelegate> delegate;
@property(nonatomic,assign) INTYPE inType;
@property(nonatomic,assign) int enterType_;
@property(nonatomic,strong) CreateGroupDataModel *groupMoal_;
@end

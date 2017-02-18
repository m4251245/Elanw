//
//  ShareSalaryArticleCtl.h
//  Association
//
//  Created by YL1001 on 14-7-2.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "ExRequetCon.h"
#import "MessagePhotoView.h"
#

@class ShareSalaryArticleCtl;
@protocol ShareSalaryArticleCtlDelegate <NSObject>

-(void)ShareSalaryOK:(ShareSalaryArticleCtl*)ctl;

@end

@interface ShareSalaryArticleCtl : BaseEditInfoCtl<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MessagePhotoViewDelegate>
{
    
    RequestCon                          * submitCon_;
    RequestCon                          * updateNickNameCon_;
    RequestCon                          * uploadMyImgCon_;
    BOOL                                bNickName_;
    NSString                            * nickNameStr_;

    IBOutlet    UIView                  * addimgView_;
    IBOutlet    UIButton                * chooseImgBtn_;
    
    
    IBOutlet UIButton *submitBtn;
    
}

@property(nonatomic,assign) id<ShareSalaryArticleCtlDelegate> deletate_;
@property (nonatomic,strong) MessagePhotoView *photoView;
@property (weak, nonatomic) IBOutlet UIButton *facebtn;
@property (weak,nonatomic) IBOutlet UITextView *contentTV_;

@property (weak, nonatomic) IBOutlet UILabel *tipsLb_;
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;

@property (nonatomic,assign) BOOL fromTodayList;

@end

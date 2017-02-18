//
//  UPdateGroupTagsCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-10-15.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "ELGroupDetailModal.h"
#import "ExRequetCon.h"
#import "CustomButton.h"


@protocol UPdateGroupTagsCtlDelegate <NSObject>

- (void)updateTagsSuccess;

typedef void (^DoneActionBlock)(id);

@end

@interface UPdateGroupTagsCtl : BaseEditInfoCtl
{
//    IBOutlet    UIView      *gourpTagView_;
    IBOutlet    UITextField *groupTagTfview_;
    IBOutlet    UIView      *TFbackView;
    IBOutlet    UIButton    *addBtn;
    
    CustomButton *_tagBtn;
    NSInteger lineNum;
    
    ELGroupDetailModal        *inModel_;
    RequestCon              *updateCon_;
    
    NSString            *groupTags_;
    
    UILabel *_alertlab;  //标签字数提示
}

@property(nonatomic,assign) id <UPdateGroupTagsCtlDelegate> delegate_;

@property (nonatomic, strong) NSMutableArray *tagViews;
@property (nonatomic, strong) NSMutableArray *tagsMade;
@property (nonatomic, assign) BOOL focusOnAddTag;
@property (nonatomic, assign) CGFloat tagGap;

@end

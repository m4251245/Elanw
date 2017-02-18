//
//  Skill_ResumeCtl.h
//  jobClient
//
//  Created by job1001 job1001 on 12-2-9.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//


/*********************************
 
 简历--->工作技能
 *********************************/

#import <UIKit/UIKit.h>
#import "BaseResumeCtl.h"


#define Skill_ResumeCtl_Xib_Name            @"Skill_ResumeCtl"
#define Skill_ResumeCtl_Title               @"技能特长"

typedef void(^skillBlock)();

@interface Skill_ResumeCtl : BaseResumeCtl<UITextViewDelegate>
{
    IBOutlet    UITextView                  *desTv_;    //工作技能描述textView
    IBOutlet    UILabel                    *titleLb_;
    IBOutlet    UIButton                     *titleBtn_;
    NSString                                *des_;      //描述
    __weak IBOutlet UILabel *grayWordLb;
    __weak IBOutlet UILabel *_wordsNumLb;
}

//检查是否能保存
-(BOOL) checkCanSave;
@property(nonatomic,copy) skillBlock block;

@end

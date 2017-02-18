//
//  IntroduceMyselfCtl.h
//  jobClient
//
//  Created by 一览ios on 16/1/16.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseResumeCtl.h"

typedef void(^backBlock)(PersonDetailInfo_DataModal *model);

@interface IntroduceMyselfCtl : BaseResumeCtl
{

    __weak IBOutlet UITextView *desTv_;
    
    __weak IBOutlet UILabel *grayWordLb;
    
    NSString *des_;      //描述
    
}

@property(nonatomic,copy) backBlock  backBlock;


@end

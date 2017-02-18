//
//  ChosseInterviewModelCtl.h
//  jobClient
//
//  Created by YL1001 on 14-9-13.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "InterviewModel_DataModal.h"
#import "ExRequetCon.h"
#import "ZWDetail_DataModal.h"

typedef enum
{
    ChooseInterview,
    ChooseZWForInterview,
    ChooseZWForScreen,
}ChooseModelType;

@protocol ChooseInterviewModelDelegate <NSObject>

@optional
-(void)chooseInterviewModel:(InterviewModel_DataModal*)dataModal;
-(void)chooseZw:(ZWDetail_DataModal*)dataModal;

@end

@interface ChosseInterviewModelCtl : BaseListCtl

@property(nonatomic,assign) id<ChooseInterviewModelDelegate> delegate_;
@property(nonatomic,assign) ChooseModelType     type_;

@end

//
//  SendInterviewCtl.h
//  jobClient
//
//  Created by YL1001 on 14-9-12.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "ExRequetCon.h"
#import "ChosseInterviewModelCtl.h"

typedef enum
{
    InterView_None,
    Interview_SMS,
    Interview_Emial,
    Interview_SMS_Emial
}InterViewType;

typedef NS_ENUM(NSInteger, OperationType) {
    OperationTypeInterview,          //面试邀请
    OperationTypeSendOffer,          //发offer
    OperationTypeOPSendOffer,        //offer派发offer
};


@interface SendInterviewCtl : BaseEditInfoCtl<ChooseInterviewModelDelegate>
{
    IBOutlet    UIButton    *   messageBtn_;
    IBOutlet    UIButton    *   mailBtn_;
    IBOutlet    UIButton    *   modelBtn_;
    IBOutlet    UITextField *   cnameTF_;
    IBOutlet    UITextField *   personNameTF_;
    IBOutlet    UITextField *   phoneTF_;
    IBOutlet    UIButton    *   zwBtn_;
    IBOutlet    UIButton    *   dateBtn_;
    IBOutlet    UITextField *   addressTF_;
    
    IBOutlet    UIView      *   bottomView_;
    IBOutlet    UIDatePicker*   datePicker_;
    IBOutlet    UIButton    *   chooseTimeBtn_;
    
    User_DataModal          * inDataModal_;
    
    RequestCon              * sendCon_;
}

@property (nonatomic, assign) InterViewType  type_;
@property (nonatomic, assign) OperationType   operationType;
@property (nonatomic, copy) NSString *companyId;
@property (weak, nonatomic) UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIButton *emailAndSmsBtn;
@property (weak, nonatomic) IBOutlet UIButton *previewBtn;

@end

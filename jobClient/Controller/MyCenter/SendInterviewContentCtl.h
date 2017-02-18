//
//  SendInterviewContentCtl.h
//  jobClient
//
//  Created by YL1001 on 15/7/20.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "InterviewModel_DataModal.h"
#import "SendInterviewCtl.h"

@class User_DataModal;
#define TEXT_MAXLENGTH 200

@interface SendInterviewContentCtl : BaseEditInfoCtl
{
     
}

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;/**< 输入框 */
@property (weak, nonatomic) IBOutlet UILabel *textNum;/**< 剩余字数 */
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;/**< 发送按钮 */
@property (strong, nonatomic) InterviewModel_DataModal *interviewModal;/**< 面试Modal */
@property (nonatomic, strong) User_DataModal *userModel;
@property (nonatomic, assign) OperationType   operationType;
@property (nonatomic, copy) NSString *companyId;

@end

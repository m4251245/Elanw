//
//  QuestionnaireCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-8-19.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "CustomButton.h"
#import "ExRequetCon.h"

@interface QuestionnaireCtl : BaseEditInfoCtl
{

    __weak IBOutlet UIView *itemView1_;
    __weak IBOutlet UIView *itemView2_;
    IBOutlet UIView     *itemView3_;
    IBOutlet UIView     *itemView4_;
    IBOutlet UIView     *itemView5_;
    IBOutlet UIView     *itemView6_;
    IBOutlet UIView     *itemView7_;
    IBOutlet UIView     *itemView8_;
    IBOutlet UIView     *itemView9_;
    IBOutlet UIView     *itemView10_;
    
    IBOutlet CustomButton   *button1_1;
    IBOutlet CustomButton   *button1_2;
    IBOutlet CustomButton   *button1_3;
    IBOutlet CustomButton   *button1_4;
    IBOutlet CustomButton   *button1_5;
    
    IBOutlet CustomButton   *button2_1;
    IBOutlet CustomButton   *button2_2;
    IBOutlet CustomButton   *button2_3;
    IBOutlet CustomButton   *button2_4;
    IBOutlet CustomButton   *button2_5;
    
    IBOutlet UITextView    *textView3_;
    
    IBOutlet CustomButton   *button4_1;
    IBOutlet CustomButton   *button4_2;
    IBOutlet CustomButton   *button4_3;
    IBOutlet CustomButton   *button4_4;
    
    IBOutlet CustomButton   *button5_1;
    IBOutlet CustomButton   *button5_2;
    IBOutlet CustomButton   *button5_3;
    
    IBOutlet CustomButton   *button6_1;
    IBOutlet CustomButton   *button6_2;
    IBOutlet CustomButton   *button6_3;
    
    IBOutlet CustomButton   *button7_1;
    IBOutlet CustomButton   *button7_2;
    
    IBOutlet CustomButton   *button8_1;
    IBOutlet CustomButton   *button8_2;

    IBOutlet UITextView    *textView9_;
    
    IBOutlet CustomButton   *button10_1;
    IBOutlet CustomButton   *button10_2;
    
    IBOutlet CustomButton   *button11_1;
    IBOutlet CustomButton   *button11_2;
    IBOutlet CustomButton   *button11_3;
    IBOutlet CustomButton   *button11_4;
    IBOutlet CustomButton   *button11_5;
    
    
    NSString *itemResutlString1_;
    NSString *itemResutlString2_;
    NSString *itemResutlString4_;
    NSString *itemResutlString5_;
    NSString *itemResutlString6_;
    NSString *itemResutlString7_;
    NSString *itemResutlString8_;
    NSString *itemResutlString10_;
    NSString *itemResutlString11_;
    CGRect textFieldRect3;
    CGRect textFieldRect9;
    IBOutlet    UIView    *commitView_;
    IBOutlet    UIButton  *commitBtn_;
    RequestCon      *commitCon_;
}
@end

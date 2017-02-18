//
//  QuestionnaireCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-8-19.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "QuestionnaireCtl.h"

@interface QuestionnaireCtl ()

@end

@implementation QuestionnaireCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)updateCom:(RequestCon *)con
{
    
    [super updateCom:con];
    [self updataFrame];
    CGRect rect10 = itemView10_.frame;
    [self.scrollView_ setContentSize:CGSizeMake(320, rect10.origin.y + rect10.size.height+2)];
    
}

-(void)updataFrame
{
    CGRect rect1 = itemView1_.frame;
    rect1.origin.x = 5;
    rect1.origin.y = 5;
    rect1.size.height = 95;
    rect1.size.width = self.view.frame.size.width-10;
    [itemView1_ setFrame:rect1];
    [self.scrollView_ addSubview:itemView1_];
    
    CGRect rect2 = itemView2_.frame;
    rect2.size.width = self.view.frame.size.width-10;
    [itemView2_ setFrame:rect2];

    CGRect rect3 = itemView3_.frame;
    rect3.size.width = self.view.frame.size.width-10;
    [itemView3_ setFrame:rect3];

    CGRect rect4 = itemView4_.frame;
    rect4.origin.y = rect3.origin.y + rect3.size.height + 2;
    rect4.origin.x = 5;
    rect4.size.width = self.view.frame.size.width-10;
    [itemView4_ setFrame:rect4];
    
    CGRect rect5 = itemView5_.frame;
    rect5.origin.y = rect4.origin.y + rect4.size.height + 2;
    rect5.origin.x = 5;
    rect5.size.width = self.view.frame.size.width-10;
    [itemView5_ setFrame:rect5];
    
    CGRect rect6 = itemView6_.frame;
    rect6.origin.y = rect5.origin.y + rect5.size.height + 2;
    rect6.origin.x = 5;
    rect6.size.width = self.view.frame.size.width-10;
    [itemView6_ setFrame:rect6];
    [self.scrollView_ addSubview:itemView6_];
    
    CGRect rect7 = itemView7_.frame;
    rect7.origin.y = rect6.origin.y + rect6.size.height + 2;
    rect7.origin.x = 5;
    rect7.size.width = self.view.frame.size.width-10;
    [itemView7_ setFrame:rect7];
    [self.scrollView_ addSubview:itemView7_];
    
    CGRect rect8 = itemView8_.frame;
    rect8.origin.y = rect7.origin.y + rect7.size.height + 2;
    rect8.origin.x = 5;
    rect8.size.width = self.view.frame.size.width-10;
    [itemView8_ setFrame:rect8];
    [self.scrollView_ addSubview:itemView8_];
    
    CGRect rect9 = itemView9_.frame;
    rect9.origin.y = rect8.origin.y + rect8.size.height + 2;
    rect9.origin.x = 5;
    rect9.size.width = self.view.frame.size.width-10;
    [itemView9_ setFrame:rect9];
    [self.scrollView_ addSubview:itemView9_];
    
    CGRect rect10 = itemView10_.frame;
    rect10.origin.y = rect9.origin.y + rect9.size.height + 2;
    rect10.origin.x = 5;
    rect10.size.width = self.view.frame.size.width-10;
    [itemView10_ setFrame:rect10];
    [self.scrollView_ addSubview:itemView10_];
    
//    [self.scrollView_ setContentSize:CGSizeMake(320, rect10.origin.y + rect10.size.height+2)];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_addQuestionnaire:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"]) {
                [BaseUIViewController showAutoDismissSucessView:@"提交成功" msg:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [BaseUIViewController showAutoDismissFailView:@"提交失败" msg:nil];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)btnResponse:(id)sender
{
    if (sender == commitBtn_) {
        [self commitMethod];
    }else
    if (sender == button1_1) {
        [self changButtonStatus1:button1_1];
    }else
    if (sender == button1_2) {
        [self changButtonStatus1:button1_2];
    }else
    if (sender == button1_3) {
        [self changButtonStatus1:button1_3];
    }else
    if (sender == button1_4) {
        [self changButtonStatus1:button1_4];
    }else
    if (sender == button1_5) {
        [self changButtonStatus1:button1_5];
    }else
    
    if (sender == button2_1) {
        [self changButtonStatus2:button2_1];
    }else
    if (sender == button2_2) {
        [self changButtonStatus2:button2_2];
    }else
    if (sender == button2_3) {
        [self changButtonStatus2:button2_3];
    }else
    if (sender == button2_4) {
        [self changButtonStatus2:button2_4];
    }else
    if (sender == button2_5) {
        [self changButtonStatus2:button2_5];
    }else
    
    if (sender == button4_1) {
        [self changButtonStatus4:button4_1];
    }else
    if (sender == button4_2) {
        [self changButtonStatus4:button4_2];
    }else
    if (sender == button4_3) {
        [self changButtonStatus4:button4_3];
    }else
    if (sender == button4_4) {
        [self changButtonStatus4:button4_4];
    }else
    
    
    if (sender == button5_1) {
        [self changButtonStatus5:button5_1];
    }else
    if (sender == button5_2) {
        [self changButtonStatus5:button5_2];
    }else
    if (sender == button5_3) {
        [self changButtonStatus5:button5_3];
    }else
    
    if (sender == button6_1) {
        [self changButtonStatus6:button6_1];
    }else
    if (sender == button6_2) {
        [self changButtonStatus6:button6_2];
    }else
    if (sender == button6_3) {
        [self changButtonStatus6:button6_3];
    }else

    
    if (sender == button7_1) {
        [self changButtonStatus7:button7_1];
    }else
    if (sender == button7_2) {
        [self changButtonStatus7:button7_2];
    }else
    
    if (sender == button8_1) {
        [self changButtonStatus8:button8_1];
    }else
    if (sender == button8_2) {
        [self changButtonStatus8:button8_2];
    }else
    
    if (sender == button10_1) {
        [self changButtonStatus10:button10_1];
    }else
    if (sender == button10_2) {
        [self changButtonStatus10:button10_2];
    }else
    
    if (sender == button11_1) {
        [self changButtonStatus11:button11_1];
    }else
    if (sender == button11_2) {
        [self changButtonStatus11:button11_2];
    }else
    if (sender == button11_3) {
        [self changButtonStatus11:button11_3];
    }else
    if (sender == button11_4) {
        [self changButtonStatus11:button11_4];
    }else
    if (sender == button11_5) {
        [self changButtonStatus11:button11_5];
    }

}

-(void)textViewDidChange:(UITextView *)textView
{
    
    CGSize sizeToFit = [textView.text sizeNewWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(279, 60) lineBreakMode:NSLineBreakByWordWrapping];
    if (sizeToFit.height <=30) {
        sizeToFit.height = 30;
    }
    
    if (textView.tag == 3000) {
        CGRect rect = textView3_.frame;
        rect.size.height = sizeToFit.height;
        [textView3_ setFrame:rect];
        
        CGRect itemViewRect = itemView3_.frame;
        itemViewRect.size.height = rect.origin.y + rect.size.height +6;
        [itemView3_ setFrame:itemViewRect];
    }else{
        CGRect rect = textView9_.frame;
        rect.size.height = sizeToFit.height;
        [textView9_ setFrame:rect];
        
        CGRect itemViewRect = itemView9_.frame;
        itemViewRect.size.height = rect.origin.y + rect.size.height +6;
        [itemView9_ setFrame:itemViewRect];
    }
    
    [self updataFrame];
}

-(void)changButtonStatus1:(CustomButton *)button
{
    [button1_1 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button1_2 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button1_3 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button1_4 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button1_5 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"ico_select_on.png"] forState:UIControlStateNormal];
    itemResutlString1_ = button.value_;
}

-(void)changButtonStatus2:(CustomButton *)button
{
    [button2_1 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button2_2 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button2_3 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button2_4 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button2_5 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"ico_select_on.png"] forState:UIControlStateNormal];
    itemResutlString2_ = button.value_;
}

-(void)changButtonStatus4:(CustomButton *)button
{
    [button4_1 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button4_2 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button4_3 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button4_4 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"ico_select_on.png"] forState:UIControlStateNormal];
    itemResutlString4_ = button.value_;
}

-(void)changButtonStatus5:(CustomButton *)button
{
    [button5_1 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button5_2 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button5_3 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"ico_select_on.png"] forState:UIControlStateNormal];
    itemResutlString5_ = button.value_;
}

-(void)changButtonStatus6:(CustomButton *)button
{
    [button6_1 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button6_2 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button6_3 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"ico_select_on.png"] forState:UIControlStateNormal];
    itemResutlString6_ = button.value_;
}

-(void)changButtonStatus7:(CustomButton *)button
{
    [button7_1 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button7_2 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"ico_select_on.png"] forState:UIControlStateNormal];
    itemResutlString7_ = button.value_;
}

-(void)changButtonStatus8:(CustomButton *)button
{
    [button8_1 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button8_2 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"ico_select_on.png"] forState:UIControlStateNormal];
    itemResutlString8_ = button.value_;
}

-(void)changButtonStatus10:(CustomButton *)button
{
    [button10_1 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button10_2 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"ico_select_on.png"] forState:UIControlStateNormal];
    itemResutlString10_ = button.value_;
}

-(void)changButtonStatus11:(CustomButton *)button
{
    [button11_1 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button11_2 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button11_3 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button11_4 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button11_5 setImage:[UIImage imageNamed:@"ico_select_off.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"ico_select_on.png"] forState:UIControlStateNormal];
    itemResutlString11_ = button.value_;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.scrollView_ setContentSize:CGSizeMake(320, itemView10_.frame.origin.y + itemView10_.frame.size.height)];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    
}

-(void)viewWillAppear:(BOOL)animated
{
//    self.navigationItem.title = @"参与用户体验问卷";
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}


- (void)keyboardWillHide:(NSNotification *)notification {
    [MyCommon removeTapGesture:self.scrollView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    

    
    CGRect frame = self.toolbarHolder.frame;
    frame.origin.y = self.view.frame.size.height;
    self.toolbarHolder.frame = frame;
    
    CGRect rect10 = itemView10_.frame;
    [self.scrollView_ setContentSize:CGSizeMake(320, rect10.origin.y + rect10.size.height+2)];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"参与用户体验问卷";
    [self setNavTitle:@"参与用户体验问卷"];
    textFieldRect3 = textView3_.frame;
    textFieldRect9 = textView9_.frame;
    textView3_.tag = 3000;
    textView9_.tag = 9000;
    
    textView3_.text = @"";
    textView9_.text = @"";
    itemResutlString1_ = @"";
    itemResutlString2_ = @"";
    itemResutlString4_ = @"";
    itemResutlString5_ = @"";
    itemResutlString6_ = @"";
    itemResutlString7_ = @"";
    itemResutlString8_ = @"";
    itemResutlString10_ = @"";
    itemResutlString11_ = @"";
    
    button1_1.value_ = @"a";
    button1_2.value_ = @"b";
    button1_3.value_ = @"c";
    button1_4.value_ = @"d";
    button1_5.value_ = @"e";
  
    button2_1.value_ = @"a";
    button2_2.value_ = @"b";
    button2_3.value_ = @"c";
    button2_4.value_ = @"d";
    button2_5.value_ = @"e";
    
    button4_1.value_ = @"a";
    button4_2.value_ = @"b";
    button4_3.value_ = @"c";
    button4_4.value_ = @"d";
    
    button5_1.value_ = @"a";
    button5_2.value_ = @"b";
    button5_3.value_ = @"c";
    
    button6_1.value_ = @"a";
    button6_2.value_ = @"b";
    button6_3.value_ = @"c";
    
    button7_1.value_ = @"a";
    button7_2.value_ = @"b";
    
    button8_1.value_ = @"a";
    button8_2.value_ = @"b";
    
    button10_1.value_ = @"a";
    button10_2.value_ = @"b";
    
    button11_1.value_ = @"a";
    button11_2.value_ = @"b";
    button11_3.value_ = @"c";
    button11_4.value_ = @"d";
    button11_5.value_ = @"e";
    
    
    CALayer *layer=[commitView_ layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1] CGColor]];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)commitMethod
{
    
    if ([itemResutlString1_ isEqualToString:@""] || [itemResutlString2_ isEqualToString:@""] ||[itemResutlString4_ isEqualToString:@""] ||[itemResutlString5_ isEqualToString:@""] ||[itemResutlString6_ isEqualToString:@""] ||[itemResutlString7_ isEqualToString:@""] ||[itemResutlString8_ isEqualToString:@""] ||[itemResutlString10_ isEqualToString:@""] ||[itemResutlString11_ isEqualToString:@""]) {
        [BaseUIViewController showAlertView:@"还有选项未填写" msg:nil btnTitle:@"确定"];
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *answerDic = [[NSMutableDictionary alloc]init];  //答案
    NSMutableDictionary *typeDic = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *itemIdDic = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *parentDic = [[NSMutableDictionary alloc]init];
    
    for (int i=1; i<12; i++) {
        NSString *iString = [NSString stringWithFormat:@"%d",i];
        switch (i) {
            case 1:
                [answerDic setObject:itemResutlString1_ forKey:iString];
                [typeDic setObject:@"单选题" forKey:iString];
                [itemIdDic setObject:@"3291408430853335" forKey:iString];
                break;
            case 2:
                [answerDic setObject:itemResutlString2_ forKey:iString];
                [typeDic setObject:@"单选题" forKey:iString];
                [itemIdDic setObject:@"3151408430961511" forKey:iString];
                break;
            case 3:
                [answerDic setObject:textView3_.text forKey:iString];
                [typeDic setObject:@"填空题" forKey:iString];
                [itemIdDic setObject:@"7861408431026456" forKey:iString];
                break;
            case 4:
                [answerDic setObject:itemResutlString4_ forKey:iString];
                [typeDic setObject:@"单选题" forKey:iString];
                [itemIdDic setObject:@"5911408431037474" forKey:iString];
                break;
            case 5:
                [answerDic setObject:itemResutlString5_ forKey:iString];
                [typeDic setObject:@"单选题" forKey:iString];
                [itemIdDic setObject:@"8681408431074936" forKey:iString];
                break;
            case 6:
                [answerDic setObject:itemResutlString6_ forKey:iString];
                [typeDic setObject:@"单选题" forKey:iString];
                [itemIdDic setObject:@"4811408431099634" forKey:iString];
                break;
            case 7:
                [answerDic setObject:itemResutlString7_ forKey:iString];
                [typeDic setObject:@"单选题" forKey:iString];
                [itemIdDic setObject:@"8981408431130102" forKey:iString];
                break;
            case 8:
                [answerDic setObject:itemResutlString8_ forKey:iString];
                [typeDic setObject:@"单选题" forKey:iString];
                [itemIdDic setObject:@"7301408431157851" forKey:iString];
                break;
            case 9:
                [answerDic setObject:textView9_.text forKey:iString];
                [typeDic setObject:@"填空题" forKey:iString];
                [itemIdDic setObject:@"2891408431206806" forKey:iString];
                break;
            case 10:
                [answerDic setObject:itemResutlString10_ forKey:iString];
                [typeDic setObject:@"单选题" forKey:iString];
                [itemIdDic setObject:@"4781408431270872" forKey:iString];
                [parentDic setObject:@"7871408431257844" forKey:iString];
                break;
            case 11:
                [answerDic setObject:itemResutlString11_ forKey:iString];
                [typeDic setObject:@"单选题" forKey:iString];
                [itemIdDic setObject:@"8241408431289405" forKey:iString];
                [parentDic setObject:@"7871408431257844" forKey:iString];
                break;
            default:
                break;
        }
        
        
    }
    
    
    [dic setObject:@"11" forKey:@"countshiti"];
    [dic setObject:answerDic forKey:@"daan"];
    [dic setObject:itemIdDic forKey:@"shitiid"];
    [dic setObject:typeDic forKey:@"tixing"];
    [dic setObject:parentDic forKey:@"parent_shitiid"];
    [dic setObject:@"4261408430807154" forKey:@"wenjuanid"];
    
    
    //参数拼接
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc]init];
    if ([Manager shareMgr].haveLogin) {
        User_DataModal *model = [Manager getUserInfo];
        [userInfoDic setObject:model.uname_ forKey:@"uname"];
        [userInfoDic setObject:model.name_ forKey:@"iname"];
        if (model.mobile_ == nil) {
            model.mobile_ = @"";
        }
        if (model.addr_ == nil) {
            model.addr_ = @"";
        }
        if (model.postCode_ == nil) {
            model.postCode_ = @"";
        }
        [userInfoDic setObject:model.mobile_ forKey:@"shouji"];
        [userInfoDic setObject:model.addr_ forKey:@"address"];
        [userInfoDic setObject:model.postCode_ forKey:@"posts"];
        [userInfoDic setObject:@"1000" forKey:@"tradeid"];
        [userInfoDic setObject:@"0" forKey:@"totalid"];
        [userInfoDic setObject:@"一览英才网" forKey:@"homename"];
        
        if (!commitCon_) {
            commitCon_ = [self getNewRequestCon:NO];
        }
        [commitCon_ addQuestionnaireWithItemId:@"4261408430807154" userId:[Manager getUserInfo].userId_ userInfoDic:userInfoDic conditionDic:dic];
        
    }else{
        [userInfoDic setObject:@"匿名" forKey:@"uname"];
        [userInfoDic setObject:@"1000" forKey:@"tradeid"];
        [userInfoDic setObject:@"0" forKey:@"totalid"];
        [userInfoDic setObject:@"一览英才网" forKey:@"homename"];
        
        if (!commitCon_) {
            commitCon_ = [self getNewRequestCon:NO];
        }
        [commitCon_ addQuestionnaireWithItemId:@"4261408430807154" userId:@"" userInfoDic:userInfoDic conditionDic:dic];
    }
    

}


-(void)backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
}

@end

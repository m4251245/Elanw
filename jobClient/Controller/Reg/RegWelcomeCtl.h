//
//  RegWelcomeCtl.h
//  jobClient
//
//  Created by 一览ios on 15/1/5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"

@protocol RegisterSuccessDelegate <NSObject>
    
-(void)refreshDelegateWithPhone:(NSString *)phone passWord:(NSString *)passWord;

@end

@interface RegWelcomeCtl : BaseUIViewController

@property(nonatomic, copy) NSString *phone;
@property(nonatomic,weak) id <RegisterSuccessDelegate> successDelegate;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;

- (IBAction)protocalBtnClick:(id)sender;
- (IBAction)startBtnClick:(id)sender;


@end

//
//  OrderCtl.h
//  jobClient
//
//  Created by 一览ios on 15/3/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "RRServiceInfo.h"
#import "Article_DataModal.h"

@protocol JoinNameDelegate <NSObject>

-(void)joinNameRefreshBtn;

@end


@class OrderService_DataModal;


@interface JoinActivityCtl : BaseEditInfoCtl

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UITextField *companyTF;
@property (weak, nonatomic) IBOutlet UITextField *groupTF;
@property (weak, nonatomic) IBOutlet UITextField *jobTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;


@property (weak, nonatomic) IBOutlet UILabel *tipsLb;

@property (weak, nonatomic) IBOutlet UITextView *summaryTV;

@property (nonatomic,strong) Article_DataModal *articleModal;
@property (nonatomic,strong) NSArray *arrName;

@property (nonatomic,weak) id <JoinNameDelegate> joinDelagete;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

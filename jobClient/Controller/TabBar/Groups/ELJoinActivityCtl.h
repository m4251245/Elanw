//
//  ELJoinActivityCtl.h
//  jobClient
//
//  Created by 一览iOS on 15/9/17.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELArticleDetailModel.h"

@protocol PublishActivityDelegate <NSObject>

-(void)publishSuccessRefresh;

-(void)keyBoardNotification;

@end

@interface ELJoinActivityCtl : UIViewController

@property (weak,nonatomic) id <PublishActivityDelegate> joinDelagete;

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *companyTF;
@property (weak, nonatomic) IBOutlet UITextField *groupTF;
@property (weak, nonatomic) IBOutlet UITextField *jobTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *summaryTV;

@property(nonatomic,strong) ELArticleDetailModel *myDataModal_;

@property(nonatomic,strong) NSArray *arrList;

-(void)showCtlView;
-(void)hideCtlView;

-(void)creatViewWithArr:(NSArray *)arrData;

@end

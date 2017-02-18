//
//  CHRSendInterviewNotificaCtl.h
//  jobClient
//
//  Created by YL1001 on 16/1/14.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"

@protocol CHRSendInterviewDelegate <NSObject>

- (void)btnResponeWitnIndex:(NSInteger)index;

@end

@interface CHRSendInterviewNotificaCtl : BaseUIViewController

@property (strong, nonatomic) IBOutlet UIView *shadeView;
@property (strong, nonatomic) IBOutlet UILabel *talentsStatusLb;
@property (strong, nonatomic) IBOutlet UILabel *tipsLb;
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) IBOutlet UIButton *noSendBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (nonatomic, copy) NSString *jobfairId;
@property (nonatomic, strong) User_DataModal *userModel;
@property (nonatomic, copy) NSString *companyId;

@property (nonatomic,weak) id<CHRSendInterviewDelegate> btnDelegate;
@property (nonatomic,assign) BOOL isCancelInterview;

- (void)showViewCtl;
- (void)setTalentName:(NSString *)talentName Status:(NSString *)status TipStr:(NSString *)tipStr;
- (void)hideView;



@end

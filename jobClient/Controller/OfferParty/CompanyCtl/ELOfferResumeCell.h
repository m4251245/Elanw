//
//  ELOfferResumeCell.h
//  jobClient
//
//  Created by 一览iOS on 16/5/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfferPartyResumeEnumeration.h"

//@class OfferPartyCompanyResumeModel;

@interface ELOfferResumeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLbaleWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *interViewRightWidth;

@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@property (weak, nonatomic) IBOutlet UILabel *summaryLb;
@property (weak, nonatomic) IBOutlet UIButton *expertsCommentBtn;
@property (weak, nonatomic) IBOutlet UILabel *jobLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UIButton *noticeInterviewBtn;
@property (weak, nonatomic) IBOutlet UIView *imageBackView;

@property (weak, nonatomic) IBOutlet UIImageView *joinStatusImage;
@property (weak, nonatomic) IBOutlet UIButton *delayInterviewBtn;//延迟按钮

@property (nonatomic, strong) User_DataModal *dataModal;
@property (nonatomic, copy) NSString *fromtype;
@property (nonatomic, assign) ComResumeListType resumeListType;  //企业offer派简历列表
@property (assign, nonatomic) OPResumeType resumeType;             //简历状态
@property (assign,nonatomic) NSInteger indexPathRow;

@end

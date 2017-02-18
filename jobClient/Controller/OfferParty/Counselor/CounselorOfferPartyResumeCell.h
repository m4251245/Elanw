//
//  CounselorOfferPartyResumeCell.h
//  jobClient
//
//  Created by YL1001 on 16/9/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfferPartyResumeEnumeration.h"

@interface CounselorOfferPartyResumeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *summaryLb;
@property (weak, nonatomic) IBOutlet UILabel *positionLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIButton *resetPasswordBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLbWidth;

@property(strong, nonatomic) User_DataModal *userModel;
@property(assign, nonatomic) OPResumeListType resumelistType;

@end

//
//  CompanyInterviewCtl_Cell.h
//  jobClient
//
//  Created by YL1001 on 14-9-10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyInterviewCtl_Cell : UITableViewCell

@property(nonatomic,weak) IBOutlet UIImageView * imgView_;
@property(nonatomic,weak) IBOutlet UILabel     * nameLb_;
@property(nonatomic,weak) IBOutlet UIImageView * isMPImg_;
@property(nonatomic,weak) IBOutlet UIImageView * isYYImg_;
@property(nonatomic,weak) IBOutlet UILabel     * gwtjLb_;
@property(nonatomic,weak) IBOutlet UILabel     * zwLb_;
@property(nonatomic,weak) IBOutlet UILabel     * contentLb_;
@property(nonatomic,weak) IBOutlet UIButton    * zwBtn_;
@property(nonatomic,weak) IBOutlet UILabel     * sendtimeLb_;
@property(nonatomic,weak) IBOutlet UILabel     * isPassedLb_;
@property(nonatomic,weak) IBOutlet UIImageView * bnewImgView_;

@end

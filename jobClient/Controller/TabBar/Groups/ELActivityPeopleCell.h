//
//  ELActivityPeopleCell.h
//  jobClient
//
//  Created by 一览iOS on 15/9/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELActivityPeopleFrameModel.h"

@interface ELActivityPeopleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *personImage;

@property (weak, nonatomic) IBOutlet UILabel *personName;
@property (weak, nonatomic) IBOutlet UILabel *personJob;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;
@property (weak, nonatomic) IBOutlet UILabel *companyLb;
@property (weak, nonatomic) IBOutlet UILabel *messageLb;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIView *agreeView;

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *noAgreeBtn;
@property (weak, nonatomic) IBOutlet UILabel *agreeLable;

@property (nonatomic,assign) BOOL isCreatGroup;

@property (nonatomic,strong) ELActivityPeopleFrameModel *modal;

@end

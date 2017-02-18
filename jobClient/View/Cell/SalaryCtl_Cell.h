//
//  SalaryCtl_Cell.h
//  Association
//
//  Created by 一览iOS on 14-1-23.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User_DataModal;
@class ELSalaryResultModel;

@interface SalaryCtl_Cell : UITableViewCell


@property(nonatomic,weak)  IBOutlet UIImageView * sexImg_;
@property(nonatomic,weak)  IBOutlet UILabel     * jobLb_;

@property(nonatomic,weak)  IBOutlet UILabel     * salaryLb_;

@property(nonatomic,weak)  IBOutlet UILabel     * firstNameLb_;
@property(nonatomic,weak)  IBOutlet UILabel     * sexLb_;
@property(nonatomic,weak)  IBOutlet UIView      * lineView_;

@property(nonatomic,weak)  IBOutlet UIView      * contentView_;
@property(nonatomic,weak)  IBOutlet UILabel     * moneyLb_;


@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UIImageView *workAgeImgv;
@property (weak, nonatomic) IBOutlet UILabel *workAgeLb;
@property (weak, nonatomic) IBOutlet UIImageView *schoolImgv;
@property (weak, nonatomic) IBOutlet UILabel *schoolLb;

@property (weak, nonatomic) IBOutlet UIButton *resumeCmpBtn;
//查看他的简历
@property (weak, nonatomic) IBOutlet UIButton *resumeLookBtn;

@property (nonatomic,strong) ELSalaryResultModel *dataModal;
@property (nonatomic,strong) ELSalaryResultModel *dataModalOne;

@end

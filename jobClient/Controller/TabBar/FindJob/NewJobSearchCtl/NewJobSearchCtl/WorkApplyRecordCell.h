//
//  WorkApplyRecordCell.h
//  Association
//
//  Created by 一览iOS on 14-6-23.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkApplyDataModel.h"
@class NewApplyRecordDataModel;
@interface WorkApplyRecordCell : UITableViewCell
{
//    IBOutlet UILabel   *titleLb_;         //职位
//    IBOutlet UILabel   *companyNameLb_;   //公司名称
//    IBOutlet UILabel   *applayTime_;      //最后操作时间
//    IBOutlet UILabel   *salaryLb_;
//    IBOutlet UIImageView    *lineView_;


    IBOutlet UILabel *ZWlabel_;
    IBOutlet UILabel *companyNameLb_;
    IBOutlet UILabel *applyTime_;
    IBOutlet UILabel *statusLb_;

}

//@property(nonatomic,weak)   IBOutlet UIButton  *statusBtn;
//- (void)initCellWith:(WorkApplyDataModel *)workApplyModel indexPath:(NSIndexPath *)indexPath;
@property (weak, nonatomic) IBOutlet UIView *messageVIew;
@property (weak, nonatomic) IBOutlet UIImageView *gwImage;
@property (weak, nonatomic) IBOutlet UILabel *gwContentLb;
@property (weak, nonatomic) IBOutlet UIButton *gwMessageBtn;

@property (weak, nonatomic) IBOutlet UIImageView *backVIewImage;
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;


- (void)initCellWith:(NewApplyRecordDataModel *)workApplyModel;

@end

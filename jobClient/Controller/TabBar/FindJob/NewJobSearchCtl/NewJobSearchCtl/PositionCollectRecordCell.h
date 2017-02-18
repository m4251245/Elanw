//
//  PositionCollectRecordCell.h
//  Association
//
//  Created by 一览iOS on 14-6-24.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionCollectRecordCell : UITableViewCell

@property(nonatomic,weak)IBOutlet   UIButton        *selectedBtn_;      //选择btn
@property(nonatomic,weak)IBOutlet   UIButton        *changePicBtn_;  //改变图片
@property(nonatomic,weak)IBOutlet   UILabel         *titleLb_;          //标题
@property(nonatomic,weak)IBOutlet   UILabel         *companyNameLb_;    //公司名称
@property(nonatomic,weak)IBOutlet   UILabel         *regionNameLb_;     //地区
@property(nonatomic,weak)IBOutlet   UILabel         *updateTimeLb_;     //更新时间

@end

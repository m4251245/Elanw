//
//  CompanyQuestionCtl_Cell.h
//  jobClient
//
//  Created by YL1001 on 14-9-10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyQuestionCtl_Cell : UITableViewCell

@property(nonatomic,weak) IBOutlet  UIImageView  * userImg_;
@property(nonatomic,weak) IBOutlet  UILabel      * askNameLb_;
@property(nonatomic,weak) IBOutlet  UILabel      * timeLb_;
@property(nonatomic,weak) IBOutlet  UILabel      * questionLb_;
@property(nonatomic,weak) IBOutlet  UIButton     * answerBtn_;
@property(nonatomic,weak) IBOutlet  UILabel      * answerLb_;
@property(nonatomic,weak) IBOutlet  UIView       * answerView_;



@end

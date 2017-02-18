//
//  InbiddingJobCell.h
//  jobClient
//
//  Created by 一览ios on 15/10/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWDetail_DataModal.h"

@interface InbiddingJobCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *ctViw;
@property (weak, nonatomic) IBOutlet UILabel *salaryLb;
@property (weak, nonatomic) IBOutlet UILabel *regionLb;
@property (weak, nonatomic) IBOutlet UILabel *positionLb;
@property (weak, nonatomic) IBOutlet UILabel *companyLb;
@property (weak, nonatomic) IBOutlet UIButton *jianliBtn;

@property (weak, nonatomic) IBOutlet UIView *functionView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIView *leftLineView;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;
@property (weak, nonatomic) IBOutlet UIButton *perfectSelectBtn;

-(void)giveDataNormalJobModal:(ZWDetail_DataModal *)dataModal;
-(void)giveDataStopJobModal:(ZWDetail_DataModal *)dataModal;

@end

//
//  ELActivityListCell.h
//  jobClient
//
//  Created by 一览iOS on 15/9/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgDetail_DataModal.h"
#import "Article_DataModal.h"
@class ELActivityModel;

@interface ELActivityListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *activityName;
@property (weak, nonatomic) IBOutlet UILabel *activityTime;
@property (weak, nonatomic) IBOutlet UILabel *activityPlace;
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *personNameLbale;
@property (weak, nonatomic) IBOutlet UIImageView *personImage;

@property (weak, nonatomic) IBOutlet UILabel *peopleCountLb;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *activityLable;
@property (weak, nonatomic) IBOutlet UIImageView *activityStatusImage;

@property(nonatomic,strong) MsgDetail_DataModal *msgActivityModal;
@property(nonatomic,strong) Article_DataModal *articleActivityModal;
@property(nonatomic,strong) ELActivityModel *dataModel;
@property(nonatomic,assign) NSInteger listType;

@end

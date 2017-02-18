//
//  GroupInfoCell.h
//  jobClient
//
//  Created by 一览iOS on 14-10-30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Groups_DataModal;

@interface GroupInfoCell : UITableViewCell


@property(nonatomic,weak)IBOutlet   UIView           *bgView_;
@property(nonatomic,weak)IBOutlet   UIImageView      *photoImgv_;
@property(nonatomic,weak)IBOutlet   UILabel          *titleLb_;
@property(nonatomic,weak)IBOutlet   UILabel          *menberCountLb_;
@property(nonatomic,weak)IBOutlet   UILabel          *articleCountLb_;
@property(nonatomic,weak)IBOutlet   UIButton         *aplayBtn_;
@property(nonatomic,weak)IBOutlet   UILabel          *dynamicLb_;
@property (weak, nonatomic) IBOutlet UIImageView *privacyImageView;

@property (nonatomic,strong) Groups_DataModal *model;
@property (nonatomic,assign) BOOL isMyCenter;

@end

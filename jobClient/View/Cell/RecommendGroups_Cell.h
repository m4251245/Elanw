//
//  RecommendGroups_Cell.h
//  Association
//
//  Created by 一览iOS on 14-4-3.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Groups_DataModal.h"

@interface RecommendGroups_Cell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel * titleLb_;
@property(nonatomic,weak) IBOutlet UILabel * infoLb_;
@property(nonatomic,weak) IBOutlet UILabel * memberNumLb_;
@property(nonatomic,weak) IBOutlet UILabel * memberLb_;
@property(nonatomic,weak) IBOutlet UILabel * articleNumLb_;
@property(nonatomic,weak) IBOutlet UILabel * articleLb_;
@property(nonatomic,weak) IBOutlet UIImageView   * imgView_;
@property(nonatomic,weak) IBOutlet UIButton * joinBtn_;
@property(nonatomic,weak) IBOutlet UIView  * bgView_;

@property (weak, nonatomic) IBOutlet UIImageView *privacyImage;

-(void)cellGiveDataWith:(Groups_DataModal *)dataModal;

@end

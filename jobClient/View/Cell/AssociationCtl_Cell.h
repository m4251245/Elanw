//
//  AssociationCtl_Cell.h
//  Association
//
//  Created by 一览iOS on 14-1-15.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssociationCtl_Cell : UITableViewCell


@property(nonatomic,weak) IBOutlet UIImageView *  propertyImg_;
@property(nonatomic,weak) IBOutlet UILabel     *  nameLb_;
@property(nonatomic,weak) IBOutlet UILabel     *  introLb_;
@property(nonatomic,weak) IBOutlet UIView      *  contentView_;
@property(nonatomic,weak) IBOutlet UIImageView *  lineImg_;
@property(nonatomic,weak) IBOutlet UILabel     *  createrLb_;
@property(nonatomic,weak) IBOutlet UILabel     *  memberLb_;
@property(nonatomic,weak) IBOutlet UILabel     *  topicLb_;

@end

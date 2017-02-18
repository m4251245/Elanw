//
//  AttendtionOrganization_Cell.h
//  jobClient
//
//  Created by YL1001 on 14/10/31.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendtionOrganization_Cell : UITableViewCell

@property(nonatomic,weak) IBOutlet UIImageView * companyLogo_;
@property(nonatomic,weak) IBOutlet UILabel     * cnameLb_;
@property(nonatomic,weak) IBOutlet UILabel     * contentLb_;
@property(nonatomic,weak) IBOutlet UIView      * contentView_;
@end

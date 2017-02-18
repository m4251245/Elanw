//
//  TJZWCell.h
//  jobClient
//
//  Created by YL1001 on 14-9-2.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELArticleDetailModel.h"

@interface TJZWCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel  * zw1NameLb_;
@property(nonatomic,weak) IBOutlet UILabel  * zw1RegionLb_;
@property(nonatomic,weak) IBOutlet UIButton * btn1_;
@property(nonatomic,weak) IBOutlet UILabel  * zw2NameLb_;
@property(nonatomic,weak) IBOutlet UILabel  * zw2RegionLb_;
@property(nonatomic,weak) IBOutlet UIButton * btn2_;
@property(nonatomic,weak) IBOutlet UIImageView  * bgImg2_;

-(void)setMyDataModal:(ELArticleDetailModel *)dataModal;

@end

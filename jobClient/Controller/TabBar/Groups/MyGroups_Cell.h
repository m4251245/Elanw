//
//  MyGroups_Cell.h
//  Association
//
//  Created by YL1001 on 14-5-9.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Groups_DataModal.h"
#import "ELGroupListDetailModel.h"

@interface MyGroups_Cell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView * imgView_;
@property (nonatomic, weak) IBOutlet UILabel     * nameLb_;
@property (nonatomic, weak) IBOutlet UILabel     * contentLb_;
@property (nonatomic, weak) IBOutlet UILabel      * msgCnt_;
@property (nonatomic, weak) IBOutlet UIView      * bgView_;
@property (weak, nonatomic) IBOutlet UIImageView *lineImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineImageLeft;
@property (weak, nonatomic) IBOutlet UIImageView *privacyImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;


-(void)cellGiveDataWithModal:(ELGroupListDetailModel *)dataModal;

@end

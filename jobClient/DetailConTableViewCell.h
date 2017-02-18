//
//  DetailConTableViewCell.h
//  jobClient
//
//  Created by 一览ios on 16/5/9.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailConTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *introLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIImageView *eIconImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightTo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLbToBottom;

@end

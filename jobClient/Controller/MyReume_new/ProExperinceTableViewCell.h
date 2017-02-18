//
//  ProExperinceTableViewCell.h
//  jobClient
//
//  Created by 一览ios on 16/5/25.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProExperinceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *proNameLb;
@property (weak, nonatomic) IBOutlet UILabel *desLb;
@property (weak, nonatomic) IBOutlet UILabel *gainLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gainBottom;

@end

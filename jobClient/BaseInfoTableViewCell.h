//
//  BaseInfoTableViewCell.h
//  jobClient
//
//  Created by 一览ios on 16/5/9.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *sexLab;
@property (weak, nonatomic) IBOutlet UILabel *birthLab;
@property (weak, nonatomic) IBOutlet UILabel *indentiLab;
@property (weak, nonatomic) IBOutlet UILabel *workAgeLab;
@property (weak, nonatomic) IBOutlet UILabel *nationLab;
@property (weak, nonatomic) IBOutlet UILabel *placeOriginLab;
@property (weak, nonatomic) IBOutlet UILabel *liveLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *mainBoxLab;

@end

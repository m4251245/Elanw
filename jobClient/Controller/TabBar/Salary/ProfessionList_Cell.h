//
//  ProfessionList_Cell.h
//  jobClient
//
//  Created by 一览ios on 15/4/27.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfessionList_Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImgv;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgv;
@property (assign, nonatomic) CGFloat originY;

@end

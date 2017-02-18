//
//  CHRIndexCtl_Cell.h
//  jobClient
//
//  Created by 一览ios on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHRIndexCtl_Cell : UITableViewCell

@property (strong, nonatomic) NSDictionary *dataModel;

@property (weak, nonatomic) IBOutlet UIImageView *titleImgv;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIImageView *isNewImgv;
@property (weak, nonatomic) IBOutlet UILabel *countLb;

@property (weak, nonatomic) IBOutlet UIImageView *right_gray;
@property (weak, nonatomic) IBOutlet UIImageView *line;
@end

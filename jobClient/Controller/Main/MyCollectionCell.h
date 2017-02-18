//
//  MyCollectionCell.h
//  jobClient
//
//  Created by 一览ios on 15/10/10.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UILabel *titleLddb;
@property (weak, nonatomic) IBOutlet UIImageView *realNameImage;
@property (weak, nonatomic) IBOutlet UILabel *messageCountLb;
@property (weak, nonatomic) IBOutlet UIImageView *redImg;

@end

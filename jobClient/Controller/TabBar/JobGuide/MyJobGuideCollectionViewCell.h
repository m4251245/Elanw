//
//  MyJobGuideCollectionViewCell.h
//  jobClient
//
//  Created by YL1001 on 15/10/13.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ELLineView;

@interface MyJobGuideCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *typeImg;
@property (strong, nonatomic) IBOutlet UILabel *typeTitle;
@property (strong,nonatomic) ELLineView *viewLine;

@end

//
//  SectionHeaderView.h
//  jobClient
//
//  Created by 一览ios on 16/5/9.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLb;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *unWholeLb;

@end

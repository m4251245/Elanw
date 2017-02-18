//
//  HeaderNotifyTableViewCell.h
//  jobClient
//
//  Created by 一览ios on 16/5/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderNotifyTableViewCell : UITableViewCell<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *notifyLab;
@property (weak, nonatomic) IBOutlet UIButton *interNotifyBtn;
@property (weak, nonatomic) IBOutlet UILabel *interNotyfyNumLab;
@property (weak, nonatomic) IBOutlet UIImageView *redCircleImg;

@property (weak, nonatomic) IBOutlet UILabel *lookLab;
@property (weak, nonatomic) IBOutlet UIImageView *lookMeRedImg;
@property (weak, nonatomic) IBOutlet UIButton *lookMeBtn;
@property (weak, nonatomic) IBOutlet UILabel *lookMeNumLab;

@property (weak, nonatomic) IBOutlet UILabel *recordLab;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIImageView *recordRedImg;
@property (weak, nonatomic) IBOutlet UILabel *recordNumlab;
@property (weak, nonatomic) IBOutlet UIView *interNotyfyBgView;
@property (weak, nonatomic) IBOutlet UIView *lookMeBgView;
@property (weak, nonatomic) IBOutlet UIView *recordBgView;


@end

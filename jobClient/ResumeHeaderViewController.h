//
//  ResumeHeaderViewController.h
//  jobClient
//
//  Created by 一览ios on 16/5/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class New_PersonDataModel;
@interface ResumeHeaderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHeight;
@property (nonatomic,assign) BOOL imgState;
@property (weak, nonatomic) IBOutlet UIButton *hBackBtn;
@property (weak, nonatomic) IBOutlet UIView *headerimgView;
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;

@end

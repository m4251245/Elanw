//
//  CreateCourseOtherBtnCtl.h
//  jobClient
//
//  Created by YL1001 on 15/10/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TimeBlock)(double);

@interface CreateCourseOtherBtnCtl : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *otherTimeTF;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property(nonatomic, copy) TimeBlock timeBlock;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *TimeView;
@property (strong, nonatomic) IBOutlet UILabel *titleLb;

@property (nonatomic,strong) NSString *hourOrPrice;

@end

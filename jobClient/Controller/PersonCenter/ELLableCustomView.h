//
//  ELLableCustomView.h
//  jobClient
//
//  Created by 一览iOS on 16/9/9.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELLableCustomView : UIView

@property (weak, nonatomic) IBOutlet UIView *addBackView;

@property (weak, nonatomic) IBOutlet UITextField *addTextField;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *confirmationBtn;

@property (weak, nonatomic) IBOutlet UIImageView *lineImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end

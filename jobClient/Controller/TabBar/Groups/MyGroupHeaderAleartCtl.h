//
//  MyGroupHeaderAleartCtl.h
//  jobClient
//
//  Created by 一览iOS on 15-3-17.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELGroupDetailCtl.h"

@interface MyGroupHeaderAleartCtl : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *addHeaderBtn;

@property (weak, nonatomic) IBOutlet UIButton *noHeaderBtn;

@property (strong,nonatomic) ELGroupDetailCtl *associationCtl;

@end

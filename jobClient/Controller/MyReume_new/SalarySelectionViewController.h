//
//  SalarySelectionViewController.h
//  jobClient
//
//  Created by 一览ios on 16/5/26.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalarySelectionViewController : UIViewController

@property(nonatomic,copy)void (^myBlock)(NSString *title);

@property(nonatomic,copy)NSString * selSalaryIdx;

@end

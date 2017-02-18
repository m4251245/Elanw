//
//  Enterprise_scaleViewController.h
//  jobClient
//
//  Created by 一览ios on 16/7/28.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELNewBaseViewController.h"

@interface Enterprise_scaleViewController : ELNewBaseViewController

@property(nonatomic,copy)void (^MyBlock)(NSString *numTxt);

@property(nonatomic,assign)NSInteger selectedType;

@property(nonatomic,copy)NSString *cScaleName;

@property(nonatomic,copy)NSString *companyId;

@end

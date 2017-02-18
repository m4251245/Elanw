//
//  CompanyName_settingViewController.h
//  jobClient
//
//  Created by 一览ios on 16/7/28.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELNewBaseViewController.h"
@interface CompanyName_settingViewController : ELNewBaseViewController

@property(nonatomic,copy)void (^MyBlock)(NSString *cName);

@property(nonatomic,assign)NSInteger cType;

@property(nonatomic,copy)NSString *companyId;

@property(nonatomic,copy)NSString *nowCname;

@end

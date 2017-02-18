//
//  Companyinfo_ViewController.h
//  jobClient
//
//  Created by 一览ios on 16/7/27.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELNewBaseViewController.h"
@class New_CompanyDataModel;
@interface Companyinfo_ViewController : ELNewBaseViewController

@property (nonatomic,retain)New_CompanyDataModel *cInfoVO;

@property(nonatomic,copy)NSString *companyId;

@end

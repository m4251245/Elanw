//
//  ELAddResumeReason.h
//  jobClient
//
//  Created by 一览ios on 16/12/10.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"

typedef void (^addReasonBlock)();
@interface ELAddResumeReason : BaseEditInfoCtl

@property (nonatomic, strong) User_DataModal *userModel;
@property (nonatomic, copy) NSString *companyId;

@property(nonatomic, copy) addReasonBlock addReasonBlock;

@end

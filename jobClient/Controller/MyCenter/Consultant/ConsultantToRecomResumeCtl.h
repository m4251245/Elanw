//
//  ConsultantToRecomResumeCtl.h
//  jobClient
//
//  Created by 一览ios on 15/6/9.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ConditionItemCtl.h"
#import "PreCondictionListCtl.h"

@interface ConsultantToRecomResumeCtl : ELBaseListCtl

@property (weak, nonatomic) IBOutlet UIButton *recomBtn;
@property (nonatomic,strong) User_DataModal *inModel;
@property (nonatomic,copy) NSString *salerId;

@end

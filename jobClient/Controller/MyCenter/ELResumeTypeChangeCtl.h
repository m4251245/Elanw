//
//  ELResumeTypeChangeCtl.h
//  jobClient
//
//  Created by 一览iOS on 2017/2/3.
//  Copyright © 2017年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"

typedef enum : NSUInteger {
    PlaceType = 1,
    PeopleType,
    PhoneType,
    JobType,
    TemplateType,
}CompanyMessageChangeType;

typedef void(^ChangeMessageBlock)(id model);

@interface ELResumeTypeChangeCtl : BaseListCtl

@property (nonatomic,assign) CompanyMessageChangeType changeType;
@property (nonatomic,copy) ChangeMessageBlock block;
@property (nonatomic,copy) NSString *editorContent;

@end

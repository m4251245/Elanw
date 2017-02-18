//
//  AttendtionOrganizationCtl.h
//  jobClient
//
//  Created by YL1001 on 14/10/31.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

typedef enum
{
    Organization_School,
    Organization_Company,
    
}OrganizationType;


@interface AttendtionOrganizationCtl : BaseListCtl
{
    NSIndexPath         *indexPath_;
}


@property(nonatomic,assign)OrganizationType  type_;

-(void)handleEdit:(int)type;

@end

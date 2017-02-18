//
//  ResumeAccessAuthorityCtl.h
//  Association
//
//  Created by 一览iOS on 14-6-26.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"

@interface ResumeAccessAuthorityCtl : BaseListCtl<UISearchBarDelegate>
{
    NSMutableArray      *resumeAuthorArray_;
    NSString            *resumeAuthorKey_;
    RequestCon          *updateCon_;
    RequestCon      *companyCon;
    RequestCon      *updateSheidCon;
    NSIndexPath     *tempIndexPath;
    NSMutableArray  *companyArray;
}

@end

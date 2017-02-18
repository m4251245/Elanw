//
//  AssociationCtl.h
//  Association
//
//  Created by 一览iOS on 14-1-15.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "ELGroupDetailCtl.h"
@interface AssociationCtl : BaseListCtl<ELGroupDetailCtlDelegate>

{
    ELGroupDetailCtl * detailCtl_;
    
}
@end

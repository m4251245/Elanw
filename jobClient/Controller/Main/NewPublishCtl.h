//
//  NewPublishCtl.h
//  Association
//
//  Created by YL1001 on 14-6-20.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "Expert_DataModal.h"
#import "ArticleDetailCtl.h"
#import "FileInfoCtl.h"


@interface NewPublishCtl : BaseListCtl
{
    Expert_DataModal        *inDataModal_;
    ArticleDetailCtl        *contentDetailCtl_;
    FileInfoCtl             *fileInfoCtl_;
    NSIndexPath             *indexPath_;
    RequestCon              *deleteCon_;
}

@end

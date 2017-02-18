//
//  RecommendArticleListCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-11-30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "Groups_DataModal.h"

@interface RecommendArticleListCtl : BaseListCtl
{
    IBOutlet        UIView  *topView;
    IBOutlet        UIView  *footView;
    IBOutlet        UIButton    *recommendBtn;
    IBOutlet        UILabel *topLb_;
    int             topCount;
    
    RequestCon      *recommendCon_;
}

@end

//
//  RecommendYLCtl.h
//  jobClient
//
//  Created by YL1001 on 14/11/30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"

@interface RecommendYLCtl : BaseListCtl
{
    RequestCon      *shareLogsCon_;
    
    IBOutlet UIView *wxBgView;
    IBOutlet UIView *pyqBgView;
    IBOutlet UIView *qqBgView;
    
    IBOutlet UIButton *wxShareBtn;
    IBOutlet UIButton *pyqShareBtn;
    IBOutlet UIButton *qqShareBtn;
    
    IBOutlet UIImageView *ylZbar;
    __weak IBOutlet UIButton *contactBtn;
    
}

@end

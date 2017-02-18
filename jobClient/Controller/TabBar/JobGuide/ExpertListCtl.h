//
//  ExpertListCtl.h
//  jobClient
//
//  Created by YL1001 on 15/7/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

@interface ExpertListCtl : BaseListCtl
{
    
    IBOutlet UIView *footerView;
    IBOutlet UIButton *moreExpertBtn_;/**<查看更多行家 */
}

@property (nonatomic,assign) NSInteger productType;

@property (nonatomic,assign) BOOL alreadyRefresh;

@property(nonatomic,assign) BOOL showApplyExpertView;

@end

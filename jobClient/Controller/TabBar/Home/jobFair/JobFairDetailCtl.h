//
//  JobFairDetailCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-7-10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

@interface JobFairDetailCtl : BaseListCtl<UIWebViewDelegate>
{

    IBOutlet    UILabel     *titleLb_;
    IBOutlet    UILabel     *timeLb_;
    IBOutlet    UILabel     *addLb_;
    IBOutlet    UIView      *timeAndAddView_;
    IBOutlet    UIView      *headView_;
    float             cellHeight_;
    BOOL              isReadData_;
    RequestCon              * shareLogsCon_;
}

@property (nonatomic,assign) BOOL isPop;
@end

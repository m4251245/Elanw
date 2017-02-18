//
//  JobSearchCell.h
//  jobClient
//
//  Created by 一览ios on 14-12-21.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchParam_DataModal.h"

@interface JobSearchCell : UITableViewCell
{
    IBOutlet    UILabel *titleLb_;
    IBOutlet    UILabel *contentLb_;
    IBOutlet    UIView  *bgView_;
}

- (void)initCell:(NSMutableArray *)jobSubArray;

@end

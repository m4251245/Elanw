//
//  WorkingAgeCtl.h
//  Association
//
//  Created by 一览iOS on 14-5-27.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"

@protocol ChooseGZNumDelegate <NSObject>

-(void)chooseGZNum:(NSString*)yearStr gznum:(NSString*)gznum;

@end

@interface WorkingAgeCtl : BaseUIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet    UITableView         *workingAgeTableView_;
    NSMutableArray  *dataArray_;
}

@property(nonatomic,assign) id<ChooseGZNumDelegate> delegate_;

@end

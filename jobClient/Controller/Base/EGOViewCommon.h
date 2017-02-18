//
//  EGOViewCommon.h
//  TableViewRefresh
//
//  Created by  Abby Lin on 12-5-2.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef TableViewRefresh_EGOViewCommon_h
#define TableViewRefresh_EGOViewCommon_h

#define TEXT_COLOR	 [UIColor darkGrayColor]

#define FLIP_ANIMATION_DURATION 0.18f

#define  REFRESH_REGION_HEIGHT 65.0f

#import <Foundation/Foundation.h>


typedef enum{
    ELEGOOPullRefreshPulling = 0,
    ELEGOOPullRefreshNormal,
    ELEGOOPullRefreshLoading,
} ELEGOPullRefreshState;

typedef enum{
    ELEGORefreshHeader = 0,
    ELEGORefreshFooter
} ELEGORefreshPos;


@protocol ELEGORefreshTableDelegate

- (void)egoRefreshTableDidTriggerRefresh:(ELEGORefreshPos)aRefreshPos;

@optional
- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view;
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view;

@end

#endif

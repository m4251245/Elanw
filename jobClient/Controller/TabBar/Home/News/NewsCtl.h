//
//  NewsCtl.h
//  Association
//
//  Created by 一览iOS on 14-1-8.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "NewsCtl_Cell.h"
#import "Home_DataModal.h"

@protocol NewsHideNavBarDelegate <NSObject>

-(void)hideNavBarFromNews:(BOOL)hide;


@end

@interface NewsCtl : BaseListCtl
{
     NSMutableArray          *imageConArr_;  //用于加载图片
    
    RequestCon               *newsCon_;
}

@property(nonatomic,assign) id<NewsHideNavBarDelegate> delegate_;

@end

//
//  RecommendGroupsCtl.h
//  Association
//
//  Created by 一览iOS on 14-1-21.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "ELGroupDetailCtl.h"
#import "JionGroupReasonCtl.h"

@interface RecommendGroupsCtl : BaseListCtl<UISearchBarDelegate,ELGroupDetailCtlDelegate,JionGroupReasonCtlDelegate>
{
    ELGroupDetailCtl * detailCtl_;
    
    RequestCon           * joinCon_;
    
    NSIndexPath             *indexpath_;
    
    ELGroupDetailCtl      *associationDetail_;
    NSMutableArray          *imageConArr_;  //用于加载图片
    IBOutlet           UIView       *topView_;
    IBOutlet           UIButton     *zbarBtn_;
    
    
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
    NSInteger                     indexTag;
}

@property(nonatomic,assign) int  type_;   //区分入口

@property(nonatomic,weak) IBOutlet UISearchBar  *  searchBar_;



@end

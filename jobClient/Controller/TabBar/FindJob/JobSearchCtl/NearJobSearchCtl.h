//
//  NearJobSearchCtl.h
//  jobClient
//
//  Created by YL1001 on 15/6/12.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "DBTools.h"
#import "SearchParam_DataModal.h"

typedef void(^nearJobSearchBlock)(SearchParam_DataModal *searchParamModel, BOOL  freshFlag);

@interface NearJobSearchCtl : BaseListCtl<UISearchBarDelegate>
{
    __weak IBOutlet UISearchBar *searchBar_;
    
    DBTools               *db_;
    
    NSMutableArray        *searchHistoryArray_;
    
    SearchParam_DataModal       *inSearchParam_;
    
    
    IBOutlet         UIButton   *clearBtn_;
}

@property (nonatomic,copy) nearJobSearchBlock nearsearchBlock;

@end

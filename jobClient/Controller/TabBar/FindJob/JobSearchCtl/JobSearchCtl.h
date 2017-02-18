//
//  JobSearchCtl.h
//  jobClient
//
//  Created by 一览ios on 15-1-7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "DBTools.h"
#import "SearchParam_DataModal.h"
#import "MyJobSearchCtl.h"

typedef void(^searchBlock)(SearchParam_DataModal *searchParamModel, BOOL  freshFlag);

@interface JobSearchCtl : BaseListCtl<UISearchBarDelegate>
{
    __weak IBOutlet UISearchBar *searchBar_;
    SearchParam_DataModal       *inSearchParam_;
}

@property(nonatomic,weak)   IBOutlet    UIView      *searchContentView_;
@property (nonatomic,strong) NSArray *payMentArray;
@property (nonatomic,strong) NSArray *colorArr;
@property (nonatomic,strong) SearchParam_DataModal *searchParam;
@property (nonatomic,strong) SearchParam_DataModal *oldSearchParam;

@property (nonatomic,copy) searchBlock searchBlock;

@property(nonatomic,assign) BOOL fromMessageList;

@property(nonatomic,strong) MyJobSearchCtl *myJobSearchCtl;

@end

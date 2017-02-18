//
//  SearchGroupArticleList.h
//  jobClient
//
//  Created by 一览ios on 14-12-19.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "Groups_DataModal.h"
#import "ArticleDetailCtl.h"
#import "ELGroupDetailModal.h"

@interface SearchGroupArticleList : BaseListCtl<UISearchBarDelegate>
{
    IBOutlet            UISearchBar         *searchBar_;
    RequestCon                              *searchCon_;
    Groups_DataModal                        *indataModal;
    IBOutlet            UIButton            *changBtn_;
    NSMutableArray                          *groupArticleArray_;
    
}

@property(nonatomic,strong) Expert_DataModal        *expertModel_;
@property(nonatomic,strong) ELGroupDetailModal *groupsDataModal_;

@end

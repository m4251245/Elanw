//
//  TheContactListCtl.h
//  jobClient
//
//  Created by 一览iOS on 15-5-7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ShareMessageModal.h"

@interface TheContactListCtl : BaseListCtl
{
    RequestCon *shareCon;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic,assign) BOOL isPushShareCtl;
@property (nonatomic,strong) ShareMessageModal *shareDataModal;

@property (nonatomic,assign) BOOL shouldRefresh;

@property (nonatomic,assign) BOOL isPersonChat;

@end

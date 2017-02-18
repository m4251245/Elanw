//
//  myJobGroupSearchCtr.h
//  jobClient
//
//  Created by 一览iOS on 15-1-21.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"


@interface myJobGroupSearchCtr : BaseListCtl


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *addQuesView;
@property (weak, nonatomic) IBOutlet UIButton *addQuesbtn;
@property (weak, nonatomic) IBOutlet UILabel *paeaseLable;

@property (strong, nonatomic) IBOutlet UIView *searchVIew;
@property (nonatomic,copy) NSString *keyWord;

-(id)init;

@end

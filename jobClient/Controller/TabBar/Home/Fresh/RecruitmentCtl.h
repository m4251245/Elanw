//
//  RecruitmentCtl.h
//  Association
//
//  Created by 一览iOS on 14-3-27.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "RegionCtl.h"

@interface RecruitmentCtl : BaseListCtl<CondictionListDelegate,ChooseHotCityDelegate>
{
    IBOutlet UITextField         * keywordsTF_;
    IBOutlet UIButton            * searchBtn_;
    IBOutlet UIButton            * regionBtn_;
    
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

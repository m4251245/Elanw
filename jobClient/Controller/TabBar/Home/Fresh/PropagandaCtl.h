//
//  PropagandaCtl.h
//  Association
//
//  Created by 一览iOS on 14-3-27.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "RegionCtl.h"
#import "School_DataModal.h"
#import "XJHChangeTypeModal.h"
#import "XJHDateChangeCtl.h"

@interface PropagandaCtl : BaseListCtl<CondictionListDelegate,ChooseHotCityDelegate>
{
    IBOutlet UITextField         * keywordsTF_;
    IBOutlet UIButton            * searchBtn_;
    IBOutlet UIButton            * regionBtn_;
    IBOutlet UIView             * headView_;
    School_DataModal            *inModel_;
    
    IBOutlet UIButton *schoolBtn;
    
    IBOutlet UIButton *dateBtn;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property(nonatomic,strong) NSString        *type_;     //1为学校入口
@property (nonatomic,strong) XJHChangeTypeModal *typeModal;

@end

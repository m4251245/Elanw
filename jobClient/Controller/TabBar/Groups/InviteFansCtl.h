//
//  InviteFansCtl.h
//  Association
//
//  Created by YL1001 on 14-5-12.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "Groups_DataModal.h"

@class ELGroupDetailModal;
@interface InviteFansCtl : BaseListCtl
{
    NSMutableArray          *imageConArr_;  //用于加载图片
    RequestCon    * inviteCon_;
    
    Groups_DataModal * inModal_;
    RequestCon   *searchCon_;
}
@property (weak, nonatomic) IBOutlet UIScrollView *imageScroll;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;


@property(nonatomic,retain)ELGroupDetailModal  *myDataModal;



@end

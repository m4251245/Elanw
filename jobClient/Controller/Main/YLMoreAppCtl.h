//
//  YLMoreAppCtl.h
//  jobClient
//
//  Created by YL1001 on 15/8/26.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"

@interface YLMoreAppCtl : BaseListCtl<UICollectionViewDataSource, UICollectionViewDelegate>
{
    
    IBOutlet UICollectionView *collectionView_;
    IBOutlet UIView *NetworkView_;
    
    RequestCon  *AppRequest;
}

@property(nonatomic,copy)void (^MyBlock)(NSString *num);
@end

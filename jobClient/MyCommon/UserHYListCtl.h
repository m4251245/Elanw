//
//  UserHYListCtl.h
//  jobClient
//
//  Created by YL1001 on 14-8-13.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "UserZYListCtl.h"


@protocol ChooseHYDelegate <NSObject>

-(void)chooseHy:(NSString*)hyStr  zy:(NSString*)zyStr;


-(void)backToReg;

@end

@interface UserHYListCtl : BaseListCtl<ChooseZyDelegate>
{
    UserZYListCtl * userZYListCtl_;
}


@property(nonatomic,assign) id<ChooseHYDelegate> delegate_;
@end

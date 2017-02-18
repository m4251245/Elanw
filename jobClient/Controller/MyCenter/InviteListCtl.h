//
//  InviteListCtl.h
//  Association
//
//  Created by YL1001 on 14-5-15.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "GroupInvite_DataModal.h"

@interface InviteListCtl : BaseListCtl
{
    NSMutableArray    * imageConArr_;
    RequestCon          *con_;     //用于处理社群请求和邀请
    NSInteger                 btnTag;
    NSString            *dealtypeStr;
    
}

@property(nonatomic,strong) NSString* type_;

@property (nonatomic,assign) BOOL isPop;

//@property(nonatomic,retain)ELGroupDetailModal *myDataModal;

@end

//
//  YLFriendListCtl.h
//  jobClient
//
//  Created by 一览iOS on 15/6/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "TheContactListCtl.h"
#import "YLAddressBookListCtl.h"

@interface YLFriendListCtl : BaseListCtl

@property (nonatomic,assign) NSInteger phoneCount;

@property (nonatomic,assign) BOOL isPop;

@end

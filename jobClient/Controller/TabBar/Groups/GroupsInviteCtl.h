//
//  GroupsInviteCtl.h
//  Association
//
//  Created by YL1001 on 14-5-12.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "Groups_DataModal.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "TKAddressBook.h"
#import "MessageUI/MFMessageComposeViewController.h"


@interface GroupsInviteCtl : BaseListCtl
{
    
}

@property(nonatomic,assign) BOOL fromCreatGroup;

@property(nonatomic,retain)ELGroupDetailModal  *myDataModal;

@end

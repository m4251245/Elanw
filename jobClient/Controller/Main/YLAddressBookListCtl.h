//
//  YLAddressBookListCtl.h
//  jobClient
//
//  Created by 一览iOS on 15/6/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "TKAddressBook.h"
#import "NSString+TKUtilities.h"
#import "YLAddressBookModal.h"
#import "YLAddressBookCell.h"
#import "YLAddressBookDeclarationCtl.h"
#import "YLAddressBookTwoCell.h"
#import "YLAddressBookMoreCtl.h"

@interface YLAddressBookListCtl : BaseListCtl

@property (nonatomic,strong) NSString *whereForm;
@property (nonatomic,strong) Groups_DataModal *groupModal;

@end

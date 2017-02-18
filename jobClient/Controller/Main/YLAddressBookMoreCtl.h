//
//  YLAddressBookMoreCtl.h
//  jobClient
//
//  Created by 一览iOS on 15/6/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "YLAddressBookTwoCell.h"
#import "YLAddressBookModal.h"


@protocol AddFollowDelegate <NSObject>

-(void)addressBookAddFollew:(NSString *)personId;

@end

@interface YLAddressBookMoreCtl : BaseListCtl

@property (nonatomic,weak) id <AddFollowDelegate> addFollowDelegate;
@property (nonatomic,strong) NSMutableDictionary *listDataDic;

@property (nonatomic,strong) NSString *whereForm;
@property (nonatomic,strong) Groups_DataModal *groupModal;

@end

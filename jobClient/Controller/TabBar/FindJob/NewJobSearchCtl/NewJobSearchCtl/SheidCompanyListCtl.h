//
//  SheidCompanyListCtl.h
//  jobClient
//
//  Created by 一览ios on 15/3/3.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"

typedef void (^ReturnStringBlock)(NSString *string);

@interface SheidCompanyListCtl : BaseListCtl<UITextFieldDelegate>
{
    NSString            *keyWordString;
    UITextField        *searchTextField;
    NSMutableArray      *resultArray;
}

@property(nonatomic,copy) ReturnStringBlock block;

@end

//
//  ELTodaySearchMoreCtl.h
//  jobClient
//
//  Created by 一览iOS on 15/10/23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "SearchParam_DataModal.h"
#import "ELTodaySearchModal.h"

typedef void(^searchBlock)(SearchParam_DataModal *searchParamModel, BOOL  freshFlag);

@interface ELTodaySearchMoreCtl : BaseListCtl

@property (nonatomic,assign) SearchDataType searchType;
@property (nonatomic,copy) NSString *keyText;

@property(nonatomic,weak)   IBOutlet    UIView      *searchContentView_;
@property(nonatomic,weak)   IBOutlet    UIButton    *regionBtn_;
@property (weak, nonatomic) IBOutlet    UIButton    *tradeBtn;
@property (weak, nonatomic) IBOutlet    UIButton    *salaryBtn;
@property (weak, nonatomic) IBOutlet    UIButton    *screenBtn;
@property (nonatomic,strong) SearchParam_DataModal *searchParam;

@property (nonatomic,strong) NSArray *payMentArray;
@property (nonatomic,strong) NSArray *colorArr;
@property (nonatomic,copy) searchBlock searchBlock;

@property (nonatomic,assign) BOOL resumeComplete;

@end

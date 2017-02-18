//
//  ELTradeChangeCtl.h
//  jobClient
//
//  Created by 一览iOS on 15/10/29.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "User_DataModal.h"


@protocol EditorTradeDelegate <NSObject>

- (void)editorSuccessWithTradeName:(NSString *)tradeName tradeId:(NSString *)tradeId;

@end


@interface ELTradeChangeCtl : BaseUIViewController

@property(nonatomic, strong) User_DataModal *inDataModal;
@property(nonatomic,weak) id <EditorTradeDelegate> delegate;
@property(nonatomic,assign) BOOL isFromExpert;

@property(nonatomic,assign) NSInteger changeCount;

@property(nonatomic,assign) int type;

@property(nonatomic,copy)NSString *companyId;


@end

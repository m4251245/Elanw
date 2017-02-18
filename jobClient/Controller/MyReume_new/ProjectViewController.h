//
//  ProjectViewController.h
//  jobClient
//
//  Created by 一览ios on 16/5/17.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELBaseListCtl.h"
@class Person_projectDataModel;
@interface ProjectViewController : ELBaseListCtl

@property (nonatomic, copy) NSString *isYjs;

@property (nonatomic, copy) void (^addOrEditorBlock)(NSString *state);

@property (nonatomic, copy) NSString *proType;

@property (nonatomic,strong) Person_projectDataModel *proVO;

@end

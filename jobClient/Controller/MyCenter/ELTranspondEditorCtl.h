//
//  ELTranspondEditorCtl.h
//  jobClient
//
//  Created by 一览iOS on 2017/1/19.
//  Copyright © 2017年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"

typedef void (^ConfirmEditorBlcok)(id dataModal);

@interface ELTranspondEditorCtl : BaseEditInfoCtl

@property (nonatomic,assign) BOOL isEditor;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,strong) NSMutableArray *selectArr;

@property (nonatomic,copy) ConfirmEditorBlcok block;

@end

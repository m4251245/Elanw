//
//  EduBackGroudDetailCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/1/14.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseSingleCtl.h"
@class Person_eduDataModel;
@class EduResume_DataModal;

typedef void(^addOrEditorBlock)(NSString *type);

@interface EduBackGroudDetailCtl : BaseSingleCtl

@property(nonatomic,assign) NSInteger addOrEditor;

@property(nonatomic,copy) addOrEditorBlock addOrEditorBlock;
@property(strong,nonatomic) EduResume_DataModal *dataModal_;
@property(nonatomic,assign) NSInteger allCount;
@property(nonatomic,strong) Person_eduDataModel * eduVO;

@end

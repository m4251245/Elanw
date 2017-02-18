//
//  ELTrainDetailCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/1/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ProjectResume_DataModal.h"
#import "ELChangeDateCtl.h"
@class Person_trainDataModel;

typedef void(^addOrEditorTrainBlock)(ProjectResume_DataModal *dataModal,NSString *type);

@interface ELTrainDetailCtl : BaseUIViewController

@property(nonatomic,assign) NSInteger addOrEditor;

@property(nonatomic,copy) addOrEditorTrainBlock addOrEditorBlock;
@property(strong,nonatomic) ProjectResume_DataModal *dataModal_;
@property(nonatomic,assign) NSInteger allCount;
@property(nonatomic,assign) NSInteger cellIndex;
@property(nonatomic,strong)Person_trainDataModel *trainVO;
@end

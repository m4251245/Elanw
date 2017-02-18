//
//  ELCerDetailCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/1/16.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseSingleCtl.h"
#import "CerResume_DataModal.h"

typedef void(^addOrEditorCerBlock)(CerResume_DataModal *dataModal,NSString *type);

@interface ELCerDetailCtl : BaseSingleCtl


@property(nonatomic,assign) NSInteger addOrEditor;

@property(nonatomic,copy) addOrEditorCerBlock addOrEditorBlock;
@property(strong,nonatomic) CerResume_DataModal *dataModal_;
@property(nonatomic,assign) NSInteger allCount;

@end

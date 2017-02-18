//
//  ELResumeLeaderDetailCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/1/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseSingleCtl.h"
#import "LeaderResume_DataModal.h"

typedef void(^addOrEditorLeaderBlock)(LeaderResume_DataModal *dataModal,NSString *type);

@interface ELResumeLeaderDetailCtl : BaseSingleCtl


@property(nonatomic,assign) NSInteger addOrEditor;

@property(nonatomic,copy) addOrEditorLeaderBlock addOrEditorBlock;
@property(strong,nonatomic) LeaderResume_DataModal *dataModal_;
@property(nonatomic,assign) NSInteger allCount;

@end

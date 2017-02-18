//
//  ELAnswerLableModel.h
//  jobClient
//
//  Created by 一览iOS on 16/9/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"
#import "CondictionList_DataModal.h"

typedef enum : NSUInteger {
    GrayColorType,
    CyanColorType,
} ELColorType;

@interface ELAnswerLableModel : PageInfo

@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,strong) CondictionList_DataModal *tradeModel;
@property(nonatomic,assign) ELColorType colorType; 

@end

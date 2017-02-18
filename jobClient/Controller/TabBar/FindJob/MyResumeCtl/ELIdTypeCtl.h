//
//  ELIdTypeCtl.h
//  jobClient
//
//  Created by 一览ios on 16/1/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELBaseListCtl.h"
@protocol idTypeCtlDelegate <NSObject>

-(void)idTypeCtl:(NSString *)idTypeName;
@end
@interface ELIdTypeCtl : ELBaseListCtl

@property (nonatomic,weak) id<idTypeCtlDelegate>delegate;



@end

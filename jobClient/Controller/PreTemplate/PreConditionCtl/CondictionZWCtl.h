//
//  CondictionZWCtl.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-6-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/******************************
 
 职位列表选择模块
 
 ******************************/

#import <UIKit/UIKit.h>
#import "CondictionTradeCtl.h"
#import "CondictionZWCtl_Sub.h"

@interface CondictionZWCtl : CondictionTradeCtl {
    
}

//检查是否是父节点职位
+(BOOL) checkIsParentZW:(NSString *)zwId;

@end

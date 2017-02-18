//
//  CondictionPlaceSchoolCtl.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/******************************
 
        地区学校列表选择模块
 
 ******************************/

#import <UIKit/UIKit.h>
#import "CondictionPlaceCtl.h"

@interface CondictionPlaceSchoolCtl : CondictionPlaceCtl {
    
}

//设置学校是单选还是多选
-(void) setSchoolMutableChoose:(BOOL)flag;

//设置学校是否含关注属性
-(void) setSchoolAttentionAtt:(BOOL)flag;

@end

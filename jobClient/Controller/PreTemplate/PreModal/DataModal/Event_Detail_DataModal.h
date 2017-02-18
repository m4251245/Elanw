//
//  Xjh_Detail_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-6-14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/********************************************
 事件详情的dataModal
 ********************************************/

#import <Foundation/Foundation.h>
#import "Xjh_DataModal.h"

@interface Event_Detail_DataModal : Xjh_DataModal {
    NSString                        *content_;      //内容
}

@property(nonatomic,retain) NSString                        *content_;


@end

//
//  CondictionList_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/********************************************
 条件选择时的dataModal
 ********************************************/

#import <Foundation/Foundation.h>
#import "PageInfo.h"

@interface CondictionList_DataModal : PageInfo {

}

//@property(nonatomic,strong) NSString                    *str_;
//@property(nonatomic,strong) NSString                    *id_;
//@property(nonatomic,strong) NSString                    *pId_;
//@property(nonatomic,assign) BOOL                        bParent_;
@property(nonatomic,copy) NSString                    *oldString;
@property(nonatomic,retain) NSString                    *str_;
@property(nonatomic,retain) NSString                    *id_;
@property(nonatomic,retain) NSString                    *id_1;
@property(nonatomic,retain) NSString                    *pId_;
@property(nonatomic,retain) NSString                    *pName;
@property(nonatomic,retain) NSString                    *pic_;
@property(nonatomic,assign) BOOL                        bParent_;
@property(nonatomic,assign) BOOL                        bAttention_;
@property(nonatomic,assign) BOOL                        bSelected_;
@property(nonatomic,assign) BOOL                        isTotalTrade;
@property(nonatomic,assign) BOOL                        isFutureTime;
@property(nonatomic,strong) NSMutableArray *dataArr;

@property(nonatomic,copy) NSString *positionMark;

@property(nonatomic,retain) NSString                    *sex;
@property(nonatomic,retain) NSString                    *rcType;
@property(nonatomic,strong) NSDate *changeDate;

@end



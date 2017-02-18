//
//  MapSearchResult_DataModal.h
//  jobClient
//
//  Created by job1001 job1001 on 12-1-11.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/****************************************
 地图企业搜索结果dataModal
 ****************************************/

#import <Foundation/Foundation.h>
#import "PageInfo.h"

@interface MapSearchResult_DataModal : PageInfo {
    NSString                            *id_;           //公司id
    NSString                            *uids_;         //集团id
    NSString                            *cname_;        //公司名称 
    NSString                            *longnum_;      //经度
    NSString                            *latnum_;       //纬度
    NSString                            *regionid_;     //所属地区id
    
    
    BOOL                                bHaveLooked_;
}

@property(nonatomic,retain) NSString                            *id_; 
@property(nonatomic,retain) NSString                            *uids_; 
@property(nonatomic,retain) NSString                            *cname_; 
@property(nonatomic,retain) NSString                            *longnum_; 
@property(nonatomic,retain) NSString                            *latnum_; 
@property(nonatomic,retain) NSString                            *regionid_; 
@property(nonatomic,assign) BOOL                                bHaveLooked_; 

@end

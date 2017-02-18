//
//  Xjh_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//


/********************************************
 宣讲会的dataModal
 ********************************************/

#import <Foundation/Foundation.h>
#import "Zph_DataModal.h"

@interface Xjh_DataModal : Zph_DataModal {
//    NSString                    *id_;       //主键
//    NSString                    *title_;    //宣讲会标题
    NSString                    *cid_;      //公司id
    NSString                    *cname_;    //公司名称
//    NSString                    *sid_;      //学校id
//    NSString                    *sname_;    //学校名称
//    NSString                    *regionId_; //举办地区
//    NSString                    *addr_;     //举办地点
//    NSString                    *sdate_;    //开始时间
    
    
}

//@property(nonatomic,retain) NSString                    *id_;
//@property(nonatomic,retain) NSString                    *title_;
@property(nonatomic,retain) NSString                    *cid_;
@property(nonatomic,retain) NSString                    *cname_;
//@property(nonatomic,retain) NSString                    *sid_;
//@property(nonatomic,retain) NSString                    *sname_;
//@property(nonatomic,retain) NSString                    *regionId_;
//@property(nonatomic,retain) NSString                    *addr_;
//@property(nonatomic,retain) NSString                    *sdate_;

@end

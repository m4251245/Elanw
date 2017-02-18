//
//  MyComment_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-11-12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/****************************************
 评论dataModal
 ****************************************/

#import <Foundation/Foundation.h>
#import "PageInfo.h"

@interface MyComment_DataModal : PageInfo {
    NSString                        *id_;               //主键
    NSString                        *projectIndity_;    //项目标识
    NSString                        *objId_;            //评论东西的id
    NSString                        *objName_;          //评论东西的name
    
    NSString                        *pId_;              //父id
    
    BOOL                            bHide_;             //是否匿名
    NSString                        *name_;             //评论者名称
    NSString                        *personId_;         //评论者id
    
    NSString                        *content_;          //内容
    NSString                        *title_;            //标题
    NSString                        *good_;             //优点
    NSString                        *bad_;              //缺点
    NSString                        *score_;            //得分
    
    NSString                        *updateTime_;       //时间
    NSString                        *clientName_;       //客户端名称
    
    NSString                        *companyId_;        //企业id
    
    int                             replyCnt_;          //回复数量
    int                             agreetCnt_;         //支持数量
}

@property(nonatomic,retain) NSString                        *id_;
@property(nonatomic,retain) NSString                        *projectIndity_;
@property(nonatomic,retain) NSString                        *objId_;
@property(nonatomic,retain) NSString                        *objName_;
@property(nonatomic,retain) NSString                        *pId_;
@property(nonatomic,assign) BOOL                            bHide_;
@property(nonatomic,retain) NSString                        *name_;
@property(nonatomic,retain) NSString                        *personId_;
@property(nonatomic,retain) NSString                        *content_;
@property(nonatomic,retain) NSString                        *title_;
@property(nonatomic,retain) NSString                        *good_;
@property(nonatomic,retain) NSString                        *bad_;
@property(nonatomic,retain) NSString                        *score_;
@property(nonatomic,retain) NSString                        *updateTime_;
@property(nonatomic,retain) NSString                        *clientName_;
@property(nonatomic,retain) NSString                        *companyId_;
@property(nonatomic,assign) int                             replyCnt_;
@property(nonatomic,assign) int                             agreetCnt_;

@end

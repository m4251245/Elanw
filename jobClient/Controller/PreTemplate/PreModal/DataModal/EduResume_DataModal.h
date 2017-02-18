//
//  EduResume_DataModal.h
//  jobClient
//
//  Created by job1001 job1001 on 12-2-13.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/********************************
 
 简历修改->教育背景dataModal
 ********************************/

#import <Foundation/Foundation.h>


@interface EduResume_DataModal : NSObject {
    NSString                        *id_;           //主键
    NSString                        *personId_;     //personId
    NSString                        *school_;       //毕业院校
    NSString                        *startDate_;    //开始时间
    NSString                        *endDate_;      //结束时间
    //NSString                        *edu_;          //所获学历
    NSString                        *eduId_;        //所获学历id
    NSString                        *zye_;          //专业类别
    NSString                        *zym_;          //专业名称
    NSString                        *des_;          //教育情况描述
    
    NSString                        *bToNow_;       //至今标识
    NSString                        *bShow_;        //是否显示
}

@property(nonatomic,retain) NSString                        *id_;
@property(nonatomic,retain) NSString                        *personId_;
@property(nonatomic,retain) NSString                        *school_;
@property(nonatomic,retain) NSString                        *startDate_;
@property(nonatomic,retain) NSString                        *endDate_;
//@property(nonatomic,retain) NSString                        *edu_;
@property(nonatomic,retain) NSString                        *eduId_;
@property(nonatomic,retain) NSString                        *zye_;
@property(nonatomic,retain) NSString                        *zym_;
@property(nonatomic,retain) NSString                        *des_;
@property(nonatomic,retain) NSString                        *bToNow_;
@property(nonatomic,retain) NSString                        *bShow_;
@property(nonatomic,strong) NSString                        *eduName_;
@property(nonatomic,assign) NSInteger    cellIndex;

@end

//
//  ProjectResume_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-6-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ProjectResume_DataModal : NSObject {
    NSString                        *id_;           //主键
    NSString                        *personId_;     //人才id
    NSString                        *bToNow_;    
    NSString                        *startDate_;
    NSString                        *endDate_;
    NSString                        *name_;
    NSString                        *des_;
    NSString                        *gainDes_;      //收获成果
}

@property(nonatomic,retain) NSString                        *id_; 
@property(nonatomic,retain) NSString                        *personId_; 
@property(nonatomic,retain) NSString                        *bToNow_;  
@property(nonatomic,retain) NSString                        *startDate_;
@property(nonatomic,retain) NSString                        *endDate_;
@property(nonatomic,retain) NSString                        *name_;
@property(nonatomic,retain) NSString                        *des_;
@property(nonatomic,retain) NSString                        *gainDes_;
@property(nonatomic,assign) NSInteger                       cellIndex;

@end

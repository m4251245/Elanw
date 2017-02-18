//
//  CerResume_DataModal.h
//  jobClient
//
//  Created by job1001 job1001 on 12-2-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//


/********************************
 
            简历修改->证书dataModal
 ********************************/

#import <Foundation/Foundation.h>

@interface CerResume_DataModal : NSObject {
    NSString                        *id_;       //证书id
    NSString                        *uid_;      //personId
    NSString                        *year_;     //年
    NSString                        *month_;    //月
    NSString                        *cerName_;  //证书名称
    NSString                        *scores_;   //成绩
}

@property(nonatomic,retain) NSString                        *id_;
@property(nonatomic,retain) NSString                        *uid_;
@property(nonatomic,retain) NSString                        *year_;
@property(nonatomic,retain) NSString                        *month_;
@property(nonatomic,retain) NSString                        *cerName_;
@property(nonatomic,retain) NSString                        *scores_;
@property(nonatomic,assign) NSInteger cellIndex;

@end

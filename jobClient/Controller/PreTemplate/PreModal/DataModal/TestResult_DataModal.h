//
//  TestResult_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-8-24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/****************************************
 测试结果dataModal
 ****************************************/

#import <Foundation/Foundation.h>


@interface TestResult_DataModal : NSObject {
    NSString                        *summary_;
    NSString                        *contents_;
}

@property(nonatomic,retain) NSString                        *summary_;
@property(nonatomic,retain) NSString                        *contents_;

@end

//
//  CountInfo_DataModal.h
//  iPadJobClient
//
//  Created by job1001 job1001 on 11-12-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

/********************************************
 数量信息，比如职位申请数等的返回数据
 ********************************************/

#import <Foundation/Foundation.h>


@interface CountInfo_DataModal : NSObject {
    NSString                        *count_;            //数量
    NSString                        *type_;             //???
}

@property(nonatomic,retain) NSString                        *count_;
@property(nonatomic,retain) NSString                        *type_;

@end

//
//  Salary_DataModal.h
//  jobClient
//
//  Created by job1001 job1001 on 12-1-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Salary_DataModal : NSObject {
    NSString                        *min_;          //最小值
    NSString                        *minmid_;       //中小
    NSString                        *mid_;          //中
    NSString                        *midmax_;       //中大
    NSString                        *max_;          //大
}

@property(nonatomic,retain) NSString                        *min_;
@property(nonatomic,retain) NSString                        *minmid_;
@property(nonatomic,retain) NSString                        *mid_;
@property(nonatomic,retain) NSString                        *midmax_;
@property(nonatomic,retain) NSString                        *max_;

@end

//
//  SalaryQuery_DataModal.h
//  ClientTemplate
//
//  Created by job1001 job1001 on 12-12-7.
//
//

/****************************************
            薪酬查询时的dataModal
 ****************************************/

#import <Foundation/Foundation.h>

@interface SalaryQuery_DataModal : NSObject{
    NSString                *zwPId_;            //职位的pid
    NSString                *zwPStr_;
    NSString                *zwSubId_;
    NSString                *zwSubStr_;
    NSString                *regionPId_;
    NSString                *regionSubId_;
    NSString                *eduId_;
    NSString                *workYear_;
}

@property(nonatomic,retain) NSString        *zwPId_;
@property(nonatomic,retain) NSString        *zwPStr_;
@property(nonatomic,retain) NSString        *zwSubId_;
@property(nonatomic,retain) NSString        *zwSubStr_;
@property(nonatomic,retain) NSString        *regionPId_;
@property(nonatomic,retain) NSString        *regionSubId_;
@property(nonatomic,retain) NSString        *eduId_;
@property(nonatomic,retain) NSString        *workYear_;

@end

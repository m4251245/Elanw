//
//  CompanyDescript_DataModal.h
//  iPadJobClient
//
//  Created by job1001 job1001 on 11-12-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

/********************************************
 公司简介的dataModal
 ********************************************/

#import <Foundation/Foundation.h>


@interface CompanyDescript_DataModal : NSObject {
    NSString                    *companyName_;              //公司名称
    NSString                    *companyDescript_;          //公司简介 
}

@property(nonatomic,retain) NSString                    *companyName_;
@property(nonatomic,retain) NSString                    *companyDescript_;

@end

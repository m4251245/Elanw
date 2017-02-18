//
//  MD5.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/****************************************
 
                获取MD5值模块
 
 ****************************************/



#import <Foundation/Foundation.h>


@interface MD5 : NSObject {
    
}

//获取str的md5值
+(NSString *) getMD5:(NSString *)str;

@end

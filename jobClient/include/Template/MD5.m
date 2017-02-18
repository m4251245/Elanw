//
//  MD5.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MD5.h"
#import <CommonCrypto/CommonDigest.h> //Import for CC_MD5 access

@implementation MD5

//获取str的md5值
+(NSString *) getMD5:(NSString *)str
{
    if( !str ){
        return nil;
    }
    
	const char *cStr = [str UTF8String]; 
	unsigned char result[16]; 
	CC_MD5(cStr, strlen(cStr), result); //This is the MD5 calculate 
    
    NSString *newMD5 = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        result[0], result[1], result[2], result[3],
                        result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11],
                        result[12], result[13], result[14], result[15] 
                        ];
    
	return newMD5;
}

@end

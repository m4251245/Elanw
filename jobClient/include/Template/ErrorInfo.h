//
//  ErrorInfo.h
//  SmartMarketClient
//
//  Created by sysweal on 13-3-26.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    //<=200为正常
	Success = 200,
	
    
    //>200为异常
	Fail,
	No_Internet_Error,
	Init_Internet_Error,
	
    Map_InValidate_Error,
    GPS_InValidate_Error,
    
    Address_SVGeocoder_Error,
    
    Cache_NoData,
	Parser_NoData,
    Parser_InitError,
    Parser_FunError,
	Parser_Error,
}ErrorCode;

@interface ErrorInfo : NSObject{

}

//get error des
+(NSString *) getErrorMsg:(ErrorCode)code;

@end

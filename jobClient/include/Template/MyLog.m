//
//  MyLog.m
//  Template
//
//  Created by sysweal on 13-9-11.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

#import "MyLog.h"

@implementation MyLog

//记录日志
+(void) Log:(NSString *)str obj:(NSObject *)obj
{
    @try {
        if( !obj ){
            NSLog(@"[MyLog] : %@",str);
        }else{
            NSLog(@"[%@] : %@",[obj class],str);
        }
    }
    @catch (NSException *exception) {
       NSLog(@"Log error!!!!");
    }
    @finally {
        
    }
}

@end

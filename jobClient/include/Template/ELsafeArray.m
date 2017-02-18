//
//  ELsafeArray.m
//  jobClient
//
//  Created by 一览ios on 17/1/10.
//  Copyright © 2017年 YL1001. All rights reserved.
//

#import "ELsafeArray.h"

@implementation ELsafeArray

+ (void)load {
    
    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
    Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(EL_objectAtIndex:));
    method_exchangeImplementations(fromMethod, toMethod);
}

- (id)EL_objectAtIndex:(NSUInteger)index {
    if (self.count-1 < index) {
        // 这里做一下异常处理，不然都不知道出错了。
        @try {
            return [self EL_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息，方便我们调试。
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    } else {
        return [self EL_objectAtIndex:index];
    }
}


@end

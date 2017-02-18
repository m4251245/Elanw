//
//  NSMutableArray+ELSafeArray.m
//  jobClient
//
//  Created by 一览ios on 16/12/26.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "NSMutableArray+ELSafeArray.h"

@implementation NSMutableArray (ELSafeArray)

+ (void)load {
    
    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:));
    Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(EL_objectAtIndex:));
    method_exchangeImplementations(fromMethod, toMethod);
    
    Method fromMethod2 = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(addObject:));
    Method toMethod2 = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(EL_addObject:));
    method_exchangeImplementations(fromMethod2, toMethod2);
    
    Method fromMethod3 = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(insertObject:atIndex:));
    Method toMethod3 = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(EL_insertObject:atIndex:));
    method_exchangeImplementations(fromMethod3, toMethod3);
}

- (id)EL_objectAtIndex:(NSUInteger)index {
    
    if (self.count-1 < index) {
        // 这里做一下异常处理，不然都不知道出错了。
        @try {
            [self EL_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息，方便我们调试。
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
//            return nil;
        }
        @finally {}
    } else {
        return [self EL_objectAtIndex:index];
    }
}

- (void)EL_addObject:(id)object
{
    if (object == nil) {
        @try {
            [self EL_addObject:object];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
//            object = [NSString stringWithFormat:@""];
//            [self EL_addObject:object];
//            return nil;
        }
        @finally {}
    }else {
       [self EL_addObject:object];
    }
}

- (void)EL_insertObject:(id)object atIndex:(NSUInteger)idx;
{
    if (object == nil) {
        @try {
            [self EL_insertObject:object atIndex:idx];
        } @catch (NSException *exception) {
            
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            
        } @finally {
            
        }
    }else{
        [self EL_insertObject:object atIndex:idx];
    }
}

@end

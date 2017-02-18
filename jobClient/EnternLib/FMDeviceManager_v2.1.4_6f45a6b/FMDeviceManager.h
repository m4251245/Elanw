//
//  FMDeviceManager.h
//  FMDeviceManager
//
//  Copyright (c) 2015年 Fraudmetrix.inc. All rights reserved.
//

#define FM_SDK_VERSION @"2.1.4"

#import <Foundation/Foundation.h>
#import <AdSupport/ASIdentifierManager.h>
#import <UIKit/UIKit.h>
#import <sys/sysctl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if_dl.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <resolv.h>
#import <sys/stat.h>
#import <mach-o/dyld.h>
#import <dlfcn.h>
#import <sys/types.h>

typedef struct _void {
    void (*initWithOptions)(NSDictionary *);
    NSString *(*getDeviceInfo)();
} FMDeviceManager_t;

@interface FMDeviceManager : NSObject

+ (FMDeviceManager_t *) sharedManager;
+ (void) destroy;

@end


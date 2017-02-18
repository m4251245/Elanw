//
//  AssociationAppDelegate.h
//  Association
//
//  Created by 一览iOS on 14-1-3.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SdkStatusStoped,
    SdkStatusStarting,
    SdkStatusStarted
} SdkStatus;

@interface AssociationAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *clientId;
//@property (assign, nonatomic) SdkStatus sdkStatus;
@property (assign, nonatomic) NSString *messageType;

@property (nonatomic,unsafe_unretained)  UIBackgroundTaskIdentifier  backgroundTaskIdentifier;
@property (nonatomic, strong) NSTimer *myTimer;
@property (assign, nonatomic) BOOL      bFromNotification;

@end

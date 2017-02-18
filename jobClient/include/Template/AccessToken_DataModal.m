//
//  AccessToken_DataModal.m
//  MBA
//
//  Created by sysweal on 13-11-12.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "AccessToken_DataModal.h"

@implementation AccessToken_DataModal

@synthesize sercet_,accessToken_;

-(void)saveDataModalWithUserDefaultType:(AccessTokenType)type
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (self.sercet_ && ![self.sercet_ isEqualToString:@""]) {
//        [userDefault removeObjectForKey:[NSString stringWithFormat:@"AccessToken_DataModal_Sercet_%ld",(unsigned long)type]];
        [userDefault setObject:self.sercet_ forKey:[NSString stringWithFormat:@"AccessToken_DataModal_Sercet_%ld",(unsigned long)type]];
    }
    if (self.accessToken_ && ![self.accessToken_ isEqualToString:@""]) {
//        [userDefault removeObjectForKey:[NSString stringWithFormat:@"AccessToken_DataModal_AccessToken_%ld",(unsigned long)type]];
        [userDefault setObject:self.accessToken_ forKey:[NSString stringWithFormat:@"AccessToken_DataModal_AccessToken_%ld",(unsigned long)type]];
    }
    [userDefault synchronize];
}
-(void)getDataModalWithUserDefaultType:(AccessTokenType)type{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.sercet_ = [userDefault objectForKey:[NSString stringWithFormat:@"AccessToken_DataModal_Sercet_%ld",(unsigned long)type]];
    self.accessToken_ = [userDefault objectForKey:[NSString stringWithFormat:@"AccessToken_DataModal_AccessToken_%ld",(unsigned long)type]];
}

@end

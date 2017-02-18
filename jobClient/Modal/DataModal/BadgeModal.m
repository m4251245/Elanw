//
//  BadgeModal.m
//  jobClient
//
//  Created by 一览iOS on 15-3-3.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BadgeModal.h"

@implementation BadgeModal


-(BadgeModal *)initWithDictionary:(NSDictionary *)subDic
{
    self = [super init];
    if (self) {
        self.prestige = [subDic objectForKey:@"prestige"];
        self.personId = [subDic objectForKey:@"person_id"];
        self.type = [subDic objectForKey:@"type"];
        self.actionId = [subDic objectForKey:@"action_id"];
        if([subDic objectForKey:@"slave"])
        {
            switch ([self.type integerValue]) {
                case 10:
                case 11:
                    self.slave = [[subDic objectForKey:@"slave"] objectForKey:@"title"];
                    break;
                case 50:
                case 30:
                case 20:
                    self.slave = [[subDic objectForKey:@"slave"] objectForKey:@"person_iname"];
                    break;
                default:
                    break;
            }
        }
        self.idatetime = [subDic objectForKey:@"idatetime"];
    }
    return self;
}

-(BadgeModal *)initWithDictionaryTwo:(NSDictionary *)subDic
{
    self = [super init];
    if (self) {
        self.ylb_id = [subDic objectForKey:@"ylb_id"];
        self.ylb_name = [subDic objectForKey:@"ylb_name"];
        self.ylb_pic = [subDic objectForKey:@"ylb_pic"];
        self.ylb_pic_gray = [subDic objectForKey:@"ylb_pic_gray"];
        self.ylb_desc = [subDic objectForKey:@"ylb_desc"];
        self.isbadge = NO;
        if (![[subDic objectForKey:@"_person_badge"] isEqual:[NSNull null]]) {
            self.isbadge = YES;
            self.ypb_person_id = [[subDic objectForKey:@"_person_badge"] objectForKey:@"ypb_person_id"];
            self.idatetime = [[subDic objectForKey:@"_person_badge"] objectForKey:@"idatetime"];
        }
    }
    return self;
}

@end

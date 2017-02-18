//
//  WhoLikeMeDataModal.m
//  jobClient
//
//  Created by 一览iOS on 15/5/21.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "WhoLikeMeDataModal.h"

@implementation WhoLikeMeDataModal

-(WhoLikeMeDataModal *)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.yp_id = dic[@"yp_id"];
        self.yp_type = dic[@"yp_type"];
        self.yp_type_code = dic[@"yp_type_code"];
        self.idatetime = dic[@"idatetime"];
        NSString *messageType = dic[@"_is_new"];
        if ([messageType isEqualToString:@"1"]) {
            self.isNewMessage = YES;
        }else
        {
            self.isNewMessage = NO;
        }
        self.personId = dic[@"_person_detail"][@"personId"];
        self.person_iname = dic[@"_person_detail"][@"person_iname"];
        self.person_nickname = dic[@"_person_detail"][@"person_nickname"];
        self.person_pic = dic[@"_person_detail"][@"person_pic"];
        self.person_zw = dic[@"_person_detail"][@"person_zw"];
        
        if(dic[@"_product_info"] && ![dic[@"_product_info"] isEqual:[NSNull null]])
        {
            if ([self.yp_type isEqualToString:@"1"])
            {
                self.article_id = dic[@"_product_info"][@"article_id"];
                self.infocontent = dic[@"_product_info"][@"title"];
                self.own_id = dic[@"_product_info"][@"own_id"];
                self.qi_id = dic[@"_product_info"][@"qi_id"];
            }
            else if ([self.yp_type isEqualToString:@"2"])
            {
                self.infoid = dic[@"_product_info"][@"id"];
                self.infocontent = dic[@"_product_info"][@"content"];
                self.article_id = dic[@"_product_info"][@"article_id"];
            }
            self.infostatus = dic[@"_product_info"][@"status"];
        }
    }
    return self;
}

@end

//
//  ReplyCommentModal.m
//  jobClient
//
//  Created by YL1001 on 16/6/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ReplyCommentModal.h"

@implementation ReplyCommentModal

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"_person_detail"])
    {
        NSDictionary *dict = value;
        _personId = dict[@"personId"];
        _person_iname = dict[@"person_iname"];
        _person_pic = dict[@"person_pic"];
    }
    else if ([key isEqualToString:@"_parent_person_detail"])
    {
        NSDictionary *dict = value;
        _parent_personId = dict[@"personId"];
        _parent_person_iname = dict[@"person_iname"];
        _parent_person_pic = dict[@"person_pic"];
    }
    else
    {
        [super setValue:value forKey:key];
    }
}

@end

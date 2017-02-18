//
//  JobGuideExpertModal.m
//  jobClient
//
//  Created by YL1001 on 16/6/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "JobGuideExpertModal.h"

@implementation JobGuideExpertModal

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"_photo"]) {
        self.photo = value;
    }
}


@end

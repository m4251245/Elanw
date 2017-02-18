//
//  ELNewNewsListVO.m
//  jobClient
//
//  Created by 一览ios on 2016/12/22.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELNewNewsListVO.h"
#import "ELNewNewsInfoVO.h"
@implementation ELNewNewsListVO
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"info"]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            ELNewNewsInfoVO *newsVO = [[ELNewNewsInfoVO alloc]init];
            [newsVO setValuesForKeysWithDictionary:value];
            self.info = newsVO;
        }
        else{
            self.info = value;
        }
    }
   
    else{
        [super setValue:value forKey:key];
    }

}
@end

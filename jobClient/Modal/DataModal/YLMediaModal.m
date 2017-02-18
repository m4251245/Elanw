//
//  YLMediaModal.m
//  jobClient
//
//  Created by 一览iOS on 15/6/5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "YLMediaModal.h"

@implementation YLMediaModal

-(YLMediaModal *)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        if (dic && ![dic isKindOfClass:[NSNull class]]) {
            [self setValuesForKeysWithDictionary:dic];
        }
        self.postfix = [YLMediaModal getStringWithPostfix:self.title];
        if (self.file_swf.length > 0)
        {
            self.file_swf = [MyCommon getWithFileSwf:self.file_swf];
        }
        self.titleImage = [YLMediaModal getImageNameWithString:self.postfix];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.id_ = value;
    }
    else{
        [super setValue:value forKey:key]; 
    }
}

+(NSString *)getImageNameWithString:(NSString *)str
{
    NSString *imageStr = @"";
    
    if ([str isEqualToString:@"txt"])
    {
        imageStr = @"attachment1";
    }
    else if ([str isEqualToString:@"jpg"] || [str isEqualToString:@"png"] || [str isEqualToString:@"jpeg"] || [str isEqualToString:@"gif"] ||[str isEqualToString:@"bmp"])
    {
        imageStr = @"attachment2";
    }
    else if ([str isEqualToString:@"doc"] || [str isEqualToString:@"docx"] || [str isEqualToString:@"wps"])
    {
        imageStr = @"attachment3";
    }
    else if ([str isEqualToString:@"xls"] || [str isEqualToString:@"xlt"] || [str isEqualToString:@"xlsx"] || [str isEqualToString:@"et"])
    {
        imageStr = @"attachment4";
    }
    else if ([str isEqualToString:@"ppt"] || [str isEqualToString:@"pptx"] || [str isEqualToString:@"ppx"])
    {
        imageStr = @"attachment5";
    }
    else
    {
        imageStr = @"attachment6";
    }
    return imageStr;
}

+(NSString *)getStringWithPostfix:(NSString *)str
{
    NSInteger k = 0;
    for (NSInteger i = str.length-1;i>=0;i--) {
        NSString *strOne= [str substringWithRange:NSMakeRange(i,1)];
        if([strOne isEqualToString:@"."])
        {
            k = i;
            break;
        }
    }
    return [str substringFromIndex:k+1];
}

@end

//
//  ELSameTradePeopleFrameModel.m
//  jobClient
//
//  Created by 一览iOS on 16/6/8.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELSameTradePeopleFrameModel.h"

@implementation ELSameTradePeopleFrameModel

-(void)setPeopleModel:(ELSameTradePeopleModel *)peopleModel{
    _peopleModel = peopleModel;
    [self changeDynamic:peopleModel];
    [self changeWorkAgeAttString:peopleModel];
}

-(void)changeDynamic:(ELSameTradePeopleModel *)peopleModel{
    if ([peopleModel.type isEqualToString:@"article"]) {
        _dynamicImageName = @"icon_wenzhang";
        _dynamicBtnEnable = YES;
    }else if ([peopleModel.type isEqualToString:@"audio"]){
        _dynamicImageName = @"ios_yuyin";
        _dynamicBtnEnable = NO;
    }else if ([peopleModel.type isEqualToString:@"photo"]){
        _dynamicImageName = @"ios_zhaopian";
        _dynamicBtnEnable = NO;
    }else if ([peopleModel.type isEqualToString:@"tag"]){
        _dynamicImageName = @"ios__biaoqian";
        _dynamicBtnEnable = NO;
    }else if ([peopleModel.type isEqualToString:@"group"]){
        _dynamicImageName = @"ios_shequn";
        _dynamicBtnEnable = YES;
    }else if ([peopleModel.type isEqualToString:@"follow"]){
        _dynamicImageName = @"ios_tonghang";
        _dynamicBtnEnable = YES;
    }else if ([peopleModel.type isEqualToString:@"pic"]){
        _dynamicImageName = @"ios_zhaopian";
        _dynamicBtnEnable = NO;
    }else{
        _dynamicImageName = @"";
        _dynamicBtnEnable = NO;
    }
}

-(void)changeWorkAgeAttString:(ELSameTradePeopleModel *)peopleModel{
    NSString *ageAndZwString = nil;
    NSMutableAttributedString *attributeString;
    if (peopleModel.person_gznum &&![peopleModel.person_gznum isEqualToString:@""]&&[peopleModel.person_gznum floatValue] > 0.0) {
        if ([peopleModel.person_gznum floatValue] < 1.0) {
            peopleModel.person_gznum= @"1";
        }else{
            peopleModel.person_gznum = [NSString stringWithFormat:@"%ld",(long)[peopleModel.person_gznum integerValue]];
        }
        if ([peopleModel.person_job_now isEqualToString:@""] || peopleModel.person_job_now == nil || [peopleModel.person_job_now isKindOfClass:NSNull.class] ) {
            ageAndZwString = [NSString stringWithFormat:@"%@年经验",peopleModel.person_gznum];
            attributeString = [[NSMutableAttributedString alloc] initWithString:ageAndZwString];
        }else{
            ageAndZwString = [NSString stringWithFormat:@"%@ | %@年经验",peopleModel.person_job_now ,peopleModel.person_gznum];
            attributeString = [[NSMutableAttributedString alloc] initWithString:ageAndZwString];
            [attributeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xD8D8D8) range:NSMakeRange(peopleModel.person_job_now.length+1, 1)];
            [attributeString addAttribute:NSFontAttributeName value:FIFTEENFONT_TITLE range:NSMakeRange(0,attributeString.string.length)];
        }
    }
    else
    {
        peopleModel.person_gznum = @"工作经验保密";
        if ([peopleModel.person_job_now isEqualToString:@""] || peopleModel.person_job_now == nil || [peopleModel.person_job_now isKindOfClass:NSNull.class] ) {
            ageAndZwString = [NSString stringWithFormat:@"%@",peopleModel.person_gznum];
            attributeString = [[NSMutableAttributedString alloc] initWithString:ageAndZwString];
        }else{
            ageAndZwString = [NSString stringWithFormat:@"%@ | %@",peopleModel.person_job_now,peopleModel.person_gznum];
            attributeString = [[NSMutableAttributedString alloc] initWithString:ageAndZwString];
            [attributeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xD8D8D8) range:NSMakeRange(peopleModel.person_job_now.length+1, 1)];
            [attributeString addAttribute:NSFontAttributeName value:FIFTEENFONT_TITLE range:NSMakeRange(0,attributeString.string.length)];
        }
    }
    self.workAgeAttString = attributeString;
}

-(void)changeSearchKeyWord{
    
    self.nameAttString = [[NSMutableAttributedString alloc] initWithString:_peopleModel.person_iname];
    [self changeColor:self.nameAttString];
    [self.nameAttString addAttribute:NSFontAttributeName value:SEVENTEENFONT_FRISTTITLE range:NSMakeRange(0,self.nameAttString.string.length)];

    [self changeColor:self.workAgeAttString];
    [self.workAgeAttString addAttribute:NSFontAttributeName value:FIFTEENFONT_TITLE range:NSMakeRange(0,self.workAgeAttString.string.length)];
}

-(void)changeColor:(NSMutableAttributedString *)attString
{
    NSString *fontLeft = @"<font color=red>";
    NSString *fontRight = @"</font>";
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    if ([attString.string containsString:fontLeft])
    {
        NSInteger startIndex = 10000;
        BOOL saveString = NO;
        
        for (NSInteger i = 0; i<attString.string.length;)
        {
            NSString *string = [attString.string substringFromIndex:i];
            NSString *str = @"";
            if (saveString && [string containsString:fontRight])
            {
                str = [attString.string substringWithRange:NSMakeRange(i,fontRight.length)];
            }
            else if([string containsString:fontLeft])
            {
                str = [attString.string substringWithRange:NSMakeRange(i,fontLeft.length)];
            }
            
            if ([str isEqualToString:fontLeft])
            {
                [arr addObject:[NSValue valueWithRange:NSMakeRange(i,fontLeft.length)]];
                i += (fontLeft.length);
                startIndex = i;
                saveString = YES;
            }
            else if([str isEqualToString:fontRight] && startIndex < i)
            {
                [arr addObject:[NSValue valueWithRange:NSMakeRange(i,fontRight.length)]];
                
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(startIndex,i-startIndex)];
                i += (fontRight.length);
                startIndex = 100000;
                saveString = NO;
            }
            else
            {
                i++;
            }
        }
    }
    
    for (NSInteger i = arr.count-1;i>=0; i--)
    {
        [attString replaceCharactersInRange:[arr[i] rangeValue] withString:@""];
    }
}

@end

//
//  User_DataModal.m
//  MBA
//
//  Created by sysweal on 13-11-12.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "User_DataModal.h"

@implementation User_DataModal

@synthesize userId_,img_,imgSmall_,imgMid_,imageData_,bImageLoad_,name_,uname_,intro_,motto_,firstName_,mobile_,tel_,dutyCode_,sex_,bday_,email_,eduId_,zym_,zye_,qq_,regionId_,gzNum_,hka_,school_,certNum_,postCode_,addr_,bSelected_,nickname_,company_,salary_,sendtime_,regiondetail_,age_,eduName_,prnd_,groupsCnt_,answerCnt_,fansCnt_,followCnt_,followStatus_,letterCnt_,publishCnt_,questionCnt_,role_,gpId_,job_,isExpert_,trade_,invitePerm_,publishPerm_,regionCity_,regionProvince_,regionHka_,languageLevel_,companyNature_,computerLevel_,companyAttenCnt_,emailId_,isGWTJ_,isPassed_,isOpen,companyModal_;

-(id) init
{
    self = [super init];
    companyModal_ = [[CompanyInfo_DataModal alloc] init];
    return self;
}

//如果内容为空,则返回@""
+(NSString *) processNULL:(NSString *)str
{
    if( !str ){
        return @"";
    }
    
    return str;
}

//获取内容,为空时返回"暂无"
+(NSString *) getVlaue:(NSString *)str
{
    if( !str || ![str isKindOfClass:[NSString class]] || [str isEqualToString:@""] || [str isEqualToString:@"null"] || [str isEqualToString:@"(null)"] ){
        return @"暂无";
    }
    
    return str;
}

//获取性别
+(NSString *) getSexStr:(NSString *)sex
{
    NSString *str = @"?";
    
    if( sex ){
        if( [sex isEqualToString:@"2"] ){
            str = @"女";
        }else if([sex isEqualToString:@"1"]){
            str = @"男";
        }
    }
    
    return str;
}

@end

@implementation ELOfferPeopleModel
    
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.id_ = value;
    }else{
        [super setValue:value forKey:key]; 
    }
}

@end

@implementation ELGWRecommentModel

-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.id_ = value;
    }else{
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [NSString stringWithFormat:@"%ld",(long)[value integerValue]];
        }
        [super setValue:value forKey:key]; 
    }
}

@end

@implementation ELGWSearchModel

-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.id_ = value;
    }else{
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [NSString stringWithFormat:@"%ld",(long)[value integerValue]];
        }
        [super setValue:value forKey:key]; 
    }
}

@end

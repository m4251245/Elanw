//
//  ELAspectantDiscuss_Modal.m
//  jobClient
//
//  Created by YL1001 on 15/9/6.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELAspectantDiscuss_Modal.h"

@implementation ELAspectantDiscuss_Modal

@synthesize recordId,YTZ_id,BYTZ_Id,status,dataTime,course_title,course_id,course_price,dis_personId,dis_personName,dis_nickname,dis_pic,dis_zw,course_info,course_long,course_status;

-(instancetype)initWithAspectantDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.phoneNum = dic[@"person_mobile"];
        self.recordId = dic[@"record_id"];
        self.YTZ_id = dic[@"person_id"];
        self.BYTZ_Id = dic[@"yuetan_person_id"];
        self.course_id = dic[@"course_id"];
        self.payStatus = dic[@"yuetan_pay_status"];
        
        self.status = dic[@"yuetan_status"];
        self.user_confirm = dic[@"confirm_person"];
        self.dis_confirm = dic[@"confirm_yuetan_person"];
        self.isInCome = dic[@"is_income"];
        self.dataTime = dic[@"idatetime"];
        self.isComment = dic[@"_is_comment"];
        
        self.question = dic[@"yuetan_question"];
        self.quizzerIntro = dic[@"yuetan_intro"];
        self.course_title = dic[@"course_info"][@"course_title"];
        self.course_price = dic[@"course_info"][@"course_price"];
        self.course_long = dic[@"course_info"][@"course_long"];
        
        if ([[Manager getUserInfo].userId_ isEqualToString:self.YTZ_id]) {
            self.user_personId = [Manager getUserInfo].userId_;
            self.user_name = [Manager getUserInfo].name_;
            self.user_pic = [Manager getUserInfo].img_;
            
            self.dis_personId = dic[@"_yuetan_person_detail"][@"personId"];
            self.dis_personName = dic[@"_yuetan_person_detail"][@"person_iname"];
            self.dis_pic = dic[@"_yuetan_person_detail"][@"person_pic"];
        }
        else
        {
            self.user_personId = dic[@"_person_detail"][@"personId"];
            self.user_name = dic[@"_person_detail"][@"person_iname"];
            self.user_pic = dic[@"_person_detail"][@"person_pic"];
            
            self.dis_personId = [Manager getUserInfo].userId_;
            self.dis_personName = [Manager getUserInfo].name_;
            self.dis_pic = [Manager getUserInfo].img_;
        }
        
        NSArray *regionArr = dic[@"_region_list"];
        if (![regionArr isEqual:[NSNull null]])
        {
            _regionArray = [[NSMutableArray alloc] init];
            
            for (NSDictionary *regionDic in regionArr)
            {
                ELAspectantDiscuss_Modal *modal = [[ELAspectantDiscuss_Modal alloc] init];
                modal.ydyrId = regionDic[@"ydyr_id"];
                modal.ydyrIsmain = regionDic[@"ydyr_ismain"];  //1已选择  0未选择地点
                modal.ydyrDatetime = regionDic[@"ydyr_datetime"];
                modal.ydrId = regionDic[@"ydr_id"];
                modal.region = regionDic[@"_region"];
                
                modal.region = [MyCommon translateHTML:modal.region];
                
                [_regionArray addObject:modal];
                if ([modal.ydyrIsmain isEqualToString:@"1"]) {
                    self.ydyrIsmain = modal.ydyrIsmain;
                    [_regionArray removeAllObjects];
                    [_regionArray addObject:modal];

                }
            }
        }
        
        @try {
            self.refund_id = dic[@"_refund_info"][@"refund_id"];
            self.ordco_id = dic[@"_refund_info"][@"ordco_id"];
            self.refund_reason = dic[@"_refund_info"][@"refund_reason"];
            self.refuse_reason = dic[@"_refund_info"][@"refuse_reason"];
            self.refund_status = dic[@"_refund_info"][@"status"];
            
            self.apply_idatetime = dic[@"_refund_info"][@"idatetime"];
            self.refuse_idatetime = dic[@"_refund_info"][@"refuse_idatetime"];
            self.acceptRefuseTime = dic[@"_refund_info"][@"accept_idatetime"];
            self.appeal_idatetime = dic[@"_refund_info"][@"shenshu_idatetime"];
            self.refund_idatetime = dic[@"_refund_info"][@"refund_idatetime"];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        self.question = [MyCommon translateHTML:self.question];
        self.quizzerIntro = [MyCommon translateHTML:self.quizzerIntro];
        self.course_title = [MyCommon translateHTML:self.course_title];
        self.refund_reason = [MyCommon translateHTML:self.refund_reason];
        self.refuse_reason = [MyCommon translateHTML:self.refuse_reason];
        self.user_name = [MyCommon translateHTML:self.user_name];
        self.dis_personName = [MyCommon translateHTML:self.dis_personName];
    }
    return self;
}

@end

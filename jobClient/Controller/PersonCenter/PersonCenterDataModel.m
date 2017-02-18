//
//  PersonCenterDataModel.m
//  jobClient
//
//  Created by 一览iOS on 14-10-29.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "PersonCenterDataModel.h"
#import "personTagModel.h"
#import "InterviewDataModel.h"

@implementation PersonCenterDataModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.photoListArray_ = [[NSMutableArray alloc] init];
        self.articleListArray_ = [[NSMutableArray alloc] init];
        self.tagListArray_ = [[NSMutableArray alloc] init];
        self.skillListArray_ = [[NSMutableArray alloc] init];
        self.fieldListArray_ = [[NSMutableArray alloc] init];
        self.visitListArray_ = [[NSMutableArray alloc] init];
        self.userModel_ = [[Expert_DataModal alloc] init];
        self.voiceModel_ = [[VoiceFileDataModel alloc] init];
        self.groupListArray_ = [[NSMutableArray alloc] init];
        self.interviewArray_ = [[NSMutableArray alloc] init];
        self.shareArticleArray_ = [[NSMutableArray alloc] init];
        self.badgeArray_ = [[NSMutableArray alloc] init];
        self.daShangPeopleArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)giveDataDicPerson:(NSDictionary *)dic
{
    NSDictionary *personInfoDic = [dic objectForKey:@"person_info"];
    NSArray *audioListArray = [dic objectForKey:@"audio_list"];
    NSArray *photoListArray = [dic objectForKey:@"photo_list"];
    //NSArray *articleListArray = [dic objectForKey:@"article_list"];
    //NSArray *tagListArray = [dic objectForKey:@"tag_label_list"];
    //NSArray *skillListArray = [dic objectForKey:@"tag_skill_list"];
    NSArray *fieldListArray = [dic objectForKey:@"tag_field_list"];
    //NSArray *badgelistArray = [dic objectForKey:@"badge_list"];
    // NSArray *shareArticleListArray = [dic objectForKey:@"share_list"];
    NSDictionary    *personDic = [dic objectForKey:@"login_person_info"];
    //个人信息
    self.goodTradeArr = dic[@"good_at_trade_list"];
    self.userModel_.good_at = personInfoDic[@"good_at"];
    
    if ([self.goodTradeArr isKindOfClass:[NSArray class]])
    {
        if (_goodTradeArr.count > 0)
        {
            self.userModel_.goodat_ = _goodTradeArr[0];
            for (NSInteger i = 1; i<_goodTradeArr.count; i++)
            {
                self.userModel_.goodat_ = [NSString stringWithFormat:@"%@,%@",self.userModel_.goodat_,_goodTradeArr[i]];
            }
        }
    }
    
    if ([[personInfoDic objectForKey:@"person_iname"] isKindOfClass:[NSString class]]) {
        self.userModel_.iname_ = [personInfoDic objectForKey:@"person_iname"];
    }else{
        self.userModel_.iname_ = @"";
    }
    
    if (self.userModel_.tradeId.length == 0)
    {
        self.userModel_.tradeId = [personInfoDic objectForKey:@"tradeid"];
    }
    if (self.userModel_.tradeName.length == 0)
    {
        self.userModel_.tradeName = [personInfoDic objectForKey:@"trade_name"];
    }
    if (self.userModel_.signature_.length == 0)
    {
        self.userModel_.signature_ = [personInfoDic objectForKey:@"person_signature"];
    }
    if (self.userModel_.job_.length == 0)
    {
        self.userModel_.job_ = [personInfoDic objectForKey:@"person_job_now"];
    }
    if (self.userModel_.zw_.length == 0)
    {
        self.userModel_.zw_ = [personInfoDic objectForKey:@"person_zw"];
    }
    if (self.userModel_.cityStr_.length == 0)
    {
        self.userModel_.cityStr_ = [personInfoDic objectForKey:@"person_region_name"];
    }
    if (self.userModel_.expertIntroduce_.length == 0)
    {
        self.userModel_.expertIntroduce_ = [personInfoDic objectForKey:@"person_intro"];
    }
    self.userModel_.yuetan_cnt = [personInfoDic[@"ytc_cnt"] integerValue];
    self.userModel_.is_shiming = personInfoDic[@"is_shiming"];
    self.userModel_.img_ = [personInfoDic objectForKey:@"person_pic"];
    self.userModel_.gznum_ = [personInfoDic objectForKey:@"person_gznum"];
    //self.userModel_.job_ = [personInfoDic objectForKey:@"person_job_now"];
    //self.userModel_.zw_ = [personInfoDic objectForKey:@"person_zw"];
    self.userModel_.age_ = [personInfoDic objectForKey:@"person_age"];
    //self.userModel_.cityStr_ = [personInfoDic objectForKey:@"person_region_name"];
    self.userModel_.sex_ = [personInfoDic objectForKey:@"person_sex"];
    //self.userModel_.signature_ = [personInfoDic objectForKey:@"person_signature"];
    self.userModel_.fansCnt_ = [[personInfoDic objectForKey:@"fans_count"] intValue];
    self.userModel_.followCnt_ = [[personInfoDic objectForKey:@"follow_count"] intValue];
    self.userModel_.followStatus_ = [[personInfoDic objectForKey:@"rel"] intValue];
    self.userModel_.publishCnt_ = [[personInfoDic objectForKey:@"publish_count"] intValue];
    self.userModel_.bday_ = [personInfoDic objectForKey:@"person_bday"];
    self.userModel_.is_jjr = [personInfoDic objectForKey:@"is_jjr"];
    self.userModel_.is_ghs = [personInfoDic objectForKey:@"is_ghs"];
    self.userModel_.is_pxs = [personInfoDic objectForKey:@"is_pxs"];
    self.userModel_.is_guWen = [personInfoDic objectForKey:@"is_guwen"];
    NSDictionary *loginPersonInfoDic =dic[@"login_person_info"];
    if ([loginPersonInfoDic isKindOfClass:[NSDictionary class]])
    {
        self.userModel_.myselfIsAgenter = loginPersonInfoDic[@"is_broker"];
        self.userModel_.myselfIsAgented = loginPersonInfoDic[@"is_entrust"];
    }
    self.userModel_.yuetabCnt_ = [[personInfoDic objectForKey:@"yuetan_count"] integerValue];
    self.userModel_.questionCnt_ = [[personInfoDic objectForKey:@"answer_count"] integerValue];
    self.userModel_.dashang_cnt = [personInfoDic[@"dashang_cnt"] integerValue];
    self.userModel_.wtc_cnt = [personInfoDic[@"wtc_cnt"] integerValue];
    self.userModel_.jobPeopleBackImage = personInfoDic[@"backphoto"];
    self.userModel_.has_jobs = [personInfoDic[@"has_jobs"] integerValue];
    if ([[personInfoDic objectForKey:@"is_expert"] isEqualToString:@"1"]) {
        self.userModel_.isExpert_ = YES;
    }else{
        self.userModel_.isExpert_ = NO;
    }
   // self.userModel_.expertIntroduce_ = [personInfoDic objectForKey:@"person_intro"];
    if ([[personInfoDic objectForKey:@"prestige_cnt"] isEqualToString:@""]) {
        self.userModel_.prestigeCnt = @"0";
    }else{
        self.userModel_.prestigeCnt = [personInfoDic objectForKey:@"prestige_cnt"];
    }
    if (![personDic isKindOfClass:[NSNull class]]) {
        self.userModel_.isSetAudio = [personDic objectForKey:@"is_set_audio"];
        self.userModel_.isSetPhoto = [personDic objectForKey:@"is_set_photo"];
    }
    if ([[personInfoDic objectForKey:@"group_invite"] isEqualToString:@"0"] || [[personInfoDic objectForKey:@"group_invite"] isEqualToString:@""]) {
        self.userModel_.haveInviteGroup = NO;
    }else{
        self.userModel_.haveInviteGroup = YES;
    }
    
    //打赏
    NSArray *dashangArr = dic[@"dashang_list"];
    if (![dashangArr isKindOfClass:[NSNull class]] && [dashangArr isKindOfClass:[NSArray class]])
    {
        [self.daShangPeopleArr removeAllObjects];
        for (NSDictionary *subDic in dashangArr) {
            personTagModel *model = [[personTagModel alloc] init];
            model.tagId_ = subDic[@"personId"];
            model.tagName_ = subDic[@"person_pic"];
            [self.daShangPeopleArr addObject:model];
        }
    }
    //语音信息
    if (![audioListArray isKindOfClass:[NSNull class]] && [audioListArray isKindOfClass:[NSArray class]]) {
        NSDictionary *audioListDic =  [audioListArray objectAtIndex:0];
        self.voiceModel_.voiceId_ = [audioListDic objectForKey:@"pa_id"];
        self.voiceModel_.voiceCateId_ = [audioListDic objectForKey:@"pmc_id"];
        self.voiceModel_.serverFilePath_ = [audioListDic objectForKey:@"pa_path"];
        self.voiceModel_.duration_ = [audioListDic objectForKey:@"pa_time"];
    }
    
    //图片信息
    if (![photoListArray isKindOfClass:[NSNull class]] && [photoListArray isKindOfClass:[NSArray class]]) {
        
         [self.photoListArray_ removeAllObjects];
        for (NSDictionary *photoListDic in photoListArray)
        {
            PhotoVoiceDataModel *photoModel = [[PhotoVoiceDataModel alloc] init];
            photoModel.photoId_ = [photoListDic objectForKey:@"pp_id"];
            photoModel.photoBigPath_ = [photoListDic objectForKey:@"pp_path"];
            photoModel.photoSmallPath140_ = [photoListDic objectForKey:@"pp_path_140_140"];
            [self.photoListArray_ addObject:photoModel];
        }
    }
    
//    //个性标签
//    if (![tagListArray isKindOfClass:[NSNull class]] && [tagListArray isKindOfClass:[NSArray class]]) {
//        [self.tagListArray_ removeAllObjects];
//        for (NSDictionary *tagListDic in tagListArray) {
//            personTagModel *tagModel = [[personTagModel alloc] init];
//            tagModel.tagId_ = [tagListDic objectForKey:@"ylt_id"];
//            tagModel.tagName_ = [MyCommon removeSpaceAtSides:[tagListDic objectForKey:@"ylt_name"]];
//            
//            [self.tagListArray_ addObject:tagModel];
//        }
//    }
//    
//    //想学技能
//    if (![skillListArray isKindOfClass:[NSNull class]] &&[skillListArray isKindOfClass:[NSArray class]]) {
//        [self.skillListArray_ removeAllObjects];
//        for (NSDictionary *tagListDic in skillListArray) {
//            personTagModel *tagModel = [[personTagModel alloc] init];
//            tagModel.tagId_ = [tagListDic objectForKey:@"ylt_id"];
//            tagModel.tagName_ = [MyCommon removeSpaceAtSides:[tagListDic objectForKey:@"ylt_name"]];
//           
//            [self.skillListArray_ addObject:tagModel];
//        }
//    }
    
    //擅长领域
    if (![fieldListArray isKindOfClass:[NSNull class]] && [fieldListArray isKindOfClass:[NSArray class]]) {
         [self.fieldListArray_ removeAllObjects];
        for (NSDictionary *tagListDic in fieldListArray) {
            personTagModel *tagModel = [[personTagModel alloc] init];
            tagModel.tagId_ = [tagListDic objectForKey:@"ylt_id"];
            tagModel.tagName_ = [MyCommon removeSpaceAtSides:[tagListDic objectForKey:@"ylt_name"]];
           
            [self.fieldListArray_ addObject:tagModel];
        }
    }

}

-(void)giveDataDicAbout:(NSDictionary *)dic
{
    NSArray *photoListArray = [dic objectForKey:@"photo_list"];
    NSArray *tagListArray = [dic objectForKey:@"tag_label_list"];
    NSArray *skillListArray = [dic objectForKey:@"tag_skill_list"];
    NSArray *fieldListArray = [dic objectForKey:@"tag_field_list"];
    NSDictionary *personInfoDic = [dic objectForKey:@"person_info"];
    
    if (self.userModel_.tradeId.length == 0)
    {
        self.userModel_.tradeId = [personInfoDic objectForKey:@"tradeid"];
    }
    if (self.userModel_.tradeName.length == 0)
    {
        self.userModel_.tradeName = [personInfoDic objectForKey:@"trade_name"];
    }
    if (self.userModel_.signature_.length == 0)
    {
        self.userModel_.signature_ = [personInfoDic objectForKey:@"person_signature"];
    }
    if (self.userModel_.job_.length == 0)
    {
        self.userModel_.job_ = [personInfoDic objectForKey:@"person_job_now"];
    }
    if (self.userModel_.zw_.length == 0)
    {
        self.userModel_.zw_ = [personInfoDic objectForKey:@"person_zw"];
    }
    if (self.userModel_.cityStr_.length == 0)
    {
        self.userModel_.cityStr_ = [personInfoDic objectForKey:@"person_region_name"];
    }
    if (self.userModel_.expertIntroduce_.length == 0)
    {
        self.userModel_.expertIntroduce_ = [personInfoDic objectForKey:@"person_intro"];
    }
    
    //图片信息
    if (![photoListArray isKindOfClass:[NSNull class]] && [photoListArray isKindOfClass:[NSArray class]]) {
        [self.photoListArray_ removeAllObjects];
        for (NSDictionary *photoListDic in photoListArray) {
            PhotoVoiceDataModel *photoModel = [[PhotoVoiceDataModel alloc] init];
            photoModel.photoId_ = [photoListDic objectForKey:@"pp_id"];
            photoModel.photoBigPath_ = [photoListDic objectForKey:@"pp_path"];
            photoModel.photoSmallPath140_ = [photoListDic objectForKey:@"pp_path_140_140"];
            
            [self.photoListArray_ addObject:photoModel];
        }
    }
    //个性标签
    if (![tagListArray isKindOfClass:[NSNull class]] && [tagListArray isKindOfClass:[NSArray class]]) {
       [self.tagListArray_ removeAllObjects];
        for (NSDictionary *tagListDic in tagListArray) {
            personTagModel *tagModel = [[personTagModel alloc] init];
            tagModel.tagId_ = [tagListDic objectForKey:@"ylt_id"];
            tagModel.tagName_ = [MyCommon removeSpaceAtSides:[tagListDic objectForKey:@"ylt_name"]];
            
            [self.tagListArray_ addObject:tagModel];
        }
    }
    
    //想学技能
    if (![skillListArray isKindOfClass:[NSNull class]] &&[skillListArray isKindOfClass:[NSArray class]]) {
          [self.skillListArray_ removeAllObjects];
        for (NSDictionary *tagListDic in skillListArray) {
            personTagModel *tagModel = [[personTagModel alloc] init];
            tagModel.tagId_ = [tagListDic objectForKey:@"ylt_id"];
            tagModel.tagName_ = [MyCommon removeSpaceAtSides:[tagListDic objectForKey:@"ylt_name"]];
          
            [self.skillListArray_ addObject:tagModel];
        }
    }
    
    //擅长领域
    if (![fieldListArray isKindOfClass:[NSNull class]] && [fieldListArray isKindOfClass:[NSArray class]]) {
       [self.fieldListArray_ removeAllObjects];
        for (NSDictionary *tagListDic in fieldListArray) {
            personTagModel *tagModel = [[personTagModel alloc] init];
            tagModel.tagId_ = [tagListDic objectForKey:@"ylt_id"];
            tagModel.tagName_ = [MyCommon removeSpaceAtSides:[tagListDic objectForKey:@"ylt_name"]];
            
            [self.fieldListArray_ addObject:tagModel];
        }
    }
    
    NSArray *interviewArray = [dic objectForKey:@"app_exam"];
   
    //我的小编专访
    if (![interviewArray isKindOfClass:[NSNull class]])
    {
         [self.interviewArray_ removeAllObjects];
        for (NSDictionary *interviewDic in interviewArray) {
            InterviewDataModel *interviewModel = [[InterviewDataModel alloc]init];
            interviewModel.id_ = [interviewDic objectForKey:@"shitiid"];
            interviewModel.question_ = [interviewDic objectForKey:@"title"];
            interviewModel.answer_ = [interviewDic objectForKey:@"daan"];
            [self.interviewArray_ addObject:interviewModel];
        }
    }

}


@end

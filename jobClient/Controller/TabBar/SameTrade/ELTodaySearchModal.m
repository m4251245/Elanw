//
//  ELTodaySearchModal.m
//  jobClient
//
//  Created by 一览iOS on 15/10/22.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELTodaySearchModal.h"

@implementation ELTodaySearchModal

-(instancetype)initExpertModelWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _personId = dic[@"personId"];
        _person_pic = dic[@"person_pic"];
        _person_iname = dic[@"person_iname"];
        _person_zw = dic[@"person_zw"];
        _person_job_now = dic[@"person_job_now"];
        _person_gznum = dic[@"person_gznum"];
        _is_expert = dic[@"is_expert"];
        _modelType = ExpertSearchType;
        
        _attStringTitle = [[NSMutableAttributedString alloc] initWithString:_person_iname];
        [self changeColor:_attStringTitle];
        
        NSString *str = @"职业/头衔：";
        if(_person_zw.length > 0)
        {
            str = [NSString stringWithFormat:@"%@%@",str,_person_zw];
        }
        else if (_person_job_now.length > 0)
        {
            str = [NSString stringWithFormat:@"%@%@",str,_person_job_now];
        }
        _attStringContent = [[NSMutableAttributedString alloc] initWithString:str];
        [self changeColor:_attStringContent];
    }
    return self;
}

-(instancetype)initSameTradeModelWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _personId = dic[@"personId"];
        _person_pic = dic[@"person_pic"];
        _person_iname = dic[@"person_iname"];
        _person_zw = dic[@"person_zw"];
        _person_job_now = dic[@"person_job_now"];
        _person_gznum = dic[@"person_gznum"];
        _is_expert = dic[@"is_expert"];
        _modelType = SameTradeSearchType;
        
        _attStringTitle =[[NSMutableAttributedString alloc] initWithString:_person_iname];
        [self changeColor:_attStringTitle];
        
        NSString *str = @"";
        if(_person_zw.length > 0)
        {
            str = _person_zw;
        }
        else if (_person_job_now.length > 0)
        {
            str = _person_job_now;
        }
        NSInteger workAge = [_person_gznum integerValue];
        NSString *workAgeStr = @"";
        if (workAge > 0) {
            workAgeStr = [NSString stringWithFormat:@"%ld年工作经验",(long)[_person_gznum integerValue]];
        }else{
            workAgeStr = @"工作经验保密";
        }
        
        if (_person_gznum.length > 0){
            if (str.length > 0){
                str = [NSString stringWithFormat:@"%@|%@",str,workAgeStr];
            }else{
                str = workAgeStr;            
            }
        }
        _attStringContent = [[NSMutableAttributedString alloc] initWithString:str];
        [self changeColor:_attStringContent];
    }
    return self;
}

-(instancetype)initArticleModalWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _article_id = dic[@"article_id"];
        _title = dic[@"title"];
        _thumb = dic[@"thumb"];
        _summary = dic[@"summary"];
        _ctime = dic[@"ctime"];
        
        NSDictionary *personDic = dic[@"_person_detail"];
        if ([personDic isKindOfClass:[NSDictionary class]])
        {
            _personId = personDic[@"personId"];
            _person_pic = personDic[@"person_pic"];
            _person_iname = personDic[@"person_iname"];
            _person_nickname = personDic[@"person_nickname"];
            _person_pic_personality = personDic[@"person_pic_personality"];
        }
        _modelType = ArticleSearchType;
        if (_title.length > 0)
        {
            _attStringTitle = [_title getHtmlAttStringWithFont:FIFTEENFONT_TITLE color:nil];
            //[self changeColor:_attStringTitle];
        }
    }
    return self;
}

-(instancetype)initGroupModalWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _modelType = GroupSearchType;
        
        _group_id = dic[@"group_id"];
        _group_name = dic[@"group_name"];
        _group_pic = dic[@"group_pic"];
        _group_person_cnt = dic[@"group_person_cnt"];
        _group_article_cnt = dic[@"group_article_cnt"];
        _openstatus = dic[@"group_open_status"];
        _group_updatetime_last = dic[@"updatetime_act_last"];
        
        NSDictionary *relDic = dic[@"group_user_rel"];
        if ([relDic isKindOfClass:[NSDictionary class]]) {
            _group_user_rel = relDic[@"code"];
        }
        
        NSDictionary *personDic = dic[@"group_person_detail"];
        NSArray *articleArr = dic[@"_article"];
        
        
        if ([personDic isKindOfClass:[NSDictionary class]])
        {
            _personId = personDic[@"personId"];
            _person_iname = personDic[@"person_iname"];
        }
        
        if ([articleArr isKindOfClass:[NSArray class]])
        {
            NSDictionary *articleDic;
            if(articleArr.count > 0)
            {
                articleDic = articleArr[0];
            }
            _article_id = articleDic[@"article_id"];
            _title = articleDic[@"title"];
            _own_id = articleDic[@"own_id"];
            NSDictionary *personDetailDic = articleDic[@"_person_detail"];
            NSArray *comment = articleDic[@"_comment"];
            if ([personDetailDic isKindOfClass:[NSDictionary class]])
            {
                _public_personId = personDetailDic[@"personId"];
                _public_person_pic = personDetailDic[@"person_pic"];
                _public_person_iname = personDetailDic[@"person_iname"];
                _public_person_zw = personDetailDic[@"person_zw"];
                if (_public_person_iname.length > 0 && _title.length > 0)
                {
                    _articleListContent = [NSString stringWithFormat:@"%@发表了:%@",_public_person_iname,_title];
                }
            }
            if ([comment isKindOfClass:[NSArray class]])
            {
                if (comment.count > 0)
                {
                    NSDictionary *commentDic = comment[0];
                    _commentId = commentDic[@"id"];
                    _comment_article_id = commentDic[@"article_id"];
                    _comment_user_id = commentDic[@"user_id"];
                    _comment_parent_id = commentDic[@"parent_id"];
                    _comment_content = commentDic[@"content"];
                    _comment_ctime = commentDic[@"ctime"];
                    NSDictionary *commentPersonDic = commentDic[@"_person_detail"];
                    if ([commentPersonDic isKindOfClass:[NSDictionary class]])
                    {
                        _comment_personId = commentPersonDic[@"personId"];
                        _comment_person_pic = commentPersonDic[@"person_pic"];
                        _comment_person_iname = commentPersonDic[@"person_iname"];
                        if (_comment_person_iname.length > 0 && _title.length > 0)
                        {
                            _articleListContent = [NSString stringWithFormat:@"%@评论了:%@",_comment_person_iname,_title];
                        }
                    }
                    
                }
            }
        }
        _group_name = [MyCommon translateHTML:_group_name];
        _articleListContent = [MyCommon translateHTML:_articleListContent];
        if (_group_name.length > 0)
        {
            if ([_group_name containsString:@"<font color=red>"]) {
                _attStringTitle = [[NSMutableAttributedString alloc] initWithString:_group_name];
               [self changeColor:_attStringTitle]; 
            }
        }
    }
    return self;
}

-(instancetype)initOfferModalWithDictionary:(NSDictionary *)dataDic
{
    self = [super init];
    if (self)
    {
        self.offerModal = [[OfferPartyTalentsModel alloc]init];
        [self.offerModal setValuesForKeysWithDictionary:dataDic];
        _modelType = OfferSearchType;
    }
    return self;
}

-(instancetype)initPositionModelWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _jobModel = [[NewJobPositionDataModel alloc] init];
        [_jobModel setValuesForKeysWithDictionary:dic];   
        _modelType = JobSearchType;
//        @try {
//            _jobModel.zwID_ = [dic objectForKey:@"id"];
//            _jobModel.jtzw_ = [dic objectForKey:@"jtzw"];
//            _jobModel.companyID_ = [dic objectForKey:@"uid"];
//            _jobModel.companyName_ =[dic objectForKey:@"cname"];
//            _jobModel.cnameAll_ = [dic objectForKey:@"cname_all"];
//            _jobModel.regionName_ = [dic objectForKey:@"regionname"];
//            _jobModel.updateTime_ = [dic objectForKey:@"updatetime"];
//            _jobModel.salary_ = [dic objectForKey:@"xzdy"];
//            _jobModel.welfareArray_ = [dic objectForKey:@"fldy"];
//            _jobModel.companyLogo_ = [dic objectForKey:@"logo"];
//            _jobModel.zptype = [dic objectForKey:@"zptype"];
//            _jobModel.gznum_ = [MyCommon removeAllSpace:[dic objectForKey:@"gznum"]];
//            
//            _jobModel.edu_ = [dic objectForKey:@"edus"];
//            _jobModel.count_ = [dic objectForKey:@"zpnum"];
//            NSString * str = [dic objectForKey:@"is_ky"];
//            if ([str isEqualToString:@"2"]) {
//                _jobModel.isKy_ = YES;
//            }
//            else
//                _jobModel.isKy_ = NO;
//        }
//        @catch (NSException *exception) {
//            
//        }
    }
    return self;
}

-(void)changeColor:(NSMutableAttributedString *)attString withKeyWork:(NSString *)text{
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
    }else if ([attString.string rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound){
        for (NSInteger i = 0; i<=(attString.string.length-text.length) ;i++)
        {
            NSString *str = [attString.string substringWithRange:NSMakeRange(i,text.length)];
            if ([str rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i,text.length)];
            }
        }
    }
    
    for (NSInteger i = arr.count-1;i>=0; i--)
    {
        [attString replaceCharactersInRange:[arr[i] rangeValue] withString:@""];
    }
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
        for (NSInteger i = arr.count-1;i>=0; i--)
        {
            [attString replaceCharactersInRange:[arr[i] rangeValue] withString:@""];
        }
    }
}

@end

//
//  Article_DataModal.m
//  Association
//
//  Created by 一览iOS on 14-1-15.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "Article_DataModal.h"
#import "YLMediaModal.h"

@implementation Article_DataModal
@synthesize personID_,personName_,commentContent_,commentpersonName_,fileDownloadCnt_,fileGrade_,fileHtmlPath_,fileId_,fileName_,filePages_,filePath_,fileSize_,fileUrl_,fileExe_,articleType_,isarticle_,commentPersonImg1_,commentPersonImg2_,commentPersonImg3_,commentArr_,zhiyeId_,zhiyeName_,zwArr_,groupId_,groupName_,grouppersonId_,grouppersonIname_,groupPic_,imageArray_;

-(id)init
{
    self = [super init];
    if (self) {
        commentArr_ = [[NSMutableArray alloc] init];
        imageArray_ =  [[NSMutableArray alloc] init];
    }
    return self;
}

-(instancetype)initWithGroupArticleListDictionary:(NSDictionary *)dic
{
    self = [self init];
    if (self)
    {
        NSString *type = dic[@"info_type"];
        if ([type isEqualToString:@"join_person"])
        {
            self.typeName = type;
            NSArray *personListArr = dic[@"person_list"];
            if ([personListArr isKindOfClass:[NSArray class]])
            {
                self.likeImageArr = [[NSMutableArray alloc] init];
                for (NSDictionary *agreeDic in personListArr)
                {
                    Expert_DataModal *modal = [[Expert_DataModal alloc] init];
                    modal.id_ = [agreeDic objectForKey:@"person_id"];
                    modal.iname_ = [agreeDic objectForKey:@"person_name"];
                    modal.img_ = [agreeDic objectForKey:@"person_pic"];
                    [self.likeImageArr addObject:modal];
                }
            }
            NSDictionary *groupDic = dic[@"_group_info"];
            if ([groupDic isKindOfClass:[NSDictionary class]])
            {
                self.groupId_ = groupDic[@"group_id"];
                self.groupName_ = groupDic[@"group_name"];
            }
        }
        else if([type isEqualToString:@"group_article"])
        {
            self.typeName = type;
            self.id_ = [dic objectForKey:@"article_id"];
            self.title_ = [dic objectForKey:@"title"];
            self.commentCount_ = [[dic objectForKey:@"c_cnt"] integerValue];
            self.likeCount_ = [[dic objectForKey:@"like_cnt"] integerValue];
            self.content_  = [dic objectForKey:@"summary"];
            self.status = dic[@"sstatus"];
            self.groupId_ = dic[@"qi_id"];
            
            if ([[dic objectForKey:@"_pic_list"] isKindOfClass:[NSArray class]])
            {
                self.imageArray_ = [dic objectForKey:@"_pic_list"];
            }
            
            NSDictionary *expertDic = [dic objectForKey:@"_person_detail"];
            NSDictionary *groupDic = dic[@"_group_info"];
            NSArray *commentArr = dic[@"_comment_list"];
            NSArray *agreeArr = nil; //dic[@"_agree_list"];
            
            if ([expertDic isKindOfClass:[NSDictionary class]])
            {
                self.expert_ = [[Expert_DataModal alloc] init];
                self.expert_.id_ = [expertDic objectForKey:@"personId"];
                self.expert_.iname_ = [expertDic objectForKey:@"person_iname"];
                self.expert_.nickname_ = [expertDic objectForKey:@"person_nickname"];
                self.expert_.img_ = [expertDic objectForKey:@"person_pic"];
                self.expert_.zw_ = [expertDic objectForKey:@"person_zw"];
                self.expert_.isExpert_ = [[expertDic  objectForKey:@"is_expert"] boolValue];
            }
            if ([groupDic isKindOfClass:[NSDictionary class]])
            {
                self.groupId_ = groupDic[@"group_id"];
                self.groupName_ = groupDic[@"group_name"];
            }
            if ([commentArr isKindOfClass:[NSArray class]])
            {
                for (NSDictionary *commentDic in commentArr)
                {
                    Comment_DataModal * commentModal = [[Comment_DataModal alloc] init];
                    commentModal.id_ = [commentDic objectForKey:@"id"];
                    commentModal.userId_ = [commentDic objectForKey:@"user_id"];
                    commentModal.content_ = [commentDic objectForKey:@"content"];
                    commentModal.userName_ = commentDic[@"user_name"];
                    NSString *str = commentDic[@"parent_id"];
                    if (str.length > 5) {
                        commentModal.parent_ = [[Comment_DataModal alloc] init];
                        commentModal.parent_.id_ = commentDic[@"parent_id"];
                        commentModal.parent_.userName_ = commentDic[@"parent_name"];
                    }
                    [self.commentArr_ addObject:commentModal];
                }
            }
            if ([agreeArr isKindOfClass:[NSArray class]])
            {
                self.likeImageArr = [[NSMutableArray alloc] init];
                for (NSDictionary *agreeDic in agreeArr)
                {
                    Expert_DataModal *modal = [[Expert_DataModal alloc] init];
                    modal.id_ = [agreeDic objectForKey:@"personId"];
                    modal.iname_ = [agreeDic objectForKey:@"person_iname"];
                    modal.nickname_ = [agreeDic objectForKey:@"person_nickname"];
                    modal.img_ = [agreeDic objectForKey:@"person_pic"];
                    modal.zw_ = [agreeDic objectForKey:@"person_zw"];
                    [self.likeImageArr addObject:modal];
                }
            }
        }
    }
    return self;
}

-(instancetype)initWithArticleDetailDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) 
    {
        NSDictionary * dataDic = [dic objectForKey:@"data"];
        
        if([dataDic isKindOfClass:[NSDictionary class]]){
            NSArray *_pic_list = [dataDic objectForKey:@"_pic_list"];
            if ([_pic_list isKindOfClass:[NSArray class]]) {
                self.articleImgArray = [[NSMutableArray alloc] initWithArray:_pic_list];
            }
            self.content_ = [dataDic objectForKey:@"content"];
            self.content_ = [MyCommon convertHTML:self.content_];
            self.updatetime_ = [dataDic objectForKey:@"ctime"];
            self.articleStatus = dataDic[@"status"];
            self.updatetime_ = [MyCommon getDateStrFromTimestamp:self.updatetime_];
            self.personName_ = [[dataDic objectForKey:@"person_detail"] objectForKey:@"person_iname"];
            self.title_ = [dataDic objectForKey:@"title"];
            self.viewCount_ = [[dataDic objectForKey:@"v_cnt"] integerValue];
            self.commentCount_ = [[dataDic objectForKey:@"c_cnt"] integerValue];
            self.summary_ = [dataDic objectForKey:@"summary"];
            self.thum_ = [dataDic objectForKey:@"thumb"];
            self.isFavorite = [[dataDic objectForKey:@"_is_favorite"] boolValue];
            self.likeCount_ = [[dataDic objectForKey:@"like_cnt"] integerValue];
            self.dicJoinName = [dataDic objectForKey:@"_activity_info"];
            
            if ([self.dicJoinName isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = self.dicJoinName[@"info"][@"info"];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    self._activity_info = [[ELActivityModel alloc] initWithDictionary:dic];
                }
            }
            NSString *isMaJia = dataDic[@"_is_majia"];
            if ([isMaJia isEqualToString:@"1"]) {
                self.isRealName = NO;
            }
            else
            {
                self.isRealName = YES;
            }
            NSDictionary *_group_info = [dataDic objectForKey:@"_group_info"];
            if ([_group_info isKindOfClass:[NSDictionary class]]) {
                self.groupId_ = dataDic[@"_group_info"][@"group_id"];
                self.groupName_ = dataDic[@"_group_info"][@"group_name"];
                self.group_open_status = dataDic[@"_group_info"][@"group_open_status"];
            }
            
            @try {
                if ([dataDic[@"_media"] isKindOfClass:[NSArray class]]) {
                    self.arrMedia = [[NSMutableArray alloc] init];
                    for (NSDictionary *dicOne in dataDic[@"_media"])
                    {
                        YLMediaModal *modalOne = [[YLMediaModal alloc] initWithDictionary:dicOne];
                        
                        if ([modalOne.postfix.lowercaseString isEqualToString:@"jpg"] || [modalOne.postfix.lowercaseString isEqualToString:@"png"] || [modalOne.postfix.lowercaseString isEqualToString:@"jpeg"] || [modalOne.postfix.lowercaseString isEqualToString:@"gif"] ||[modalOne.postfix.lowercaseString isEqualToString:@"bmp"])
                        {
                            [self.arrMedia addObject:modalOne];
                        }
                        else
                        {
                            if(modalOne.file_swf.length > 0)
                            {
                                [self.arrMedia addObject:modalOne];
                            }
                        }
                    }
                }

            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            @try {
                if ([dataDic objectForKey:@"_group_source"]) {
                    self.groupSource = [dataDic objectForKey:@"_group_source"];
                    self.majiaName = [[dataDic objectForKey:@"_majia_info"] objectForKey:@"person_iname"];
                    self.majiaPic = [[dataDic objectForKey:@"_majia_info"] objectForKey:@"person_pic"];
                    self.majiaId = [[dataDic objectForKey:@"_majia_info"] objectForKey:@"personId"];
                }

            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            @try {
                if ([dataDic objectForKey:@"zhiwei"]) {
                    NSArray * zwArr = [dataDic objectForKey:@"zhiwei"];
                    if ([zwArr isKindOfClass:[NSArray class]]) {
                        self.zwArr_ = [[NSMutableArray alloc] init];
                        for (NSDictionary * zwDic in zwArr) {
                            ZWDetail_DataModal * zwModal = [[ZWDetail_DataModal alloc] init];
                            
                            zwModal.jtzw_ = [zwDic objectForKey:@"jtzw"];
                            zwModal.zwID_ = [zwDic objectForKey:@"id"];
                            zwModal.regionId_ = [zwDic objectForKey:@"regionid"];
                            zwModal.regionName_ = [zwDic objectForKey:@"region_name"];
                            zwModal.companyName_ = [zwDic objectForKey:@"cname_all"];
                            zwModal.companyLogo_ = [zwDic objectForKey:@"logopath"];
                            zwModal.companyID_ = [zwDic objectForKey:@"uid"];
                            [self.zwArr_ addObject:zwModal];
                        }
                    }
                }
                
            }
            @catch (NSException *exception) {
                self.zwArr_ = nil;
            }
            @finally {
                
            }
            
            @try {
                if ([[dataDic objectForKey:@"other_article"] isKindOfClass:[NSArray class]])
                {
                    NSArray * articleArr = [dataDic objectForKey:@"other_article"];
                    self.otherArticleArr_ = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary * artDic in articleArr) {
                        Article_DataModal * artModal = [[Article_DataModal alloc] init];
                        artModal.id_ = [artDic objectForKey:@"article_id"];
                        artModal.title_ = [artDic objectForKey:@"title"];
                        artModal.thum_ = [artDic objectForKey:@"thumb"];
                        
                        [self.otherArticleArr_ addObject:artModal];
                    }
                }
            }
            @catch (NSException *exception) {
                self.otherArticleArr_ = nil;
            }
            @finally {
                
            }
        }
    }
    return self;
}

-(void)setId_:(NSString *)id_
{
    super.id_ = id_;
    _isLike_ = [Manager getIsLikeStatus:id_];
}

-(void)setIsLike_:(BOOL)isLike_
{
    if (!_isLike_) {
        _isLike_ = isLike_;
    }
}

@end

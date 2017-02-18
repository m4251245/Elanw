//
//  Comment_DataModal.m
//  MBA
//
//  Created by sysweal on 13-11-20.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "Comment_DataModal.h"

@implementation Comment_DataModal

@synthesize id_,userId_,objectId_,datetime_,content_,next_,cellHeight_,imageData_,bImageLoad_,parent_,parentId,author,childList_,userName_,imageUrl_,nickName_,objectTitle_,bRead_;

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        childList_  = [[NSMutableArray alloc] init];
        cellHeight_ = 0;
        self.id_ = [dic objectForKey:@"id"];
        self.objectId_ = dic[@"_article_info"][@"article_id"];
        self.objectTitle_ = dic[@"_article_info"][@"title"];
        self.content_ = [dic objectForKey:@"content"];
        self.bRead_ = [[dic objectForKey:@"_is_new"] boolValue];
        self.datetime_ = [dic objectForKey:@"ctime"];
        self.parentId = dic[@"parent_id"];
        self.userId_ = dic[@"_person_detail"][@"personId"];
        self.userName_ = dic[@"_person_detail"][@"person_iname"];
        self.imageUrl_ = dic[@"_person_detail"][@"person_pic"];
        self.nickName_ = dic[@"_person_detail"][@"person_nickname"];
        self.articleType = dic[@"_article_info"][@"_is_gxs"];
        NSDictionary *parentDic = dic[@"_parent_comment"];
        if ([parentDic isKindOfClass:[NSDictionary class]])
        {
            NSString *content = parentDic[@"content"];
            if (content.length > 0) {
                self.parentContent = content;
            }
        }
        self.content_ = [MyCommon translateHTML:self.content_];
        self.nickName_ = [MyCommon translateHTML:self.nickName_];
        self.objectTitle_ = [MyCommon translateHTML:self.objectTitle_];
        self.userName_ = [MyCommon translateHTML:self.userName_];
    }
    return self;
}

@end

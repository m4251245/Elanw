//
//  News_DataModal.m
//  Association
//
//  Created by 一览iOS on 14-1-8.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "News_DataModal.h"

@implementation News_DataModal
@synthesize type_,id_,title_,author_,catId_,commentCount_,likeCount_,viewCount_,updatetime_,lastCommenttime_,ownname_,imageData_,bImageLoad_,content_,summary_,idatetime_,thum_,xw_type_,url_;


-(id)init
{
    self = [super init];
    if (self) {
        _articleImgArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

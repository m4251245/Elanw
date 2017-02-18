//
//  ShareMessageModal.m
//  jobClient
//
//  Created by 一览iOS on 15-5-13.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ShareMessageModal.h"

@implementation ShareMessageModal

-(void)setDataWithModal:(Article_DataModal *)modal
{
    if(modal.id_.length > 0)
    {
        self.article_id = modal.id_;
    }
    else
    {
        self.article_id = @"";
    }
    if (modal.summary_.length > 0) {
        self.article_summary = modal.summary_;
    }
    else
    {
        self.article_summary = @"";
    }
    
    if (modal.thum_.length > 0) {
        self.article_thumb = modal.thum_;
    }
    else
    {
        self.article_thumb = @"";
    }
    
    if (modal.title_.length > 0) {
        self.article_title = modal.title_;
    }
    else
    {
        self.article_title = @"";
    }

}

@end

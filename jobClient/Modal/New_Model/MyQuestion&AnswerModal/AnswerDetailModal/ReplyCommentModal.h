//
//  ReplyCommentModal.h
//  jobClient
//
//  Created by YL1001 on 16/6/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ReplyCommentModal : PageInfo

/*
 问答详情回答列表的回复
 */

@property (nonatomic, copy) NSString *comment_id;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *comment_content;
@property (nonatomic, copy) NSString *parentid;

//_person_detail
@property (nonatomic, copy) NSString *person_pic;
@property (nonatomic, copy) NSString *person_iname;
@property (nonatomic, copy) NSString *personId;

//_parent_person_detail
@property (nonatomic, copy) NSString *parent_person_pic;
@property (nonatomic, copy) NSString *parent_person_iname;
@property (nonatomic, copy) NSString *parent_personId;

@property (nonatomic,strong) NSMutableAttributedString *contentAttString;
@property (nonatomic,assign) CGRect contentFrame;

@end

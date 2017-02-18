//
//  GroupPermission_DataModal.h
//  Association
//
//  Created by YL1001 on 14-5-29.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupPermission_DataModal : NSObject

@property(nonatomic,strong) NSString * groupId_;
@property(nonatomic,assign) NSInteger        joinStatus_;
@property(nonatomic,assign) NSInteger        publishStatus_;
@property(nonatomic,assign) NSInteger        inviteStatus_;
@property(nonatomic,strong) NSMutableArray * publishArr_;
@property(nonatomic,strong) NSMutableArray * InviteArr_;

@property(nonatomic,copy) NSString *group_id;
@property(nonatomic,copy) NSString *group_open_status;
@property(nonatomic,copy) NSString *gs_topic_publish;
@property(nonatomic,copy) NSString *gs_member_invite;
@property(nonatomic,copy) NSString *gs_view_content;
@property(nonatomic,strong) NSMutableArray *_topic_publish_list;
@property(nonatomic,strong) NSMutableArray *_member_invite_list;

-(instancetype)initWithDictionary:(NSDictionary *)subDic;

@end

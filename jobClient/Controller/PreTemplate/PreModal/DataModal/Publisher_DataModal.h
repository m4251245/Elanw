//
//  Publisher_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 13-3-11.
//
//

#import "PageInfo.h"

//消息发布者类型
typedef enum
{
    SysLoginPublisherType           = -200,     //系统登录类型(自己处理)
    SysAddAttentionPublisherType    = -100,     //系统添加关注学校类型(自己处理)
    SysPublisherType                = 10,
    SchoolPublisherType             = 20,
}PublisherType;

@interface Publisher_DataModal : PageInfo
{
    NSString                *id_;
    PublisherType           publisherIdType_;
    NSString                *name_;
    NSString                *pic_;
    NSString                *title_;
    NSString                *dateDes_;
    int                     newMsgCnt_;
    
    BOOL                    bImageLoad_;
    NSData                  *imageData_;
}

@property(nonatomic,retain) NSString                *id_;
@property(nonatomic,assign) PublisherType           publisherIdType_;
@property(nonatomic,retain) NSString                *name_;
@property(nonatomic,retain) NSString                *pic_;
@property(nonatomic,retain) NSString                *title_;
@property(nonatomic,retain) NSString                *dateDes_;
@property(nonatomic,assign) int                     newMsgCnt_;
@property(nonatomic,assign) BOOL                    bImageLoad_;
@property(nonatomic,retain) NSData                  *imageData_;


@end

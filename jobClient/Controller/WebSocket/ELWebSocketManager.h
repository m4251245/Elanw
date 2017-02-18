//
//  ELWebSocketManager.h
//  jobClient
//
//  Created by YL1001 on 16/12/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

// 聊天状态
typedef NS_ENUM(NSInteger, ELWebSocketStatus) {
    ELWebSocketStatusOpen           = 1 << 1,  // 与服务器连接成功
    ELWebSocketStatusClose          = 1 << 2,  // 与服务器断开连接
    ELWebSocketStatusLogin          = 1 << 3,  // 已登录
    ELWebSocketStatusLogOffByServer = 1 << 4,  // 已下线
    ELWebSocketStatusLogOffByUser   = 1 << 5   // 用户自己下线
};

@class ELWebSocketManager;
@protocol ELWebSocketManagerDelegate <NSObject>

@optional
//与服务器连接状态变化回调
- (void)chatManager:(ELWebSocketManager *)manager didReceiceWSStatuChange:(ELWebSocketStatus)status;

//发送文本的回调
- (void)chatManager:(ELWebSocketManager *)manager didSendMessage:(NSDictionary *)messageDic;

//收到消息回调<文本消息，语音消息，图片消息，系统消息...>
- (void)chatManager:(ELWebSocketManager *)manager didReceiceMessage:(NSDictionary *)messageDic;

@end

@interface ELWebSocketManager : NSObject

@property (nonatomic, assign) ELWebSocketStatus status;
@property (nonatomic, weak) id<ELWebSocketManagerDelegate> delegate;

/**
 * @brief   聊天管理类对象
 *
 * @return  SRChatManager
 */
+ (instancetype)defaultManager;

/**
 * @brief   建立连接
 *
 * @return
 */
- (void)openServer;

/**
 * @brief   关闭连接
 *
 * @return
 */
- (void)closeServer;

/**
 * @brief   发送文本消息 群聊
 *
 * @param
 * message        文本消息
 * groupModel     社群信息
 * topicId        话题Id
 * tagId          简历评价标签（招聘社群才有）
 * qiId           是否 是招聘文章还是普通文章
 * parentId       话题回复别人评论时才用到
 * CommentType    信息类型 1表示纯文本 3表示富文本
 * contentType    当CommentType=1时，该值为1，表示纯文本； 当CommentType=1时，4表示图片，5表示语音，10表示社群，11表示文章，20表示职位，25表示简历
 * @return
 */
- (void)sendMessage:(NSString *)message GroupModel:(ELGroupDetailModal *)groupModel TopicId:(NSString *)topicId TagId:(NSString *)tagId QiId:(NSString *)qiId ParentId:(NSString *)parentId CommentType:(NSString *)commentType ContentType:(NSString *)contentType share:(NSString *)share;


@end

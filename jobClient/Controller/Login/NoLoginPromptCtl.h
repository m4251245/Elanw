//
//  NoLoginPromptCtl.h
//  jobClient
//
//  Created by 一览iOS on 15-4-28.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LoginType_None = 0,
    LoginType_Answer_button = 1,//问答首页卡片回答
    LoginType_Set_Question,//问答首页提问
    LoginFollow_Today_Recomment,//今日看点顶部按钮
    LoginFollow_Today_Add,//今日看点“+”
    LoginFollow_AnswerDetail,//问答详情
    LoginType_Dasang,      //打赏
    LoginType_ArticleComment, //文章评论
    LoginType_ArticleRefresh, //文章详情刷新
    LoginType_GroupDetailPublish, //社群详情发表按钮
    LoginType_Chat,         //约谈
    LoginType_CreatGroup,   //社群首页创建社群
    LoginType_RewardBottom,  //打赏底部按钮
    LoginType_OA,  //OA
    LoginType_PersonCenterRefresh, //个人主页刷新
    LoginType_MyPersonCenter,   //我模块
    LoginType_OfferDetail,     //offer派详情
    LoginType_OfferRightZbar,  //offer派现场签到
    LoginType_ApplyPostion,    //职位详情申请职位
    LoginType_PushUrl,         //3G页面跳转
    LoginType_MyGuanXinShui,   //我的灌薪水帖子
    LoginType_SalaryListCell,   //点击查工资卡片
    LoginType_SalaryRightButton,//点击查工资右上角比薪资按钮
    LoginType_PushPersonCenter, //跳转个人主页
    LoginType_ZhiYeJingJiRenRight, //职业经纪人首页申请行家与我的约谈
    LoginType_OfferPayJoin,      //offer派申请
    LoginType_MessageCenter,     //消息模块
} NoLoginType;

@protocol NoLoginDelegate <NSObject>

@optional
-(void)loginDelegateCtl;
-(void)loginSuccessResponse;

@end

@interface NoLoginPromptCtl : UIViewController

@property (weak,nonatomic) id <NoLoginDelegate> noLoginDelegare;
@property (nonatomic,strong) NSDictionary *noLoginDic;
@property (nonatomic,assign) NoLoginType loginType;
@property (nonatomic,weak) UIButton *button;
@property (nonatomic,strong) NSIndexPath *indexPath;


+(NoLoginPromptCtl *)noLoginManagerWithDelegate:(id)delegate;
+(NoLoginPromptCtl *)getNoLoginManager;

//不显示弹框直接退出登录
/*
    refresh 传yes标识登录成功后为首页，不返回当前页
 */
+(void)loginOutWithDelegate:(id)delegate type:(NoLoginType)loginType loginRefresh:(BOOL)refresh;
//登陆成功操作
-(void)loginSuccessDelegate;
-(id)init;

-(void)showNoLoginCtlView;
-(void)hideNoLoginCtlView;

@end

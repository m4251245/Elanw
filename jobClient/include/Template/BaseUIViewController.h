//
//  BaseUIViewController.h
//  Template
//
//  Created by sysweal on 13-9-11.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

/***************************
 
 Ctl Base Class
 
 ***************************/

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Common.h"
#import "RequestCon.h"
#import "ErrorCtl.h"
#import "InLoadingCtl.h"
#import "AMScrollingNavbarViewController.h"
#import "MyConfig.h"
#import "Message_DataModal.h"
#import "NSString+Size.h"
#import "NoDataOkCtl.h"

//背景设置时的方式
typedef enum
{
    BG_Copy,    //平铺
    BG_Fill,    //自动拉伸
}BGType;

@interface BaseUIViewController : AMScrollingNavbarViewController<LoadDataDelegate,ErrorCtlDelegate>{
    //背景相关
    BOOL                    bInsertBG_;             //是否插入背景
    UIImageView             *bgImageView_;          //背景图片的ImageView
    BGType                  bgType_;                //背景图片的类型
    
    //导航条相关
    IBOutlet UILabel        *titleBarLb_;           //自定义的导航lb(如果有此值，则会与self.title关联)
    IBOutlet UIImageView    *selfNavBGImageView_;   //自定义的导航条背景(如果有此值，则会起作用)
    IBOutlet UIButton       *selfBackBtn_;          //自定义的导航条返回按扭(一般与selfNavBGImageView_同时使用)
    IBOutlet UIView         *myLeftBarBtnItem_;     //如果有此值，则导航条的左Item采用此值
    IBOutlet UIView         *myRightBarBtnItem_;    //如果有此值，则导航条的右Item采用此值
    UIButton                *backBarBtn_;           //返回按扭(如果leftNavBarStr_存在，则其不存在)
    UIButton                *leftBarBtn_;           //左按扭(leftNavBarStr_存在时才有此值)
    UIButton                *rightBarBtn_;          //右按扭(rightNavBarStr_存在时才有此值)
    NSString                *leftNavBarStr_;        //导航左边的按扭Str
    NSString                *rightNavBarStr_;       //导航右边的按扭Str
    NSString                *rightNavBarRightWidth;
    //数据请求相关
    @public
    RequestCon              *requestCon_;           //默认的数据请求类
    long                    validateSeconds_;       //默认请求的有效期
    
    //与数据请求相关的视图
//    ErrorCtl                *errorCtl_;             //加载出错的视图
    NoDataOkCtl             *noDataCtl;             //异常状态的视图
    InLoadingCtl            *inLoadingCtl_;         //正在加载的视图
    BOOL                   showTipsMessageViewFlag_;  //是否显示提示消息的view
}

@property(nonatomic,strong) NSString                *comInditify_;  //com的标识(如果标识发生改变,代表不同的类别)
@property(nonatomic,strong) NSString                *requestInditify_;  //request的标识(如果标识发生改变,代表不同的类别)

//show alert view(just one btn)
+(void) showAlertView:(NSString *)title msg:(NSString *)msg btnTitle:(NSString *)btnTitle;

//show alert view(just one btn)
+(void) showAlertView:(NSString *)title msg:(NSString *)msg btnTitle:(NSString *)btnTitle delegate:(id)delegate;

//让提示框自动消失
+(void) showAutoDismissAlertView:(NSString *)title msg:(NSString *)msg seconds:(float)seconds;

//让提示框自动消失
+(void) showAutoDisappearAlertView:(NSString *)title msg:(NSString *)msg seconds:(float)seconds;

//时间到了让提示框消失
+(void) dimissAlertView:(UIAlertView *)alertView;

//自动消失的操作成功视图
+(void) showAutoDismissSucessView:(NSString *)title msg:(NSString *)msg;

//可设置时间消失的操作成功视图
+(void) showAutoDismissSucessView:(NSString *)title msg:(NSString *)msg seconds:(float)seconds;

//自动消息的操作失败视图
+(void) showAutoDismissFailView:(NSString *)title msg:(NSString *)msg;

//可设置时间自动消息的操作失败视图
+(void) showAutoDismissFailView:(NSString *)title msg:(NSString *)msg seconds:(float)seconds;

//显示模态正在加载的视图
+(void) showModalLoadingView:(BOOL)flag title:(NSString *)title status:(NSString *)status;
+(void)showLoadView:(BOOL)flag content:(NSString *)content view:(UIView *)view;

//自动消失的视图
+(void)showAlertViewContent:(NSString *)content toView:(UIView *)view second:(CGFloat)second animated:(BOOL)animated;

//show choose alert view
-(UIAlertView *) showChooseAlertView:(int)type title:(NSString *)title msg:(NSString *)msg okBtnTitle:(NSString *)okBtnTitle cancelBtnTitle:(NSString *)cancelBtnTitle;

//UIAlertView delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

//alert view choosed
-(void) alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type;

//alert view choosed cancel
-(void) alertViewCancel:(UIAlertView *)alertView index:(int)index type:(int)type;

//获取背景图片的name
-(NSString *) getBGName;

//获取背景图片的SuperView
-(UIView *) getBGSuperView;

//设置背景
-(UIImageView *) setBG:(NSString *)bgName;

//获取导航背景name
-(NSString *) getSelfNavBGName;

//设置自定义的navBg
-(void) setSelfNavBG;

//获取返回按扭的背景
-(NSString *) getBackBarBtnBGName;

//获取自定义左按扭的背景
-(NSString *) getLeftBarBtnBGName;

//获取自定义右按扭的背景
-(NSString *) getRightBarBtnBGName;

//设置返回按扭的属性
-(void) setBackBarBtnAtt;

//设置左按扭的属性
-(void) setLeftBarBtnAtt;

//设置右按扭的属性
-(void) setRightBarBtnAtt;

//获取正在加载时所显示的文字
-(NSString *) getLoadingTxt;

//获取异常视图的父视图
-(UIView *) getErrorSuperView;

//获取异常视图
-(UIView *) getErrorView;

//获取正在加载视图的父视图
-(UIView *) getLoadingSuperView;

//获取正在加载视图
-(UIView *) getLoadingView;

//显示加载出错的视图
-(void) showErrorView:(BOOL)flag;

//显示正在加载的视图
-(void) showLoadingView:(BOOL)flag;

//刷新界面
-(void) updateCom:(RequestCon *)con;

//刷新一下加载界面
-(void) updateLoadingCom:(RequestCon *)con;

//获取某个连接的数据有效期
-(long) getRequestConValidateSeconds:(RequestCon *)con;

//获取一个请求类(validateSeconds数据有效期)
-(RequestCon *) getNewRequestCon:(BOOL)bDefault;

//开始加载数据
-(void) beginLoad:(id)dataModal exParam:(id)exParam;

//开始请求
-(void) startLoad:(RequestCon *)con;

//刷新加载
-(void) refreshLoad:(RequestCon *)con;

//加载数据的方法
-(void) getDataFunction:(RequestCon *)con;

//error get data
-(void) errorGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type;

//finish get data
-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr;

//判断是否需要响应事件
-(BOOL) canBtnResponse:(id)sender;

//返回按扭点击的响应事件
-(void) backBarBtnResponse:(id)sender;

//左按扭点击的响应事件
-(void) leftBarBtnResponse:(id)sender;

//右按扭点击的响应事件
-(void) rightBarBtnResponse:(id)sender;

//已经完全dismiss了
-(void) haveDismiss;

//其它按扭的点击事件
-(void) btnResponse:(id)sender;

//按扭事件
-(IBAction) btnClick:(id)sender;

//获取ip的线程
-(void) getIP;
//设置标题
- (void)setNavTitle:(NSString *)title;
- (void)setNavTitle:(NSString *)title withColor:(UIColor *)color;

//connect interrupt
-(BOOL) dataConnShouldInterrupt:(RequestCon *)con aciton:(NSString *)action bodyMsg:(NSString *)bodyMsg method:(NSString *)method;

@end

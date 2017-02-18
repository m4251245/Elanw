//
//  ArticleDetailCtl.h
//  Association
//
//  Created by 一览iOS on 14-1-15.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ExRequetCon.h"
#import "MJPhotoBrowser.h"
#import "JoinActivityCtl.h"

@class ELArticleDetailModel;
@class ELGroupDetailModal;
@protocol joinGroupDelegate <NSObject>

-(void)joinSuccessRefresh;

@end

typedef void(^addCommentSuccessBlock)(BOOL likeFlag,BOOL commentFlag);

@interface ArticleDetailCtl : BaseListCtl<UIWebViewDelegate,UITextViewDelegate,UIScrollViewDelegate,MJPhotoBrowserDelegate,UIGestureRecognizerDelegate>
{
    IBOutlet  UIWebView         *webview_;
    IBOutlet  UIView            *headView_;
    ELArticleDetailModel        *myDataModal_;
    MJPhotoBrowser              *photoBrowser_;
    UITapGestureRecognizer      *singleTap_;  //单击的事件
}

@property(nonatomic,strong) NSString               *type_;
@property(nonatomic,assign) BOOL                   bScrollToComment_;
@property(nonatomic,assign) BOOL                   isFromGroup_;//社群
@property(nonatomic, copy)  addCommentSuccessBlock addCommentSuccessBlock;
@property(nonatomic,assign) BOOL                   isFromCompanyGroup;//公司群
@property(nonatomic,assign) BOOL                   isFromNews;//薪闻
@property(nonatomic,weak)   id <joinGroupDelegate> joinGroupDelegate;

@property(nonatomic,assign) BOOL stateType;

@property(nonatomic,assign) BOOL isEnablePop;

-(void)attentionSuccessRefresh:(BOOL)isSuccess;
-(void)addLikeSuccessRefresh;
-(void)viewSingleTap:(id)sender;
- (IBAction)backBarBtnResponeTwo:(id)sender;
-(void)keyBoardShow;
-(void)addGesture;
-(void)removeGesture;
-(void)setMycontentoffset;
-(void)setTableViewContentOffset;
-(void)addKeyBoardNotification;
-(void)removeKeyBoardNotification;
-(void)refreshCommentSuccess;
-(void)tapPersonCenterCtl:(UITapGestureRecognizer *)sender;
-(void)tableReloadData;
-(void)sendReplyMessageWithText:(NSString *)text tagId:(NSString *)tagId;

@end

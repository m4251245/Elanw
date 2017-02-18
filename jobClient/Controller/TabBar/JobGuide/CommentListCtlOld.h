//
//  CommentListCtl.h
//  MBA
//
//  Created by sysweal on 13-11-20.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "Comment_DataModal.h"
#import "ExRequetCon.h"
#import "ReplyCommentCtl.h"
#import "ReplyAnswerCommentCtl.h"
#import "NewAnswerListModal.h"

@class CommentListCtlOld;

@protocol RefreshDelegate <NSObject>

@optional
-(void)refreshSelf:(CommentListCtlOld *)ctl;

@end


@interface CommentListCtlOld : BaseListCtl<UITextViewDelegate,AddReplyCommentDelegate,AddReplyAnswerCommentDelegate>
{
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
    ReplyAnswerCommentCtl   *replyAnswerCommentCtl_;
    
    Comment_DataModal       *selectDataModal_;
 
    RequestCon  *addCommentCon_;    //用于添加评论
    NSMutableArray *imageConArr_;   //用于请求图片
    int  maxDesLine_;        //盖楼最多缩进多少行
    
    id   inDataModal;
    int  selfViewOriginY_;   //自己视图的原始y座标
    
    CGRect  giveCommentStartRect_;
    BOOL  commentBtnStatus_;  //评论按钮的状态
    
}

@property(nonatomic,weak)  IBOutlet    UILabel     * tipsLb_;
@property(nonatomic,weak)  IBOutlet    UIView      *giveCommentView_;
@property(nonatomic,weak)  IBOutlet    UITextView  *giveCommentTv_;
@property(nonatomic,weak)  IBOutlet    UIButton    *giveMyCommentBtn_;
@property(nonatomic,strong)  NSString    *objId_;
@property(nonatomic,strong)  NSString    *typeStr_;
@property(nonatomic,assign) id<RefreshDelegate> delegate_;

@property (weak, nonatomic) IBOutlet UIButton *faceBtn;


//从链表取的数据
//-(Comment_DataModal *) getDataModal:(Comment_DataModal *)dataModal index:(NSInteger)index;

//获取链表大小
//-(int) getListSize:(Comment_DataModal *)dataModal;

//添加评论
-(void) addComment;

//添加评论成功
-(void) haveAddCommentOK;

//将所有评论的PageInfo+1
-(void) addPageInfo;

//自己视图的单击事件
-(void) viewSingleTap:(id)sender;
//
////添加评论成功后设置tableview的contentoffset
//-(void)setMycontentoffset;

@end

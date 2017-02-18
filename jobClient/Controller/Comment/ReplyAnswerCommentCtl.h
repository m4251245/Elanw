//
//  ReplyCommentCtl.h
//  MBA
//
//  Created by sysweal on 13-11-21.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ExRequetCon.h"
#import "Comment_DataModal.h"
#import "Answer_DataModal.h"
#import "NewAnswerListModal.h"

@class ReplyAnswerCommentCtl;
@protocol AddReplyAnswerCommentDelegate <NSObject>

-(void) addReplyAnswerCommentOK:(ReplyAnswerCommentCtl *)ctl dataModal:(Comment_DataModal *)dataModal;

@end

@interface ReplyAnswerCommentCtl : BaseUIViewController<UITextViewDelegate>
{
    Comment_DataModal           *inDataModal_;  //传进来的值
}

@property(nonatomic,unsafe_unretained)  IBOutlet    UILabel     *nameLb_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UITextView  *contentTv_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UILabel     *promptLb_;
@property(nonatomic,strong)  NSString                           *objId_;
@property(nonatomic,strong)  NSString                           *typeStr_;
@property(nonatomic,assign)  id<AddReplyAnswerCommentDelegate>        delegate_;
@property(nonatomic,strong) NSString                            *proId_;

@property (weak, nonatomic) IBOutlet UIButton *faceBtn;

@property(nonatomic,strong) Answer_DataModal        *answerModel_;
//添加回复
-(void) addReply;

@end

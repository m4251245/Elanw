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

@class ELGroupCommentModel;
@class ReplyCommentCtl;
@class ELGroupDetailModal;

@protocol AddReplyCommentDelegate <NSObject>

-(void) addReplyCommentOK:(ReplyCommentCtl *)ctl dataModal:(Comment_DataModal *)dataModal;

@end

@interface ReplyCommentCtl : BaseUIViewController<UITextViewDelegate>
{
    ELGroupCommentModel           *inDataModal_;  //传进来的值
}

@property(nonatomic,unsafe_unretained)  IBOutlet    UILabel     *nameLb_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UITextView  *contentTv_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UILabel     *promptLb_;
@property(nonatomic,strong)  NSString                           *objId_;
@property(nonatomic,strong)  NSString                           *typeStr_;
@property(nonatomic,assign)  id<AddReplyCommentDelegate>        delegate_;
@property(nonatomic,strong) NSString                            *proId_;
@property(nonatomic,assign) BOOL isNiMingComment;
@property(nonatomic,assign) BOOL isCompanyGroup;
@property(nonatomic,copy) NSString *niMingPersonId;
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;

//招聘群才用到
@property (nonatomic, strong) ELGroupDetailModal *groupModel;
@property (nonatomic, strong) NSString *qiId;

//添加回复
-(void) addReply;

@end

//
//  ELArticleCommentView.h
//  jobClient
//
//  Created by 一览iOS on 16/5/10.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELArticleDetailModel.h"
#import "Expert_DataModal.h"

@interface ELArticleCommentView : UIView

@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UIButton *pingLunBtn;
@property (weak, nonatomic) IBOutlet UIView *plBackView;
@property (weak, nonatomic) IBOutlet UIView *msgBackView;

@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UIImageView *bianKuangImage;
@property (nonatomic,weak)  IBOutlet UILabel *tipsLb_;
@property(nonatomic,weak)  IBOutlet  UITextView *giveCommentTv_;
@property(nonatomic,weak)  IBOutlet  UIButton *giveMyCommentBtn_;
@property (nonatomic,copy) NSString *tipsStr;
@property (nonatomic,assign) BOOL isFromCompanyGroup;
@property (nonatomic,assign) BOOL isReply;


-(void)textChanged:(UITextView *)textView;
-(void)addKeyBoardNotification;
-(void)removeKeyBoardNotification;
-(void)setMyModal:(ELArticleDetailModel *)myModal;
-(void)commentSuccessRefresh;
-(void)hideCommentKeyBoardAndFace;
-(instancetype)initWithArticleCtl:(ArticleDetailCtl *)articleCtl isHave:(BOOL)isHave;
-(BOOL)getPersonNameNiMingStatus;

@end

//
//  CommentListCtlself.m
//  jobClient
//
//  Created by 一览ios on 14/11/20.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "CommentListCtlCell.h"
#import "MyConfig.h"
#import "Comment_DataModal.h"
#import "CommentImageListView.h"
#import "MLEmojiLabel.h"
#import "NSString+Size.h"
#import "ELGroupCommentModel.h"
#import "ELPersonCenterCtl.h"
#import "ELButtonView.h"
#import "ResumeCommentTag_DataModal.h"

//行距
//#define LINE_MARGIN 8

static double LINE_MARGIN = 8;

@interface CommentListCtlCell() <ClickDelegate>

@property(nonatomic,retain)UILabel *statusLb;

@end

@implementation CommentListCtlCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.nameLb_ setFont: [UIFont fontWithName:@"STHeitiSC-Light" size:16]];
    [self.dateLb_ setFont:FOURTEENFONT_CONTENT];
    [self.likeBtn_.titleLabel setFont:FOURTEENFONT_CONTENT];
    //设置背景
    UIView *backgroundView = [[UIView alloc]init];
    CALayer *bgLayer = backgroundView.layer;
    bgLayer.borderWidth = 0.5;
    bgLayer.borderColor = [UIColor colorWithRed:200.0/225 green:200.0/225 blue:200.0/225 alpha:1.0].CGColor;
    bgLayer.backgroundColor = [UIColor whiteColor].CGColor;
    self.backgroundView = backgroundView;
    
    //设置头像圆角
    CALayer *layer = self.picBtn_.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:4.0];
    
    [self.picBtn_ addTarget:self action:@selector(personCenterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.likeBtn_ addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.likeBtn_ setTitleColor:REDCOLOR forState:UIControlStateSelected];
    
    CommentImageListView *commentImages = [[CommentImageListView alloc]init];
    commentImages.tag = 2000;
    [self addSubview:commentImages];
    
    
    _statusLb = [[UILabel alloc]initWithFrame:CGRectZero];
    _statusLb.numberOfLines = 1;
    _statusLb.font = [UIFont systemFontOfSize:11];
    _statusLb.textColor = UIColorFromRGB(0xe13e3e);
    _statusLb.textAlignment = NSTextAlignmentCenter;
    _statusLb.layer.borderWidth = 1;
    _statusLb.layer.borderColor = UIColorFromRGB(0xe13e3e).CGColor;
    _statusLb.layer.cornerRadius = 3;
    _statusLb.layer.masksToBounds = YES;
    _statusLb.layer.shouldRasterize = YES;
    [self.contentView addSubview:_statusLb];
    
    _commentLb = [[ELButtonView alloc] init];
    [self.contentView addSubview:_commentLb];
    
    _exceptionalBtn.layer.cornerRadius = 3;
    _exceptionalBtn.layer.masksToBounds = YES;
    _exceptionalBtn.hidden = YES;
    
}

//文字自适应
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(320, 20)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataModal:(ELGroupCommentModel *)dataModal
{
    _dataModal = dataModal;
    
    //面试状态
    _statusLb.hidden = YES;
    if (dataModal.tagsList.count > 0) {
        _statusLb.hidden = NO;
        ResumeCommentTag_DataModal *model = [dataModal.tagsList objectAtIndex:0];
        _statusLb.text = model.tagName_;
        CGSize statusLbsize =  [self sizeWithString:_statusLb.text font:_statusLb.font];
        _statusLb.frame = CGRectMake(ScreenWidth - statusLbsize.width - 22, 10, statusLbsize.width + 10, 20);
    }

    
    //头像
    [self.picBtn_ sd_setImageWithURL:[NSURL URLWithString:dataModal.person_pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"] options:SDWebImageAllowInvalidSSLCertificates];
    //用户名
    if (dataModal.person_iname && ![dataModal.person_iname isEqualToString:@""]) {
        self.nameLb_.text = dataModal.person_iname;
    }else if (dataModal.person_nickname && ![dataModal.person_nickname isEqualToString:@""]){
        self.nameLb_.text = dataModal.person_nickname;
    }else{
        self.nameLb_.text = @"匿名";
    }
    //发布时间
    self.dateLb_.text = dataModal.ctime;
    
    self.likeCountLb.text = [NSString stringWithFormat:@"%ld",(long)[dataModal.agree integerValue]];
    CGSize size = [self.likeCountLb.text sizeNewWithFont:self.likeCountLb.font];
    
    self.likeBtn_.frame = CGRectMake(ScreenWidth-35-size.width, 13, size.width+20, 30);
    
    if (dataModal.isLiked) {
        self.likeImageView.image = [UIImage imageNamed:@"ico_zan_down2"];
        self.likeCountLb.textColor = [UIColor redColor];
    }else{
        self.likeImageView.image = [UIImage imageNamed:@"ico_zan_open2"];
        self.likeCountLb.textColor = UIColorFromRGB(0xa6a6a6);
    }
    
    CGFloat photoViewY = 0;
    
    if (dataModal._parent_comment) {
        //对评论的回复
        ELGroupCommentModel *parentComment = dataModal._parent_comment;
        NSString *parentContent = parentComment.content;
        //引用的内容
        if ([parentContent hasPrefix:@"http://"] || [parentContent hasPrefix:@"https://"]) {
            
            self.noCommentPic.hidden = NO;
            [self.noCommentPic sd_setImageWithURL:[NSURL URLWithString:parentContent] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
            self.noCommentPic.frame = CGRectMake(CGRectGetMaxX(dataModal.parentFrame), 50+LINE_MARGIN, 20, 20);
        }else{
            self.noCommentPic.hidden = YES;
        }
        self.commentLb.hidden = NO;
        self.parentLb.hidden = NO;
        
        self.parentLb.frame = dataModal.parentFrame;
        [self.parentLb setAttributedText:dataModal.parentAttString];
    }else{
        //不是对评论的回复
        self.noCommentPic.hidden = YES;
        self.parentLb.hidden = YES;
        self.commentLb.hidden = NO; 
    }
    self.commentLb.frame = dataModal.commentFrame;
    self.commentLb.clickDelegate = self;
    self.commentLb.showLink = YES;
    self.commentLb.linkCanClick = YES;
    [self.commentLb setNumberlines:0];
    [self.commentLb setAttributedText:dataModal.commentAttString];
    
    photoViewY = CGRectGetMaxY(self.commentLb.frame);

    self.parentLb.lineBreakMode = NSLineBreakByTruncatingTail;
    //显示评论图片的列表
    CommentImageListView *commentImages = (CommentImageListView *)[self viewWithTag:2000];
    commentImages.hidden = YES;
    if ([dataModal._pic_list isKindOfClass:[NSArray class]]) {
        if (dataModal._pic_list.count > 0) {
            commentImages.hidden = NO;
            CGSize size = [CommentImageListView imageSizeWithCount:dataModal._pic_list.count];
            commentImages.frame = CGRectMake(56, photoViewY+LINE_MARGIN, size.width, size.height);
            commentImages.imageUrls = dataModal._pic_list;
            commentImages.bigImageUrls = dataModal._pic_list;
            photoViewY += size.height + LINE_MARGIN + 10;
        }
    }  
}

-(void)linkDelegateBtnRespone:(TextSpecial *)model{
    if (model.key && ![model.key isEqualToString:@""]){
        NSString *link = model.key;
        NSArray *ylUrls = [[Manager shareMgr] getUrlArr];            
        for (NSString *url in ylUrls) {
            if ([link rangeOfString:url].location != NSNotFound) {
                PushUrlCtl *urlCtl = [[PushUrlCtl alloc]init];
                urlCtl.isThirdUrl = YES;
                urlCtl.hideShareButton = YES;
                [[Manager shareMgr].centerNav_ pushViewController:urlCtl animated:YES];
                if (![link hasPrefix:@"http://"]) {
                    link = [NSString stringWithFormat:@"http://%@",link];
                }
                [urlCtl beginLoad:link exParam:link];
                break;
            }
        }
    }
}

#pragma mark - 评论头像点击
-(void)personCenterBtnClick:(UIButton *)sender{
    NSString *personId = _dataModal.personId;
    if (personId.length <= 0) {
        return;
    }
    ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
    personCenterCtl.isFromManagerCenterPop = YES;
    [[Manager shareMgr] pushWithCtl:personCenterCtl];
    [personCenterCtl beginLoad:personId exParam:nil];
}

#pragma mark - 评论点赞
- (void)likeBtnClick:(UIButton *)btn
{
    if (_dataModal.isLiked) {
        
        [Manager deleteLikeDate:_dataModal.id_];
        
        NSInteger agreeCount = [_dataModal.agree integerValue];
        agreeCount--;
        _dataModal.agree = [NSString stringWithFormat:@"%ld",(long)agreeCount];
        _dataModal.isLiked = NO;
        
        self.likeImageView.image = [UIImage imageNamed:@"ico_zan_open2.png"];
        
        self.likeCountLb.textColor = UIColorFromRGB(0xA6A6A6);
        self.likeCountLb.text = [NSString stringWithFormat:@"%ld",(long)[_dataModal.agree integerValue]];
        CGSize size = [self.likeCountLb.text sizeNewWithFont:self.likeCountLb.font];
        
        self.likeBtn_.frame = CGRectMake(ScreenWidth-35-size.width,13,size.width+20,30);
        
        [self supportComment:@"cancel"];
    }
    else
    {
        NSInteger agreeCount = [_dataModal.agree integerValue];
        agreeCount++;
        _dataModal.agree = [NSString stringWithFormat:@"%ld",(long)agreeCount];
        _dataModal.isLiked = YES;
        [Manager saveAddLikeWithAticleId:_dataModal.id_];
        self.likeImageView.image = [UIImage imageNamed:@"ico_zan_down2"];
        
        self.likeCountLb.textColor = [UIColor redColor];
        self.likeCountLb.text = [NSString stringWithFormat:@"%ld",(long)[_dataModal.agree integerValue]];
        CGSize size = [self.likeCountLb.text sizeNewWithFont:self.likeCountLb.font];
        
        self.likeBtn_.frame = CGRectMake(ScreenWidth-35-size.width,13,size.width+20,30);
        
        [self supportComment:@"add"];
    }
}

- (void)supportComment:(NSString *)type
{
    NSString *personId = @"";
    if ([Manager shareMgr].haveLogin) {
        personId = [Manager getUserInfo].userId_;
    }
    
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&comment_id=%@&type=%@", personId, _dataModal.id_, type];
    NSString * function = @"addCommentPraise";      //Table_Func_AddCommentLiked;
    NSString * op = @"yl_praise_busi";
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];

}

@end

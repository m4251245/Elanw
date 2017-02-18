//
//  ELArticleCommentView.m
//  jobClient
//
//  Created by 一览iOS on 16/5/10.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELArticleCommentView.h"
#import "FaceScrollView.h"
#import "ArticleDetailCtl.h"
#import "ELGroupListDetailModel.h"
#import "ELWebSocketManager.h"
#import "ResumeCommentTag_DataModal.h"
#import "GroupChangeNiMingViewCtl.h"

#define kWebSocketHeight 82
#define kNormalHeght 40

@interface ELArticleCommentView() <UITextViewDelegate,changeNiMingDelegate,NoLoginDelegate>
{
    __weak ArticleDetailCtl *_articleDetailCtl;
    
    ELArticleDetailModel *myDataModal_;
    
    BOOL _isKeyboardShow;
    CGFloat _keyboardHeight;
    BOOL isCompanyGroup;
    BOOL isPingLunRefresh;
    BOOL isNiMing;
    BOOL  bSetToCommentOffset_;
    
    UIImageView *sImage;
    UIImageView *nImage;
    NSString *sName;
    NSString *nName;
    BOOL isKewBoardShow;
    
    FaceScrollView *_faceScrollView;   
    GroupChangeNiMingViewCtl *changeNiMingCtl;//实名匿名选择界面
    
    UIView *backView;
    CGFloat textViewHeight;
    
    UIButton *selectBtn;
    
    CGFloat allHeight;
    CGFloat eY;
    
    NSMutableArray *_tagArray;
}
@property (weak, nonatomic) IBOutlet UILabel *resumeMarkLb;
@property (nonatomic,assign) BOOL isHave;
@end

@implementation ELArticleCommentView

@synthesize giveCommentTv_,giveMyCommentBtn_,isFromCompanyGroup,tipsLb_,tipsStr;

-(instancetype)initWithArticleCtl:(ArticleDetailCtl *)articleCtl isHave:(BOOL)isHave
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ELArticleCommentView" owner:self options:nil] lastObject];
    if (self)
    {
        _articleDetailCtl = articleCtl;
        giveCommentTv_.delegate = self;
        isKewBoardShow = NO;
        tipsStr = @"我来说两句";
        _pingLunBtn.clipsToBounds = YES;
        _pingLunBtn.layer.cornerRadius = 3.0;
        [_faceBtn setImage:[UIImage imageNamed:@"icon_keyboard.png"] forState:UIControlStateSelected];
        
        _isHave = isHave;
        //设置圆角
        CALayer *layer=[_msgBackView layer];
        [layer setMasksToBounds:YES];
        [layer setBorderWidth:1.0];
        [layer setCornerRadius:6.0];
        [layer setBorderColor:[[UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1] CGColor]];
        
        //设置阴影
        layer=[self layer];
        layer.shadowOffset = CGSizeMake(0, -0.5); //设置阴影的偏移量
        //layer.shadowRadius = 1.0;  //设置阴影的半径
        layer.shadowColor = [UIColor blackColor].CGColor; //设置阴影的颜色为黑色
        layer.shadowOpacity = 0.1; //设置阴影的不透明度
        layer.shadowPath =[UIBezierPath bezierPathWithRect:CGRectMake(0,0,ScreenWidth,allHeight)].CGPath;
        
        
        if ([self respondsToSelector:@selector(setAllowsNonContiguousLayout:)]) {
            giveCommentTv_.layoutManager.allowsNonContiguousLayout = NO;
        } 
        [self addKeyBoardNotification];
    }
    return self;
}

-(void)configUI
{
    CGRect allFrame = self.frame;
    if (_isHave) {
        _tagArray = [[NSMutableArray alloc] init];
        [self requestResumeTag];
        allHeight = kWebSocketHeight;
        eY = 47;
        _resumeMarkLb.hidden = NO;
    }
    else{
        allHeight = kNormalHeght;
        eY = 5;
        _resumeMarkLb.hidden = YES;
    }
    allFrame.size.height = allHeight;
    self.frame = allFrame;
    [self configAllCon];
}

//初始化所有控件
-(void)configAllCon{
    _faceBtn.frame = [self viewsRect:_faceBtn];
    _pingLunBtn.frame = [self viewsRect:_pingLunBtn];
    _plBackView.frame = [self viewsRect:_plBackView];
    _msgBackView.frame = [self viewsRect:_msgBackView];
    _headerBtn.frame = [self viewsRect:_headerBtn];
    _headerImage.frame = [self viewsRect:_headerImage];
    _bianKuangImage.frame = [self viewsRect:_bianKuangImage];
    self.tipsLb_.frame = [self viewsRect:self.tipsLb_];
    self.giveMyCommentBtn_.frame = [self viewsRect:self.giveMyCommentBtn_];
}

-(CGRect)viewsRect:(id)control{
    CGRect rect = [control frame];
    rect.origin.y = eY;
    return rect;
}

//请求简历话题标签
- (void)requestResumeTag
{
    NSString *op = @"yl_tag_busi";
    NSString *func = @"getZpgroupResumeCommentTag";
    
    NSString *source;
    if ([myDataModal_.qi_id_isdefault isEqualToString:@"1"]) {
        //默认话题
        source = @"zp_group_common";
    }
    else if([myDataModal_.qi_id_isdefault isEqualToString:@"2"])
    {
        source = @"zp_group_resume";
    }
    
    NSString *bodyMsg = [NSString stringWithFormat:@"source=%@", source];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dict = result;
        NSArray *tagArr = [dict objectForKey:@"info"];
        if (![tagArr isKindOfClass:[NSNull class]]) {
            for (NSDictionary *tagDic in tagArr) {
                ResumeCommentTag_DataModal *model = [[ResumeCommentTag_DataModal alloc] init];
                model.tagId_ = [tagDic objectForKey:@"labelId"];
                model.tagName_ = [tagDic objectForKey:@"labelName"];
                [_tagArray addObject:model];
            }
        }
        [self configSel];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)configSel{
    UIScrollView *selView = [[UIScrollView alloc]initWithFrame:CGRectMake(65, 0, ScreenWidth - 65, 42)];
    [self addSubview:selView];
    
    CGFloat wid = 0.0;
    for (int i = 0; i < _tagArray.count; i++) {
        ResumeCommentTag_DataModal *model = _tagArray[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:model.tagName_ forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        CGSize size = [self sizeWithString:model.tagName_ font:[UIFont systemFontOfSize:12]];
        CGFloat eW = size.width + 10;
        btn.frame = CGRectMake(wid + 10*i, 11, eW+4, 24);
        wid += eW;
        [btn setTitleColor:UIColorFromRGB(0x616161) forState:UIControlStateNormal];
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = UIColorFromRGB(0xb0b0b0).CGColor;
        btn.layer.borderWidth = 0.5;
        [selView addSubview:btn];
        
        btn.tag = 999+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    selView.contentSize = CGSizeMake(wid + 12*_tagArray.count, 30);
    selView.showsHorizontalScrollIndicator = NO;
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

-(void)btnClick:(UIButton *)btn{
    
    if (btn != selectBtn) {
        selectBtn.layer.borderColor = UIColorFromRGB(0xbdbdbd).CGColor;
        [selectBtn setTitleColor:UIColorFromRGB(0x616161) forState:UIControlStateNormal];
        
        btn.layer.borderColor = UIColorFromRGB(0xe13e3e).CGColor;
        [btn setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateNormal];
        selectBtn = btn;
    }
    else{
        btn.layer.borderColor = UIColorFromRGB(0xbdbdbd).CGColor;
        [btn setTitleColor:UIColorFromRGB(0x616161) forState:UIControlStateNormal];
        selectBtn = nil;
    }
}

-(void)textChanged:(UITextView *)textView
{
    [self changeTextViewFrame];
}

-(void)changeTextViewFrame
{
    NSLog(@"%@\n%@",NSStringFromCGSize(giveCommentTv_.contentSize),giveCommentTv_.text);    
    CGRect textFrame=[[giveCommentTv_ layoutManager] usedRectForTextContainer:[giveCommentTv_ textContainer]];
    CGFloat height = textFrame.size.height;
    if (giveCommentTv_.text.length <= 0){
        tipsLb_.text = tipsStr;
    }else{
        tipsLb_.text = @"";
    }
    if (fabs(height -textViewHeight) < 10) {
        return;
    }
    textViewHeight = height;
    giveCommentTv_.textContainerInset = UIEdgeInsetsMake(0,0,0,0);
    CGRect frame = _msgBackView.frame;
    if (height > 90) {
        frame.size.height = 82;
    }else{
        frame.size.height = height > 30 ? height:30;
    }
    _msgBackView.frame = frame;
    
    
    frame = giveCommentTv_.frame;
    if (height < 20 || giveCommentTv_.text.length <= 0) {
        frame.origin.y = 8;
    }else{
        frame.origin.y = 0;
    }
    giveCommentTv_.frame = frame;
    
    CGFloat heightOne = 0;
    if (_isKeyboardShow) {
        heightOne = _keyboardHeight;
    }
    else if (_faceScrollView.isShow)
    {
        heightOne = _faceScrollView.frame.size.height;
    }
    frame = self.frame;
    frame.size.height = _msgBackView.frame.size.height + allHeight - 30;
    frame.origin.y = ScreenHeight- 20 -  heightOne - frame.size.height;
    self.frame = frame;
    if(_msgBackView.frame.size.height >= 82){
        [giveCommentTv_ scrollRangeToVisible:giveCommentTv_.selectedRange]; 
    } 
}

-(void)setMyModal:(ELArticleDetailModel *)myModal
{
    myDataModal_ = myModal;
    [self configUI];
    
    if ([myDataModal_._group_source isEqualToString:@"3"] && [Manager shareMgr].haveLogin)
    {
        tipsStr = @"点击头像可切换匿名";
        
        isCompanyGroup = YES;
        sImage = [[UIImageView alloc] init];
        nImage = [[UIImageView alloc] init];
    
        
        [_headerImage sd_setImageWithURL:[NSURL URLWithString:[Manager getUserInfo].img_]];
        
        [sImage sd_setImageWithURL:[NSURL URLWithString:[Manager getUserInfo].img_]];
        
        [nImage sd_setImageWithURL:[NSURL URLWithString:myDataModal_._majia_info.person_pic]];
        sName = [NSString stringWithFormat:@"实名:%@",[Manager getUserInfo].name_];
        nName = [NSString stringWithFormat:@"匿名:%@",myDataModal_._majia_info.person_iname];
        
        _headerBtn.hidden = NO;
        CGRect frame =  _faceBtn.frame;
        frame.origin.x = ScreenWidth-95;
        _faceBtn.frame = frame;
        _faceBtn.hidden = YES;
        
        _bianKuangImage.hidden = NO;
        _headerImage.hidden = NO;
        
        isNiMing = NO;
    }
    
    if (isCompanyGroup) {
        _msgBackView.frame = CGRectMake(40,eY,ScreenWidth-135,30);
        _plBackView.frame = CGRectMake(40,eY,ScreenWidth-135,30);
        _faceBtn.hidden = NO;
    }
    else
    {
        _msgBackView.frame = CGRectMake(40,eY,ScreenWidth-98,30);
        _plBackView.frame = CGRectMake(40,eY,ScreenWidth-98,30);
    }
    
    //从公司社群进来 评论框提示
    if (isFromCompanyGroup) {
        tipsStr = @"点击头像可切换匿名";
    }
    
    if (giveCommentTv_.text.length > 0) {
        tipsLb_.text = @"";
    }
    else
    {
        [tipsLb_ setText:tipsStr];
    }
    [giveMyCommentBtn_ setTitle:[NSString stringWithFormat:@"%ld",(long)[myDataModal_.c_cnt integerValue]] forState:UIControlStateNormal];
}

-(void)addKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)removeKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)dealloc
{
    [self removeKeyBoardNotification];
}

-(void)commentSuccessRefresh
{
    myDataModal_.c_cnt = [NSString stringWithFormat:@"%ld",(long)[myDataModal_.c_cnt integerValue]+1];
    [giveMyCommentBtn_ setTitle:[NSString stringWithFormat:@"%ld",(long)[myDataModal_.c_cnt integerValue]] forState:UIControlStateNormal];
    [giveMyCommentBtn_ setImage:[UIImage imageNamed:@"icon_assess2_def2.png"] forState:UIControlStateNormal];
}

- (IBAction)btnRespone:(UIButton *)sender 
{
    if (changeNiMingCtl) {
       [changeNiMingCtl viewWithHide]; 
    }
    if (sender == giveMyCommentBtn_) {
        if ([myDataModal_.c_cnt integerValue] == 0) {
            return;
        }
        if ([giveMyCommentBtn_.titleLabel.text isEqualToString:@"原文"]) {
            [_articleDetailCtl setTableViewContentOffset];
            [giveMyCommentBtn_ setTitle:[NSString stringWithFormat:@"%ld",(long)[myDataModal_.c_cnt integerValue]] forState:UIControlStateNormal];
            [giveMyCommentBtn_.titleLabel setFont:[UIFont systemFontOfSize:10]];
            [giveMyCommentBtn_ setImage:[UIImage imageNamed:@"icon_assess2_def2.png"] forState:UIControlStateNormal];
        }else{
            [_articleDetailCtl setMycontentoffset];
            [giveMyCommentBtn_ setTitle:@"原文" forState:UIControlStateNormal];
            [giveMyCommentBtn_ setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [giveMyCommentBtn_.titleLabel setFont:[UIFont systemFontOfSize:14]];
        }
    }
    else if( sender == _pingLunBtn)
    {
        isKewBoardShow = _isKeyboardShow;
        if (_faceScrollView.isShow) {
            [self hideFaceView:YES];
        }
        [self buttonCommit];
    }else if (sender == _faceBtn)
    {
        if (!_faceBtn.selected)
        {
            _isKeyboardShow = NO;
            _faceBtn.selected = YES;
            [self showFaceView];
            [giveCommentTv_ resignFirstResponder];
            giveMyCommentBtn_.hidden = YES;
            _pingLunBtn.hidden = NO;
        }
        else
        {
            _faceBtn.selected = NO;
            _isKeyboardShow = YES;
            [giveCommentTv_ becomeFirstResponder];
        }
    }

}

#pragma mark - NoLoginDelegate
-(void)loginDelegateCtl{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_ArticleComment:
        {
            [self buttonCommit];
        }
            break;
        default:
            break;
    }
}

-(void)buttonCommit
{
    if (![Manager shareMgr].haveLogin) 
    {
        [giveCommentTv_ resignFirstResponder];
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_ArticleComment;
    }
    else
    {
        if ([MyCommon stringContainsEmoji:giveCommentTv_.text])
        {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"当前不支持输入法自带表情" seconds:1.5];
            [giveCommentTv_ resignFirstResponder];
            return;
        }
        
        NSString *giveTextStr = giveCommentTv_.text;
        giveTextStr = [giveTextStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
        giveTextStr = [giveTextStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        giveTextStr = [giveTextStr stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
        if ([giveTextStr length] == 0)
        {
            if (_isReply) {
                [BaseUIViewController showAutoDismissFailView:nil msg:@"不能发送空白回复" seconds:1.5];
            }else{
                [BaseUIViewController showAutoDismissFailView:nil msg:@"不能发送空白评论" seconds:1.5];
            }
            
            [giveCommentTv_ setText:@""];
            [giveCommentTv_ resignFirstResponder];
            return;
        }
        if (_faceScrollView)
        {
            [self hideFaceView:YES];
        }
        
        
        NSString *tagId;
        if (selectBtn == nil) {
            tagId = @"";
        }
        else {
            ResumeCommentTag_DataModal *model = [_tagArray objectAtIndex:selectBtn.tag-999];
            tagId = model.tagId_;
        }
        
        if (_isReply) {
            [_articleDetailCtl sendReplyMessageWithText:giveCommentTv_.text tagId:tagId];
            return;
        }
        
        if (myDataModal_._group_info != nil)
        {
            if ([myDataModal_.qi_id_isdefault isEqualToString:@"2"])
            {
                NSMutableDictionary *shareDic = [[NSMutableDictionary alloc] init];
                [shareDic setObject:@"11" forKey:@"type"];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:myDataModal_.id_ forKey:@"article_id"];
                [dic setObject:@"" forKey:@"url"];
                [shareDic setObject:dic forKey:@"slave"];
                
                SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
                NSString *shareStr = [jsonWriter stringWithObject:shareDic];
            
                [[ELWebSocketManager defaultManager] sendMessage:giveTextStr GroupModel:myDataModal_._group_info TopicId:myDataModal_.id_ TagId:tagId QiId:myDataModal_.qi_id_isdefault ParentId:nil CommentType:@"3" ContentType:@"11" share:shareStr];
            }
            else {
                [[ELWebSocketManager defaultManager] sendMessage:giveTextStr GroupModel:myDataModal_._group_info TopicId:myDataModal_.id_ TagId:tagId QiId:myDataModal_.qi_id_isdefault ParentId:nil CommentType:@"1" ContentType:@"1" share:nil];
            }
            
            selectBtn.layer.borderColor = UIColorFromRGB(0xbdbdbd).CGColor;
            [selectBtn setTitleColor:UIColorFromRGB(0x616161) forState:UIControlStateNormal];
            selectBtn = nil;
            [self changeTextViewFrame];
        }
        else {
            [self addComment];
        }
    }
}

-(void)hideCommentKeyBoardAndFace
{
    if (self.isReply){
        self.tipsStr = @"我来说两句";
        [self.pingLunBtn setTitle:@"评论" forState:UIControlStateNormal];
        [self.giveCommentTv_ becomeFirstResponder];
        [self changeTextViewFrame];
        self.isReply = NO;
    }
    [giveCommentTv_ resignFirstResponder];
    _isKeyboardShow = NO;
    if (_faceScrollView.isShow) {
        [self hideFaceView:YES];
    }
    if (changeNiMingCtl) {
        [changeNiMingCtl viewWithHide]; 
    }
}

#pragma mark - UITextViewDelegate
-(BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(changeNiMingCtl){
      [changeNiMingCtl viewWithHide];  
    }
    tipsLb_.text = @"";
    if (textView.text.length > 0) {
        _pingLunBtn.backgroundColor = PINGLUNHONG;
    }
    else
    {
        _pingLunBtn.backgroundColor = PINGLUNHUI;
    }
    
//    giveCommentTv_.text = [giveCommentTv_.text stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
}

-(void)finishTextViewEditing
{
    if (!_isKeyboardShow && !_faceScrollView.isShow)
    {
        //        CGFloat height = 0;
        //        if (IOS7) {
        //            height = 20;
        //        }
        //        CGRect frame = giveCommentTv_.frame;
        //        frame.size.height = 30;
        //        giveCommentTv_.frame = frame;
        //        
        //        frame = giveCommentView_.frame;
        //        frame.size.height = 40;
        //        frame.origin.y = CGRectGetHeight(self.view.bounds)- frame.size.height - height;
        //        giveCommentView_.frame = frame;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    @try {
        NSString *content = textView.text;
        if(range.length == 1 && [text isEqualToString:@""])
        {
            NSString *result = [MyCommon substringExceptLastEmoji:content];
            if (![content isEqualToString:result]) {
                textView.text = result;
                if ([textView.text isEqualToString:@""]) {
                    _pingLunBtn.backgroundColor = PINGLUNHUI;
                }
                [self changeTextViewFrame];
                return NO;
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"文章评论异常1");
    } @finally {
        
    }
    return YES;
}

#pragma mark - Responding to keyboard events
-(void)keyboardWillShow:(NSNotification *)notification
{
    _isKeyboardShow = YES;
    
    if (changeNiMingCtl.isShowView && changeNiMingCtl)
    {
        [changeNiMingCtl viewWithHide];
    }
    if (!_isReply) {
        tipsLb_.text = @"";
    }
    
    [_articleDetailCtl keyBoardShow];
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    _keyboardHeight = keyboardRect.size.height;
    _faceBtn.selected = NO;
    
    if (_faceScrollView.isShow) {
        [self hideFaceView:YES];
    }
    
    CGRect frame = self.frame;
    frame.origin.y = ScreenHeight- 20 -  CGRectGetHeight(keyboardRect) - frame.size.height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.frame = frame;
    }];
    _keyboardHeight = keyboardRect.size.height;
    
    giveMyCommentBtn_.hidden = YES;
    _pingLunBtn.hidden = NO;
    
    [self changeTextViewFrame];
}

-(void)keyboardWillHide:(NSNotification *)notification {
    
    _isKeyboardShow = NO;
    if ([giveCommentTv_.text isEqualToString:@""]) {
        tipsLb_.text = tipsStr;
        _pingLunBtn.backgroundColor = PINGLUNHUI;
    }
    [_articleDetailCtl removeGesture];
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    if (!_faceScrollView.isShow)
    {
        _pingLunBtn.hidden = YES;
        giveMyCommentBtn_.hidden = NO;
        [self hideFaceView:YES];
    }
    [self finishTextViewEditing];
}

//显示表情
- (void)showFaceView{
    if (_faceScrollView == nil)
    {
        [self initFaceView];
    }
    _faceScrollView.isShow = YES;
    //添加点击事件
    [_articleDetailCtl addGesture];
    
    CGRect scrollFrame = _faceScrollView.frame;
    scrollFrame.origin.y = ScreenHeight - CGRectGetHeight(_faceScrollView.frame) - 20;
    
    CGRect frame = self.frame;
    frame.origin.y = CGRectGetMinY(scrollFrame)-frame.size.height;
    
    [UIView animateWithDuration:0.26 animations:^{
        self.frame = frame;
        _faceScrollView.frame = scrollFrame;
    }];
    _faceBtn.selected = YES;
    [self changeTextViewFrame];
}

- (void)initFaceView
{
    __weak ELArticleCommentView *this = self;
    _faceScrollView = [[FaceScrollView alloc] initWithBlock:^(NSString *faceName) {
        if ([faceName isEqualToString:@"delete"]) {
            NSString *text = this.giveCommentTv_.text;
            if (!text || [text isEqualToString:@""]) {
                return ;
            }
            NSString *result = [MyCommon substringExceptLastEmoji:text];
            if (![text isEqualToString:result]) {
                this.giveCommentTv_.text = result;
            }else{
                this.giveCommentTv_.text = [text substringToIndex:text.length-1];
            }
            if ([this.giveCommentTv_.text isEqualToString:@""]) {
                _pingLunBtn.backgroundColor = PINGLUNHUI;
            }
            [self changeTextViewFrame];
            return;
        }
        if (changeNiMingCtl) {
            [changeNiMingCtl viewWithHide]; 
        }
        tipsLb_.text = @"";
        NSString *temp = this.giveCommentTv_.text;
        this.giveCommentTv_.text = [temp stringByAppendingFormat:@"%@", faceName];
        _pingLunBtn.backgroundColor = PINGLUNHONG;
        [self changeTextViewFrame];
    }];
    _faceScrollView.backgroundColor = [UIColor whiteColor];
    _faceScrollView->faceView.backgroundColor = [UIColor whiteColor];
    _faceScrollView.frame = CGRectMake(0,ScreenHeight-20, 0, 0);
    [_articleDetailCtl.view addSubview:_faceScrollView];
    //tableView_.autoresizingMask = UIViewAutoresizingNone;
    self.autoresizingMask = UIViewAutoresizingNone;
    
    giveMyCommentBtn_.hidden = YES;
    _pingLunBtn.hidden = NO;
}

//隐藏表情,是否隐藏工具栏
- (void)hideFaceView:(BOOL)hideToolBar
{
    _faceScrollView.isShow = NO;
    
    if (!_isKeyboardShow)
    {
        CGRect scrollFrame = _faceScrollView.frame;
        scrollFrame.origin.y = ScreenHeight-20;
        
        CGRect frame = self.frame;
        frame.origin.y = CGRectGetMinY(scrollFrame)-self.frame.size.height;
        
        [UIView animateWithDuration:0.26 animations:^{
            self.frame = frame;
            _faceScrollView.frame = scrollFrame;
        }];
    }
    [_articleDetailCtl removeGesture];
    
    if (!_isKeyboardShow)
    {
        giveMyCommentBtn_.hidden = NO;
        _pingLunBtn.hidden = YES;
    }
    _faceBtn.selected = NO;
    [self finishTextViewEditing];
}

- (IBAction)changeHeaderBtnRespone:(UIButton *)sender
{
    if (!changeNiMingCtl) {
        changeNiMingCtl = [[GroupChangeNiMingViewCtl alloc] init];
        changeNiMingCtl.changeNiMingDelegate = self;
    }
    if (!changeNiMingCtl.isShowView)
    {
        changeNiMingCtl.view.frame = [UIScreen mainScreen].bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:changeNiMingCtl.view];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:changeNiMingCtl.view];
        
        [changeNiMingCtl viewWithShow:sImage.image sName:sName nImage:nImage.image nName:nName isNiMing:isNiMing];
        
        CGRect frameCtl = changeNiMingCtl.view.frame;
        
        CGFloat keyboary = 0;
        CGFloat faceScroll = 0;
        if (_isKeyboardShow) {
            keyboary = _keyboardHeight;
        }
        if (_faceScrollView.isShow) {
            faceScroll = _faceScrollView.frame.size.height;
        }
        frameCtl.size.height = CGRectGetHeight(_articleDetailCtl.view.bounds) - self.frame.size.height - keyboary - faceScroll;
        changeNiMingCtl.view.frame = frameCtl;
    }
    else
    {
        [changeNiMingCtl viewWithHide];
    }
}

-(void)changeNiMingWithBtnRespone:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
            isNiMing = YES;
            _headerImage.image = nImage.image;
            if([giveCommentTv_.text isEqualToString:@""])
            {
                tipsStr = @"点击头像可切换实名";
                tipsLb_.text = @"点击头像可切换实名";
            }
            else
            {
                tipsLb_.text = @"";
            }
            break;
        case 200:   
            isNiMing = NO;
            _headerImage.image = sImage.image;
            if ([giveCommentTv_.text isEqualToString:@""]) {
                tipsStr = @"点击头像可切换匿名";
                tipsLb_.text = @"点击头像可切换匿名";
            }
            else
            {
                tipsLb_.text = @"";
            }
            break;
        default:
            break;
    }
}

//加入公司群调用
-(void)joinCompany:(NSString *)groupId
{
    NSString * bodyMsg = nil;
    //非私密社群
    bodyMsg = [NSString stringWithFormat:@"group_id=%@&request_person_id=%@",groupId,[Manager getUserInfo].userId_];
    //组装请求参数
    [ELRequest postbodyMsg:bodyMsg op:Table_Op_JoinGroup func:Table_Func_JoinGroup requestVersion:NO success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dic = result;
         Status_DataModal * dataModal = [[Status_DataModal alloc] init];
         dataModal.code_ = [dic objectForKey:@"code"];
         dataModal.status_ = [dic objectForKey:@"status"];
         dataModal.des_ = [dic objectForKey:@"status_desc"];
         dataModal.status_ = [dataModal.status_ uppercaseString];
         if([dataModal.status_ isEqualToString:@"OK"])
         {
             [[Manager shareMgr] showSayViewWihtType:2];
         }
         if ([dataModal.status_ isEqualToString:Success_Status])
         {
             if ([dataModal.code_ isEqualToString:@"100"])
             {
                 [_articleDetailCtl.joinGroupDelegate joinSuccessRefresh];
                 [BaseUIViewController showAutoDismissSucessView:nil msg:@"你已成功加入该社群" seconds:1.0];
             }
         }
         
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         
     }];
    
}

//添加评论
-(void) addComment
{
    bSetToCommentOffset_ = YES;
    [giveCommentTv_ resignFirstResponder];
    giveCommentTv_.text = [MyCommon convertContent:giveCommentTv_.text];
    
    NSString *personId = [Manager getUserInfo].userId_;
    NSString *insider = @"";
    if (isCompanyGroup && isNiMing)
    {
        personId = myDataModal_._majia_info.personId;
        insider = [Manager getUserInfo].userId_;
    }
    
    NSString *content = [giveCommentTv_.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    content = [content URLEncodedForString];
    //组装分页参数
    NSMutableDictionary *insertDic = [[NSMutableDictionary alloc] init];
    [insertDic setObject:[NSString stringWithFormat:@"%@",myDataModal_.id_] forKey:@"article_id"];
    [insertDic setObject:[NSString stringWithFormat:@"%@",personId] forKey:@"user_id"];
    [insertDic setObject:[NSString stringWithFormat:@"%@",content] forKey:@"content"];
    if (insider.length > 0) 
    {
        [insertDic setObject:insider forKey:@"insider"];
    }
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *insertStr = [jsonWriter2 stringWithObject:insertDic];
    //组装请求参数
    NSString *bodyMsg = @"";
    NSString *op = @"";
    NSString *function = @"";
    BOOL verson = NO;
    
    if (isCompanyGroup) 
    {
        bodyMsg = [NSString stringWithFormat:@"insertArr=%@",insertStr];
        op = @"comm_comment_busi";
        function = @"addArticleComment";
        verson = YES;
    }
    else
    {
        bodyMsg = [NSString stringWithFormat:@"insertArr=%@",insertStr];
        op = @"comm_comment";
        function = @"addArticleComment";
        verson = NO;
    }
    
    [BaseUIViewController showLoadView:YES content:@"正在提交" view:nil];
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:verson success:^(NSURLSessionDataTask *operation, id result) 
    {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
        NSDictionary *dic = result;
        Status_DataModal * dataModal = [[Status_DataModal alloc] init];
        dataModal.status_ = [dic objectForKey:@"status"];
        dataModal.code_ = [dic objectForKey:@"code"];
        dataModal.des_ = [dic objectForKey:@"status_desc"];
        if( [dataModal.status_ isEqualToString:Success_Status])
        {
            if (_articleDetailCtl.addCommentSuccessBlock) {
                _articleDetailCtl.addCommentSuccessBlock(NO,YES);
            }
            [BaseUIViewController showAutoDismissAlertView:nil msg:@"评论成功" seconds:1.0];
            giveCommentTv_.text = @"";
            [giveCommentTv_ resignFirstResponder];

            myDataModal_.c_cnt = [NSString stringWithFormat:@"%ld",(long)([myDataModal_.c_cnt integerValue]+1)];
            [giveMyCommentBtn_ setTitle:[NSString stringWithFormat:@"%ld",(long)[myDataModal_.c_cnt integerValue]] forState:UIControlStateNormal];
            [giveMyCommentBtn_.titleLabel setFont:[UIFont systemFontOfSize:10]];
            [giveMyCommentBtn_ setImage:[UIImage imageNamed:@"icon_assess2_def2.png"] forState:UIControlStateNormal];
            
            [self joinCompany:myDataModal_._group_info.group_id];
            [self changeTextViewFrame];
            [_articleDetailCtl setMycontentoffset];
            [_articleDetailCtl refreshCommentSuccess];
            tipsStr = @"我来说两句";
            tipsLb_.text = tipsStr;
        }
        else{
            [BaseUIViewController showAutoDismissFailView:nil msg:dataModal.des_ seconds:2.0];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
           [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];
}

-(BOOL)getPersonNameNiMingStatus{
    if (isNiMing && isCompanyGroup) {
        return YES;
    }
    return NO;
}

@end

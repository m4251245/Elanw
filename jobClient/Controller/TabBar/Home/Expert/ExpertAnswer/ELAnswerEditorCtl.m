//
//  ELAnswerEditorCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/9/14.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELAnswerEditorCtl.h"
#import "ELRequest.h"
#import "FaceScrollView.h"
#import "AnswerDetialModal.h"

@interface ELAnswerEditorCtl ()<UITextViewDelegate>
{
    UITextView *contentTV;
    UILabel *contentTipsLb;
    BOOL fillFinish; //标识能否点击下一步
    
    UIButton *faceButton;
    UIButton *showButton;
    FaceScrollView *_faceScrollView;
    UIView *titleBackView;
    CGFloat startY;
    CGFloat titleHeight;
    UIView *answerView;
    BOOL isShow;
}
@end

@implementation ELAnswerEditorCtl

-(instancetype)init{
    self = [super init];
    if (self) {
        rightNavBarStr_ = @"提交";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight-64);
    // Do any additional setup after loading the view from its nib.
    [self setNavTitle:@"回答"];
    
    [ELRequest postbodyMsg:[NSString stringWithFormat:@"question_id=%@",_questionId] op:@"zd_ask_question_busi" func:@"getquestion_content" requestVersion:YES progressFlag:YES progressMsg:@"" success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString *title = dic[@"question_title"];
            NSString *content = dic[@"question_content"];
            if ([title isKindOfClass:[NSString class]]) {
                if (title.length > 0) {
                    title = [MyCommon MyfilterHTML:title];
                    title = [MyCommon translateHTML:title];
                    _questionTitle = title;
                }
            }
            if ([content isKindOfClass:[NSString class]]) {
                if (content.length > 0) {
                    content = [MyCommon MyfilterHTML:content];
                    content = [MyCommon translateHTML:content];
                    _questionContent = content;
                }
            }
        }
        [self creatUI];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self creatUI];
    }];
    
}

-(void)creatUI{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight-64)];
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:scrollView];
    self.scrollView_ = scrollView;
    
    titleBackView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,100)];
    titleBackView.backgroundColor = [UIColor whiteColor];
    titleBackView.clipsToBounds = YES;
    [scrollView addSubview:titleBackView];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(16,14,ScreenWidth-32,0)];
    titleLb.textColor = UIColorFromRGB(0x212121);
    titleLb.font = [UIFont systemFontOfSize:16];
    titleLb.text = [MyCommon translateHTML:_questionTitle];
    titleLb.numberOfLines = 0;
    [titleLb sizeToFit];
    titleLb.frame = CGRectMake(16,14,ScreenWidth-32,titleLb.height);
    [titleBackView addSubview:titleLb];
    
    UILabel *contentLb = [[UILabel alloc] initWithFrame:CGRectMake(16,14,ScreenWidth-32,0)];
    contentLb.textColor = UIColorFromRGB(0x9e9e9e);
    contentLb.font = FOURTEENFONT_CONTENT;
    contentLb.text = [MyCommon translateHTML:_questionContent];
    contentLb.numberOfLines = 0;
    [contentLb sizeToFit];
    contentLb.frame = CGRectMake(16,CGRectGetMaxY(titleLb.frame)+13,ScreenWidth-32,contentLb.height);
    [titleBackView addSubview:contentLb];
    titleHeight = CGRectGetMaxY(contentLb.frame)+8;
    
    NSInteger titleLine = (titleLb.height/titleLb.font.lineHeight);
    NSInteger contentLine = (contentLb.height/contentLb.font.lineHeight);
    BOOL showB = NO;
    startY = 0;
    if (titleLine > 6){
        showB = YES;
        startY = titleLb.frame.origin.y+(titleLb.font.lineHeight*6);
    }else if ((titleLine + contentLine) > 6){
        showB = YES;
        if (titleLine == 6) {
            startY = titleLb.frame.origin.y+(titleLb.font.lineHeight*6);
        }else{
            startY = contentLb.frame.origin.y + (contentLb.font.lineHeight*(6-titleLine));
        }
    }else{
        startY = CGRectGetMaxY(contentLb.frame)+16;
        showB = NO;
    }
    titleBackView.frame = CGRectMake(0,0,ScreenWidth,startY);
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    CGFloat lineY = 0;
    if (showB){
        whiteView.frame = CGRectMake(0,0,ScreenWidth,180);
        showButton = [UIButton buttonWithType:UIButtonTypeCustom];
        showButton.frame = CGRectMake((ScreenWidth-40)/2,0,40,40);
        [showButton setImage:[UIImage imageNamed:@"jobquestion_bottom"] forState:UIControlStateNormal];
        [showButton addTarget:self action:@selector(showAllContent:) forControlEvents:UIControlEventTouchUpInside];
        isShow = NO;
        [whiteView addSubview:showButton];
        lineY = 40;
    }else{
        whiteView.frame = CGRectMake(0,0,ScreenWidth,140);
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,lineY,ScreenWidth,10)];
    lineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [whiteView addSubview:lineView];
    
    contentTV = [[UITextView alloc] initWithFrame:CGRectMake(16,CGRectGetMaxY(lineView.frame)+16,ScreenWidth-32,96)];
    contentTV.delegate = self;
    contentTV.textColor = UIColorFromRGB(0x212121);
    contentTV.font = [UIFont systemFontOfSize:16];
    contentTV.bounces = NO;
    [whiteView addSubview:contentTV];
    
    contentTipsLb = [[UILabel alloc] initWithFrame:CGRectMake(16,CGRectGetMaxY(lineView.frame)+16,200,20)];
    contentTipsLb.font = [UIFont systemFontOfSize:16];
    contentTipsLb.textColor = UIColorFromRGB(0xBDBDBD);
    contentTipsLb.text = @"请输入回答内容";
    [whiteView addSubview:contentTipsLb];
    
    answerView = [[UIView alloc] initWithFrame:CGRectMake(0,startY,ScreenWidth,whiteView.height+40)];
    answerView.backgroundColor = [UIColor clearColor];
    [answerView addSubview:whiteView];
    [scrollView addSubview:answerView];
    
    faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    faceButton.frame = CGRectMake(5,CGRectGetMaxY(whiteView.frame)+5,35,35);
    [faceButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
    [faceButton addTarget:self action:@selector(faceBtnRespone:) forControlEvents:UIControlEventTouchUpInside];
    [answerView addSubview:faceButton];
    
    self.scrollView_.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(answerView.frame));
    
    [self changeDataFillFinish];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name: UITextViewTextDidChangeNotification object:nil];
    contentTV.textContainerInset = UIEdgeInsetsMake(0,0,0,0);
    
    if (_editorModel) {
        if (_editorModel.answer_content) {
            contentTV.text = _editorModel.answer_content;
            contentTipsLb.hidden = YES;
            [self changeDataFillFinish];
        }
    }
}

-(void)showAllContent:(UIButton *)sender{
    CGFloat height = 0;
    if (!isShow) {
        [showButton setImage:[UIImage imageNamed:@"jobquestion_top"] forState:UIControlStateNormal];
        isShow = YES;
        height = titleHeight;
    }else{
        [showButton setImage:[UIImage imageNamed:@"jobquestion_bottom"] forState:UIControlStateNormal];
        isShow = NO;
        height = startY;
    }
    CGRect frame = answerView.frame;
    frame.origin.y = height;
    CGRect titleF = titleBackView.frame;
    titleF.size.height = height;
    [UIView animateWithDuration:0.3 animations:^{
        titleBackView.frame = titleF;
        answerView.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            self.scrollView_.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(frame));
        } 
    }];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

#pragma UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyboardWillHide:(NSNotification *)notification{
    [super keyboardWillHide:notification];
    if (!_faceScrollView.isShow) {
        self.scrollView_.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight-64);
    }
}

-(void)keyboardWillShow:(NSNotification *)notification{
    [super keyboardWillShow:notification];
    if (_faceScrollView.isShow){
        [self hideFaceView];
    }
    self.scrollView_.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight-64-self.keyBoardHeight);
    if(self.scrollView_.contentSize.height > self.scrollView_.frame.size.height){
        self.scrollView_.contentOffset = CGPointMake(0,self.scrollView_.contentSize.height-self.scrollView_.frame.size.height);
    }
}

#pragma mark - 动态改变社群名称输入框的高度和位置
-(void)textChanged:(NSNotification *)textView{
    if (contentTV.isFirstResponder){
        [self changeTextViewFrame];
    }
}

-(void)changeTextViewFrame{
    [self changeDataFillFinish];
    [contentTV scrollRangeToVisible:contentTV.selectedRange];
}

#pragma mark - 修改右上方按钮的状态
-(void)setDataFinish:(BOOL)isFinish{
    if (isFinish) {
        [rightBarBtn_ setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }else{
        [rightBarBtn_ setTitleColor:UIColorFromRGB(0xf3b4b4) forState:UIControlStateNormal];
    }
}

-(void)changeDataFillFinish{
    BOOL isFinish = NO;
    fillFinish = NO;
    NSString *str = [contentTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(str.length > 0){
        fillFinish = YES;
        isFinish = YES;
    }
    [self setDataFinish:isFinish];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == contentTV){
        if (textView.text.length <= 0) {
            contentTipsLb.hidden = NO;
        }
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == contentTV) {
        contentTipsLb.hidden = YES;
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(textView == contentTV){
        [MyCommon dealLabNumWithTipLb:nil numLb:nil textView:contentTV wordsNum:1000];
    }
    [textView scrollRangeToVisible:textView.selectedRange];
}
- (void)setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"提交" forState:UIControlStateNormal];
    [rightBarBtn_ setTitleColor:UIColorFromRGB(0xf3b4b4) forState:UIControlStateNormal];
    [rightBarBtn_ setFrame:CGRectMake(0, 0, 50, 44)];
    [rightBarBtn_.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [rightBarBtn_ setBackgroundColor:[UIColor clearColor]];
}

-(void)rightBarBtnResponse:(id)sender
{
    if (!fillFinish) {
        return;
    }
    NSString *giveTextStr = contentTV.text;
    giveTextStr = [giveTextStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    giveTextStr = [giveTextStr stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    giveTextStr = [giveTextStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    NSMutableString *string = [[NSMutableString alloc] initWithString:giveTextStr];
    [string replaceOccurrencesOfString:@"'" withString:@"\\'" options:NSCaseInsensitiveSearch range:NSMakeRange(0,giveTextStr.length)];
    [string replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,giveTextStr.length)];
    [string replaceOccurrencesOfString:@"•" withString:@"·" options:NSCaseInsensitiveSearch range:NSMakeRange(0,giveTextStr.length)];
    [string replaceOccurrencesOfString:@"¥" withString:@"￥" options:NSCaseInsensitiveSearch range:NSMakeRange(0,giveTextStr.length)];
    [string replaceOccurrencesOfString:@"、 " withString:@"、" options:NSCaseInsensitiveSearch range:NSMakeRange(0,giveTextStr.length)];
    giveTextStr = [NSString stringWithFormat:@"%@",string];
    giveTextStr = [giveTextStr URLEncodedForString];
    [contentTV resignFirstResponder];
    
    if (_editorModel){
        NSString * bodyMsg = [NSString stringWithFormat:@"answer_id=%@&content=%@",_editorModel.answer_id,giveTextStr];
        [ELRequest postbodyMsg:bodyMsg op:@"zd_ask_question_busi" func:@"doeditAnswer" requestVersion:YES progressFlag:YES progressMsg:@"正在提交" success:^(NSURLSessionDataTask *operation, id result) {
            NSDictionary *dic = result;
            if ([dic isKindOfClass:[NSDictionary class]]) {
                Status_DataModal * model = [[Status_DataModal alloc] init];
                model.code_ = [dic objectForKey:@"code"];
                model.status_ = [dic objectForKey:@"status"];
                model.des_ = [dic objectForKey:@"status_desc"];
                if ([model.code_ isEqualToString:@"200"]){
                    [BaseUIViewController showAutoDismissSucessView:@"修改成功" msg:nil];
                    [contentTV resignFirstResponder];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"answerEditorSuccessRefresh" object:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                    [BaseUIViewController  showAutoDismissFailView:model.des_ msg:nil];
                }
            }else{
                [BaseUIViewController showAutoDismissSucessView:@"出错了，请稍后再试" msg:nil];
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [BaseUIViewController showAutoDismissSucessView:@"出错了，请稍后再试" msg:nil];
        }];
    }else{
        NSString * bodyMsg = [NSString stringWithFormat:@"uid=%@&question_id=%@&content=%@",[Manager getUserInfo].userId_,_questionId,giveTextStr];
        [ELRequest postbodyMsg:bodyMsg op:@"zd_ask_answer" func:@"submitAnswer" requestVersion:NO progressFlag:YES progressMsg:@"正在提交" success:^(NSURLSessionDataTask *operation, id result) {
            NSDictionary *dic = result;
            if ([dic isKindOfClass:[NSDictionary class]]) {
                Status_DataModal * model = [[Status_DataModal alloc] init];
                model.code_ = [dic objectForKey:@"code"];
                model.status_ = [dic objectForKey:@"status"];
                model.des_ = [dic objectForKey:@"status_desc"];
                if ([model.status_ isEqualToString:@"OK"]) {
                    [BaseUIViewController showAutoDismissSucessView:model.des_ msg:nil];
                    [contentTV resignFirstResponder];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"answerEditorSuccessRefresh" object:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                    [BaseUIViewController  showAutoDismissFailView:model.des_ msg:nil];
                }
            }else{
                [BaseUIViewController showAutoDismissSucessView:@"出错了，请稍后再试" msg:nil];
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [BaseUIViewController showAutoDismissSucessView:@"出错了，请稍后再试" msg:nil];
        }];
    }
}

-(void)faceBtnRespone:(UIButton *)sender{
    if (_faceScrollView.isShow) {
        [self hideFaceView];
    }else{
        [self showFaceView];
    }
    [contentTV resignFirstResponder];
}

-(void)dismissKeyboard{
    [contentTV resignFirstResponder];
    if (_faceScrollView.isShow) {
        [self hideFaceView];
    }
}

//显示表情
- (void)showFaceView{
    if (_faceScrollView.isShow) {
        return;
    }
    if (_faceScrollView == nil)
    {
        [self initFaceView];
    }
    _faceScrollView.isShow = YES;
    CGRect scrollFrame = _faceScrollView.frame;
    scrollFrame.origin.y = ScreenHeight - CGRectGetHeight(_faceScrollView.frame) - 64;
    self.scrollView_.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight-64-scrollFrame.size.height);
    [UIView animateWithDuration:0.26 animations:^{
        _faceScrollView.frame = scrollFrame;
    } completion:^(BOOL finished) {
        if (finished) {
            if(self.scrollView_.contentSize.height > self.scrollView_.frame.size.height){
                self.scrollView_.contentOffset = CGPointMake(0,self.scrollView_.contentSize.height-self.scrollView_.frame.size.height);
            }
        }
    }];
    
    
}

- (void)initFaceView
{
    __weak ELAnswerEditorCtl *this = self;
    _faceScrollView = [[FaceScrollView alloc] initWithBlock:^(NSString *faceName) {
        [this changeTextViewFaceStrring:faceName];
    }];
    _faceScrollView.backgroundColor = [UIColor whiteColor];
    _faceScrollView->faceView.backgroundColor = [UIColor whiteColor];
    _faceScrollView.frame = CGRectMake(0,ScreenHeight-20, 0, 0);
    [self.view addSubview:_faceScrollView];
}

-(void)changeTextViewFaceStrring:(NSString *)faceName{  
    if ([faceName isEqualToString:@"delete"]) {
        NSString *text = contentTV.text;
        if (!text || [text isEqualToString:@""]) {
            return ;
        }
        NSString *result = [MyCommon substringExceptLastEmoji:text];
        if (![text isEqualToString:result]) {
            contentTV.text = result;
        }else{
            contentTV.text = [text substringToIndex:text.length-1];
        }
        [self changeTextViewFrame];
        return;
    }
    contentTipsLb.text = @"";
    NSString *temp = contentTV.text;
    contentTV.text = [temp stringByAppendingFormat:@"%@",faceName];
    [self changeTextViewFrame];
}

//隐藏表情,是否隐藏工具栏
- (void)hideFaceView
{
    if (!_faceScrollView.isShow) {
        return;
    }
    _faceScrollView.isShow = NO;
    CGRect scrollFrame = _faceScrollView.frame;
    scrollFrame.origin.y = ScreenHeight-20;
    [UIView animateWithDuration:0.26 animations:^{
        _faceScrollView.frame = scrollFrame;
        self.scrollView_.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight-64);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

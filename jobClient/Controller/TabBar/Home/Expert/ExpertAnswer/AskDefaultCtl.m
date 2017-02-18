//
//  AskDefaultCtl.m
//  Association
//
//  Created by 一览iOS on 14-6-4.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "AskDefaultCtl.h"
#import "TagsOfAskDefaultCtl.h"
#import "ELLineView.h"
#import "ELJobGuideLableChangeCtl.h"
#import "AnswerDetialModal.h"

@interface AskDefaultCtl ()<UITextViewDelegate>
{
    Answer_DataModal *answerModal;
    
    __weak IBOutlet UIView *backView;
    
    __weak IBOutlet UITextView *contentTV;
    __weak IBOutlet UITextView *titleTV;
    
    __weak IBOutlet UILabel *titleTipsLb;
    
    __weak IBOutlet UILabel *contentTipsLb;
    
    BOOL fillFinish; //标识能否点击下一步
    CGFloat textViewHeight;
}
@end

@implementation AskDefaultCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rightNavBarStr_ = @"下一步";
        rightNavBarRightWidth = @"16";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"提问";
    [self setNavTitle:@"提问"];
    // Do any additional setup after loading the view from its nib.
    
    titleTV.delegate = self;
    contentTV.delegate = self;
    [self changeDataFillFinish];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name: UITextViewTextDidChangeNotification object:nil];
    titleTV.textContainerInset = UIEdgeInsetsMake(0,0,0,0);
    contentTV.textContainerInset = UIEdgeInsetsMake(0,0,0,0);
    //标题下方的线
    ELLineView *lineView = [[ELLineView alloc] initWithFrame:CGRectMake(0,56,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)];
    [backView addSubview:lineView];
    
    if (_editorModel) {
        if (_editorModel.question_title && ![_editorModel.question_title isEqualToString:@""]) {
            titleTV.text = _editorModel.question_title;
            titleTipsLb.hidden = YES;
        }
        if (_editorModel.question_content && ![_editorModel.question_content isEqualToString:@""]){
            contentTV.text = _editorModel.question_content;
            contentTipsLb.hidden = YES;
        }
        [self changeDataFillFinish];
        CGRect textFrame = [[titleTV layoutManager] usedRectForTextContainer:[titleTV textContainer]];
        CGFloat height = textFrame.size.height;
        if (fabs(height -textViewHeight) < 10) {
            return;
        }
        CGRect frame = titleTV.frame;
        if (height < 20) {
            frame.origin.y = 18;
        }else{
            frame.origin.y = 10;
        }
        titleTV.frame = frame;
        textViewHeight = height;
    }
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    answerModal = [[Answer_DataModal alloc] init];
    answerModal.expertId_ = dataModal;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 动态改变输入框的高度和位置
-(void)textChanged:(UITextView *)textView{
    if (titleTV.isFirstResponder){
        [self changeDataFillFinish];
        CGRect textFrame = [[titleTV layoutManager] usedRectForTextContainer:[titleTV textContainer]];
        CGFloat height = textFrame.size.height;
        if (fabs(height -textViewHeight) < 10) {
            return;
        }
        CGRect frame = titleTV.frame;
        if (height < 20) {
            frame.origin.y = 18;
        }else{
            frame.origin.y = 10;
        }
        titleTV.frame = frame;
        textViewHeight = height;
    }
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
    NSString *str = [titleTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(str.length > 0){
        fillFinish = YES;
        isFinish = YES;
    }
    [self setDataFinish:isFinish];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == titleTV) {
        if (textView.text.length <= 0) {
            titleTipsLb.hidden = NO;
        }
    }else if (textView == contentTV) {
        if (textView.text.length <= 0) {
            contentTipsLb.hidden = NO;
        }
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == titleTV) {
        titleTipsLb.hidden = YES;
    }else if (textView == contentTV) {
        contentTipsLb.hidden = YES;
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(textView == titleTV){
        [MyCommon dealLabNumWithTipLb:nil numLb:nil textView:titleTV wordsNum:50];
    }else if(textView == contentTV){
        [MyCommon dealLabNumWithTipLb:nil numLb:nil textView:contentTV wordsNum:1000];
    }
    [textView scrollRangeToVisible:textView.selectedRange];
}
- (void)setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"下一步" forState:UIControlStateNormal];
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
    NSString *giveTextStr = titleTV.text;
    giveTextStr = [giveTextStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    giveTextStr = [giveTextStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    giveTextStr = [giveTextStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if ([giveTextStr length] < 5) {
        [BaseUIViewController showAlertView:@"提问不能少于5个字" msg:nil btnTitle:@"确定"];
        return;
    }
    answerModal.questionContent_ = titleTV.text;
    answerModal.content_ = contentTV.text;
    ELJobGuideLableChangeCtl *ctl = [[ELJobGuideLableChangeCtl alloc] init];
    ctl.backCtlIndex = _backCtlIndex;
    ctl.fromTodayList = _fromTodayList;
    if (_editorModel) {
        _editorModel.question_content = contentTV.text;
        _editorModel.question_title = titleTV.text;
        ctl.editorModel = _editorModel;
    }
    [self.navigationController pushViewController:ctl animated:YES];
    [ctl beginLoad:answerModal exParam:nil];
    
//    TagsOfAskDefaultCtl *tagsCtl = [[TagsOfAskDefaultCtl alloc] init];
//    tagsCtl.fromTodayList = _fromTodayList;
//    [self.navigationController pushViewController:tagsCtl animated:YES];
//    [tagsCtl beginLoad:answerModal exParam:nil];    
}

@end

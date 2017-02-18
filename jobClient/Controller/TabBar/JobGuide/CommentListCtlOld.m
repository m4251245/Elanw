//
//  CommentListCtl.m
//  MBA
//
//  Created by sysweal on 13-11-20.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "CommentListCtlOld.h"
#import "CommentListCtl_Cell.h"
#import "Comment_DataModal.h"
#import "CommentSubView.h"
#import "Subject_DataModal.h"
#import "FaceScrollView.h"
#import "AnswerDetialModal.h"

@interface CommentListCtlOld ()
{
    BOOL _isKeyboardShow;
    CGFloat _keyboardHeight;
    FaceScrollView *_faceScrollView;
    CGFloat textViewHeight;
    __weak IBOutlet UIView *msgBackView;
    
}
@end

@implementation CommentListCtlOld

@synthesize giveCommentView_,giveCommentTv_,giveMyCommentBtn_,objId_,typeStr_,delegate_,tipsLb_;

-(id) init
{
    self = [super init];
    
    
    bFooterEgo_ = YES;
    maxDesLine_ = 4;
    selfViewOriginY_ = -1000;
    
    imageConArr_ = [[NSMutableArray alloc] init];
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//    self.navigationItem.title = @"";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setFd_prefersNavigationBarHidden:NO];
//    self.navigationItem.title = @"评论";
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setFd_prefersNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.title = @"评论";
    [self setNavTitle:@"评论"];
    giveCommentTv_.delegate = self;
    
    tableView_.backgroundView = nil;
    [_faceBtn setImage:[UIImage imageNamed:@"icon_keyboard.png"] forState:UIControlStateSelected];
    //设置圆角
    CALayer *layer=[msgBackView layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1.0];
    [layer setCornerRadius:6.0];
    [layer setBorderColor:[[UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1] CGColor]];
    
    giveMyCommentBtn_.clipsToBounds = YES;
    giveMyCommentBtn_.layer.cornerRadius = 3.0;
    
    //设置阴影
    layer=[giveCommentView_ layer];
    layer.shadowOffset = CGSizeMake(0, -0.5); //设置阴影的偏移量
    //layer.shadowRadius = 1.0;  //设置阴影的半径
    layer.shadowColor = [UIColor blackColor].CGColor; //设置阴影的颜色为黑色
    layer.shadowOpacity = 0.1; //设置阴影的不透明度
    layer.shadowPath =[UIBezierPath bezierPathWithRect:giveCommentView_.bounds].CGPath;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name: UITextViewTextDidChangeNotification object:nil];
}

-(void)textChanged:(UITextView *)textView
{
    [self changeTextViewFrame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加评论
-(void) addComment
{
    NSString *giveTextStr = giveCommentTv_.text;
    giveTextStr = [giveTextStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    giveTextStr = [giveTextStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    giveTextStr = [giveTextStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if( giveTextStr.length < Min_Comment_Length ){
        [BaseUIViewController showAlertView:nil msg:[NSString stringWithFormat:@"评论内容长度不能少于%d个字符",Min_Comment_Length] btnTitle:@"确定"];
        return;
    }
    
    if( !addCommentCon_ ){
        addCommentCon_ = [self getNewRequestCon:NO];
    }

    NSString *str = [MyCommon convertContent:giveCommentTv_.text];
    if (!selectDataModal_) {
        NewAnswerListModal *datamodal = (NewAnswerListModal *)inDataModal;
        [addCommentCon_ submitAnwserComment:[Manager getUserInfo].userId_ answerId:datamodal.answer_id content:str parentid:@"" reUserId:@""];
    }
    else
    {
        Comment_DataModal *datamodal = selectDataModal_;
        [addCommentCon_ submitAnwserComment:[Manager getUserInfo].userId_ answerId:datamodal.objectId_ content:str parentid:datamodal.id_ reUserId:datamodal.userId_];
    }
}

//添加评论成功
-(void) haveAddCommentOK
{
    [MyLog Log:@"add comment ok" obj:self];
}

//将所有评论的PageInfo+1
-(void) addPageInfo
{
    for ( Comment_DataModal *dataModal in requestCon_.dataArr_ ) {
        ++dataModal.totalCnt_;
    }
}

-(void) beginLoad:(id)dataModal exParam:(id)exParam
{
    
    [imageConArr_ removeAllObjects];
    inDataModal = dataModal;
    [super beginLoad:dataModal exParam:exParam];
}

-(void) getDataFunction:(RequestCon *)con
{
    NSString * myid;
    
    if ([inDataModal isKindOfClass:[AnswerListModal class]]) {
        AnswerListModal *datamodal = (AnswerListModal *)inDataModal;
        myid = datamodal.answer_id;
        
        if( con == requestCon_ ){
            [con getReplyCommentList:myid pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:20];
        }
    }

}

-(void)errorGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type
{
    [super errorGetData:requestCon code:code type:type];
    switch (type) {
        case Request_AddComment:
        {
            
        }
            break;
        default:
            break;
    }
}

-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
            /*
        case Request_Image:
        {
            @try {
                for( Comment_DataModal *dataModal in requestCon_.dataArr_ ){
                    Comment_DataModal * lastData = [self getDataModal:dataModal index:[dataModal.childList_ count]];
                    if( [lastData.author.img_ isEqualToString:requestCon.url_] ){
                        lastData.author.imageData_ = [dataArr objectAtIndex:0];
                    }
                }
                
                [imageConArr_ removeObject:requestCon];
                [tableView_ reloadData];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
            break;
             */
        case Request_AddComment:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            
            if( [dataModal.status_ isEqualToString:Success_Status] ){
                [BaseUIViewController showAutoDismissAlertView:nil msg:@"评论成功" seconds:2.0];
                
                giveCommentTv_.text = @"";
                [giveCommentTv_ resignFirstResponder];
                [self haveAddCommentOK];
                
                [self changeTextViewFrame];
                [self refreshLoad:nil];
                [delegate_ refreshSelf:self];
                
                NSString * typeStr = [RegCtl getRegTypeStr:[Manager shareMgr].registeType_];
                NSDictionary *dict = @{@"Source" : typeStr};
                [MobClick event:@"commentCount" attributes:dict];
                
            }else{
                
                [BaseUIViewController showAutoDismissFailView:nil msg:dataModal.des_ seconds:1.0];
            }
        }
            break;
        case Request_SubmitAnswerComment:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            
            if( [dataModal.code_ isEqualToString:@"200"] ){
                [BaseUIViewController showAutoDismissAlertView:nil msg:@"评论成功" seconds:2.0];
                
                giveCommentTv_.text = @"";
                [giveCommentTv_ resignFirstResponder];
                
                [self haveAddCommentOK];
                
                [self refreshLoad:nil];
                if ([delegate_ respondsToSelector:@selector(refreshSelf:)]) {
                    [delegate_ refreshSelf:self];
                }
                NSString * typeStr = [RegCtl getRegTypeStr:[Manager shareMgr].registeType_];
                NSDictionary *dict = @{@"Source" : typeStr};
                [MobClick event:@"commentCount" attributes:dict];
            }else{
                [BaseUIViewController showAutoDismissFailView:nil msg:dataModal.des_ seconds:1.0];
            }
        }
            break;
        case Request_GetReplyCommentList:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma AddReplyCommentDelegate
-(void) addReplyCommentOK:(ReplyCommentCtl *)ctl dataModal:(Comment_DataModal *)dataModal
{
    [self refreshLoad:nil];
    [delegate_ refreshSelf:self];
    [self haveAddCommentOK];
}

#pragma AddReplyAnswerCommentDelegate
-(void) addReplyAnswerCommentOK:(ReplyCommentCtl *)ctl dataModal:(Comment_DataModal *)dataModal
{
    [self refreshLoad:nil];
    [delegate_ refreshSelf:self];
    [self haveAddCommentOK];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentListCtl_Cell";
    
    CommentListCtl_Cell *cell = (CommentListCtl_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentListCtl_Cell" owner:self options:nil] lastObject];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        CALayer *layer = [cell.picBtn_ layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:8];
    }
    
    Comment_DataModal *dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    [cell setDataModal:dataModal];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     Comment_DataModal *dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    return dataModal.cellHeight;
}

-(void) loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    Comment_DataModal *commentData = selectData;
    selectDataModal_ = commentData;
    
    tipsLb_.text = [NSString stringWithFormat:@"回复:%@",commentData.author.iname_];
    giveCommentTv_.text = @"";
    [giveCommentTv_ becomeFirstResponder];
}

#pragma mark - UITextViewDelegate
-(BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (giveCommentTv_.text.length > 0) {
        giveMyCommentBtn_.backgroundColor = PINGLUNHONG;
    }
    else
    {
        giveMyCommentBtn_.backgroundColor = PINGLUNHUI;
    }
}

-(void)changeTextViewFrame
{
    CGRect textFrame=[[giveCommentTv_ layoutManager] usedRectForTextContainer:[giveCommentTv_ textContainer]];
    CGFloat height = textFrame.size.height;
    if (fabs(height -textViewHeight) < 10) {
        return;
    }
    textViewHeight = height;
    giveCommentTv_.textContainerInset = UIEdgeInsetsMake(0,0,0,0);
    CGRect frame = msgBackView.frame;
    if (height > 90) {
        frame.size.height = 84;
    }else{
        frame.size.height = height > 30 ? height:30; 
    }
    msgBackView.frame = frame;
    
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
    frame = giveCommentView_.frame;
    frame.size.height = msgBackView.frame.size.height +10;
    frame.origin.y = ScreenHeight- 64 -  heightOne - frame.size.height;
    giveCommentView_.frame = frame;
    if(msgBackView.frame.size.height >= 84){
        [giveCommentTv_ scrollRangeToVisible:giveCommentTv_.selectedRange]; 
    } 
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    tipsLb_.text = @"";
    NSString *content = textView.text;
    if(range.length == 1 && [text isEqualToString:@""]) {
        NSString *result = [MyCommon substringExceptLastEmoji:content];
        if (![content isEqualToString:result]) {
            textView.text = result;
            if([textView.text isEqualToString:@""])
            {
                giveMyCommentBtn_.backgroundColor = PINGLUNHUI;
            }
            return NO;
        }
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == tableView_) {
        [giveCommentTv_ resignFirstResponder];
    }
}

#pragma mark - Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    
    if (singleTapRecognizer_) {
        [MyCommon removeTapGesture:tableView_ ges:singleTapRecognizer_];
        singleTapRecognizer_ = nil;
    }
    //停止scrollview的滚动
    [tableView_ setContentOffset:tableView_.contentOffset animated:NO];
    
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
    
    CGRect frame = giveCommentView_.frame;
    frame.origin.y = CGRectGetHeight(self.view.bounds) -  CGRectGetHeight(keyboardRect) - frame.size.height;
    
    CGRect tableFrame = tableView_.frame;
    tableFrame.size.height = self.view.frame.size.height - CGRectGetHeight(keyboardRect) - frame.size.height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        tableView_.frame = tableFrame;
        giveCommentView_.frame = frame;
    }];
    
    //添加点击事件
    singleTapRecognizer_ = [MyCommon addTapGesture:tableView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    _isKeyboardShow = YES;
    _keyboardHeight = keyboardRect.size.height;
    
    [self changeTextViewFrame];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    [MyCommon removeTapGesture:tableView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    
    _isKeyboardShow = NO;
    
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    //NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];

    if ([giveCommentTv_.text isEqualToString:@""] && !_faceScrollView.isShow) {
        tipsLb_.text = @"我有话说...";
        giveMyCommentBtn_.backgroundColor = PINGLUNHUI;
        selectDataModal_ = nil;
    }
    
    if(!_faceScrollView.isShow)
    {
        [self hideFaceView:YES];
    }
    
}

//显示表情
- (void)showFaceView{
    if (_faceScrollView == nil) {
        [self initFaceView];
    }
    _faceScrollView.isShow = YES;
    //添加点击事件
    singleTapRecognizer_ = [MyCommon addTapGesture:tableView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    [self changeTextViewFrame];

    CGRect frame = giveCommentView_.frame;
    frame.origin.y = CGRectGetHeight(self.view.bounds) -  CGRectGetHeight(_faceScrollView.frame) - frame.size.height;
    
    CGRect scrollFrame = _faceScrollView.frame;
    scrollFrame.origin.y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_faceScrollView.frame);
    
    CGRect tableFrame = tableView_.frame;
    tableFrame.size.height = self.view.frame.size.height - CGRectGetHeight(scrollFrame) - frame.size.height;
    
    [UIView animateWithDuration:0.26 animations:^{
        tableView_.frame = tableFrame;
        giveCommentView_.frame = frame;
        _faceScrollView.frame = scrollFrame;
    }];
    _faceBtn.selected = YES;
}

- (void)initFaceView
{
    __weak CommentListCtlOld *this = self;
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
            if([this.giveCommentTv_.text isEqualToString:@""])
            {
                giveMyCommentBtn_.backgroundColor = PINGLUNHUI;
            }
            [self changeTextViewFrame];
            return;
        }
        tipsLb_.text = @"";
        NSString *temp = this.giveCommentTv_.text;
        this.giveCommentTv_.text = [temp stringByAppendingFormat:@"%@", faceName];
        giveMyCommentBtn_.backgroundColor = PINGLUNHONG;
        [self changeTextViewFrame];
    }];
    _faceScrollView.backgroundColor = [UIColor whiteColor];
    _faceScrollView->faceView.backgroundColor = [UIColor whiteColor];
    _faceScrollView.frame = CGRectMake(0, self.view.bounds.size.height, 0, 0);
    [self.view addSubview:_faceScrollView];
    tableView_.autoresizingMask = UIViewAutoresizingNone;
    giveCommentView_.autoresizingMask = UIViewAutoresizingNone;
}

//隐藏表情,是否隐藏工具栏
- (void)hideFaceView:(BOOL)hideToolBar
{
    if ([giveCommentTv_.text isEqualToString:@""]) {
        giveMyCommentBtn_.backgroundColor = PINGLUNHUI;
    }
    _faceScrollView.isShow = NO;
    
    if (!_isKeyboardShow)
    {
        CGRect frame = giveCommentView_.frame;
        frame.origin.y = CGRectGetHeight(self.view.bounds) - frame.size.height;
        
        CGRect scrollFrame = _faceScrollView.frame;
        scrollFrame.origin.y = CGRectGetHeight(self.view.bounds);
        
        CGRect tableFrame = tableView_.frame;
        tableFrame.size.height = self.view.frame.size.height - frame.size.height;
        
        [UIView animateWithDuration:0.26 animations:^{
            tableView_.frame = tableFrame;
            giveCommentView_.frame = frame;
            _faceScrollView.frame = scrollFrame;
        }];
    }
    [MyCommon removeTapGesture:tableView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    _faceBtn.selected = NO;
}

//自己视图的单击事件
-(void) viewSingleTap:(id)sender
{
    [giveCommentTv_ resignFirstResponder];
    if (_faceScrollView.isShow)
    {
        [self hideFaceView:YES];
    }
}

-(void) backBarBtnResponse:(id)sender
{
    [giveCommentTv_ resignFirstResponder];
    giveCommentTv_.text =@"";
    [self hideFaceView:YES];
    [super backBarBtnResponse:sender];
}

-(void) btnClick:(id)sender
{
    [super btnClick:sender];
}

-(void)btnResponse:(id)sender
{
    //评论
    if( sender == giveMyCommentBtn_ ){
        if (_faceScrollView.isShow) {
            [self hideFaceView:YES];
        }
        [giveCommentTv_ resignFirstResponder];
        [self addComment];
    }
    else if (sender == _faceBtn)
    {
        if (!_faceBtn.selected)
        {
            _isKeyboardShow = NO;
            _faceBtn.selected = YES;
            [self showFaceView];
            [giveCommentTv_ resignFirstResponder];
        }
        else
        {
            _faceBtn.selected = NO;
            _isKeyboardShow = YES;
            [giveCommentTv_ becomeFirstResponder];
        }
    }
}

@end

//
//  PublishArticle.m
//  jobClient
//
//  Created by YL1001 on 14/12/10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "PublishArticle.h"
#import "NSString+URLEncoding.h"
#import <objc/runtime.h>
#import "FaceScrollView.h"
#import "PhotoSelectCtl.h"
#import "PhotoBrowerCtl.h"
#import "AlbumListCtl.h"
#import "Article_DataModal.h"
#import "TZImagePickerController.h"

@interface PublishArticle ()<UIGestureRecognizerDelegate, UITextViewDelegate, PhotoSelectCtlDelegate,PhotoBrowerDelegate,TZImagePickerControllerDelegate>
{
    NSString * thumUrl_;
    NSMutableArray  *  imgUrlArr_;
    int currentOperateIndex_;
    int errorCount;//图片上传失败的数量
    
    FaceScrollView *_faceScrollView;//表情面板
    UITapGestureRecognizer *_singleTapRecognizer;
    BOOL isNiMing;
    UIButton *addImageBtn;
    UITextView *contentTV;
    CGFloat textViewHeight;
    BOOL _isKeyboardShow;
    CGFloat _keyboardHeight;
    
    UITextView *selectTV;
    UITextField *selectTF;
}

@end

@implementation PublishArticle
@synthesize type_,delegate_;
-(id)init
{
    self = [super init];
    rightNavBarStr_ = @"提交";
    _canImageCount = 9;
    return self;
}

-(void)saveDraftDataModal
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arrData = [userDefault objectForKey:@"publishArticle_draft"];
    if (!arrData)
    {
        arrData = [[NSMutableArray alloc] init];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"" forKey:@"article_title"];
    [dic setObject:@"" forKey:@"article_content"];
    [dic setObject:@"" forKey:@"article_date"];
    [dic setObject:@"" forKey:@"article_imageArr"];
}

- (void)viewDidLoad
{
    self.view.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight-64);
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight-64)];
    scrollView.bounces = NO;
    contentView_ = [[UIView alloc] initWithFrame:scrollView.bounds];
    [scrollView addSubview:contentView_];
    
    titleTf_ = [[UITextField alloc] initWithFrame:CGRectMake(8,0,ScreenWidth-16,40)];
    titleTf_.delegate = self;
    titleTf_.font = [UIFont systemFontOfSize:14];
    titleTf_.placeholder = @"|标题";
    [contentView_ addSubview:titleTf_];
    
    [contentView_ addSubview:[[ELLineView alloc] initWithFrame:CGRectMake(0,41,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)]];
    
    contentTV = [[UITextView alloc] initWithFrame:CGRectMake(8,56,ScreenWidth-16,180)];
    contentTV.delegate = self;
    contentTV.bounces = NO;
    contentTV.font = [UIFont systemFontOfSize:15];
    contentTV.textContainerInset = UIEdgeInsetsMake(0,0,0,0);
    [contentView_ addSubview:contentTV];
    
    tipsLb_ = [[UILabel alloc] initWithFrame:CGRectMake(8,60,ScreenWidth-16,40)];
    tipsLb_.text = @"关于职场的经验和感悟，想说便说（发布广告、中介、情色、政治等内容会被屏蔽噢）";
    tipsLb_.textColor = UIColorFromRGB(0xCACACA);
    tipsLb_.font = [UIFont systemFontOfSize:14];
    tipsLb_.numberOfLines = 0;
    [contentView_ addSubview:tipsLb_];
    
    tagView_ = [[UIView alloc] initWithFrame:CGRectMake(0,contentTV.bottom+10,ScreenWidth,40)];
    tagView_.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [contentView_ addSubview:tagView_];
    
    chooseImgBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseImgBtn_ setImage:[UIImage imageNamed:@"iocn_ios_tupian1"] forState:UIControlStateNormal];
    chooseImgBtn_.frame = CGRectMake(0,0,40,40);
    [chooseImgBtn_ addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [tagView_ addSubview:chooseImgBtn_];
    
    _faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_faceBtn setImage:[UIImage imageNamed:@"icon_face"] forState:UIControlStateNormal];
    _faceBtn.frame = CGRectMake(41,0,40,40);
    [_faceBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [tagView_ addSubview:_faceBtn];
    
    addTagBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [addTagBtn_ setImage:[UIImage imageNamed:@"iocn_ios_biaoqian1"] forState:UIControlStateNormal];
    addTagBtn_.frame = CGRectMake(82,0,40,40);
    [addTagBtn_ addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [tagView_ addSubview:addTagBtn_];
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(40,10,1,21)];
    lineImage.image = [UIImage imageNamed:@"iocn_dian"];
    [tagView_ addSubview:lineImage];
    
    lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(81,10,1,21)];
    lineImage.image = [UIImage imageNamed:@"iocn_dian"];
    [tagView_ addSubview:lineImage];
    
    tag1TF_ = [self getTagTextFieldWithFrame:CGRectMake(130,6,90,30)];
    [tagView_ addSubview:tag1TF_];
    
    tag2TF_ = [self getTagTextFieldWithFrame:CGRectMake(227,6,90,30)];
    [tagView_ addSubview:tag2TF_];
    tag3TF_ = [self getTagTextFieldWithFrame:CGRectMake(130,44,90,30)];
    [tagView_ addSubview:tag3TF_];
    tag4TF_ = [self getTagTextFieldWithFrame:CGRectMake(227,44,90,30)];
    [tagView_ addSubview:tag4TF_];
    tag5TF_ = [self getTagTextFieldWithFrame:CGRectMake(130,82,90,30)];
    [tagView_ addSubview:tag5TF_];
    tag6TF_ = [self getTagTextFieldWithFrame:CGRectMake(227,82,90,30)];
    [tagView_ addSubview:tag6TF_];
    
    _niMingImage = [[UIImageView alloc] initWithFrame:CGRectMake(10,45,15, 15)];
    _niMingImage.image = [UIImage imageNamed:@"nimingweixuanzhong"];
    [tagView_ addSubview:_niMingImage];
    
    _niMingLable = [[UILabel alloc] initWithFrame:CGRectMake(33,41,68,20)];
    _niMingLable.text = @"匿名发表";
    _niMingLable.textColor = UIColorFromRGB(0xaaaaaa);
    _niMingLable.font = [UIFont systemFontOfSize:14];
    [tagView_ addSubview:_niMingLable];
    
    _niMingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _niMingBtn.frame = CGRectMake(6,36,90,30);
    [_niMingBtn addTarget:self action:@selector(isNiMingChangeBtnRespone:) forControlEvents:UIControlEventTouchUpInside];
    [tagView_ addSubview:_niMingBtn];
    
    [self.view addSubview:scrollView];
    self.scrollView_ = scrollView;
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name: UITextViewTextDidChangeNotification object:nil];
    
    if (_fromTodayList) //微分享
    {
        self.title = @"";
        tipsLb_.text = @"这一刻的想法... ...(字数在5个字以上，优质的内容会得到更多赞哟)";
        CGRect frame = contentTV.frame;
        frame.origin.y = 0;
        contentTV.frame = frame;
        
        frame = tipsLb_.frame;
        frame.origin.y = 8;
        tipsLb_.frame = frame;
        
        frame = tagView_.frame;
        frame.origin.x = -42;
        frame.size.width += 42;
        tagView_.frame = frame;
    }
    [self sharePhotoview];
    [self setNavTitle:@"发表"];
    
    thumUrl_ = @"";
    imgUrlArr_ = [[NSMutableArray alloc] init];
    [self tagViewInit];
    
    NSString *strHtml = [CommonConfig getDBValueByKey:@"publish_article_content"];
    
    if (strHtml && ![strHtml isEqualToString:@""] && !_fromTodayList) {
        contentTV.text = strHtml;
        tipsLb_.hidden = YES;
    }else{
        contentTV.text = @"";
        tipsLb_.hidden = NO;
    }
    if ([CommonConfig getDBValueByKey:@"publish_article_title"]&&[[CommonConfig getDBValueByKey:@"publish_article_title"] length] > 0 && !_fromTodayList) {
        titleTf_.text = [CommonConfig getDBValueByKey:@"publish_article_title"];
    }
    
    if (_isCompanyGroup) {
        _niMingBtn.hidden = NO;
        _niMingImage.hidden = NO;
        _niMingLable.hidden = NO;
        CGRect frame = tagView_.frame;
        frame.size.height = 70;
        tagView_.frame = frame;
        _niMingImage.image = [UIImage imageNamed:@"nimingweixuanzhong"];
        isNiMing = NO;
        _niMingBtn.selected = NO;
    }else{
        _niMingBtn.hidden = YES;
        _niMingImage.hidden = YES;
        _niMingLable.hidden = YES;
    }
    
    //share进入
    if (_titleTxt) {
        titleTf_.text = _titleTxt;
    }
    if (_content) {
        tipsLb_.hidden = NO;
        contentTV.text = _content;
    }
    if (_imageArr) {
        [self didFinishSelectPhoto:_imageArr];
    }
    [contentView_ bringSubviewToFront:tipsLb_];
}

-(UITextField *)getTagTextFieldWithFrame:(CGRect)frame{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.delegate = self;
    textField.background = [UIImage imageNamed:@"btn_inputbox"];
    textField.placeholder = @"| 输入标签";
    textField.textAlignment = NSTextAlignmentCenter;
    textField.font = [UIFont systemFontOfSize:14];
    return textField;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.navigationItem.title = @"发表";
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillDisappear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)sharePhotoview
{
    if (!self.photoView)
    {
        self.photoView = [[MessagePhotoView alloc]initWithFrame:CGRectMake(0.0f,
                                                                           contentTV.frame.origin.y + contentTV.frame.size.height + 8,
                                                                           ScreenWidth, 60)];
        NSLog(@"%@",NSStringFromCGRect(contentTV.frame));
        [contentView_ addSubview:self.photoView];
        self.photoView.delegate = self;
        if (_fromTodayList) {
            self.photoView.alpha = 1.0;
        }
        else
        {
            self.photoView.alpha = 0.0;
        }
    }
}

//实现代理方法
-(void)addPicker:(ZYQAssetPickerController *)picker{
    
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

-(void)addUIImagePicker:(UIImagePickerController *)picker
{
    [self presentViewController:picker animated:YES completion:nil];
}


-(void)setViewAlpha:(BOOL)alpha
{
    if (alpha && self.photoView.alpha == 0.0) {
        self.photoView.alpha = 1.0;
        CGRect rect = tagView_.frame;
        rect.origin.y = self.photoView.frame.origin.y + self.photoView.frame.size.height;
        tagView_.frame = rect;
    }
    if (!alpha && self.photoView.alpha == 1.0 && !_fromTodayList) {
        self.photoView.alpha = 0.0;
        CGRect rect = tagView_.frame;
        rect.origin.y = self.photoView.frame.origin.y;
        tagView_.frame = rect;
    }
    [self.scrollView_ setContentSize:CGSizeMake(self.view.frame.size.width, contentView_.frame.origin.y + tagView_.frame.origin.y + tagView_.frame.size.height)];
}

-(void)deleteImage:(NSInteger)index
{
    
    @try {
        [self changeAddImageBtn];
        if (imgUrlArr_.count >index)
        {
            [imgUrlArr_ removeObjectAtIndex:index];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}


-(void)updateCom:(RequestCon *)con
{
    CGRect rect = contentView_.frame;
    if (type_ == Article || type_ == Topic) {
        rect.origin.y = 8.0;
    }
    else if (type_ == AllTopic)
    {
        rect.origin.y = 56.0;
    }
    contentView_.frame = rect;
    [self.scrollView_ setContentSize:CGSizeMake(self.view.frame.size.width, contentView_.frame.origin.y + tagView_.frame.origin.y + tagView_.frame.size.height)];
    [self changeAddImageBtn];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    if ([dataModal isKindOfClass:[Groups_DataModal class]]) {
        Groups_DataModal *modal = dataModal;
        groupId = modal.id_;
    }else{
        groupId = dataModal;
    }
}
-(void)textChanged:(UITextView *)textView
{
    if (contentTV.isFirstResponder) {
        [self changeTextViewFrame];
    }
}

-(void)changeTextViewFrame{
    CGFloat heightOne = 0;
    if (_isKeyboardShow) {
        heightOne = _keyboardHeight;
    }
    else if (_faceScrollView.isShow)
    {
        heightOne = _faceScrollView.frame.size.height;
    }
    CGFloat maxHeight = ScreenHeight-64-contentTV.top-heightOne;
    if (maxHeight > 180) {
        maxHeight = 180;
    }
    CGRect frame = contentTV.frame;
    frame.size.height = maxHeight;
    contentTV.frame = frame;
    [contentTV scrollRangeToVisible:contentTV.selectedRange];
}

#pragma Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    if (contentTV.isFirstResponder) {
        tipsLb_.hidden = YES;
        NSDictionary *userInfo = [notification userInfo];
        NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        CGRect keyboardRect = [aValue CGRectValue];
        _keyboardHeight = keyboardRect.size.height;
        _isKeyboardShow = YES;
        [self.view bringSubviewToFront:self.toolbarHolder];
        CGRect frame = self.toolbarHolder.frame;
        frame.origin.y = self.view.frame.size.height - (keyboardRect.size.height + self.toolbarHolder.frame.size.height);
        self.toolbarHolder.frame = frame;
        [self changeTextViewFrame];
    }else{
        [super keyboardWillShow:notification];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{

}

- (void)keyboardWillHide:(NSNotification *)notification {
    [super keyboardWillHide:notification];
    [self.scrollView_ setContentSize:CGSizeZero];
    _isKeyboardShow = NO;
    NSString * myStr = [contentTV.text stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    myStr = [myStr stringByReplacingOccurrencesOfString:@"<div>" withString:@""];
    myStr = [myStr stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
    myStr = [myStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    myStr = [myStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if ([[myStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]  isEqualToString:@""] ) {
        tipsLb_.hidden = NO;
        contentTV.text = @"";
    }
    else{
        tipsLb_.hidden = YES;
    }
    if (contentTV.isFirstResponder){
        [self changeTextViewFrame];
    }
}


#pragma mark - UITextView Delegate

- (void)textViewDidChange:(UITextView *)textView{
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    selectTV = textView;
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    selectTF = textField;
}

- (void)dismissKeyboard {
    if (selectTV) {
        [selectTV resignFirstResponder];
    }
    if (selectTF) {
        [selectTF resignFirstResponder];
    }
}

-(void)shareArticle
{
    [BaseUIViewController showLoadView:YES content:@"正在发表" view:nil];
    NSString * myStr = [contentTV.text stringByReplacingOccurrencesOfString:@"<div>" withString:@""];
    myStr = [MyCommon MyfilterHTML:myStr];
    myStr = [myStr stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
    myStr = [myStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    myStr = [myStr stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    myStr = [myStr stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    myStr = [myStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!addCon_) {
        addCon_ = [self getNewRequestCon:NO];
    }
    NSMutableString * title = [[NSMutableString alloc] initWithString:titleTf_.text];
    if ([[title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0)
    {
        @try {
            title = [[NSMutableString alloc] initWithString:[myStr substringToIndex:30]];
        }
        @catch (NSException *exception) {
            title = [[NSMutableString alloc] initWithString:myStr];
        }
        @finally {
            
        }
    }
    
    if ([[myStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0)
    {
        @try {
            myStr = [[NSMutableString alloc] initWithString:[title substringToIndex:30]];
        }
        @catch (NSException *exception) {
            myStr = [[NSMutableString alloc] initWithString:title];
        }
        @finally {
            
        }
    }

    NSRange rang1;
    rang1.location = 0;
    rang1.length = [title length];
    [title replaceOccurrencesOfString:@"'" withString:@"\\'" options:NSCaseInsensitiveSearch range:rang1];
    rang1.length = [title length];
    [title replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:rang1];
    rang1.length = [title length];
    [title replaceOccurrencesOfString:@"•" withString:@"·" options:NSCaseInsensitiveSearch range:rang1];
    rang1.length = [title length];
    [title replaceOccurrencesOfString:@"¥" withString:@"￥" options:NSCaseInsensitiveSearch range:rang1];
    rang1.length = [title length];
    [title replaceOccurrencesOfString:@"、 " withString:@"、" options:NSCaseInsensitiveSearch range:rang1];
    //添加图片在文章内容
    NSMutableString * thumStr = [NSMutableString stringWithFormat:@""];
    for (NSString * thum in imgUrlArr_) {
        [thumStr appendString:[NSString stringWithFormat:@"<img src='%@'><br>",thum]];
    }
    
    NSMutableString *webStr = [[NSMutableString alloc] initWithString:myStr];
    [webStr appendString:thumStr];
    NSRange rang;
    rang.location = 0;
    rang.length = [webStr length];
    [webStr replaceOccurrencesOfString:@"'" withString:@"\\'" options:NSCaseInsensitiveSearch range:rang];
    rang.length = [webStr length];
    [webStr replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:rang];
    rang.length = [webStr length];
    [webStr replaceOccurrencesOfString:@"•" withString:@"·" options:NSCaseInsensitiveSearch range:rang];
    rang.length = [webStr length];
    [webStr replaceOccurrencesOfString:@"¥" withString:@"￥" options:NSCaseInsensitiveSearch range:rang];
    rang.length = [webStr length];
    [webStr replaceOccurrencesOfString:@"、 " withString:@"、" options:NSCaseInsensitiveSearch range:rang];
    NSString * newstr = webStr;
    
    NSString *keyWord = [[NSString alloc]init];
    for (int i=0; i<tagCount_; i++) {
        switch (i) {
            case 0:
            {
                NSString *temp = [[NSString alloc]init];
                if (![[MyCommon removeAllSpace:tag1TF_.text] isEqualToString:@""]) {
                    temp = [[MyCommon removeAllSpace:tag1TF_.text] stringByAppendingString:@","];
                }else{
                    temp = @"";
                }
                keyWord = [keyWord stringByAppendingString:temp];
            }
                break;
            case 1:
            {
                NSString *temp = [[NSString alloc]init];
                if (![[MyCommon removeAllSpace:tag2TF_.text] isEqualToString:@""]) {
                    temp = [[MyCommon removeAllSpace:tag2TF_.text] stringByAppendingString:@","];
                }else{
                    temp = @"";
                }
                keyWord = [keyWord stringByAppendingString:temp];
            }
                break;
            case 2:
            {
                NSString *temp = [[NSString alloc]init];
                if (![[MyCommon removeAllSpace:tag3TF_.text] isEqualToString:@""]) {
                    temp = [[MyCommon removeAllSpace:tag3TF_.text] stringByAppendingString:@","];
                }else{
                    temp = @"";
                }
                keyWord = [keyWord stringByAppendingString:temp];
            }
                break;
            case 3:
            {
                NSString *temp = [[NSString alloc]init];
                if (![[MyCommon removeAllSpace:tag4TF_.text] isEqualToString:@""]) {
                    temp = [[MyCommon removeAllSpace:tag4TF_.text] stringByAppendingString:@","];
                }else{
                    temp = @"";
                }
                keyWord = [keyWord stringByAppendingString:temp];
            }
                break;
            case 4:
            {
                NSString *temp = [[NSString alloc]init];
                if (![[MyCommon removeAllSpace:tag5TF_.text] isEqualToString:@""]) {
                    temp = [[MyCommon removeAllSpace:tag5TF_.text] stringByAppendingString:@","];
                }else{
                    temp = @"";
                }
                keyWord = [keyWord stringByAppendingString:temp];
            }
                break;
            case 5:
            {
                NSString *temp = [[NSString alloc]init];
                if (![[MyCommon removeAllSpace:tag6TF_.text] isEqualToString:@""]) {
                    temp = [[MyCommon removeAllSpace:tag6TF_.text] stringByAppendingString:@","];
                }else{
                    temp = @"";
                }
                keyWord = [keyWord stringByAppendingString:temp];
            }
                break;
            default:
                break;
        }
    }
    
    //获取封面链接
    @try {
        thumUrl_ = [imgUrlArr_ objectAtIndex:0];
    }
    @catch (NSException *exception) {
        thumUrl_ = @"";
    }
    @finally {
        
    }
    NSString *str;
    if (isNiMing) {
        str = @"1";
    }
    else
    {
        str = @"0";
    }
    
    keyWord = [MyCommon utf8ToUnicode:keyWord];
    NSString *unicodeStr = [MyCommon utf8ToUnicode:newstr];
    NSString *unicodeTitleStr = [MyCommon utf8ToUnicode:title];
    
    NSString *cateName = @"";
    if (_fromTodayList) {
        cateName = @"微分享";
    }
    
    if (type_ == Article) {
        [addCon_ shareArticle:[Manager getUserInfo].userId_ userName:[Manager getUserInfo].name_ type:3 title:unicodeTitleStr showContent:1 addComment:1 showComment:1 content:unicodeStr thumb:thumUrl_ kw:keyWord cateName:cateName];
    }
    else if (type_ == Topic || type_ == AllTopic){
        [addCon_ publishTopic:[Manager getUserInfo].userId_ groupId:groupId ownId:[Manager getUserInfo].userId_ title:unicodeTitleStr content:unicodeStr thumb:thumUrl_ kw:keyWord isCompany:_isCompanyGroup Type:str];
    }
    
}

-(void)uploadPhoto
{
    @try {
//        if (currentOperateIndex_ == 0) {
//              [BaseUIViewController showLoadView:YES content:@"正在上传图片" view:nil];
//        }
        id image = [self.photoView.photoMenuItems objectAtIndex:currentOperateIndex_];
        UIImage * photo;
        if ([image isMemberOfClass:[ALAsset class]]) {
            ALAsset * alasset = image;
            photo = [UIImage imageWithCGImage:alasset.defaultRepresentation.fullScreenImage];
        }
        else{
            photo = image;
        }
        NSData *imgData = UIImageJPEGRepresentation(photo, 0.1);
        NSString* base64Str_ = [[imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] URLEncodedForString];
        RequestCon * con  = [self getNewRequestCon:NO];
        [con uploadImgData:base64Str_];
        ++currentOperateIndex_;
    }
    @catch (NSException *exception) {
//        [self shareArticle];
    }
    @finally {
        
    }
    
}

-(void)errorGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type
{
    [super errorGetData:requestCon code:code type:type];
    [BaseUIViewController showLoadView:NO content:nil view:nil];
    switch (type) {
        case Request_UploadImgData:
        {
//            [self uploadPhoto];
            [BaseUIViewController showAutoDismissFailView:@"发表失败" msg:@"请稍后再试"];
            currentOperateIndex_ = 0;

        }
            break;
        case Request_ShareArticle:
        {
            [BaseUIViewController showAutoDismissFailView:@"发表失败" msg:@"请稍后再试"];
            currentOperateIndex_ = 0;
            [imgUrlArr_ removeAllObjects];
        }
            break;
        case Request_PublishTopic:
        {
            [BaseUIViewController showAutoDismissFailView:@"发表失败" msg:@"请稍后再试"];
            currentOperateIndex_ = 0;
            [imgUrlArr_ removeAllObjects];
        }
            break;
        default:
            break;
    }
}


-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
//    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
//    [BaseUIViewController showLoadView:NO content:nil view:nil];
    switch (type) {
        case Request_ShareArticle:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                titleTf_.text = @"";
                [BaseUIViewController showLoadView:NO content:nil view:nil];
                [titleTf_ resignFirstResponder];
                
                [BaseUIViewController showAutoDismissSucessView:@"发表成功" msg:nil];
                
                [self.navigationController popViewControllerAnimated:NO];
                
                if (!_fromTodayList) {
                    if (!_isFromPublishList)
                    {
                        ExpertPublishCtl *ctl = [[ExpertPublishCtl alloc]init];
                        Expert_DataModal *modal = [[Expert_DataModal alloc] init];
                        modal.id_ = [Manager getUserInfo].userId_;
                        [ctl setIsMyCenter:YES];
                        [self.navigationController pushViewController:ctl animated:YES];
                        [ctl beginLoad:modal exParam:nil];
                    }
                }
                [delegate_ publishSuccess];
                [CommonConfig setDBValueByKey:@"publish_article_content" value:@""];
                [CommonConfig setDBValueByKey:@"publish_article_title" value:@""];
            }
            else
            {
                [BaseUIViewController showLoadView:NO content:nil view:nil];
                [BaseUIViewController showAutoDismissFailView:@"" msg:dataModal.des_];
                currentOperateIndex_ = 0;
                [imgUrlArr_ removeAllObjects];
            }
        }
            break;
        case Request_PublishTopic:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                titleTf_.text = @"";
                [BaseUIViewController showLoadView:NO content:nil view:nil];
                [titleTf_ resignFirstResponder];
                
                [BaseUIViewController showAutoDismissSucessView:@"发表成功" msg:nil];
                [self.navigationController popViewControllerAnimated:YES];
                [delegate_ publishSuccess];
                [CommonConfig setDBValueByKey:@"publish_article_content" value:@""];
                [CommonConfig setDBValueByKey:@"publish_article_title" value:@""];
            }
            else
            {
                [BaseUIViewController showLoadView:NO content:nil view:nil];
                [BaseUIViewController showAutoDismissFailView:@"" msg:dataModal.des_];
                currentOperateIndex_ = 0;
                [imgUrlArr_ removeAllObjects];
            }
            
        }
            break;
        case Request_UploadImgData:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {//所有图片上传成功后才上传文字，否则不上传
                [imgUrlArr_ addObject:dataModal.exObj_];
                
                if ((currentOperateIndex_ == self.photoView.photoMenuItems.count)&& (errorCount == 0)) {
                    [self shareArticle];
                }else if (currentOperateIndex_ < self.photoView.photoMenuItems.count){
                    [self uploadPhoto];
                }
            }else{
                errorCount = 1;
                [BaseUIViewController showAutoDismissFailView:@"发表失败" msg:@"请稍后再试"];
            }

        }
            break;
            
            
        default:
            break;
    }
}

- (void)tagViewInit
{
    [tag1TF_ setHidden:YES];
    [tag2TF_ setHidden:YES];
    [tag3TF_ setHidden:YES];
    [tag4TF_ setHidden:YES];
    [tag5TF_ setHidden:YES];
    [tag6TF_ setHidden:YES];
    
}

- (void)changeFirstResponder
{
    if ([tag1TF_ isFirstResponder]) {
        [tag1TF_ resignFirstResponder];
    }
    if ([tag2TF_ isFirstResponder]) {
        [tag2TF_ resignFirstResponder];
    }
    if ([tag3TF_ isFirstResponder]) {
        [tag3TF_ resignFirstResponder];
    }
    if ([tag4TF_ isFirstResponder]) {
        [tag4TF_ resignFirstResponder];
    }
    if ([tag5TF_ isFirstResponder]) {
        [tag5TF_ resignFirstResponder];
    }
    
    if ([tag6TF_ isFirstResponder]) {
        [tag6TF_ resignFirstResponder];
    }
    
    if ([titleTf_ isFirstResponder]) {
        [titleTf_ resignFirstResponder];
    }
}

-(void)btnResponse:(id)sender
{
    [self changeFirstResponder];
    [self dismissKeyboard];
    if (sender == chooseImgBtn_ || sender == addImageBtn)
    {
            if (self.photoView.photoMenuItems.count < _canImageCount) {
                //在这里呼出下方菜单按钮项
                UIActionSheet* myActionSheet = [[UIActionSheet alloc]
                                 initWithTitle:nil
                                 delegate:self
                                 cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
                [myActionSheet showInView:self.view];
            }
            else
            {
                 [BaseUIViewController showAutoDismissAlertView:@"" msg:[NSString stringWithFormat:@"最多只能选择%ld张图片", (long)_canImageCount] seconds:1.0f];
            }
    }else if (sender == addTagBtn_){
        if (tagCount_ < 5) {
            [self changTagView];
        }
        
    }else if (sender == _faceBtn){
        [self showFaceView];
    }
}



//下拉菜单的点击响应事件
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
//            [self addImage];
        {
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
            
            // 你可以通过block或者代理，来得到用户选择的照片.
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        BOOL accessStatus = [[Manager shareMgr] getTheCameraAccessWithCancel:^{}];
        if (!accessStatus) {
            return;
        }        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

/*
 调用系统相册的方法
 */
-(void)addImage{

    PhotoSelectCtl *photoSelectCtl = [[PhotoSelectCtl alloc]init];
    NSInteger selectedCnt = self.photoView.photoMenuItems.count;
    photoSelectCtl.maxCount = _canImageCount-selectedCnt;
    photoSelectCtl.delegate = self;
    [self.navigationController pushViewController:photoSelectCtl animated:YES];
    [photoSelectCtl beginLoad:nil exParam:nil];
//      AlbumListCtl *albumListCtl = [[AlbumListCtl alloc]init];
//      NSInteger selectedCnt = self.photoView.photoMenuItems.count;
//      albumListCtl.maxCount = _canImageCount-selectedCnt;
//      albumListCtl.delegate = self;
//      [self.navigationController pushViewController:albumListCtl animated:YES];
//      [albumListCtl beginLoad:nil exParam:nil];
}

-(void)didSelectePhotoMenuItem:(MessagePhotoMenuItem *)shareMenuItem atIndex:(NSInteger)index
{
    PhotoBrowerCtl *browerCtl = [[PhotoBrowerCtl alloc]init];
    browerCtl.fromPublishArticle = YES;
    browerCtl.browerDelegate = self;
    browerCtl.selectIndex = index;
    browerCtl.selectedAssets = [NSMutableArray arrayWithArray:self.photoView.photoMenuItems];
    [self.navigationController pushViewController:browerCtl animated:YES];
}

-(void)finishWithImageArr:(NSArray *)arr
{
    [self.photoView.photoMenuItems removeAllObjects];
    [self.photoView.itemArray removeAllObjects];
    [self.photoView assetPickerController:nil didFinishPickingAssets:arr];
    [self changeAddImageBtn];
}

#pragma mark 相册图片选择delegate
- (void)didFinishSelectPhoto:(NSArray *)imageArr
{
//    for (UIImage *image in imageArr) {
//        [self.photoView reloadDataWithImage:image];
//    }
    [self.photoView assetPickerController:nil didFinishPickingAssets:imageArr];
    [self changeAddImageBtn];
}

-(void)fromTodayListRefreshWithType:(NSInteger)type imageArr:(NSArray *)arr
{
    switch (type) {
        case 1:
        {
             [self.photoView reloadDataWithImage:arr[0]];
        }
            break;
        case 2:
        {
            [self.photoView assetPickerController:nil didFinishPickingAssets:arr];
        }
            break;
        default:
            break;
    }
    [self changeAddImageBtn];
}

-(void)changeAddImageBtn
{
    if (!_fromTodayList) {
        return;
    }
    if(!addImageBtn){
        addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addImageBtn setImage:[UIImage imageNamed:@"weifenxiangbtnadd"] forState:UIControlStateNormal];
        [addImageBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.photoView.photoMenuItems.count < _canImageCount)
    {
        if (self.photoView.photoMenuItems.count == 0)
        {
             addImageBtn.frame = CGRectMake(5,8,44,44);
        }
        else
        {
            addImageBtn.frame = CGRectMake(self.photoView.photoScrollView.contentSize.width-5,8,44,44);
        }
        CGSize size = self.photoView.photoScrollView.contentSize;
        size.width += 44;
        self.photoView.photoScrollView.contentSize = size;
        [self.photoView.photoScrollView addSubview:addImageBtn];
    }
    else
    {
        [addImageBtn removeFromSuperview];
    }
}

//选择某张照片之后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    //[self.delegate dismissPickerController:picker];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //如果是 来自照相机的image，那么先保存
        UIImage* original_image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImageWriteToSavedPhotosAlbum(original_image, self,
                                       nil,
                                       nil);
    }
    
    //当选择的类型是图片
    if([type isEqualToString:@"public.image"]){
        //先把图片转成NSData
        UIImage *uploadImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        uploadImage = [uploadImage fixOrientation];
//        NSData *imgData = UIImageJPEGRepresentation(uploadImage, 0.3);
//        UIImage *image = [UIImage imageWithData:imgData];
        [self.photoView reloadDataWithImage:uploadImage];
        [self changeAddImageBtn];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    //[self.delegate dismissPickerController:picker];
}

- (void)changTagView
{
    float height = tagView_.frame.size.height;
   
    switch (tagCount_) {
        case 0:
        {
            [tag1TF_ setHidden:NO];
        }
            break;
        case 1:
            [tag2TF_ setHidden:NO];
            break;
        case 2:
            [tag3TF_ setHidden:NO];
            height = 80;
            break;
        case 3:
            [tag4TF_ setHidden:NO];
            
            break;
        case 4:
            [tag5TF_ setHidden:NO];
            height = 120;
            break;
//        case 5:
//            [tag6TF_ setHidden:NO];
//            
//            break;
        default:
            break;
    }
     tagCount_ ++ ;
    
    CGRect tagViewRect = tagView_.frame;
    tagViewRect.size.height = height;
    [tagView_ setFrame:tagViewRect];
    
    if (tagView_.frame.origin.y + tagView_.frame.size.height > contentView_.frame.size.height) {
        CGRect contentView = contentView_.frame;
        contentView.size.height = tagView_.frame.origin.y + tagView_.frame.size.height + 10;
        contentView_.frame = contentView;
    }
    
    [self.scrollView_ setContentSize:CGSizeMake(ScreenWidth, tagView_.frame.size.height+ tagView_.frame.origin.y + contentView_.frame.origin.y +1)];
}


-(void)backBarBtnResponse:(id)sender
{
    NSString *content = contentTV.text;
    NSString *title = titleTf_.text;
    if (!content) {
        content = @"";
    }
    if (!title) {
        title = @"";
    }
    [CommonConfig setDBValueByKey:@"publish_article_content" value:content];
    [CommonConfig setDBValueByKey:@"publish_article_title" value:title]; 
    [super backBarBtnResponse:sender];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)rightBarBtnResponse:(id)sender
{
    
    if (![MyCommon IsEnable3G]&&![MyCommon IsEnableWIFI]) {
        [BaseUIViewController showAutoDismissFailView:@"无网络连接" msg:nil seconds:1.5];
        return;
    }
    
    if (!groupId && type_ != Article) {
        [BaseUIViewController showAlertView:@"请选择社群" msg:nil btnTitle:@"确定"];
        return;
    }
    
    if (titleTf_.text.length > 30) {
        [BaseUIViewController showAlertView:@"标题文章过长" msg:nil btnTitle:@"确定"];
        return;
    }
    
    NSString * myStr = [contentTV.text stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    myStr = [myStr stringByReplacingOccurrencesOfString:@"<div>" withString:@""];
    myStr = [myStr stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
    myStr = [myStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    myStr = [myStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    myStr = [myStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *titleStr = [titleTf_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (titleStr.length > 0 && myStr.length == 0) {
        myStr = titleStr;
    }
    
    if (titleTf_.text.length == 0 && myStr.length > 0) {
        titleTf_.text = ((myStr.length > 30)?[myStr substringWithRange:NSMakeRange(0, 30)]:myStr);
    }
    
    if ([myStr length] <= 0){
        [BaseUIViewController showAlertView:@"内容不能为空" msg:nil btnTitle:@"确定"];
        return;
    }
    
    if([MyCommon isContactEmojiString:myStr])
    {
        [BaseUIViewController showAutoDisappearAlertView:@"" msg:@"发表失败！请检查文章是否包含特殊字符" seconds:1.0];
        return;
    } 

    if(_fromTodayList)
    {
        if([myStr length] < 5)
        {
            [BaseUIViewController showAlertView:@"请输入不少于5个字的内容" msg:nil btnTitle:@"确定"];
            return;  
        }
        if ([self.photoView.photoMenuItems count] == 0)
        {
            [BaseUIViewController showAlertView:@"请添加至少一张图片" msg:nil btnTitle:@"确定"];
            return;
        }
    }
    
    [self hideFaceView];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if ([self.photoView.photoMenuItems count] > 0) {
        
        [self uploadPhoto];
        [BaseUIViewController showModalLoadingView:YES title:@"正在上传" status:nil];

    }
    else
    {
        [self shareArticle];
    }
}

#pragma mark 显示表情
- (void)showFaceView {
    //添加点击事件
    if( !_singleTapRecognizer )
        _singleTapRecognizer = [MyCommon addTapGesture:self.view target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    _singleTapRecognizer.delegate = self;
    if (_faceScrollView == nil) {
        [self initFaceView];
    }
    _faceScrollView.isShow = YES;
    CGFloat faceBoardH = CGRectGetHeight(_faceScrollView.frame) ;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGFloat y = CGRectGetHeight(self.view.bounds) - faceBoardH;
        CGRect frame = _faceScrollView.frame;
        frame.origin.y = y;
        _faceScrollView.frame = frame;
    } completion:^(BOOL finished) {
    }];
    [self changeTextViewFrame];
}

- (void)viewSingleTap:(UITapGestureRecognizer *)sender
{
    [self hideFaceView];
}

#pragma mark 初始化标签面板
- (void)initFaceView
{
    if (_faceScrollView == nil) {
        __weak PublishArticle *this = self;
        _faceScrollView = [[FaceScrollView alloc] initWithBlock:^(NSString *faceName) {
            [this setShowFaceText:faceName];
        }];
        _faceScrollView->faceView.backgroundColor = [UIColor colorWithRed:240.f/255 green:240.f/255 blue:240.f/255 alpha:1.0];
        _faceScrollView.backgroundColor =  [UIColor colorWithRed:240.f/255 green:240.f/255 blue:240.f/255 alpha:1.0];
        _faceScrollView.frame = CGRectMake(0, self.view.bounds.size.height, 0, 0);
        [self.view addSubview:_faceScrollView];
    }
}

-(void)setShowFaceText:(NSString *)faceName
{
    if ([faceName isEqualToString:@"delete"]) {//删除功能
        NSString *text = contentTV.text;
        if (!text || [text isEqualToString:@""]) {
            return ;
        }
        NSString *result = [MyCommon substringExceptLastEmoji:text];
        if (![text isEqualToString:result]) {
            contentTV.text = result;
        }else{
            [text substringToIndex:text.length-1];
        }
        [self changeTextViewFrame];
        return;
    }
    NSString *text = contentTV.text;
    if (!text) {
        text = @"";
    }
    tipsLb_.hidden = YES;
    contentTV.text = [text stringByAppendingFormat:@"%@",faceName];
    [self changeTextViewFrame];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *content = textView.text;
    if(range.length == 1 && [text isEqualToString:@""]) {
        NSString *result = [MyCommon substringExceptLastEmoji:content];
        if (![content isEqualToString:result]) {
            textView.text = result;
            return NO;
        }
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = textField.text;
    if(range.length == 1 && [string isEqualToString:@""]) {
        NSString *result = [MyCommon substringExceptLastEmoji:text];
        if (![text isEqualToString:result]) {
            textField.text = result;
            return NO;
        }
    }
    return YES;
}

#pragma mark 隐藏表情
- (void)hideFaceView
{
    if (!_faceScrollView.isShow) {
        return;
    }
    [MyCommon removeTapGesture:self.view ges:_singleTapRecognizer];
    _singleTapRecognizer = nil;
    _faceScrollView.isShow = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat y = CGRectGetHeight(self.view.bounds);
        CGRect frame = _faceScrollView.frame;
        frame.origin.y = y;
        _faceScrollView.frame = frame;
        
    }];
    _faceBtn.selected = NO;
    
    NSString * myStr = [contentTV.text stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    myStr = [myStr stringByReplacingOccurrencesOfString:@"<div>" withString:@""];
    myStr = [myStr stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
    myStr = [myStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    myStr = [myStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if ([[myStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]  isEqualToString:@""] ) {
        tipsLb_.hidden = NO;
        contentTV.text = @"";
    }
    else{
        tipsLb_.hidden = YES;
    }
    [self changeTextViewFrame];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point =  [gestureRecognizer locationInView:self.view];
    if (_faceScrollView) {
        CGFloat height = CGRectGetHeight(_faceScrollView.frame);
        if (point.y > CGRectGetHeight(self.view.bounds) - height) {
            return NO;
        }
    }
    return YES;
}

- (void)isNiMingChangeBtnRespone:(UIButton *)sender
{
    if (!sender.selected) {
        _niMingImage.image = [UIImage imageNamed:@"nimingxuanzhong"];
        isNiMing = YES;
    }
    else
    {
        _niMingImage.image = [UIImage imageNamed:@"nimingweixuanzhong"];
        isNiMing = NO;
    }
    sender.selected = !sender.selected;
}


@end

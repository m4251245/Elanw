//
//  EditorTagCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-11-1.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//行业或职业选择

#import "RegInfoThreeCtl.h"
#import "personTagModel.h"
#import "CustomTagButton.h"
#import "CustomTradeTextField.h"
#import "User_DataModal.h"

#define BUTTON_OFFSET_Y 80
#define BUTTON_TAG_OFFSET 100


@interface RegInfoThreeCtl ()
{
    RequestCon *_getTradeTagCon;
    RequestCon *_saveUserCon;
    CustomTagButton *_selectedTagBtn;
    NSArray *_tagArray;
}
@end

@implementation RegInfoThreeCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        rightNavBarStr_ = @"完成";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"选择行业";
    [self setNavTitle:@"选择行业"];
    if (!_type) {
        rightBarBtn_.hidden = YES;
    }
}



- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    _inDataModal = dataModal;
    if (_getTradeTagCon == nil) {
        _getTradeTagCon = [self getNewRequestCon:NO];
    }
    if ([_type isEqualToString:@"1"]) {//职业
        [_getTradeTagCon getJobTagsListWithTradeId:_inDataModal.tradeId];
    }else{
        if([_type isEqualToString:@"2"]){
            rightNavBarStr_ = @"下一步";
        }
        [_getTradeTagCon getTradeTagsList];//行业
    }
    
}

- (void)getDataFunction:(RequestCon *)con
{
    
} 


- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    if (requestCon == _getTradeTagCon) {
        _tagArray = [NSArray arrayWithArray:dataArr];
    }else if (requestCon == _saveUserCon){
        Status_DataModal * dataModal = [dataArr objectAtIndex:0];
        if([dataModal.status_ isEqualToString:Success_Status]){
            //完善用户信息后 直接登录
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showTip"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            if ([Manager shareMgr].haveLogin && [Manager shareMgr].isPublishReginfoCtl) {//登录时完善信息
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{//注册时
                [Manager shareMgr].isPublishReginfoCtl = NO;
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RegistSuccess" object:nil userInfo:@{@"key":_inDataModal}];
                if (![Manager shareMgr].haveLogin) {
                    [[Manager shareMgr].loginCtl_ login:0];
                }
            }
//            [BaseUIViewController showModalLoadingView:NO title:nil status:nil];
//            [self showChooseAlertView:11 title:@"注册完成" msg:@"是否马上登录" okBtnTitle:@"马上登录" cancelBtnTitle:@"稍后登录"];
        }
        else
        {
            [BaseUIViewController showAutoDismissFailView:@"注册失败"  msg:dataModal.des_];
        }
    }
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    if (con && con == _getTradeTagCon) {
        [self initTradeView];
    }
    
}

#pragma mark 初始化行业的view
- (void)initTradeView
{
    NSInteger tagCount = [_tagArray count];
    if (tagCount == 0) {
        return;
    }
    NSInteger column = 2;
    NSInteger remainder = tagCount%column;
    NSInteger line = 0;
    if (remainder ==0) {
        line = tagCount/column;
    }else{
        line = tagCount/column +1;
    }
    
    CGFloat btnWidth = (ScreenWidth-44)/2.0;
    for (int i=0; i<line; i++) {
        for (int k=0;k<column;k++) {
            if (i == line-1 && remainder==1 && k==1) {
                break;
            }
            personTagModel *model = [_tagArray objectAtIndex:i*column+k];
            CustomTagButton *button = [[CustomTagButton alloc]init];
            [button setFrame:CGRectMake(18+k*(btnWidth+10), BUTTON_OFFSET_Y+i*48, btnWidth, 38)];
            [button setTitle:model.tagName_ forState:UIControlStateNormal];
            
            [button setTag:(BUTTON_TAG_OFFSET + i*column + k) ];
            [button addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
            [button setTitleColor:WhiteColor forState:UIControlStateSelected];
            button.isSeleted_ = NO;
            [self.scrollView_ setContentSize:CGSizeMake(ScreenWidth, button.frame.origin.y+button.frame.size.height+10)];
            [self.scrollView_ addSubview:button];
        }
    }
    
    if (line != 0) {
        tagsTextField_ = [[CustomTradeTextField alloc]init];
        tagsTextField_.hidden = YES;
        tagsTextField_.placeholder = @"请输入行业名称";
        tagsTextField_.delegate =  self;
        CGSize size = self.scrollView_.contentSize;
        tagsTextField_.backgroundColor = [UIColor whiteColor];
        tagsTextField_.frame = CGRectMake(18, size.height-38-10,ScreenWidth-113, 38);
        tagsTextField_.clearButtonMode = UITextFieldViewModeWhileEditing;
        tagsTextField_.text = @"";
        [self.scrollView_ addSubview:tagsTextField_];
        //添加确定按钮
        submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        submitBtn.titleLabel.font = FOURTEENFONT_CONTENT;
        submitBtn.frame = CGRectMake(ScreenWidth-85, size.height -38-10, 69, 38);
        submitBtn.hidden = YES;
        submitBtn.layer.cornerRadius = 19;
        submitBtn.layer.masksToBounds = YES;
        submitBtn.layer.borderWidth = 0.5;
        submitBtn.backgroundColor = [UIColor colorWithRed:215.0/255 green:50.0/255 blue:50.0/255 alpha:1.0];
        submitBtn.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
        [self.scrollView_ addSubview:submitBtn];
        [submitBtn addTarget:self action:@selector(submitCustomerTag) forControlEvents:UIControlEventTouchUpInside];
        size.height += 30;
        self.scrollView_.contentSize = size;
    }


}

#pragma mark 提交自定义的行业
- (void)submitCustomerTag
{
    if ([[tagsTextField_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ] isEqualToString:@""]) {
        [BaseUIViewController showAlertView:nil msg:@"请输入其他行业的名称" btnTitle:@"确定"];
        return;
    }
    
    NSString *regex = @"^[\u4e00-\u9fa5_a-zA-Z0-9 ]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject: tagsTextField_.text]){
        NSString *errMsg;
        errMsg = @"行业只能由中文,字母或者数字组成";
        [BaseUIViewController showAlertView:errMsg msg:nil btnTitle:@"确定"];
        [tagsTextField_ becomeFirstResponder];
        return;
    }
    if(!_type){
        _inDataModal.tradeName = tagsTextField_.text;
        _inDataModal.tradeId = @"001";
        [tagsTextField_ resignFirstResponder];
        [self saveUserInfo:_inDataModal.userId_];
    }else if ([_type isEqualToString:@"0"]){//行业修改
        //直接返回
        if([_delegate respondsToSelector:@selector(updateTrade:)]){
            personTagModel *customTagModel = [[personTagModel alloc]init];
            customTagModel.tagName_ = tagsTextField_.text;
            customTagModel.tagId_ = @"001";
            [_delegate updateTrade:customTagModel];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark 选择项
-(void)tagButtonClick:(CustomTagButton *)button
{

    if (button.selected) {
        button.selected = NO;
        [button setBackgroundColor:[UIColor clearColor]];
    }else{
        button.selected = YES;
        [button setBackgroundColor:[UIColor colorWithRed:215.0/255 green:50.0/255 blue:50.0/255 alpha:1.0]];
    }
    if (_selectedTagBtn && _selectedTagBtn !=button) {
        _selectedTagBtn.selected = NO;
        if (!_type) {
            [_selectedTagBtn setBackgroundColor:[UIColor whiteColor]];
        }else{
             [_selectedTagBtn setBackgroundColor:[UIColor clearColor]];
        }
    }
    _selectedTagBtn = button;
    NSInteger tag = button.tag;
    NSInteger index = tag - BUTTON_TAG_OFFSET;
    personTagModel *selectTagModel = _tagArray[index];
    NSString *tagId = selectTagModel.tagId_;
    
    if ([tagId isEqualToString:@"001"]) {//001表示其他行业
        button.hidden = YES;
        tagsTextField_.hidden = NO;
        submitBtn.hidden = NO;
        return;
    }
    
    if (!_type) {//默认注册
        //立即注册
        _inDataModal.tradeId = tagId;
        _inDataModal.tradeName = @"";
//        [self saveUserInfo:_inDataModal.userId_];
        [self saveUserInfo:inModal_.userId_];
        return;
    }else if ([_type isEqualToString:@"0"]){//修改行业
       //直接返回
        if([_delegate respondsToSelector:@selector(updateTrade:)]){
            [_delegate updateTrade:selectTagModel];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark 完善注册信息
-(void)saveUserInfo:(NSString*)userId
{

    if (!_saveUserCon) {
        _saveUserCon = [self getNewRequestCon:NO];
    }
    //    // person_id 人才ID
    //    // person_pic_personality 图片
    //    // person_iname 姓名
    //    // person_nickname 呢称
    //    // person_sex 性别
    //    // person_hka 籍贯
    //    // person_zw 职称/职位
    //    // person_job_now 行业/职业
    //    // person_signature 个性签名
    //    // person_company 公司/单位
    //tradeID：行业代码  trade->person_job_now职业名称 job ->person_zw头衔  pic->person_pic_personality头像    zym－>专业 rctypeId－>分类 企业达人／应届生
    
    [_saveUserCon saveUserInfo:userId job:inModal_.job_ sex:inModal_.sex_ pic:inModal_.img_ name:inModal_.name_ trade:inModal_.trade_ company:@"" nickname:@"" signature:@"" hkaId:@"" school:inModal_.school_ zym:inModal_.major_ rctypeId:inModal_.identity_ regionStr:nil workAge:nil brithday:nil tradeId: inModal_.tradeId tradeName:inModal_.tradeName];
}

-(void)alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    [super alertViewChoosed:alertView index:index type:type];
    switch (type) {
        case 1://返回登录页面
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 11://自动登录
        {
            [[Manager shareMgr].loginCtl_ login:0];
        }
            break;
        default:
            break;
    }
}

-(void)alertViewCancel:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch (type) {
        case 11:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark 达人完成注册
- (void)rightBarBtnResponse:(id)sender
{
    //type ==0 修改行业信息入口
    if ([[MyCommon removeSpaceAtSides:tagsTextField_.text] isEqualToString:@""] && _selectedTagBtn ==nil) {
        if ([_type isEqualToString:@"0"]) {
            [BaseUIViewController showAlertView:@"温馨提示" msg:@"请选择行业" btnTitle:@"知道了"];
        }else if ([_type isEqualToString:@"1"]){
            [BaseUIViewController showAlertView:@"温馨提示" msg:@"请填写职业" btnTitle:@"知道了"];
        }
        return;
    }
    if ([_type isEqualToString:@"0"] || [_type isEqualToString:@"1"]) {//0行业修改 1职业修改
        personTagModel *personModel = [[personTagModel alloc]init];
        if (_selectedTagBtn) {
            NSInteger tag = _selectedTagBtn.tag;
            NSInteger index = tag - BUTTON_TAG_OFFSET;
            personTagModel *selectTagModel = _tagArray[index];
            NSString *tagId = selectTagModel.tagId_;
            personModel.tagId_ = tagId;
            personModel.tagName_ = _selectedTagBtn.titleLabel.text;
        }
        if (![[tagsTextField_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            personModel.tagName_ = tagsTextField_.text;
            personModel.tagId_ = @"";
        }
        if ([_type isEqualToString:@"0"]){
            if([_delegate respondsToSelector:@selector(updateTrade:)]){
                [_delegate updateTrade:personModel];
            }
        }else if  ([_type isEqualToString:@"1"]){
            if([_delegate respondsToSelector:@selector(updateJob:)]){
                [_delegate updateJob:personModel];
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if (_selectedTagBtn) {
            NSInteger tag = _selectedTagBtn.tag;
            NSInteger index = tag - BUTTON_TAG_OFFSET;
            personTagModel *selectTagModel = _tagArray[index];
            NSString *tagId = selectTagModel.tagId_;
            _inDataModal.tradeId = tagId;
            _inDataModal.tradeName = @"";
        }
        
        //文本框输入
        if (![[tagsTextField_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            _inDataModal.tradeName = tagsTextField_.text;
            _inDataModal.tradeId = @"";
        }
//            _inDataModal.userId_ = @"15698343";
        [self saveUserInfo:_inDataModal.userId_];
    }
    
    
    
}

//设置右按扭的属性
- (void)setRightBarBtnAtt
{
//    [rightBarBtn_ setTitle:@"完成" forState:UIControlStateNormal];
//    rightBarBtn_.layer.cornerRadius = 2.0;
//    [rightBarBtn_ setBackgroundColor:[UIColor colorWithRed:196.0/255.0 green:0.0/255.0 blue:8.0/255.0 alpha:1.0]];
//    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightBarBtn_ setFrame:CGRectMake(0, 0, 55, 26)];
//    [rightBarBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [MyCommon removeTapGesture:self.scrollView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    CGPoint point = self.scrollView_.contentOffset;
    if( point.y < 0 ){
        [self.scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if( self.scrollView_.frame.size.height + point.y > self.scrollView_.contentSize.height ){
        if( self.scrollView_.frame.size.height > self.scrollView_.contentSize.height ){
            [self.scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
        }else
            [self.scrollView_ setContentOffset:CGPointMake(0, self.scrollView_.contentSize.height - self.scrollView_.frame.size.height) animated:YES];
    }
    CGRect frame = self.toolbarHolder.frame;
    frame.origin.y = self.view.frame.size.height;
    self.toolbarHolder.frame = frame;
}



@end

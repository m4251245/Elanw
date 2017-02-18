//
//  ELTradeChangeCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/10/29.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELTradeChangeCtl.h"
#import "CustomTagButton.h"
#import "CustomTradeTextField.h"
#import "personTagModel.h"

@interface ELTradeChangeCtl () <UIScrollViewDelegate,UITextFieldDelegate>
{
    __weak IBOutlet UIScrollView *scrollView_;
    RequestCon *_getTradeTagCon;
    RequestCon *_saveUserCon;
    CustomTagButton *_selectedTagBtn;
    NSArray *_tagArray;
    UITextField         *tagsTextField_;
    UIButton            *submitBtn;

    personTagModel *personModel_;
    RequestCon *editCon_;
}

@end

@implementation ELTradeChangeCtl

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        rightNavBarStr_ = @"保存";
        [rightBarBtn_ setTitleColor:FONEREDCOLOR forState:UIControlStateNormal];
        [rightBarBtn_ setBackgroundColor:[UIColor whiteColor]];
        rightBarBtn_.clipsToBounds = YES;
        rightBarBtn_.layer.cornerRadius = 3.0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    scrollView_.delegate = self;
//    self.navigationItem.title = @"选择行业";
    [self setNavTitle:@"选择行业"];
}


- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    _inDataModal = dataModal;
//    if (!personModel_) {
//        personModel_ = [[personTagModel alloc]init];
//    }
//    personModel_.tagName_ = _inDataModal.tradeName;
//    personModel_.tagId_ = _inDataModal.tradeId;
    if (_getTradeTagCon == nil) {
        _getTradeTagCon = [self getNewRequestCon:NO];
    }
    [_getTradeTagCon getTradeTagsList];
    
}

- (void)getDataFunction:(RequestCon *)con
{
    
}


- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    if (requestCon == _getTradeTagCon)
    {
        _tagArray = [NSArray arrayWithArray:dataArr];
    }
    else if (type == Request_SaveInfo)
    {
        Status_DataModal * dataModal = [dataArr objectAtIndex:0];
        if([dataModal.status_ isEqualToString:Success_Status])
        {
            User_DataModal *userModel = [Manager getUserInfo];
            [CommonConfig setDBValueByKey:@"tradeName" value:personModel_.tagName_];
            [CommonConfig setDBValueByKey:@"tradeId" value:personModel_.tagId_];
            userModel.tradeName= personModel_.tagName_;
            userModel.tradeId = personModel_.tagId_;
            [Manager setUserInfo:userModel];
            [_delegate editorSuccessWithTradeName:personModel_.tagName_ tradeId:personModel_.tagId_];
            [BaseUIViewController showAutoDismissSucessView:@"修改成功" msg:nil];
            //修改成功回调
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [BaseUIViewController showAutoDismissFailView:@"修改失败" msg:@"请稍后再试"];
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

-(void)rightBarBtnResponse:(id)sender
{
    if (personModel_.tagName_.length == 0 && tagsTextField_.text.length > 0)
    {
        if (!personModel_) {
            personModel_ = [[personTagModel alloc]init];
        }
        personModel_.tagName_ = tagsTextField_.text;
        personModel_.tagId_ = @"001";
    }
    if(_isFromExpert)
    {
        [_delegate editorSuccessWithTradeName:personModel_.tagName_ tradeId:personModel_.tagId_];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self saveTrade];
    }
}

#pragma mark 初始化行业的view
- (void)initTradeView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHideKeyBoard:)];
    scrollView_.userInteractionEnabled = YES;
    [scrollView_ addGestureRecognizer:tap];
    
    NSInteger tagCount = [_tagArray count];
    if (tagCount == 0) {
        return;
    }
    NSInteger column = 2;
    NSInteger remainder = tagCount%column;
    NSInteger line = 0;
    CGRect frameLast = CGRectZero;
    if (remainder ==0) {
        line = tagCount/column;
    }else{
        line = tagCount/column +1;
    }
    CGFloat btnWidth = (ScreenWidth/2.0)-23;
    
    NSString *tagStr = _inDataModal.tradeId;
    NSString *tag = _inDataModal.tradeName;
    
    for (int i=0; i<line; i++) {
        for (int k=0;k<column;k++) {
            if (i == line-1 && remainder==1 && k==1) {
                break;
            }
            personTagModel *model = [_tagArray objectAtIndex:i*column+k];
            CustomTagButton *button = [[CustomTagButton alloc]init];
            button.isSeleted_ = NO;
            if ([tagStr isEqualToString:model.tagId_] || [tag isEqualToString:model.tagName_]) {
                _selectedTagBtn = button;
                button.selected = YES;
                [button setBackgroundColor:[UIColor colorWithRed:215.0/255 green:50.0/255 blue:50.0/255 alpha:1.0]];
            }
            else{
                button.selected = NO;
                [button setBackgroundColor:[UIColor clearColor]];
            }
            [button setFrame:CGRectMake(18+k*(btnWidth+10), 40+i*48, btnWidth, 38)];
            [button setTitle:model.tagName_ forState:UIControlStateNormal];
            
            [button setTag:(100 + i*column + k) ];
            [button addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
            [button setTitleColor:WhiteColor forState:UIControlStateSelected];
            
            
            [scrollView_ setContentSize:CGSizeMake(ScreenWidth, button.frame.origin.y+button.frame.size.height+10)];
            [scrollView_ addSubview:button];
            frameLast = button.frame;
        }
    }
    
    if (line != 0)
    {
        scrollView_.contentSize = CGSizeMake(ScreenWidth,CGRectGetMaxY(frameLast)+58);
        tagsTextField_ = [[CustomTradeTextField alloc]init];
        tagsTextField_.hidden = YES;
        tagsTextField_.placeholder = @"请输入行业名称";
        tagsTextField_.delegate =  self;
        CGSize size = scrollView_.contentSize;
        tagsTextField_.backgroundColor = [UIColor clearColor];
        tagsTextField_.frame = CGRectMake(18,CGRectGetMaxY(frameLast)+10, 207, 38);
        tagsTextField_.clearButtonMode = UITextFieldViewModeWhileEditing;
        tagsTextField_.text = @"";
        [scrollView_ addSubview:tagsTextField_];
        //添加确定按钮
        submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        submitBtn.titleLabel.font = FOURTEENFONT_CONTENT;
        submitBtn.frame = CGRectMake(235, CGRectGetMaxY(frameLast)+10, 69, 38);
        submitBtn.hidden = YES;
        submitBtn.layer.cornerRadius = 19;
        submitBtn.layer.masksToBounds = YES;
        submitBtn.layer.borderWidth = 0.5;
        submitBtn.backgroundColor = [UIColor colorWithRed:215.0/255 green:50.0/255 blue:50.0/255 alpha:1.0];
        submitBtn.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
        [scrollView_ addSubview:submitBtn];
        [submitBtn addTarget:self action:@selector(submitCustomerTag) forControlEvents:UIControlEventTouchUpInside];
        size.height += 30;
        scrollView_.contentSize = size;
    }
}

-(void)tapHideKeyBoard:(UITapGestureRecognizer *)sender
{
    [tagsTextField_ resignFirstResponder];
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

    if (!personModel_) {
          personModel_ = [[personTagModel alloc]init];
    }
    personModel_.tagName_ = tagsTextField_.text;
    personModel_.tagId_ = @"001";

    if ([[MyCommon removeAllSpace:personModel_.tagName_] isEqualToString:@""]) {
        [BaseUIViewController showAlertView:@"温馨提示" msg:@"请选择行业" btnTitle:@"知道了"];
        return;
    }
    [self saveTrade];
}

-(void)saveTrade
{
    if (_selectedTagBtn) {
        NSInteger tag = _selectedTagBtn.tag;
        NSInteger index = tag - 100;
        personTagModel *selectTagModel = _tagArray[index];
        if (!personModel_) {
            personModel_ = [[personTagModel alloc]init];
        }
        personModel_.tagName_ = selectTagModel.tagName_;
        personModel_.tagId_ = selectTagModel.tagId_;
    }
    else{
        personModel_ = [[personTagModel alloc]init];
    }
    
    if ([MyCommon removeAllSpace:personModel_.tagName_].length == 0) {
        [BaseUIViewController showAlertView:@"温馨提示" msg:@"请选择行业" btnTitle:@"知道了"];
        return;
    }
    if (_type == 1) {
        [BaseUIViewController showLoadView:YES content:nil view:nil];
        NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
        [conditionDic setObject:_inDataModal.tradeName forKey:@"trade_before"];
        [conditionDic setObject:personModel_.tagName_ forKey:@"trade"];
        SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
        NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
        NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&contact_arr=%@",_companyId,conDicStr];
        NSString *function = @"editCompanyInfo";
        NSString *op = @"company_info_busi";
        [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
            NSString *status = result[@"status"];
            if ([status isEqualToString:@"TRUE"]) {
                if ([self.delegate respondsToSelector:@selector(editorSuccessWithTradeName:tradeId:)]) {
                    [self.delegate editorSuccessWithTradeName:personModel_.tagName_ tradeId:personModel_.tagId_];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            [BaseUIViewController showLoadView:NO content:nil view:nil];
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [BaseUIViewController showLoadView:NO content:nil view:nil];
        }];
    }
    else{
        if(!editCon_)
        {
            editCon_ = [self getNewRequestCon:NO];
        }
        [editCon_ saveUserInfo:[Manager getUserInfo].userId_ job:nil sex:nil pic:nil name:nil trade:nil company:nil nickname:nil signature:nil hkaId:nil school:nil zym:nil rctypeId:nil regionStr:nil workAge:nil brithday:nil tradeId:personModel_.tagId_ tradeName:nil];
    }
    
}

#pragma mark 选择项
-(void)tagButtonClick:(CustomTagButton *)button
{
    if (_selectedTagBtn != button) {
        _selectedTagBtn.selected = NO;
        [_selectedTagBtn setBackgroundColor:[UIColor clearColor]];
        button.selected = YES;
        [button setBackgroundColor:[UIColor colorWithRed:215.0/255 green:50.0/255 blue:50.0/255 alpha:1.0]];
        _selectedTagBtn = button;
    }
    else{
        button.selected = NO;
        [button setBackgroundColor:[UIColor clearColor]];
        _selectedTagBtn = nil;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_selectedTagBtn)
    {
        _selectedTagBtn.selected = NO;
        [_selectedTagBtn setBackgroundColor:[UIColor clearColor]];
    }
    scrollView_.contentSize = CGSizeMake(ScreenWidth,scrollView_.contentSize.height + 240);
    scrollView_.contentOffset = CGPointMake(0,scrollView_.contentSize.height-scrollView_.frame.size.height);
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    scrollView_.contentSize = CGSizeMake(ScreenWidth,scrollView_.contentSize.height - 240);
    scrollView_.contentOffset = CGPointMake(0,scrollView_.contentSize.height-scrollView_.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

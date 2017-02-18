//
//  ELEvaluationResumeCtl.m
//  jobClient
//
//  Created by YL1001 on 16/8/10.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELEvaluationResumeCtl.h"
#import "ResumeComment_DataModal.h"
#import "ResumeComment_Cell.h"
#import "GCPlaceholderTextView.h"
#import "NSString+URLEncoding.h"

@interface ELEvaluationResumeCtl ()<UITextViewDelegate>
{
     GCPlaceholderTextView *_commentTV;
     UIButton *_submitBtn;
     UITapGestureRecognizer  *_singleTapRecognizer;
     UIScrollView *scrollView;
     NSString *comment_type;
     NSArray *titleArr;
     UIButton *nowBtn;//当前选中按钮
}

@end

@implementation ELEvaluationResumeCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"评论/备注"];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    [self configUI];
}

- (void)configUI
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight+300);
    [self.view addSubview:scrollView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [scrollView addSubview:topView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, ScreenWidth-30, 13)];
    label.text = @"备注标签";
    label.font = [UIFont systemFontOfSize:13];
    [topView addSubview:label];
    
    UIView *btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, label.bottom+15, ScreenWidth, 117)];
    [topView addSubview:btnBgView];
    
    titleArr = @[@"简历合适",@"简历不合适",@"待确定",@"面试通过",@"面试不通过",@"发offer",@"确认上岗",@"背景调查"];
    
    for (NSUInteger i = 0 , count = titleArr.count; i < count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat btnWidth = 85;
        CGFloat btnspacing = (ScreenWidth - btnWidth*3)/4;
        
        btn.frame = CGRectMake(btnspacing+(i%3)*(btnWidth+btnspacing), (i/3)*43, btnWidth, 31);
        
        [btn setBackgroundImage:[UIImage createImageWithColor:UIColorFromRGB(0xffffff)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage createImageWithColor:UIColorFromRGB(0xfb8787)] forState:UIControlStateSelected];
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
        btn.layer.cornerRadius = 15;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = UIColorFromRGB(0xe4e4e4).CGColor;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.tag = 100 +i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnBgView addSubview:btn];
    }
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, btnBgView.bottom+18, ScreenWidth-30, 12)];
    label2.text = @"注：选择一个备注标签，让你的评论备注看起来更有针对性吧~";
    label2.textColor = UIColorFromRGB(0x757575);
    label2.font = [UIFont systemFontOfSize:12];
    [topView addSubview:label2];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, label2.bottom+20, ScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xe0e0e0);
    [topView addSubview:lineView];
    
    UILabel *label3 = [[UILabel alloc] init];
    CGRect frame = label2.frame;
    frame.origin.y = lineView.bottom+20;
    label3.frame = frame;
    label3.text = @"备注内容";
    label3.font = [UIFont systemFontOfSize:12];
    label3.textColor = UIColorFromRGB(0x434343);
    [topView addSubview:label3];
    
    _commentTV = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(15, label3.bottom+15, ScreenWidth-30, 146)];
    _commentTV.layer.borderWidth = 0.5;
    _commentTV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _commentTV.placeholder = @"随手备注一下候选人的招聘过程,对招聘复盘很重要哦~\n候选人是看不到备注内容的";
    _commentTV.delegate = self;
    [topView addSubview:_commentTV];
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitBtn.frame = CGRectMake(38, _commentTV.bottom+16, ScreenWidth-72, 33);
    _submitBtn.backgroundColor = UIColorFromRGB(0xe23e3f);
    [_submitBtn setTitle:@"提交评价" forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _submitBtn.layer.cornerRadius = 4;
    [_submitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_submitBtn];
}

- (void)btnAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        nowBtn.selected = NO;
        nowBtn = btn;
        nowBtn.selected = YES;
        comment_type = titleArr[btn.tag-100];
    }
}

- (void)btnResponse:(id)sender
{
    [_commentTV resignFirstResponder];
    if ([[_commentTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        [BaseUIViewController showAutoDismissFailView:@"请填写评价内容" msg:nil];
        return;
    }
    
    NSMutableDictionary *condictionDic = [[NSMutableDictionary alloc] init];
    if ([Manager getUserInfo].name_.length > 0) {
        [condictionDic setObject:[Manager getUserInfo].name_ forKey:@"author"];
    }
    NSString *text = [_commentTV.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    [condictionDic setObject:[text URLEncodedForString] forKey:@"content"];
    [condictionDic setObject:@"" forKey:@"m_id"];
    [condictionDic setObject:_userModel.zpId_ forKey:@"job_id"];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [condictionDic setObject:synergy_id forKey:@"synergy_m_id"];
    }
    [condictionDic setObject:comment_type forKey:@"comment_type"];
    [condictionDic setObject:@"40" forKey:@"commentLabelId"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *condictionStr = [jsonWriter stringWithObject:condictionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&cmailbox_id=%@&person_id=%@&param=%@&type=%@", _companyId, _userModel.forKey, _userModel.userId_, condictionStr, @""];
    NSString * function = @"mobileResumeCommentNew";
    NSString * op = @"company_resume_comment_busi";
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        Status_DataModal * dataModal = [[Status_DataModal alloc] init];
        dataModal.status_ = [result objectForKey:@"status"];
        dataModal.des_ = [result objectForKey:@"desc"];
        
        if ([dataModal.status_ isEqualToString:Success_Status]) {
            _commentTV.text = @"";
           
            [BaseUIViewController showAutoDismissSucessView:@"提交成功" msg:nil];
            if ([_delegate respondsToSelector:@selector(refreshResume)]) {
                [_delegate refreshResume];
            }

            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [BaseUIViewController showAutoDismissFailView:@"提交失败" msg:dataModal.des_];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

//#pragma mark - 请求数据
//- (void)beginLoad:(id)param exParam:(id)exParam
//{
//    [super beginLoad:param exParam:exParam];
//    
//    self.noDataTopSpace = 1;
//}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_commentTV resignFirstResponder];
}

#pragma mark - keyBoard
-(void)keyboardWillHide:(NSNotification *)notification{
    [super keyboardWillHide:notification];
    CGRect frame = self.scrollView_.frame;
    frame.size.height = ScreenHeight;
    self.scrollView_.frame = frame;
}

-(void)keyboardWillShow:(NSNotification *)notification{
    [super keyboardWillShow:notification];
    CGRect frame = self.scrollView_.frame;
    frame.size.height = ScreenHeight-self.keyBoardHeight;
    self.scrollView_.frame = frame;
}

//自己视图的单击事件
-(void) viewSingleTap:(id)sender
{
    [_commentTV resignFirstResponder];
}

//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    if (_commentTV.frame.origin.y > 100 && scrollView.contentOffset.y == 0) {
//        scrollView.contentOffset = CGPointMake(0, 80);
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

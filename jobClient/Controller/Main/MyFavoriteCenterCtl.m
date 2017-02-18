//
//  MyFavoriteCenterCtl.m
//  jobClient
//
//  Created by 一览ios on 15/8/14.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MyFavoriteCenterCtl.h"
#import "MyFavoriteArticleList.h"
#import "MyFvoritePositionList.h"
#import "MyAccessoryList.h"
#import "ShareMessageModal.h"

@interface MyFavoriteCenterCtl () <ShareMessageDelegate,SharePositionMessageDelegate>
{
    MyFavoriteArticleList *favArticleCtl;
    MyFvoritePositionList *favPositionCtl;
    MyAccessoryList       *accessoryList;
    UIButton *leftBtn;
    UIButton *midBtn;
    UIButton *rightBtn;
    UIView *segView;
    UIView *lineImgv;
}
@end

@implementation MyFavoriteCenterCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
        rightNavBarStr_ = @"编辑";
        favArticleCtl = [[MyFavoriteArticleList alloc]init];
        favPositionCtl = [[MyFvoritePositionList alloc]init];
        accessoryList = [[MyAccessoryList alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight-64);
    
    segView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,36)];
    segView.backgroundColor = [UIColor whiteColor];
    segView.clipsToBounds = YES;
    [self.view addSubview:segView];
    
    [segView addSubview:[[ELLineView alloc] initWithFrame:CGRectMake(0,35,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)]];
    
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn setTitle:@"文章" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [segView addSubview:leftBtn];
    
    midBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    midBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [midBtn setTitle:@"职位" forState:UIControlStateNormal];
    [midBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [segView addSubview:midBtn];
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"附件" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [segView addSubview:rightBtn];
    
    lineImgv = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    lineImgv.backgroundColor = UIColorFromRGB(0xF41A28);
    [segView addSubview:lineImgv];
    
    [self setNavTitle:@"我的收藏"];
 
    __block UIButton *rightBarBtn  = rightBarBtn_;
    favArticleCtl.block = ^(BOOL flag){
        if (!flag) {
            [rightBarBtn setTitle:@"完成" forState:UIControlStateNormal];
        }else{
            [rightBarBtn setTitle:@"编辑" forState:UIControlStateNormal];
        }
    };
    
    favPositionCtl.block = ^(BOOL flag){
        if (!flag) {
            [rightBarBtn setTitle:@"完成" forState:UIControlStateNormal];
        }else{
            [rightBarBtn setTitle:@"编辑" forState:UIControlStateNormal];
        }
    };
    
    accessoryList.block = ^(BOOL flag){
        if (!flag) {
            [rightBarBtn setTitle:@"完成" forState:UIControlStateNormal];
        }else{
            [rightBarBtn setTitle:@"编辑" forState:UIControlStateNormal];
        }
    };
  
    [favArticleCtl beginLoad:nil exParam:nil];
    [favPositionCtl beginLoad:nil exParam:nil];
    [accessoryList beginLoad:nil exParam:nil];
  
    favArticleCtl.view.frame = CGRectMake(0, 36, self.view.frame.size.width, self.view.frame.size.height-36);
    [self.view addSubview:favArticleCtl.view];
    [self addChildViewController:favArticleCtl];
    favPositionCtl.view.frame = favArticleCtl.view.frame;
    favArticleCtl.view.hidden = YES;
    [self.view addSubview:favPositionCtl.view];
    [self addChildViewController:favPositionCtl];
    accessoryList.view.frame = favArticleCtl.view.frame;
    accessoryList.view.hidden = YES;
    [self.view addSubview:accessoryList.view];
    [self addChildViewController:accessoryList];
    
    [self changModel:leftBtn];
    
    if (_fromMessageList) {
        [rightBarBtn setHidden:YES];
         CGFloat btnWidth = ScreenWidth/2;
        [leftBtn setFrame:CGRectMake(0, 0, btnWidth, 36)];
        [midBtn setFrame:CGRectMake(btnWidth, 0, btnWidth, 36)];
        [rightBtn setHidden:YES];
        [lineImgv setFrame:CGRectMake(0, 34, btnWidth, 2)];
        favArticleCtl.fromMessageList = YES;
        favPositionCtl.fromMessageList = YES;
        favArticleCtl.shareDelegate = self;
        favPositionCtl.shareDelegate = self;
    }
    else
    {
        CGFloat btnWidth = ScreenWidth/3;
        [leftBtn setFrame:CGRectMake(0, 0, btnWidth, 36)];
        [midBtn setFrame:CGRectMake(btnWidth, 0, btnWidth, 36)];
        [rightBtn setFrame:CGRectMake(btnWidth*2, 0, btnWidth, 36)];
        
        lineImgv.frame = CGRectMake(0, 34, btnWidth, 2);
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void)shareMessageDelegateModal:(Article_DataModal *)modal
{
    ShareMessageModal *modalOne = [[ShareMessageModal alloc] init];
    if ([modal.typeCode isEqualToString:@"group"]) {
        modalOne.shareType = @"11";
        modalOne.shareContent = @"社群文章";
    }
    else
    {
        modalOne.shareType = @"2";
        modalOne.shareContent = @"个人文章";
    }
    
    if(modal.id_.length > 0)
    {
        modalOne.article_id = modal.id_;
    }
    else
    {
        modalOne.article_id = @"";
    }
    if (modal.summary_.length > 0) {
        modalOne.article_summary = modal.summary_;
    }
    else
    {
        modalOne.article_summary = @"";
    }
    
    if (modal.thum_.length > 0) {
        modalOne.article_thumb = modal.thum_;
    }
    else
    {
        modalOne.article_thumb = @"";
    }
    
    if (modal.title_.length > 0) {
        modalOne.article_title = modal.title_;
    }
    else
    {
        modalOne.article_title = @"";
    }
    [_favoriteDelegate favoriteMessageDelegateModal:modalOne];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sharePositionMessageModal:(ZWDetail_DataModal *)modal
{
    ShareMessageModal *shareModal = [[ShareMessageModal alloc] init];
    shareModal.shareType = @"20";
    shareModal.shareContent = @"职位";
    
    shareModal.position_id = modal.zwID_;
    shareModal.position_name = modal.zwName_;
    shareModal.position_logo = modal.companyLogo_;
    shareModal.position_company = modal.companyName_;
    shareModal.position_company_id = modal.companyID_;
    
    if (!shareModal.position_name) {
        shareModal.position_name = @"";
    }
    if (!shareModal.position_logo) {
        shareModal.position_logo = @"";
    }
    if (!shareModal.position_company) {
        shareModal.position_company = @"";
    }
    if (!shareModal.position_company_id)
    {
        shareModal.position_company_id = @"";
    }
    
    if (modal.salary_.length > 0) {
        shareModal.position_salary = modal.salary_;
    }
    else
    {
        shareModal.position_salary = @"面议";
    }
    [_favoriteDelegate favoriteMessageDelegateModal:shareModal];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

- (void)btnResponse:(id)sender
{
    if (sender == leftBtn || sender == rightBtn || sender == midBtn) {
        [self changModel:sender];
        [self lineViewFrameChange:sender];
    }
}

- (void)changModel:(id)button
{
    UIButton *clickBtn = button;
    favArticleCtl.view.hidden = YES;
    favPositionCtl.view.hidden = YES;
    accessoryList.view.hidden = YES;
    [self changAllBtnStatus];
    if (clickBtn == leftBtn) {
        [leftBtn setTitleColor:[UIColor colorWithRed:249.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        favArticleCtl.view.hidden = NO;
    }else if (clickBtn == midBtn) {
        [midBtn setTitleColor:[UIColor colorWithRed:249.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        favPositionCtl.view.hidden = NO;
        
    }else{
        [rightBtn setTitleColor:[UIColor colorWithRed:249.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        accessoryList.view.hidden = NO;
    }
}

- (void)changAllBtnStatus
{
    [leftBtn setTitleColor:[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [midBtn setTitleColor:[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [rightBarBtn_ setTitle:@"编辑" forState:UIControlStateNormal];
    [favArticleCtl stopEditro];
    [favPositionCtl stopEditro];
    [accessoryList stopEditro];
}


- (void)lineViewFrameChange:(id)sender
{
    UIButton *clickBtn = sender;
    CGRect rect = lineImgv.frame;
    rect.origin.x = clickBtn.frame.origin.x;
    [lineImgv setFrame:rect];
}

- (void)rightBarBtnResponse:(id)sender
{
    [self startEditor:sender];
}

- (void)startEditor:(UIButton *)item
{
    if (CGColorEqualToColor(leftBtn.titleLabel.textColor.CGColor, [UIColor colorWithRed:249.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0].CGColor)) {
        [favArticleCtl startEditor];
    }else if (CGColorEqualToColor(midBtn.titleLabel.textColor.CGColor, [UIColor colorWithRed:249.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0].CGColor)){
        [favPositionCtl startEditor];
    }else if (CGColorEqualToColor(rightBtn.titleLabel.textColor.CGColor, [UIColor colorWithRed:249.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0].CGColor)){
        [accessoryList startEditor];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([rightBarBtn_.titleLabel.text isEqualToString:@"完成"]) {
        [rightBarBtn_ setTitle:@"编辑" forState:UIControlStateNormal];
    }
    [favArticleCtl stopEditro];
    [favPositionCtl stopEditro];
    [accessoryList stopEditro];
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

//
//  OfferPartyDetailIndexCtlViewController.m
//  jobClient
//
//  Created by 一览ios on 15/8/3.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "OfferPartyDetailIndexCtl.h"
#import "OfferPartyInterviewTipsCtl.h"
#import "SBJson.h"
#import "YLOfferApplyUrlCtl.h"


@interface OfferPartyDetailIndexCtl ()
{
    
    IBOutlet UIView *_backView;
    __weak IBOutlet UIButton *_sharaBtn;
    
    BOOL isShowBtn; //显示分享按钮
}
@end

@implementation OfferPartyDetailIndexCtl

-(id)init
{
    if (self = [super init]) {
        self.recommendDetail = [[MyOfferPartyDetailCtl alloc] init];
        _recommendDetail.offerPartyDetailType = OfferPartyDetailTypeRecommend;
        self.offerApllyUrlCtl = [[YLOfferApplyUrlCtl alloc] init];
    };
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.titleView = segmentView;
}

-(void)viewDidDisappear:(BOOL)animated{
    self.navigationItem.titleView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_scrollView];
    
     self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        segmentView.layer.borderWidth = 1.0f;
        segmentView.layer.borderColor = [UIColor whiteColor].CGColor;
        segmentView.clipsToBounds = YES;
        segmentView.layer.cornerRadius = 4.0f;
        self.navigationItem.titleView = segmentView;
        
        _scrollView.contentSize = CGSizeMake(ScreenWidth*2,self.view.bounds.size.height);
        _scrollView.scrollEnabled = NO;
        _scrollView.bounces = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        self.offerApllyUrlCtl.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
        self.recommendDetail.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - 64);
        
        [_scrollView addSubview:self.offerApllyUrlCtl.view];
        [_scrollView addSubview:self.recommendDetail.view];
        [self addChildViewController:self.offerApllyUrlCtl];
        [self addChildViewController:self.recommendDetail];
    
    
    if (_isSignUp) {
        [self btnResponse:_recommendBtn];
        isShowBtn = NO;
    }
    else
    {
        isShowBtn = YES;
    }
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:_backView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    NSInteger width = -10;
    negativeSpacer.width = width;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];
    
    [self isShowSahreBtn];
    
    if(_isFromNotice)
    {//来自推送通知
        if ([_offerPartyModel.msgType isEqualToString:@"30"] || [_offerPartyModel.msgType isEqualToString:@"100"] ) {
            if (![Manager shareMgr].offerTipsCtl) {
                [Manager shareMgr].offerTipsCtl = [[OfferPartyInterviewTipsCtl alloc] init];
                [Manager shareMgr].offerTipsCtl.view.frame = [UIScreen mainScreen].bounds;
                [Manager shareMgr].offerTipsCtl.maskView.frame = [Manager shareMgr].offerTipsCtl.view.frame;
            }
            [Manager shareMgr].offerTipsCtl.offerPartyModel = _offerPartyModel;
            [[Manager shareMgr].offerTipsCtl getPersonInterviewState];
            [[Manager shareMgr].offerTipsCtl showViewCtl];
        }
    }
    
    if(_isFromZbar)
    {
        [self btnResponse:_recommendBtn];
    }
    
}

- (void)isShowSahreBtn
{
    if (isShowBtn) {
        if (_offerPartyModel.xuanchuan_url.length > 0) {
            _sharaBtn.hidden = NO;
        }
        else {
            _sharaBtn.hidden = YES;
        }
    }
    else {
        _sharaBtn.hidden = YES;
    }
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:nil exParam:nil];
    _offerApllyUrlCtl.modal = _offerPartyModel;
    _offerApllyUrlCtl.resumeComplete = _resumeComplete;
    [_offerApllyUrlCtl beginLoad:exParam exParam:nil];
    _recommendDetail.jobfair_id = _offerPartyModel.jobfair_id;
    _recommendDetail.jobfair_time = _offerPartyModel.jobfair_time;
    _recommendDetail.jobfair_name = _offerPartyModel.jobfair_name;
    _recommendDetail.place_name = _offerPartyModel.place_name;
    _recommendDetail.fromtype = _offerPartyModel.fromtype;
    _recommendDetail.isjoin = _offerPartyModel.isjoin;
    _recommendDetail.iscome = _offerPartyModel.iscome;
    _recommendDetail.resumeComplete = _resumeComplete;
    [_recommendDetail beginLoad:exParam exParam:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnResponse:(id)sender
{
    if (sender == _allBtn) {//offer派详情
        _allBtn.backgroundColor = [UIColor whiteColor];
        [_allBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        _recommendBtn.backgroundColor = [UIColor colorWithRed:225.f/255 green:62.f/255 blue:62.f/255 alpha:1.f];
        [_recommendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        isShowBtn = YES;
        [self isShowSahreBtn];
        
    }
    else if (sender == _recommendBtn)
    {//本场职位
        _recommendBtn.backgroundColor = [UIColor whiteColor];
        [_recommendBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _allBtn.backgroundColor = [UIColor colorWithRed:225.f/255 green:62.f/255 blue:62.f/255 alpha:1.f];
        [_allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
        
        isShowBtn = NO;
        [self isShowSahreBtn];
    }
    else if (sender == _sharaBtn)
    {
        UIImage * image = nil;
        NSString *imageUrl = _offerPartyModel.logo_src;
        NSString *title = _offerPartyModel.jobfair_name;
        NSString *content = @"";
        
        if (_offerPartyModel.share_friend_title.length > 0) {
            title = _offerPartyModel.share_friend_title;
        }
        
        if (_offerPartyModel.share_friend_content.length > 0) {
            content = _offerPartyModel.share_friend_content;
        }
        else
        {
            content = @"面试复试一站式服务，大把offer轻松拿";
        }
        if (_offerPartyModel.xuanchuan_url.length > 0) {
            imageUrl = _offerPartyModel.xuanchuan_url;
        }
        
        if (imageUrl.length > 0)
        {
            UIImage *imageOne = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
            if (imageOne) {
                image = imageOne;
            }
        }
        
        [[ShareManger sharedManager] shareWithCtl:self.navigationController title:title content:content image:image url:_offerPartyModel.xuanchuan_url];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

@end

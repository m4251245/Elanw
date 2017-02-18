//
//  ELAnswerCenterCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/9/7.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELAnswerCenterCtl.h"
#import "Manager.h"
#import "AnswerList_Ctl.h"

@interface ELAnswerCenterCtl ()
{
    UIView *segmentView;
    UIButton *segmentRightBtn;
    UIButton *segmentLeftBtn;
    UIScrollView *_scrollView;
    
    AnswerList_Ctl *leftCtl;
    AnswerList_Ctl *rightCtl;
    
    UIView *lineView;
}
@end

@implementation ELAnswerCenterCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight-64)];
    _scrollView.scrollEnabled = NO;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    BOOL showWait = YES;
    BOOL isMyCenter = YES;
    if (_formPersonCenter){
        if ([_userId isEqualToString:[Manager getUserInfo].userId_]) {
            showWait = YES;
            isMyCenter = YES;
        }else{
            showWait = NO;
            isMyCenter = NO;
        }
    }
    
    if ([Manager getUserInfo].isExpert_ && showWait){
        [self creatSegment];
        _scrollView.frame = CGRectMake(0,40,ScreenWidth,ScreenHeight-104);
        segmentView.hidden = NO;
        _scrollView.contentSize = CGSizeMake(ScreenWidth*2,0);
        leftCtl = [[AnswerList_Ctl alloc] init];
        leftCtl.isMyCenter = YES;
        leftCtl.isWaitList = YES;
        leftCtl.formMyAnswer = YES;
        rightCtl = [[AnswerList_Ctl alloc] init];
        rightCtl.isMyCenter = YES;
        rightCtl.formMyAnswer = YES;
        leftCtl.view.frame = CGRectMake(0,0,ScreenWidth,_scrollView.height);
        rightCtl.view.frame = CGRectMake(ScreenWidth,0,ScreenWidth,_scrollView.height);
        
        [_scrollView addSubview:leftCtl.view];
        [_scrollView addSubview:rightCtl.view];
        [leftCtl beginLoad:nil exParam:nil];
        [rightCtl beginLoad:nil exParam:nil];
        if (_showWaitAnswerList) {
           [self btnResponse:segmentLeftBtn]; 
        }else{
           [self btnResponse:segmentRightBtn];
        }
    }else{
        _scrollView.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight-64);
        segmentView.hidden = YES;
        _scrollView.contentSize = CGSizeMake(ScreenWidth,0);
        leftCtl = [[AnswerList_Ctl alloc] init];
        leftCtl.isMyCenter = isMyCenter;
        leftCtl.userId = _userId;
        leftCtl.formMyAnswer = YES;
        leftCtl.view.frame = CGRectMake(0,0,ScreenWidth,_scrollView.height);
        [_scrollView addSubview:leftCtl.view];
        [leftCtl beginLoad:_userId exParam:nil];
    }
}

-(void)creatSegment{
    segmentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,40)];
    segmentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:segmentView];
    
    segmentLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [segmentLeftBtn.titleLabel setFont:FIFTEENFONT_TITLE];
    segmentLeftBtn.frame = CGRectMake(0,0,ScreenWidth/2,40);
    [segmentLeftBtn setTitle:@"待回答" forState:UIControlStateNormal];
    [segmentLeftBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [segmentView addSubview:segmentLeftBtn];
    
    segmentRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [segmentRightBtn.titleLabel setFont:FIFTEENFONT_TITLE];
    segmentRightBtn.frame = CGRectMake(ScreenWidth/2,0,ScreenWidth/2,40);
    [segmentRightBtn setTitle:@"已回答" forState:UIControlStateNormal];
    [segmentRightBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [segmentView addSubview:segmentRightBtn];
    
    ELLineView *line = [[ELLineView alloc] initWithFrame:CGRectMake(0,39,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)];
    [segmentView addSubview:line];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0,38,103,2)];
    lineView.backgroundColor = PINGLUNHONG;
    [segmentView addSubview:lineView];
    
    [self btnResponse:segmentLeftBtn];
}

-(void)viewDidLayoutSubviews{
    [self.view layoutSubviews];
}

-(void)btnResponse:(id)sender{
    if (sender == segmentLeftBtn){
        [segmentLeftBtn setTitleColor:PINGLUNHONG forState:UIControlStateNormal];
        [segmentRightBtn setTitleColor:UIColorFromRGB(0x424242) forState:UIControlStateNormal];
        lineView.center = CGPointMake(ScreenWidth_Four,lineView.center.y);
        [_scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    }else if (sender == segmentRightBtn){
        [segmentRightBtn setTitleColor:PINGLUNHONG forState:UIControlStateNormal];
        [segmentLeftBtn setTitleColor:UIColorFromRGB(0x424242) forState:UIControlStateNormal];
        [_scrollView setContentOffset:CGPointMake(ScreenWidth,0) animated:YES];
        lineView.center = CGPointMake(ScreenWidth_Four*3,lineView.center.y);
    }
}

-(void)editorSuccessRefresh{
    if (_scrollView.contentOffset.x == 0) {
        [leftCtl refreshLoad:nil];
    }else{
        [rightCtl refreshLoad:nil];
    }
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam{
    
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

//
//  MyAQListCtl.m
//  jobClient
//
//  Created by YL1001 on 14/10/30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "MyAQListCtl.h"
#import "ELAnswerCenterCtl.h"

@interface MyAQListCtl ()
{
    NSString * indexStr_;
    BOOL selectRight;
    NSString *userId;
}

@end

@implementation MyAQListCtl
@synthesize type_;
-(id)init
{
    self = [super init];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight-64);
    [self creatSegment];
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
    
    scrollView_ = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView_.delegate = self;
    scrollView_.scrollEnabled = NO;
    [scrollView_ setContentSize:CGSizeMake(2*ScreenWidth, 1)];
    [self.view addSubview:scrollView_];
    
    if (type_ == 1) {
        questionListCtl_ = [[QuestionListCtl alloc] init];
        questionListCtl_.userId = userId;
        questionListCtl_.formPersonCenter = _formPersonCenter;
        answerListCtl_ = [[ELAnswerCenterCtl alloc] init];
        //answerListCtl_.isMyCenter = YES;
        answerListCtl_.userId = userId;
        answerListCtl_.showWaitAnswerList = _showWaitAnswerList;
        answerListCtl_.formPersonCenter = _formPersonCenter;
        
        [scrollView_ addSubview:questionListCtl_.view];
        [scrollView_ addSubview:answerListCtl_.view];
        
        [self addChildViewController:questionListCtl_];
        [self addChildViewController:answerListCtl_];
        
        [questionListCtl_.view setFrame:scrollView_.bounds];
        [answerListCtl_.view setFrame:scrollView_.bounds];
        
        //change rect
        CGRect rect = answerListCtl_.view.frame;
        rect.origin.x = ScreenWidth;
        [answerListCtl_.view setFrame:rect];
        
        [questionListCtl_ beginLoad:nil exParam:nil];
    }
   
    [scrollView_ setContentOffset:CGPointMake(_leftRight*scrollView_.frame.size.width, 0) animated:YES];
    
    if (_leftRight == AQleft) {
        [self changeModel:AQleft];
    }else{
        [self changeModel:AQright];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWithEditorSuccess) name:@"answerEditorSuccessRefresh" object:nil];
}

-(void)creatSegment{
    segmentedView_ = [[UIView alloc] init];
    segmentedView_.frame = CGRectMake(0,0,132,28);
    segmentedView_.layer.cornerRadius = 5.0;
    segmentedView_.layer.masksToBounds = YES;
    segmentedView_.layer.borderWidth = 0.5;
    segmentedView_.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
    [segmentedView_ setBackgroundColor:[UIColor colorWithRed:226.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0]];
    
    rightBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn_.titleLabel setFont:FOURTEENFONT_CONTENT];
    [rightBtn_ setBackgroundColor:[UIColor colorWithRed:226.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0]];
    [rightBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn_.frame = CGRectMake(66,0,66,28);
    [rightBtn_ setTitle:@"回答" forState:UIControlStateNormal];
    [rightBtn_.layer setMasksToBounds:YES];
    [rightBtn_ addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [segmentedView_ addSubview:rightBtn_];
    
    leftBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn_.titleLabel setFont:FOURTEENFONT_CONTENT];
    [leftBtn_ setBackgroundColor:[UIColor whiteColor]];
    [leftBtn_ setTitleColor:[UIColor colorWithRed:226.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    leftBtn_.frame = CGRectMake(0,0,66,28);
    [leftBtn_ setTitle:@"提问" forState:UIControlStateNormal];
    [leftBtn_.layer setMasksToBounds:YES];
    [leftBtn_ addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [segmentedView_ addSubview:leftBtn_];
    
    self.navigationItem.titleView = segmentedView_;
}

-(void)refreshWithEditorSuccess{
    if (!selectRight) {
        [questionListCtl_ refreshLoad:nil];
    }else{
        [answerListCtl_ editorSuccessRefresh];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationItem.titleView = segmentedView_;
    [self setFd_prefersNavigationBarHidden:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    self.navigationItem.titleView = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self setFd_prefersNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    userId = dataModal;
    [self updateCom:nil];
}


-(void)changeModel:(int)index
{
    [self changeBtnStatus:index];
    [scrollView_ setContentOffset:CGPointMake(index*scrollView_.frame.size.width, 0) animated:YES];
}

-(void)changeBtnStatus:(int)index
{
    switch (index) {
        case AQleft:
        {
            [rightBtn_ setBackgroundColor:[UIColor colorWithRed:225.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0]];
            [rightBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [leftBtn_ setBackgroundColor:[UIColor whiteColor]];
            [leftBtn_ setTitleColor:[UIColor colorWithRed:225.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
            break;
        case AQright:
        {
            [leftBtn_ setBackgroundColor:[UIColor colorWithRed:225.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0]];
            [leftBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [rightBtn_ setBackgroundColor:[UIColor whiteColor]];
            [rightBtn_ setTitleColor:[UIColor colorWithRed:225.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            
            [answerListCtl_ beginLoad:nil exParam:nil];
        }
            break;
        default:
            break;
    }
}

-(void)btnResponse:(id)sender
{
    if (sender == leftBtn_) {
        _leftRight = AQleft;
        [self changeModel:_leftRight];
        selectRight = NO;
    }else if (sender == rightBtn_){
         _leftRight = AQright;
        [self changeModel:_leftRight];
        selectRight = YES;
    }
}


@end

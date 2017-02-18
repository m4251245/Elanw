//
//  CompanyHRCtl.m
//  jobClient
//
//  Created by YL1001 on 14-9-5.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "CompanyHRCtl.h"

@interface CompanyHRCtl ()
{
    NSString * companyId_;
    BOOL isPop_;
}

@end

@implementation CompanyHRCtl
@synthesize modelIndex_;

-(id)init
{
    self = [super init];
    
    _companyResumeCtl_ = [[CompanyResumeCtl alloc] init];
    _companyResumeCtl_.type_ = 0;
    _companyResumeCtl_.delegate_ = self;
    _companyRecommendedResumeCtl_ = [[CompanyResumeCtl alloc] init];
    _companyRecommendedResumeCtl_.type_ = 2;
    _companyRecommendedResumeCtl_.delegate_ = self;
    //comCollectResumeCtl_ = [[ComColllectResumeCtl alloc] init];
    _downloadResumeListCtl_ = [[DownloadResumeListCtl alloc] init];
    return  self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectResumeSuccess) name:@"CollectResumeSuccess" object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"招聘管理";
    [self setNavTitle:@"招聘管理"];
    resumeCntLb_.alpha = 0.0;
    collectionCntLb_.alpha = 0.0;
    recommendCntLb_.alpha = 0.0;
    
    resumeBtn_.selected = YES;
    
    resumeCntLb_.layer.cornerRadius = 8.0;
    resumeCntLb_.layer.masksToBounds = YES;
    recommendCntLb_.layer.cornerRadius = 8.0;
    recommendCntLb_.layer.masksToBounds = YES;
    collectionCntLb_.layer.cornerRadius = 8.0;
    collectionCntLb_.layer.masksToBounds = YES;
    
    scrollView_.scrollEnabled = NO;
    [scrollView_ setContentSize:CGSizeMake(scrollView_.frame.size.width * 3, 1)];
    
    [scrollView_ addSubview:_companyResumeCtl_.view];
    [scrollView_ addSubview:_companyRecommendedResumeCtl_.view];
    [scrollView_ addSubview:_downloadResumeListCtl_.view];
    
    [_companyResumeCtl_.view setFrame:scrollView_.bounds];
    [_companyRecommendedResumeCtl_.view setFrame:scrollView_.bounds];
    [_downloadResumeListCtl_.view setFrame:scrollView_.bounds];
    
    CGRect rect = _companyRecommendedResumeCtl_.view.frame;
    rect.origin.x = rect.size.width * 1;
    [_companyRecommendedResumeCtl_.view setFrame:rect];
    
    rect = _downloadResumeListCtl_.view.frame;
    rect.origin.x = rect.size.width * 2;
    [_downloadResumeListCtl_.view setFrame:rect];
    
    [scrollView_ setContentOffset:CGPointMake(modelIndex_*scrollView_.frame.size.width, 0) animated:YES];
    
    //companyQuestionCtl_.delegate_ = self;
    _companyResumeCtl_.delegate_ = self;
    _companyRecommendedResumeCtl_.delegate_ = self;
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationItem.title = @"招聘管理";
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationItem.title = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)collectResumeSuccess
{
    myModal_.colResumeCnt_ ++ ;
    collectionCntLb_.text = [NSString stringWithFormat:@"%ld",(long)myModal_.colResumeCnt_];
    [comCollectResumeCtl_ refreshLoad:nil];
}

-(void)updateCount:(CompanyInfo_DataModal *)dataModal
{
    myModal_ = dataModal;
    if (myModal_.resumeCnt_ > 0) {
        resumeCntLb_.alpha = 1.0;
        [resumeCntLb_ setText:[NSString stringWithFormat:@"%ld",(long)myModal_.resumeCnt_]];
    }
    
    if (myModal_.resumeRecommendUnreadCnt > 0) {
        recommendCntLb_.alpha = 1.0;
        [recommendCntLb_ setText:[NSString stringWithFormat:@"%ld",(long)myModal_.resumeRecommendUnreadCnt]];
    }
    
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    companyId_ = dataModal;
    myModal_ = nil;
    _companyResumeCtl_.jobId_ = @"";
    [super beginLoad:dataModal exParam:exParam];
    [self changeModel:0];
    _companyRecommendedResumeCtl_.jobId_ = @"";
    [_companyResumeCtl_ beginLoad:dataModal exParam:exParam];
    [_companyRecommendedResumeCtl_ beginLoad:dataModal exParam:exParam];
    [_downloadResumeListCtl_ beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
//    [con companyHRDetail:companyId_];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_CompanyHRDetail:
        {
            myModal_ = [dataArr objectAtIndex:0];
            [Manager getUserInfo].companyModal_ = myModal_;
        }
            break;
        case Request_CancelBindCompany:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [BaseUIViewController showAutoDismissSucessView:@"解绑成功" msg:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [BaseUIViewController showAutoDismissFailView:@"解绑失败" msg:@"请稍后再试"];
            }
        }
            break;
        default:
            break;
    }
}


//change model
-(void) changeModel:(int)index
{
    [scrollView_ setContentOffset:CGPointMake(index*scrollView_.frame.size.width, 0) animated:NO];
    [self changeBtnStatus:index];
    modelIndex_ = index;
    switch (index) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        default:
            break;
    }
}

//change btn status
-(void) changeBtnStatus:(int)index
{
    switch ( index ) {
        case 0:
        {
            resumeBtn_.selected = YES;
            collectionBtn_.selected = NO;
            recommendBtn_.selected = NO;
            
        }
            break;
        case 1 :
        {
            resumeBtn_.selected = NO;
            collectionBtn_.selected = NO;
            recommendBtn_.selected = YES;
            
            
        }
            break;
        case 2:
        {
            resumeBtn_.selected = NO;
            collectionBtn_.selected = YES;
            recommendBtn_.selected = NO;
        }
            break;
     
        default:
            break;
    }
}


-(void)btnResponse:(id)sender
{
    if (sender == resumeBtn_) {
       
        [self changeModel:0];
    }
    else if (sender == collectionBtn_){
    
        [self changeModel:2];
    }
    else if (sender == recommendBtn_){

        [self changeModel:1];
    }
}

#pragma ChooseInterviewModelDelegate
-(void)chooseZw:(ZWDetail_DataModal *)dataModal
{
    [self changeModel:0];
    _companyResumeCtl_.jobId_ = dataModal.zwID_;
    resumeCntLb_.text = dataModal.resumeNewNum_;
    [_companyResumeCtl_ refreshLoad:nil];
}



#pragma CompanyResumeReadDelegate
-(void)resumeBeRead
{
    if ([Manager getUserInfo].companyModal_.resumeCnt_ > 0) {
        [Manager getUserInfo].companyModal_.resumeCnt_--;
    }
    NSInteger resumeNewCnt = [resumeCntLb_.text integerValue];
    if (resumeNewCnt > 0) {
        resumeNewCnt -- ;
        if (resumeNewCnt == 0) {
            resumeCntLb_.alpha = 0.0;
        }
        else
            resumeCntLb_.text = [NSString stringWithFormat:@"%ld",(long)resumeNewCnt];
    }
}

#pragma mark delegate
- (void)recommendResumeBeRead
{
    NSInteger recommendResumeNewCnt = [recommendCntLb_.text integerValue];
    if (recommendResumeNewCnt > 0) {
        recommendResumeNewCnt -- ;
        if (recommendResumeNewCnt == 0) {
            recommendCntLb_.alpha = 0.0;
        }
        else
            recommendCntLb_.text = [NSString stringWithFormat:@"%ld",(long)recommendResumeNewCnt];
    }
}


@end

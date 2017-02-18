//
//  CHRIndexCtl.m
//  jobClient
//
//  Created by 一览ios on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "CHROfferPartyDetailCtl.h"
//#import "CHRIndexCtl_Cell.h"
#import "ELCompanyOfferPResuemCtl.h"
#import "OfferPartyTalentsModel.h"
#import "ELResumeChangeCtl.h"

@interface CHROfferPartyDetailCtl ()
{
    RequestCon *bindinCon;
    BOOL isStart;
}
@end

@implementation CHROfferPartyDetailCtl

- (instancetype)init
{
    if (self = [super init]) {
        rightNavBarStr_ = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
    
    _redMark.hidden = YES;
    _fivesBgView.hidden = YES;
    if ([self.fromtype isEqualToString:@"offer"]) {
        _fivesBgView.hidden = NO;
    }
    
    if ([self.fromtype isEqualToString:@"offer"] || [self.fromtype isEqualToString:@"hunter"]) {
        [self setNavTitle:@"Offer派"];
        
        if (_isFromMessage) {
            _confirmRedMark.layer.cornerRadius = 3;
            _waitInterviewRedMark.layer.cornerRadius = 3;
            _interviewedRedMark.layer.cornerRadius = 3;
            switch ([self.msgType integerValue]) {
                case 10:
                {
                    _confirmRedMark.hidden = NO;
                }
                    break;
                case 20:
                case 50:
                {
                    _interviewedRedMark.hidden = NO;
                }
                    break;
                default:
                    break;
            }
        }
    }
    else if ([self.fromtype isEqualToString:@"kpb"]||[self.fromtype isEqualToString:@"vph"])
    {
        
        if ([self.fromtype isEqualToString:@"kpb"]) {
            [self setNavTitle:@"快聘宝"];
            
        }else if ([self.fromtype isEqualToString:@"vph"]){
            [self setNavTitle:@"V聘会"];
        }
        _firstTitleLb.text = @"全部";
    }
    
    self.titleLb.text = self.jobfair_name;
    if (_guWenRequestFlag == YES) {
        NSString *companyName_adress = [NSString stringWithFormat:@"%@\n%@",_companyInfomModel.cname_,_companyInfomModel.address_];
        _timeLb.text = companyName_adress;//_timeLb此处将时间改为公司名加地点(顾问端)
        _addressLb.text = self.place_name;
        [_addressLb setHidden: YES];
       
    }
    else{
        _timeLb.text = self.jobfair_time;
        _addressLb.text = self.place_name;
        
    }
    
    _scrollView.contentSize = CGSizeMake(ScreenWidth, self.view.bounds.size.height-NavBarHeight);
    
}

-(void)viewDidAppear:(BOOL)animated{
    _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
}

//设置右按扭的属性
- (void)setRightBarBtnAtt
{
    [rightBarBtn_ setFrame:CGRectMake(0, 0, 24, 24)];
    [rightBarBtn_ setBackgroundColor:[UIColor clearColor]];
    [rightBarBtn_ setImage:[UIImage imageNamed:@"ic_refresh_white.png"] forState:UIControlStateNormal];
}

- (void)rightBarBtnResponse:(id)sender
{
    [self refreshLoad:requestCon_];
    
    if (!isStart) {
        isStart = YES;
        [self rotateSpinningView];
    }
}

- (void)rotateSpinningView
{
    rightBarBtn_.enabled = NO;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [rightBarBtn_ setTransform:CGAffineTransformRotate(rightBarBtn_.transform, M_PI)];
        
    } completion:^(BOOL finished) {
        if (isStart) {
            [self rotateSpinningView];
            isStart = NO;
        }
        else {
            rightBarBtn_.enabled = YES;
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshLoad:requestCon_];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    
}

- (void)getDataFunction:(RequestCon *)con
{
    [super updateCom:con];
    [con getOfferPartyPersonCnt:self.jobfair_id companyId:_companyId withFromType:_fromtype];
    
    if (_isFromMessage) {
        if (!bindinCon) {
            bindinCon = [self getNewRequestCon:NO];
        }
        [bindinCon bingdingStatusWith:[Manager getUserInfo].userId_];
    }
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetOfferPartyPersonCnt://offer派人数统计
        {
            NSDictionary *dataDic = dataArr[0];
            if ([dataDic isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = dataDic[@"data"];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    dataDic = dic;
                }
                _offerPartyCntLb.text = [NSString stringWithFormat:@"%@人", [NSString changeNullOrNil:dataDic[@"all"]]];
                _confirmFitCntLb.text = [NSString stringWithFormat:@"%@人", [NSString changeNullOrNil:dataDic[@"company_state"]]];
                _presentCntLb.text = [NSString stringWithFormat:@"%@人", [NSString changeNullOrNil:dataDic[@"join_state"]]];
                _toInterviewCntLb.text = [NSString stringWithFormat:@"%@人", [NSString changeNullOrNil:dataDic[@"wait_interview"]]];
                _interviewedCntLb.text = [NSString stringWithFormat:@"%@人", [NSString changeNullOrNil:dataDic[@"mianshi_state"]]];
                
                if ([dataDic[@"is_new"]integerValue] == 1) {
                    _redMark.layer.cornerRadius = 3.5;
                    _redMark.layer.masksToBounds = YES;
                    [_redMark setHidden:NO];
                }
            }
            
            /*
            else{
                [_redMark setHidden:YES];
            }
             */
        }
            break;
        case requestBingdingStatusWith:
        {
            ConsultantHRDataModel *model = dataArr[0];
            [Manager setHrInfo:model];
        }
            break;
        default:
            break;
    }
}

- (void)updateCom:(RequestCon *)con
{
    
}

- (void)btnResponse:(id)sender
{
    ELCompanyOfferPResuemCtl *resumeListCtl = [[ELCompanyOfferPResuemCtl alloc] init];
    resumeListCtl.companyId = _companyId;
    
    if (!self.jobfair_id || [self.jobfair_id isEqualToString:@""]) {
        return;
    }
    resumeListCtl.jobfair_id = _jobfair_id;
    resumeListCtl.fromtype = _fromtype;
    resumeListCtl.counselorFlag = _consultantCompanyFlag;
    
    if (sender == _adviserRecoBtn)
    {//offer派简历
        
        if ([self.fromtype isEqualToString:@"offer"] || [self.fromtype isEqualToString:@"hunter"]) {
            [resumeListCtl setNavTitle:@"Offer派简历"];
            resumeListCtl.resumeListType = ComResumeListTypeAllPerson;
            
        }else if ([self.fromtype isEqualToString:@"kpb"]){
            [resumeListCtl setNavTitle:@"快聘宝简历"];
        }else if ([self.fromtype isEqualToString:@"vph"]){
            [resumeListCtl setNavTitle:@"V聘会简历"];
        }
        
    }
    else if (sender == _confirmFitBtn)
    {//通过初选
        
        resumeListCtl.resumeListType = ComResumeListTypePrimaryElection;
        [resumeListCtl setNavTitle:@"筛选简历"];
        if (_isFromMessage) {
            _confirmRedMark.hidden = YES;
        }
    }
    else if (sender == _presentBtn)
    {//等候面试
        
        resumeListCtl.resumeListType = ComResumeListTypeToInterview;
        [resumeListCtl setNavTitle:@"等待面试"];
        
    }
    else if (sender == _toInterviewBtn)
    {//已面试
        
        resumeListCtl.resumeListType = ComResumeListTypeHasInterviewed;
        [resumeListCtl setNavTitle:@"已面试"];
        
        if (_isFromMessage) {
            _interviewedRedMark.hidden = YES;
        }
    }
    else if (sender == _interviewedBtn)
    {//其他已到场人才
        resumeListCtl.resumeListType = ComResumeListTypeHasPresent;
        [resumeListCtl setNavTitle:@"其他已到场人才"];
    }
    
    _isFromMessage = NO;
    
    resumeListCtl.synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];;
    resumeListCtl.fromtype = self.fromtype;
    [self.navigationController pushViewController:resumeListCtl animated:YES];
    [resumeListCtl beginLoad:nil exParam:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end

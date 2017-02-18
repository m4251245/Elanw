//
//  ELAspDisServiceDetailCtl.m
//  jobClient
//
//  Created by YL1001 on 15/9/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELAspDisServiceDetailCtl.h"
#import "Expert_DataModal.h"
#import "ELAspDisServiceCtl.h"
#import "ELCreateCourseCtl.h"
#import "ELCourseAlertView.h"

@interface ELAspDisServiceDetailCtl () <ELCourseAlertDelegate>
{
    ELAspectantDiscuss_Modal *expertDataModal_;
    ELCourseAlertView *alertView;
    __weak IBOutlet NSLayoutConstraint *scrollBottom;
    
    __weak IBOutlet NSLayoutConstraint *scrollViewSizeHeight;
}
@end

@implementation ELAspDisServiceDetailCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
        rightNavBarStr_ = @"修改";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        self.scrollView_.hidden = YES;
    }
//    self.navigationItem.title = @"TA的约谈";
}

-(void)rightBarBtnResponse:(id)sender{
    ELAspectantDiscuss_Modal *dataModal = expertDataModal_;
    ELCreateCourseCtl *createcourseCtl = [[ELCreateCourseCtl alloc] init];
    createcourseCtl.backIndex = _backIndex;
    switch ([dataModal.course_status integerValue]) {
        case 1:
        {
            if ([dataModal.hasOrder integerValue] > 0) {
                [BaseUIViewController showAlertView:@"" msg:@"请完成进行中的约谈订单后再做修改" btnTitle:@"确定"];
            }
            else
            {
                [self.navigationController pushViewController:createcourseCtl animated:YES];
                [createcourseCtl beginLoad:dataModal exParam:nil];
            }
        }
            break;
        case 5:
        {
            if (!alertView) {
                alertView = [[ELCourseAlertView alloc] initWithTitle:dataModal.verifyReason];
            }
            alertView.contentLb.text = dataModal.verifyReason;
            alertView.alertDelegate = self;
            [alertView showView];
        }
            break;
        default:
        {//审核中  草稿修改
            [self.navigationController pushViewController:createcourseCtl animated:YES];
            [createcourseCtl beginLoad:dataModal exParam:nil];
        }
            break;
    }
}

//跳转到修改详情
-(void)delegateRightBtnClick{
    ELAspectantDiscuss_Modal *dataModal = expertDataModal_;
    ELCreateCourseCtl *createcourseCtl = [[ELCreateCourseCtl alloc] init];
    createcourseCtl.backIndex = _backIndex;
    [self.navigationController pushViewController:createcourseCtl animated:YES];
    [createcourseCtl beginLoad:dataModal exParam:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"TA的约谈";
//    [self setNavTitle:@"TA的约谈"];
    expertImg.layer.cornerRadius = 20;
    expertImg.layer.masksToBounds = YES;
    
    coursePriceLb.layer.cornerRadius = 4.0;
    coursePriceLb.layer.masksToBounds = YES;
    coursePriceLb.layer.borderWidth = 1.0f;
    coursePriceLb.layer.borderColor = UIColorFromRGB(0xE4403A).CGColor;
    
    courseLongLb.layer.cornerRadius = 4.0;
    courseLongLb.layer.masksToBounds = YES;
    courseLongLb.layer.borderWidth = 1.0f;
    courseLongLb.layer.borderColor = UIColorFromRGB(0xE4403A).CGColor;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editorSuccessRefresh:) name:@"COURSEEDITORSUCCESS" object:nil];
    
    [BaseUIViewController showLoadView:YES content:@"正在加载" view:self.view];
    self.scrollView_.hidden = YES;
    [self getCourseData];
    
    if ([expertDataModal_.dis_personId isEqualToString:[Manager getUserInfo].userId_]) {
        [self setNavTitle:@"我的约谈"];
    }else{
        [self setNavTitle:@"TA的约谈"];
    }
}

-(void)editorSuccessRefresh:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSString *type = dic[@"type"];
        if (type && [type isEqualToString:@"delete"]){
            return;
        }
    }
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self getCourseData];
    });
}

-(void)refreshLoadData{
    coursePriceLb.text = [NSString stringWithFormat:@"%@元/次",expertDataModal_.course_price];
    courseLongLb.text = [NSString stringWithFormat:@"%@小时",expertDataModal_.course_long];
    
    if ([[Manager getUserInfo].userId_ isEqualToString:expertDataModal_.dis_personId]) {
        btnBgView.hidden = YES;
        CGRect frame = self.scrollView_.frame;
        frame.size.height = [[UIScreen mainScreen] bounds].size.height;
        self.scrollView_.frame = frame;
    }
    
    if (_isShowBtn) {
        btnBgView.hidden = YES;
        scrollBottom.constant = 0;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已有%@人约谈",expertDataModal_.personCount]];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xE4403A) range:NSMakeRange(2,expertDataModal_.personCount.length)];
    countLb.attributedText = str;
    
    viewCount.text = expertDataModal_.course_visit_cnt;
    serviceTitle.text = expertDataModal_.course_title;
    NSString *courseStr = expertDataModal_.course_info;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    paragraphStyle.firstLineHeadIndent = 30.0f;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:THIRTEENFONT_CONTENT,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    serviceConTV.textColor = UIColorFromRGB(0x666666);
    serviceConTV.attributedText = [[NSAttributedString alloc] initWithString:courseStr attributes:attributes];
    
    //[serviceConTV sizeToFit];
    [self.view layoutIfNeeded];
    
    scrollViewSizeHeight.constant = CGRectGetMaxY(serviceConTV.frame)+15;
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    expertDataModal_ = dataModal;
}

-(void)setRightBarBtnAtt{
    [super setRightBarBtnAtt];
    if ([expertDataModal_.dis_personId isEqualToString:[Manager getUserInfo].userId_]) {
        rightBarBtn_.hidden = NO;
    }
    else
    {
        rightBarBtn_.hidden = YES;
    }
}

- (void)btnResponse:(id)sender
{
    if (sender == discussBtn) {
        //1对1约谈
        if ([Manager shareMgr].haveLogin)
        {
            ELAspDisServiceCtl* aspDisCtl = [[ELAspDisServiceCtl alloc]init];
            aspDisCtl.isShowCourse = NO;
            [self.navigationController pushViewController:aspDisCtl animated:YES];
            [aspDisCtl beginLoad:expertDataModal_ exParam:nil];
        }
        else
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_Chat;
            return;
        }
    }
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_Chat:
        {
            NSString *userId = [Manager getUserInfo].userId_;
            if (userId)
            {
                ELAspDisServiceCtl* aspDisCtl = [[ELAspDisServiceCtl alloc]init];
                aspDisCtl.isShowCourse = NO;
                [self.navigationController pushViewController:aspDisCtl animated:NO];
                [aspDisCtl beginLoad:expertDataModal_ exParam:nil];
            }
        }
            break;
        default:
            break;
    }
}
- (void)getCourseData
{
    NSString * function = @"getCourseInfo";
    NSString * op = @"yuetan_record_busi";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"course_id=%@",expertDataModal_.course_id];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
       
        self.scrollView_.hidden = NO;
        NSDictionary *dic = result;
        
        expertDataModal_.course_id = dic[@"course_id"];
        expertDataModal_.dis_personId = dic[@"person_id"];
        expertDataModal_.course_title = dic[@"course_title"];
        expertDataModal_.course_price = dic[@"course_price"];
        expertDataModal_.course_long = dic[@"course_long"];
        expertDataModal_.personCount = dic[@"course_yuetan_cnt"];
        expertDataModal_.course_info = dic[@"course_intro"];
        expertDataModal_.course_status = dic[@"course_status"];
        expertDataModal_.course_visit_cnt = dic[@"course_visit_cnt"];
        
        [self refreshLoadData];
        
        [expertImg sd_setImageWithURL:[NSURL URLWithString:dic[@"_person_detail"][@"person_pic"]] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
        expertName.text = dic[@"_person_detail"][@"person_iname"];
        expertJob.text = dic[@"_person_detail"][@"person_zw"];
        
        [BaseUIViewController showLoadView:NO content:nil view:nil];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

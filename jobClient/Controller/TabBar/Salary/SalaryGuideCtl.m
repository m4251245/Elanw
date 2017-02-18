//
//  SalaryGuideCtl.m
//  jobClient
//
//  Created by YL1001 on 14-9-24.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "SalaryGuideCtl.h"
#import "JobExperienceView.h"
#import "SalaryGuide_HeaderView.h"
#import "JobSearch_DataModal.h"
#import "GXSArticleLIst_Cell.h"
#import "AD_Cell.h"
#import "Article_DataModal.h"
#import "CondictionListCtl.h"
#import "RecommendZW_Cell.h"
#import "SalaryIrrigationCtl.h"
#import "BuySalaryServiceCtl.h"
#import "NoLoginPromptCtl.h"
#import "ELSalaryResultDetailModel.h"
#import "ELJobSearchModel.h"
#import "ELUserJobModel.h"
#import "ELUserModel.h"
#import "ZWDetail_DataModal.h"
#import "SalaryListCtl.h"

@interface SalaryGuideCtl () <NoLoginDelegate>
{
    BOOL  beAddComent_;
    ELSalaryModel   * bChooseArticle_;
    Comment_DataModal   * bChooseComment_;
    NSInteger   articleIndex_;
    NSInteger   commentIndex_;
    NSString    * comment_parentId_;
    NSString    * percentContent_;
    RequestCon *_querySalaryCountCon;
    __weak IBOutlet UIView *titleView;
    __weak IBOutlet UILabel *titleLb;
    
    ELSalaryResultDetailModel *detailModel;
}

@end

@implementation SalaryGuideCtl
@synthesize kwFlag_,regionId_,commentTF_,commentView_,giveCommentBtn_,bgColor_,noFromMessage_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        bHeaderEgo_ = NO;
        rightNavBarStr_ = @"分享";
        
        //增加键盘事件的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"详情"];
    
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
    
    gxsSectionHeaderView_ = [[[NSBundle mainBundle] loadNibNamed:@"GXS_SectionHeaderView" owner:self options:nil] lastObject];
    [gxsSectionHeaderView_.publishBtn_ addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    gxsSectionHeaderView_.textView_.layer.cornerRadius = 4.0;
    gxsSectionHeaderView_.textView_.layer.borderWidth = 0.5;
    gxsSectionHeaderView_.textView_.layer.borderColor = [UIColor lightGrayColor].CGColor;
    gxsSectionHeaderView_.textView_.placeholder = @"看完了,想说点啥?";
    gxsSectionHeaderView_.publishBtn_.layer.cornerRadius = 4.0;
    gxsSectionHeaderView_.textView_.delegate = self;
    
    tableView_.alpha = 0.0;
    [activityView_ startAnimating];
    CGRect rect = commentView_.frame;
    rect.origin.y = self.view.frame.size.height;
    [commentView_ setFrame:rect];
    
    nameLb_.center = CGPointMake(ScreenWidth/2,nameLb_.center.y);
    
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    tableView_.tableHeaderView = headView_;
    tableView_.tableFooterView = footerView_;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [myModalCon_ stopConnWhenBack];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//     self.navigationItem.title = @"详情";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationItem.title = @"";
}

- (void)viewDidLayoutSubviews
{
    [self.view layoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//设置右按扭的属性
-(void) setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"" forState:UIControlStateNormal];
    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarBtn_ setFrame:CGRectMake(0, 0, 40, 40)];
    rightBarBtn_.titleLabel.font = [UIFont boldSystemFontOfSize:13];//[UIFont boldSystemFontOfSize:14];
    [rightBarBtn_ setImage:[UIImage imageNamed:@"share_white-2"] forState:UIControlStateNormal];
}


-(void)updateCom:(RequestCon *)con
{
    
    if (!bgColor_ || [bgColor_ isEqual:[UIColor whiteColor]]) {
        [bgView_ setBackgroundColor:UIColorFromRGB(0x494949)];
    }
    else
    {
        [bgView_ setBackgroundColor:bgColor_];
    }
    self.view.backgroundColor = bgView_.backgroundColor;
   
    if (detailModel) {
        NSString * ta = @"TA";
        if (![detailModel.userInfo.sex isEqualToString:@"2"]) {
            ta = @"他";
        }
        else
        {
            ta = @"她";
        }
        
        sexImgView_.layer.cornerRadius = 20.0;
        sexImgView_.layer.masksToBounds = YES;
        NSString * regionStr = detailModel.userInfo.region_name;
        if (noFromMessage_) {
            regionStr = [CondictionListCtl getRegionStr:regionId_];
            [sexImgView_ setImage:[UIImage imageNamed:detailModel.userInfo.person_pic]];
        }
        if (detailModel.userInfo.person_pic && ![detailModel.userInfo.person_pic isEqualToString:@""]) {
            [sexImgView_ sd_setImageWithURL:[NSURL URLWithString:detailModel.userInfo.person_pic]];
        }
        if (!regionStr || [regionStr isEqualToString:@""]||[regionStr  isEqualToString:@"暂无"]) {
            regionStr = @"全国";
        }
        attributedLb_.backgroundColor = [UIColor clearColor];
        attributedLb_.layer.borderColor = [UIColor whiteColor].CGColor;
        attributedLb_.layer.borderWidth = 0.5;
        attributedLb_.layer.cornerRadius = 4.0;
        NSString * str = [NSString stringWithFormat:@"%@击败了%@",ta,regionStr];
        attributedLb_.text = str;
        [attributedLb_ setFont:[UIFont systemFontOfSize:22] fromIndex:1 length:2];
        [attributedLb_ setColor:[UIColor whiteColor] fromIndex:0 length:[str length]];
        [attributedLb_ setFont:[UIFont systemFontOfSize:14] fromIndex:0 length:1];
        [attributedLb_ setFont:[UIFont systemFontOfSize:14] fromIndex:3 length:[str length]-3];
        
        NSString * astr = [NSString stringWithFormat:@"%@了%@",ta,regionStr];
        NSString * bstr = @"击败";
        CGSize aSize = [astr sizeNewWithFont:[UIFont systemFontOfSize:14.0]];
        CGSize bSize = [bstr sizeNewWithFont:[UIFont systemFontOfSize:22.0]];
        
        CGRect rect = attributedLb_.frame;
        rect.size.width = aSize.width + bSize.width;
        rect.origin.x = (self.view.frame.size.width - rect.size.width)/2.0;
        attributedLb_.frame = rect;
        
        @try {
            salaryLb_.text = detailModel.userInfo.yuex;
            
            CGSize salarySize = [detailModel.userInfo.yuex sizeNewWithFont:salaryLb_.font];
            
            UILabel *lableLeft = (UILabel *)[bgView_ viewWithTag:151];
            UILabel *lableRight = (UILabel *)[bgView_ viewWithTag:152];
            
            CGRect salaryFrame = lableLeft.frame;
            salaryFrame.origin.x = (ScreenWidth-105-salarySize.width-2)/2.0;
            lableLeft.frame = salaryFrame;
            
            salaryFrame = salaryLb_.frame;
            salaryFrame.size.width = salarySize.width+2;
            salaryFrame.origin.x = CGRectGetMaxX(lableLeft.frame);
            salaryLb_.frame = salaryFrame;
            
            salaryFrame = lableRight.frame;
            salaryFrame.origin.x = CGRectGetMaxX(salaryLb_.frame);
            lableRight.frame = salaryFrame;
            
        }
        @catch (NSException *exception) {
            //salaryLb_.text = [NSString stringWithFormat:@"%@",inModal_.salary_];
        }
        @finally {
            
        }
        
        NSString * nameStr = @"";
        @try {
            
            nameStr = detailModel.userInfo.iname;
            nameStr = [NSString stringWithFormat:@"%@**",[nameStr substringToIndex:1]];
        }
        @catch (NSException *exception) {
            nameStr = @"***";
        }
        @finally {
           
            nameLb_.text = nameStr;
            titleLb.text = nameStr;
        }
        
        if ([detailModel.percent isEqualToString:@""]) {
            detailModel.percent = @"0.01";
        }
        NSString *pstr = @"%";
        percentLb_.text = [NSString stringWithFormat:@"%@%@",detailModel.percent,pstr];
        
        percentContent_ = [self salaryContent:detailModel.percent];
        educationLb_.text = detailModel.userInfo.edu;
        schoolLb_.text = detailModel.userInfo.school;
        zwLb_.text = detailModel.userInfo.job;
        ageLb_.text = detailModel.userInfo.age;
        jobageLb_.text = detailModel.userInfo.gznum;
        regionLb_.text = detailModel.userInfo.region_name;
        
        jobLb_.alpha = 0.0;
        lineView_.alpha = 0.0;
        int index = 0;
        float height = 210;
       
        if (detailModel.jobArr)
        {
            if ([detailModel.jobArr count] > 1) {
                lineView_.alpha = 1.0;
                CGRect lineRect = lineView_.frame;
                lineRect.size.height = 45 * ([detailModel.jobArr count]-1) + 18;
                lineView_.frame = lineRect;
            }
            
            jobLb_.alpha = 1.0;
            
            
            for (NSInteger i = [detailModel.jobArr count];i > 0 ; --i) {
                ELUserJobModel * jobModal = [detailModel.jobArr objectAtIndex:[detailModel.jobArr count]-1-(i-1)];
                JobExperienceView * jobView = [[[NSBundle mainBundle] loadNibNamed:@"JobExperienceView" owner:self options:nil] lastObject];
                jobView.frame = CGRectMake(8, 50 * index + 240, ScreenWidth-32, 45);
                if (i == [detailModel.jobArr count]) {
                    [jobView.timeLb_ setTextColor:Color_Red];
                    [jobView.numberLb_ setTextColor:Color_Red];
                    [jobView.zwLb_ setTextColor:Color_Red];
                }

                [resumeView_ addSubview:jobView];
                
                
                if (i == [detailModel.jobArr count]) {
                    UIImageView * yuanImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, jobView.frame.origin.y + 6, 12, 12)];
                    [yuanImg setImage:[UIImage imageNamed:@"icon_ios_quan1"]];
                    [resumeView_ addSubview:yuanImg];
                }
                else
                {
                    UIImageView * yuanImg = [[UIImageView alloc] initWithFrame:CGRectMake(26.5, jobView.frame.origin.y + 9, 8, 8)];
                    [yuanImg setImage:[UIImage imageNamed:@"icon_ios_lvli_def"]];
                    [resumeView_ addSubview:yuanImg];
                }
                
                NSDate * startDate = [jobModal.startdate dateFormStringFormat:@"yyyy-MM-dd" timeZone:[NSTimeZone localTimeZone]];
                NSDate * endDate = [jobModal.stopdate dateFormStringFormat:@"yyyy-MM-dd" timeZone:[NSTimeZone localTimeZone]];
                if (!endDate || endDate == nil ) {
                    endDate = [NSDate date];
                }
                
                NSTimeInterval timeInterval = [startDate timeIntervalSinceDate:endDate];
                timeInterval = -timeInterval;
                
                NSString * time = [NSString stringWithFormat:@"%0.1f年",timeInterval/(60*60*24*30*12)];
                jobView.numberLb_.text = time;
                
               
                if (!jobModal.stopdate || [jobModal.stopdate isEqualToString:@""]||[jobModal.stopdate isEqualToString:@"0000-00-00"]) {
                    jobModal.stopdate = @"至今";
                }
                if (!jobModal.startdate || [jobModal.startdate isEqualToString:@""]||[jobModal.startdate isEqualToString:@"0000-00-00"]) {
                    jobModal.startdate = [MyCommon getDateStr:[NSDate date] format:@"yyyy-MM-dd"];
                }
                NSString * startdate = jobModal.startdate;
                NSString * enddate = jobModal.stopdate;
                @try {
                    startdate = [startdate substringToIndex:7];
                }
                @catch (NSException *exception) {
                    
                }
                
                @try {
                    enddate = [enddate substringToIndex:7];
                    if ([[enddate substringToIndex:4] integerValue] > 2100) {
                        enddate = @"至今";
                    }
                }
                @catch (NSException *exception) {
                    
                }
                startdate  = [startdate stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
                enddate = [enddate stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
                jobView.timeLb_.text = [NSString stringWithFormat:@"%@ -- %@",startdate,enddate];
                jobView.zwLb_.text = [NSString stringWithFormat:@"担任 %@",jobModal.jtzw];
                
                
                ++index;
                
            }
            height = 240 + 50 * [detailModel.jobArr count];
        }
        
        rect = resumeView_.frame;
        rect.size.height = height ;
        [resumeView_ setFrame:rect];
        
        rect = gxsSectionHeaderView_.frame;
        rect.origin.y = resumeView_.frame.origin.y + resumeView_.frame.size.height;
        rect.size.width = ScreenWidth;
        gxsSectionHeaderView_.frame = rect;
        [headView_ addSubview:gxsSectionHeaderView_];
        
        rect = headView_.frame;
        rect.size.height = gxsSectionHeaderView_.frame.origin.y + gxsSectionHeaderView_.frame.size.height;
        [headView_ setFrame:rect];
        
        tableView_.tableHeaderView = headView_;
        
        tableView_.contentInset = UIEdgeInsetsZero;
        [tableView_ reloadData];
        
        
    }
    
}


-(NSString*)salaryContent:(NSString*)percent_
{
    NSMutableString * content_ = [NSMutableString stringWithFormat:@""];
    
    if (0<=[percent_ integerValue]&&[percent_ integerValue]<10) {
        [content_ appendFormat:@"%@",UnderTen2];
        NSRange rang;
        rang.location = 0;
        rang.length = [content_ length];
        [content_ replaceOccurrencesOfString:@"00" withString:percentLb_.text options:NSCaseInsensitiveSearch range:rang];
        
    }
    else if (10<=[percent_ integerValue]&&[percent_ integerValue]<20) {
        [content_ appendFormat:@"%@",Ten2];
        NSRange rang;
        rang.location = 0;
        rang.length = [content_ length];
        [content_ replaceOccurrencesOfString:@"00" withString:percentLb_.text options:NSCaseInsensitiveSearch range:rang];
    }
    else if (20<=[percent_ integerValue]&&[percent_ integerValue]<30) {
        [content_ appendFormat:@"%@",Twenty2];
        NSRange rang;
        rang.location = 0;
        rang.length = [content_ length];
        [content_ replaceOccurrencesOfString:@"00" withString:percentLb_.text options:NSCaseInsensitiveSearch range:rang];
    }
    else if (30<=[percent_ integerValue]&&[percent_ integerValue]<40) {
        [content_ appendFormat:@"%@",Thirty2];
        NSRange rang;
        rang.location = 0;
        rang.length = [content_ length];
        [content_ replaceOccurrencesOfString:@"00" withString:percentLb_.text options:NSCaseInsensitiveSearch range:rang];
    }
    else if (40<=[percent_ integerValue]&&[percent_ integerValue]<50) {
        [content_ appendFormat:@"%@",Fourty2];
        NSRange rang;
        rang.location = 0;
        rang.length = [content_ length];
        [content_ replaceOccurrencesOfString:@"00" withString:percentLb_.text options:NSCaseInsensitiveSearch range:rang];
    }
    else if (50<=[percent_ integerValue]&&[percent_ integerValue]<60) {
        [content_ appendFormat:@"%@",Fifty2];
        NSRange rang;
        rang.location = 0;
        rang.length = [content_ length];
        [content_ replaceOccurrencesOfString:@"00" withString:percentLb_.text options:NSCaseInsensitiveSearch range:rang];
    }
    else if (60<=[percent_ integerValue]&&[percent_ integerValue]<70) {
        [content_ appendFormat:@"%@",Sixty2];
        NSRange rang;
        rang.location = 0;
        rang.length = [content_ length];
        [content_ replaceOccurrencesOfString:@"00" withString:percentLb_.text options:NSCaseInsensitiveSearch range:rang];
    }
    else if (70<=[percent_ integerValue]&&[percent_ integerValue]<80) {
        [content_ appendFormat:@"%@",Seventy2];
        NSRange rang;
        rang.location = 0;
        rang.length = [content_ length];
        [content_ replaceOccurrencesOfString:@"00" withString:percentLb_.text options:NSCaseInsensitiveSearch range:rang];
    }
    else if (80<=[percent_ integerValue]&&[percent_ integerValue]<90) {
        [content_ appendFormat:@"%@",Eighty2];
        NSRange rang;
        rang.location = 0;
        rang.length = [content_ length];
        [content_ replaceOccurrencesOfString:@"00" withString:percentLb_.text options:NSCaseInsensitiveSearch range:rang];
    }
    else if (90<=[percent_ integerValue]&&[percent_ integerValue]<=100) {
        [content_ appendFormat:@"%@",Ninety2];
        NSRange rang;
        rang.location = 0;
        rang.length = [content_ length];
        [content_ replaceOccurrencesOfString:@"00" withString:percentLb_.text options:NSCaseInsensitiveSearch range:rang];
    }
    
    return content_;

}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    NSString *personId = @"";
    NSString *zym = @"";
    NSString *yuex = @"";
    NSString *regionId = @"";
    if ([dataModal isKindOfClass:[ELSalaryResultModel class]]) {
        ELSalaryResultModel *model = dataModal;
        if (model.userInfo) {
            personId = model.person_id;
            zym = model.userInfo.job;
            yuex = model.userInfo.yuex;
            regionId = model.userInfo.region_name;
        }else if (model.zw_regionid){
            personId = model.person_id;
            zym = model.zw_typename;
            yuex = model.person_yuex;
            regionId = model.zw_regionid;
        }else{
            personId = model._id;
            zym = model.zym;
            yuex = model.salary;
            regionId = model.regionid;
        }
    }
    else if ([dataModal isKindOfClass:[User_DataModal class]]){
        User_DataModal *userModal = dataModal;
        personId = userModal.userId_;
        zym = userModal.zym_;
        yuex = userModal.salary_;
        regionId = userModal.regionId_;
    }
    
    if (!myModalCon_) {
        myModalCon_ = [self getNewRequestCon:NO];
    }
    NSString * bg = @"0";
    if ([bgColor_ isEqual:Color_Red]) {
        bg = @"3";
    }
    else if ([bgColor_ isEqual:Color_Blue]){
        bg = @"2";
    }
    [myModalCon_ getSalaryCompareResult:personId zw:zym  kwflag:kwFlag_ salary:yuex  regionId:regionId bg:bg];
}

-(void)getDataFunction:(RequestCon *)con
{
    //[con getSalaryCompareResult:inModal_.userId_ zw:inModal_.zym_  kwflag:kwFlag_ salary:inModal_.salary_  regionId:regionId_ bg:<#(NSString *)#>];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_SalaryCompareResult:
        {
            [activityView_ stopAnimating];
            activityView_.alpha = 0.0;
            tableView_.alpha = 1.0;
            detailModel = [dataArr objectAtIndex:0];
        }
            break;
        case Request_ShareSalaryArticle:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [BaseUIViewController showAutoDismissSucessView:@"发表成功" msg:nil];
                [gxsSectionHeaderView_.textView_ resignFirstResponder];
                gxsSectionHeaderView_.textView_.text = @"";
            }
        }
            break;
        case Request_GetQuerySalaryCount://查询薪指的次数
        {
                //友盟统计点击数
                NSDictionary * dict = @{@"Function":@"看看我能打败多少人"};
                [MobClick event:@"vsPay" attributes:dict];
                
                SalaryCompeteCtl * salaryCompeteCtl_ = [[SalaryCompeteCtl alloc] init];
            salaryCompeteCtl_.isEnablePop = YES;
                salaryCompeteCtl_.type_ = 2;
                salaryCompeteCtl_.kwFlag_ = kwFlag_;
                [salaryCompeteCtl_ beginLoad:detailModel.userInfo.job exParam:nil];
                [self.navigationController pushViewController:salaryCompeteCtl_ animated:YES];
                [salaryCompeteCtl_ beginLoad:[Manager getUserInfo].trade_ exParam:nil];
        }
            break;
        default:
            break;
    }
}


#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     if (section == 0){
        if (detailModel.recommendJobArr ) {
            return 40;
        }
        else
            return 0;
    }
    else
    {
        if (detailModel.ya_url &&![detailModel.ya_path isKindOfClass:[NSNumber class]]&& ![detailModel.ya_path isEqualToString:@""]) {
            return 40;
        }
        else
            return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case 0:
        {
            if (detailModel.recommendJobArr && [detailModel.recommendJobArr count] > 0) {
                count = [detailModel.recommendJobArr count];
            }
        }
            break;
        case 1:
        {
            if (detailModel.ya_path && ![detailModel.ya_path isKindOfClass:[NSNumber class]] &&![detailModel.ya_path isEqualToString:@""]) {
                count = 1;
            }
        }
            
        default:
            break;
    }
    
    return count;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SalaryGuide_HeaderView * headerView = [[[NSBundle mainBundle] loadNibNamed:@"SalaryGuide_HeaderView" owner:self options:nil] lastObject];
    if (section == 0){
        headerView.titleLb_.text = @"高薪职位";
        headerView.moreBtn_.alpha = 0.0;
        headerView.colorView_.backgroundColor = [UIColor colorWithRed:97.0/255.0 green:53.0/255.0 blue:192.0/255.0 alpha:1.0];
    }
    else{
        headerView.titleLb_.text = @"精品课程";
        headerView.moreBtn_.alpha = 0.0;
        headerView.colorView_.backgroundColor = [UIColor colorWithRed:71.0/255.0    green:149.0/255.0 blue:70.0/255.0 alpha:1.0];
    }
        
    return headerView;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"RecommendZW_Cell";
        
        RecommendZW_Cell *cell = (RecommendZW_Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RecommendZW_Cell" owner:self options:nil] lastObject];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        cell.contentView_.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.contentView_.layer.borderWidth = 0.5;
        ELJobSearchModel *dataModal = [detailModel.recommendJobArr objectAtIndex:indexPath.row];
        [cell cellInitWithImage:dataModal.logo positionName:dataModal.jtzw time:dataModal.updatetime companyName:dataModal.cname salary:dataModal.xzdy welfare:dataModal.fldy region:dataModal.regionname];
        
        return cell;

    }
    else if (indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"ADCell";
        
        AD_Cell *cell = (AD_Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AD_Cell" owner:self options:nil] lastObject];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        cell.contentView_.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.contentView_.layer.borderWidth = 0.5;
        [cell.adImg_ sd_setImageWithURL:[NSURL URLWithString:detailModel.ya_path] placeholderImage:nil];
        return cell;
    }

    else  {
        static NSString *CellIdentifier = @"GXSArticleListCell";
        
        GXSArticleLIst_Cell *cell = (GXSArticleLIst_Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GXSArticleLIst_Cell" owner:self options:nil] lastObject];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        cell.contentView_.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.contentView_.layer.borderWidth = 0.5;
        
        cell.addCommentBtn_.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.addCommentBtn_.layer.borderWidth = 0.5;
        cell.addCommentBtn_.layer.cornerRadius = 2.0;
        ELSalaryModel * dataModal = [detailModel.gxsArticleArr objectAtIndex:indexPath.row];
        [cell.userImg_ sd_setImageWithURL:[NSURL URLWithString:dataModal.person_pic] placeholderImage:[UIImage imageNamed:@"bg_xinwen"]];
        [cell.titleLb_ setText:dataModal.title_];
        [cell.contentLb_ setText:dataModal.summary];
        [cell.likeBtn_ setTitle:[NSString stringWithFormat:@"%ld",(long)dataModal.like_cnt] forState:UIControlStateNormal];
        [cell.commentBtn_ setTitle:[NSString stringWithFormat:@"%ld",(long)dataModal.c_cnt] forState:UIControlStateNormal];
        
        if (dataModal.isLike_) {
            cell.likeBtn_.selected = YES;
        }
        [cell.likeBtn_ addTarget:self action:@selector(addArticleLike:) forControlEvents:UIControlEventTouchUpInside];
        cell.likeBtn_.tag = 4000 + indexPath.row;
        
        [cell.shareBtn_ addTarget:self action:@selector(shareArticle:) forControlEvents:UIControlEventTouchUpInside];
        cell.shareBtn_.tag = 5000 + indexPath.row;
        
        [cell.commentBtn_ addTarget:self action:@selector(commentCntBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.commentBtn_.tag = 7000 + indexPath.row;
        
        [cell.addCommentBtn_ addTarget:self action:@selector(addCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.addCommentBtn_.tag = 8000 + indexPath.row;
        
        return cell;
    }
}


-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    if (indexPath.section == 2) {
        ELSalaryModel * article = [detailModel.gxsArticleArr objectAtIndex:indexPath.row];
        article.bgColor_ = [UIColor whiteColor];
        SalaryIrrigationDetailCtl * articleDetailCtl = [[SalaryIrrigationDetailCtl alloc] init];
        [self.navigationController pushViewController:articleDetailCtl animated:YES];
        [articleDetailCtl beginLoad:article exParam:nil];
    }
    else if (indexPath.section == 0){
        ELJobSearchModel * dataModal = [detailModel.recommendJobArr objectAtIndex:indexPath.row];
        ZWDetail_DataModal *zwDetailModel = [[ZWDetail_DataModal alloc] init];
        zwDetailModel.zwID_ = dataModal.zwId;
        zwDetailModel.zwName_ = dataModal.jtzw;
        zwDetailModel.companyName_ = dataModal.cname;
        //跳转到职位详情
        PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
        [self.navigationController pushViewController:detailCtl animated:YES];
        [detailCtl beginLoad:zwDetailModel exParam:nil];
    }
    else
    {
        PushUrlCtl * webViewCtl = [[PushUrlCtl alloc] init];
        [self.navigationController pushViewController:webViewCtl animated:YES];
        [webViewCtl beginLoad:detailModel.ya_url exParam:@"精品课程"];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    if (scrollView.contentOffset.y > 100) {
        titleView.backgroundColor = UIColorFromRGB(0x494949);
        titleLb.hidden = NO;
    }
    else
    {
        titleView.backgroundColor = [UIColor clearColor];
        titleLb.hidden = YES;
    }
}

-(IBAction)addArticleLike:(id)sender
{
    UIButton * btn = sender;
    if (btn.selected) {
        return;
    }
    NSInteger index = btn.tag - 4000;
    
    CGRect rect = [tableView_ rectForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    rect.origin.x = btn.frame.origin.x + 20;
    rect.origin.y = rect.origin.y + btn.frame.origin.y;
    rect.size.width = btn.frame.size.width;
    rect.size.height = btn.frame.size.height;
    UILabel *tagLb = [[UILabel alloc]initWithFrame:rect];
    [tagLb setBackgroundColor:[UIColor clearColor]];
    [tagLb setTextColor:[UIColor redColor]];
    [tagLb setText:@"+1"];
    [tableView_ addSubview:tagLb];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect tagRect = tagLb.frame;
        tagRect.origin.y -=  20;
        [tagLb setFrame:tagRect];
    } completion:^(BOOL finished) {
        [tagLb removeFromSuperview];
    }];
    
    ELSalaryModel * article = [detailModel.gxsArticleArr objectAtIndex:index];
    article.like_cnt++;
    article.isLike_ = YES;
    [tableView_ reloadData];
    if (!addlikeCon_) {
        addlikeCon_ = [self getNewRequestCon:NO];
    }
    [addlikeCon_ addArticleLike:article.article_id];
}

-(IBAction)shareArticle:(id)sender
{
    UIButton * btn = sender;
    NSInteger index = btn.tag - 5000;
    if (detailModel.gxsArticleArr.count <= 0) {
        return;
    }
    ELSalaryModel * article = [detailModel.gxsArticleArr objectAtIndex:index];
    NSString *imagePath = article.thumb;
    
    NSString * sharecontent = article.summary;
    
    NSString * titlecontent = [NSString stringWithFormat:@"%@",article.title_];
    
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/gxs_article/%@.htm",article.article_id];

    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
    //调用分享
    [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url];

}

-(IBAction)commentCntBtnClick:(id)sender
{
    UIButton * btn = sender;
    NSInteger index = btn.tag - 7000;
    ELSalaryModel * article = [detailModel.gxsArticleArr objectAtIndex:index];
    article.bgColor_ = [UIColor whiteColor];
    SalaryIrrigationDetailCtl * articleDetailCtl = [[SalaryIrrigationDetailCtl alloc] init];
    [self.navigationController pushViewController:articleDetailCtl animated:YES];
    [articleDetailCtl beginLoad:article exParam:nil];
    
}

-(IBAction)addCommentBtnClick:(id)sender
{
    UIButton * btn = sender;
    NSInteger index = btn.tag - 8000;
    bChooseArticle_ = [detailModel.gxsArticleArr objectAtIndex:index];
    articleIndex_ = index;
    comment_parentId_ = nil;
    bChooseComment_ = nil;
    [commentTF_ becomeFirstResponder];
    [commentTF_ setPlaceholder:@"说两句"];
}




-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == commentTF_) {
        beAddComent_ = YES;
    }
    else{
        beAddComent_ = NO;
    }
    return YES;
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [commentTF_ resignFirstResponder];
    beAddComent_ = NO;
    return YES;
}

#pragma Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    if( !singleTapRecognizer_ )
        singleTapRecognizer_ = [MyCommon addTapGesture:self.view target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    //singleTapRecognizer_.delegate = self;
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    if (beAddComent_) {
        CGRect newTextViewFrame = commentView_.frame;
        newTextViewFrame.origin.y = tableView_.frame.size.height - keyboardRect.size.height;
        
        NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        commentView_.frame = newTextViewFrame;
        [UIView commitAnimations];
    }
    else
    {
        tableView_.contentInset = UIEdgeInsetsMake(0,0,keyboardRect.size.height,0);
        CGFloat contentOfSetY = headView_.frame.size.height-gxsSectionHeaderView_.frame.size.height - (ScreenHeight-64-gxsSectionHeaderView_.frame.size.height-keyboardRect.size.height);
        CGPoint point = CGPointMake(0,contentOfSetY);
        tableView_.contentOffset = point;        
//        CGRect frame = tableView_.frame;
//        frame.size.height = ScreenHeight-64-keyboardRect.size.height;
//        tableView_.frame = frame;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [MyCommon removeTapGesture:self.view ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    if (beAddComent_) {
        CGRect newTextViewFrame = commentView_.frame;
        newTextViewFrame.origin.y = self.view.frame.size.height;
        
        NSDictionary* userInfo = [notification userInfo];
        NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        commentView_.frame = newTextViewFrame;
        [UIView commitAnimations];
    }
    else
    {
//        CGRect frame = tableView_.frame;
//        frame.size.height = ScreenHeight-64;
//        tableView_.frame = frame;
        tableView_.contentInset = UIEdgeInsetsZero;
    }
}

//自己视图的单击事件
-(void) viewSingleTap:(id)sender
{
    [gxsSectionHeaderView_.textView_ resignFirstResponder];
    [commentTF_ resignFirstResponder];
    [gxsSectionHeaderView_.nickNameTF_ resignFirstResponder];
}


-(void)submitGXS
{
    NSString *contentStr = [gxsSectionHeaderView_.textView_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([contentStr length] == 0) {
        [BaseUIViewController showAlertView:@"内容不能为空" msg:nil btnTitle:@"确定"];
        return;
    }
     NSString *titleStr = @"";
    @try {
        titleStr = [contentStr substringToIndex:10];
    }
    @catch (NSException *exception) {
        titleStr = contentStr;
    }
    @finally {
        
    }
    
    if (!submitCon_) {
        submitCon_ = [self getNewRequestCon:NO];
    }
    [submitCon_ shareSalaryArticle:[Manager getUserInfo].userId_ job:nil title:titleStr content:gxsSectionHeaderView_.textView_.text sourceId:@""];
    [gxsSectionHeaderView_.textView_ resignFirstResponder];
    [gxsSectionHeaderView_.nickNameTF_ resignFirstResponder];
}




-(void)btnResponse:(id)sender
{
    if (sender == giveCommentBtn_) {
        if ([[commentTF_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            [BaseUIViewController showAutoDismissFailView:@"评论内容不能为空" msg:nil seconds:2.0];
            return;
        }
        
        ELSalaryModel * articleModal = [detailModel.gxsArticleArr objectAtIndex:articleIndex_];
        articleModal.c_cnt ++ ;
        [tableView_ reloadData];
        if (!addCommentCon_) {
            addCommentCon_ = [self getNewRequestCon:NO];
        }
        [addCommentCon_ addComment:bChooseArticle_.article_id parentId:comment_parentId_ userId:[Manager getUserInfo].userId_ content:commentTF_.text proID:nil clientId:[Common idfvString]];
        
        [commentTF_ resignFirstResponder];
        [commentTF_ setText:@""];

    }
    else if (sender == gxsSectionHeaderView_.publishBtn_){
        [self submitGXS];
    }
    else if (sender == compareBtn_)
    {//看看能打败多少人
        NSString *userId = [Manager getUserInfo].userId_;
        if (!userId) {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            //[BaseUIViewController showAlertView:nil msg:@"该功能需要登录后才能使用" btnTitle:@"确定"];
            return;
        }
        
        if (!_querySalaryCountCon) {
            _querySalaryCountCon = [self getNewRequestCon:NO];
        }
        [_querySalaryCountCon getSalaryQueryCountWithUserId:userId];
        
    }
    else if(sender == gxsSectionHeaderView_.moreBtn_)
    {
        //灌薪水跳转
        SalaryIrrigationCtl *irrigationCtl_ = [[SalaryIrrigationCtl alloc]init];
        SearchParam_DataModal *searchParam = [self getSearchDataModal];
        [self.navigationController pushViewController:irrigationCtl_ animated:YES];
        [irrigationCtl_ beginLoad:searchParam exParam:nil];
        
    }
    else if (sender == backBtn_){
        [super backBarBtnResponse:sender];
    }
    else if (sender == shareBtn_){
        [self rightBarBtnResponse:sender];
    }
}

//获取搜索时需要的dataModal
-(SearchParam_DataModal *)getSearchDataModal
{
    SearchParam_DataModal *searchParam = [[SearchParam_DataModal alloc] init];
    searchParam.searchType_ = 3;
    searchParam.searchKeywords_ = detailModel.userInfo.job;
    
    searchParam.regionId_ = detailModel.userInfo.regionid;
    searchParam.bCampusSearch_ = NO;
    
    searchParam.tradeId_ = @"1000";
    
    
    return searchParam;
}

-(void)rightBarBtnResponse:(id)sender
{
    if(&UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(self.view.frame.size);
    }
    
    //获取图像
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1024"  ofType:@"png"];
    
    NSString * sharecontent = percentContent_;
    
    NSString * titlecontent = [NSString stringWithFormat:@"我打败了%@的人，赶紧来试试吧！",percentLb_.text];
    
    NSString * url = detailModel.share_url;
    if (!url || [url isEqualToString:@""]) {
        url = @"http://m.yl1001.com/xinwen/xzbj/?";
    }
    
    [self viewSingleTap:nil];
    
    //调用分享
    [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url];

}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void) alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch ( type ) {
        case 1:
        {
            [[Manager shareMgr] loginOut];
            [Manager shareMgr].haveLogin = NO;
        }
            
            break;
            
        default:
            break;
    }
}


-(NSString*)shareUrl:(User_DataModal*)model
{
    NSString * pre = @"http://m.yl1001.com/xinwen/xzbj/?";
    
    NSString * regionId = model.regionId_;
    if ([regionId isEqualToString:@"10000"]|| [regionId isEqualToString:@""]) {
        regionId = @"100";
    }
    
    
    NSString * bg = @"0";
    if ([bgColor_ isEqual:Color_Red]) {
        bg = @"3";
    }
    else if ([bgColor_ isEqual:Color_Blue]){
        bg = @"2";
    }
    
    NSString * kw = [MyCommon utf8ToUnicode:model.zym_];
    kw = [kw stringByReplacingOccurrencesOfString:@"@@" withString:@"\\"];
    
    NSString * condition = [NSString stringWithFormat:@"comp_id=%@&yuex=%@",model.userId_,model.salary_];
    
    return [NSString stringWithFormat:@"%@%@",pre,condition];
    
}


@end

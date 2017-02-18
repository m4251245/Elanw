//
//  WantJob_ResumeCtl.m
//  jobClient
//
//  Created by job1001 job1001 on 12-2-7.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "WantJob_ResumeCtl.h"
#import "PreCommon.h"
#import "PreStatus_DataModal.h"
#import "FBRegionCtl.h"
#import "ELJobTypeChangeCtl.h"

@interface WantJob_ResumeCtl ()<UIScrollViewDelegate>
{
    RequestCon *openCon_;
    
    PersonDetailInfo_DataModal *personDataModal;
    BOOL isBack;
    BOOL hotCity;
    BOOL hotCity1;
    BOOL hotCity2;
}

@end

@implementation WantJob_ResumeCtl

-(id) init
{
    self = [self initWithNibName:@"WantJob_ResumeCtl" bundle:nil];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavTitle:@"求职意向"];
    [self changFontWithLabel:nil button:jobTypeBtn_ textField:nil uitextView:nil];
    [self changFontWithLabel:nil button:zw1Btn_ textField:nil uitextView:nil];
    [self changFontWithLabel:nil button:zw2Btn_ textField:nil uitextView:nil];
    [self changFontWithLabel:nil button:zw3Btn_ textField:nil uitextView:nil];
    [self changFontWithLabel:nil button:region1Btn_ textField:nil uitextView:nil];
    [self changFontWithLabel:nil button:region2Btn_ textField:nil uitextView:nil];
    [self changFontWithLabel:nil button:region3Btn_ textField:nil uitextView:nil];
    [self changFontWithLabel:nil button:workDateBtn_ textField:nil uitextView:nil];
    [self changFontWithLabel:nil button:nil textField:monthSalaryTf_ uitextView:nil];
    
    //设置相关代理
    monthSalaryTf_.delegate = self;
    preCondictionListCtl.delegate_ = self;
    
    //获取scrollView的contentSize
    scrollView_.contentSize = CGSizeMake(ScreenWidth, 750);
    scrollViewContentSize_ = scrollView_.contentSize;
    [_receiveEmailSwitch addTarget:self action:@selector(jobSwithchClick:) forControlEvents:UIControlEventValueChanged];
    
    saveBtn_.titleLabel.font = [UIFont systemFontOfSize:16];
    saveBtn_.layer.cornerRadius = 3;
    saveBtn_.layer.masksToBounds = YES;
    [saveBtn_ setBackgroundImage:[UIImage createImageWithColor:UIColorFromRGB(0xe13e3e)] forState:UIControlStateNormal];
    [saveBtn_ setBackgroundImage:[UIImage createImageWithColor:UIColorFromRGB(0xbb3434)] forState:UIControlStateHighlighted];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.navigationItem.title = @"求职意向";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (isBack) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
        isBack = NO;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationItem.title = @"";
}

- (void)jobSwithchClick:(UISwitch *)witch
{
    if (witch.isOn) {
        if ([zw1Btn_.titleLabel.text isEqualToString:@""] ||[zw2Btn_.titleLabel.text isEqualToString:@""] || [zw3Btn_.titleLabel.text isEqualToString:@""]) {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"请选择意向职位" seconds:2.f];
            [witch setOn:NO];
            return;
        }
        
        //意向地区1
        NSString *region1 = region1Btn_.titleLabel.text;
        //意向地区2
        NSString *region2 = region2Btn_.titleLabel.text ;
        //意向地区3
        NSString *region3 = region3Btn_.titleLabel.text ;
        if (!region1 && !region2 && !region3) {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"请选择意向地区" seconds:2.f];
            [witch setOn:NO];
            return;
        }
    }
    
    NSString *type;
    NSString *status;
    if (witch.isOn) {
        //打开
        type = @"210";
        status = @"1";
    }else{
        //关闭
        type = @"210";
        status = @"0";
    }
    NSString *bodyMsg =[NSString stringWithFormat:@"person_id=%@&msg_type=%@&msg_val=%@",[Manager getUserInfo].userId_, type, status];
    [ELRequest postbodyMsg:bodyMsg op:@"yl_app_push_setting" func:@"addOrUpdatePushSetting" requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
        [BaseUIViewController showAutoDismissSucessView:nil msg:result[@"status_desc"]];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (void)changFontWithLabel:(UILabel *)label_ button:(UIButton *)button_ textField:(UITextField *)textField_ uitextView:(UITextView *)textView_
{
    if (label_ !=nil) {
        [label_ setTextColor:UIColorFromRGB(0x333333)];
    }
    if (button_ !=nil) {
        [button_ setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }
    if (textField_ != nil) {
        [textField_ setTextColor:UIColorFromRGB(0x333333)];
    }
    if (textView_ != nil) {
        [textView_ setTextColor:UIColorFromRGB(0x333333)];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//让有焦点的控件失去焦点
-(void) comResignFirstResponse
{
    [super comResignFirstResponse];
    
    [monthSalaryTf_ resignFirstResponder];
}

//检查是否能保存
-(BOOL) checkCanSave
{
    if( !jobTypeBtn_.titleLabel.text || [jobTypeBtn_.titleLabel.text isEqualToString:@""] || [jobTypeBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
        
    {
        return [self alertShow:@"请选择求职类型"];
    }
    
    if( ( !zw1Btn_.titleLabel.text || [zw1Btn_.titleLabel.text isEqualToString:@""] || [zw1Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] ) &&
       ( !zw2Btn_.titleLabel.text || [zw2Btn_.titleLabel.text isEqualToString:@""] || [zw2Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] ) &&
       ( !zw3Btn_.titleLabel.text || [zw3Btn_.titleLabel.text isEqualToString:@""] || [zw3Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] ) )
    {
        return [self alertShow:@"请至少选择一个意向职位"];
    }
    
    if( ( !region1Btn_.titleLabel.text || [region1Btn_.titleLabel.text isEqualToString:@""] || [region1Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] ) &&
       ( !region2Btn_.titleLabel.text || [region2Btn_.titleLabel.text isEqualToString:@""] || [region2Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] ) &&
       ( !region3Btn_.titleLabel.text || [region3Btn_.titleLabel.text isEqualToString:@""] || [region3Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] ) )
    {
        return [self alertShow:@"请至少选择一个希望工作地区"];
    }
    
    if( !workDateBtn_.titleLabel.text || [workDateBtn_.titleLabel.text isEqualToString:@""] || [workDateBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
        
    {
        return [self alertShow:@"请选择可到职日期"];
    }
    
    if( [monthSalaryTf_.text intValue] > 1000000 )
    {
        NSString *msg = [[NSString alloc] initWithFormat:@"您输入的期望月薪不能超过:%d",1000000] ;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        
        monthSalaryTf_.text = @"";
        [monthSalaryTf_ becomeFirstResponder];
        
        return NO;
    }
    else
    {
        NSString *str = [[NSString alloc] initWithFormat:@"%d",[monthSalaryTf_.text intValue]];
        monthSalaryTf_.text = str;
    }
    
    return YES;
}

-(BOOL)alertShow:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil];
    [alert show];
    return NO;
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    
}

//获取意向职位信息
- (void)getWantJonInfo
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[Manager getUserInfo].userId_ forKey:@"personId"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *paramStr = [jsonWrite stringWithObject:paramDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"param=%@&where=%@&slaveInfo=%@",paramStr,@"1=1",@"1"];
    [ELRequest postbodyMsg:bodyMsg op:@"person_sub_busi" func:@"getPersonDetail" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dic = result;
        //@"jobtype",@"job",@"jobs",@"job1",@"city",@"gzdd1",@"gzdd5",@"workdate",@"yuex",
        personDataModal = [[PersonDetailInfo_DataModal alloc] init];
        personDataModal.jobtype_ = dic[@"jobtype"];
        personDataModal.worddate_ = dic[@"workdate"];
        personDataModal.yuex_ = dic[@"yuex"];
        
        personDataModal.job_ = dic[@"job"];
        personDataModal.jobs_ = dic[@"jobs"];
        personDataModal.job1_ = dic[@"job1"];
        
        personDataModal.city_ = dic[@"city"];
        personDataModal.gzdd1_ = dic[@"gzdd1"];
        personDataModal.gzdd5_ = dic[@"gzdd5"];
        
        [self updateComInfo:nil];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
    
}

//是否订阅邮件推送
- (void)checkEmailSubscribe
{
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&conditionArr=",[Manager getUserInfo].userId_];
    
    [ELRequest postbodyMsg:bodyMsg op:@"person_sub_busi" func:@"getPushSettingByPerson" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dic = result;
        
        NSString *isOn = dic[@"210"];
        
        if ([isOn isEqualToString:@"1"]) {
            _receiveEmailSwitch.on = YES;
        }
        else
        {
            _receiveEmailSwitch.on = NO;
        }
        [self updateComInfo:nil];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
    
}

//不用载入数据
-(void) getDataFunction
{
    [self getWantJonInfo];
    [self checkEmailSubscribe];
    loadStats_ = FinishLoad;
}

//更新控件上的值
-(void) updateComInfo:(PreRequestCon *)con
{
    [super updateComInfo:con];
    
    PersonDetailInfo_DataModal *dataModal = personDataModal;
    
    //求职类型
    if( dataModal.jobtype_ && [dataModal.jobtype_ isKindOfClass:[NSString class]] && ![dataModal.jobtype_ isEqualToString:@""] )
    {
        [jobTypeBtn_ setTitle:dataModal.jobtype_ forState:UIControlStateNormal];
    }
    else
    {
        [jobTypeBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }
    
    //意向职位1
    if( dataModal.job_ && [dataModal.job_ isKindOfClass:[NSString class]] && ![dataModal.job_ isEqualToString:@""])
    {
        [zw1Btn_ setTitle:dataModal.job_ forState:UIControlStateNormal];
    }
    else
    {
        [zw1Btn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }
    
    //意向职位2
    if( dataModal.jobs_ && [dataModal.jobs_ isKindOfClass:[NSString class]] && ![dataModal.jobs_ isEqualToString:@""] )
    {
        [zw2Btn_ setTitle:dataModal.jobs_ forState:UIControlStateNormal];
    }
    else
    {
        [zw2Btn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }
    
    //意向职位3
    if( dataModal.job1_ && [dataModal.job1_ isKindOfClass:[NSString class]] && ![dataModal.job1_ isEqualToString:@""] )
    {
        [zw3Btn_ setTitle:dataModal.job1_ forState:UIControlStateNormal];
    }
    else
    {
        [zw3Btn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }
    
    //意向地区1
    NSString *region1 = [CondictionPlaceCtl getRegionStr:dataModal.city_];
    if ([dataModal.city_ isEqualToString:@""]) {
        region1 = @"不限";
    }
    if( region1 )
    {
        [region1Btn_ setTitle:region1 forState:UIControlStateNormal];
    }
    else
    {
        [region1Btn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }
    
    //意向地区2
    NSString *region2 = [CondictionPlaceCtl getRegionStr:dataModal.gzdd1_];
    if ([dataModal.gzdd1_ isEqualToString:@"10000"]) {
        region2 = @"全国";
    }
    if( region2 )
    {
        [region2Btn_ setTitle:region2 forState:UIControlStateNormal];
    }
    else
    {
        [region2Btn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }
    
    //意向地区3
    NSString *region3 = [CondictionPlaceCtl getRegionStr:dataModal.gzdd5_];
    if ([dataModal.gzdd5_ isEqualToString:@"10000"]) {
        region3 = @"全国";
    }
    if( region3 )
    {
        [region3Btn_ setTitle:region3 forState:UIControlStateNormal];
    }
    else
    {
        [region3Btn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }
    
    //可到职日期
    if( dataModal.worddate_ && ![dataModal.worddate_ isEqualToString:@""] )
    {
        [workDateBtn_ setTitle:dataModal.worddate_ forState:UIControlStateNormal];
    }
    else
    {
        [workDateBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }
    
    //月薪
    if( dataModal.yuex_ )
    {
        monthSalaryTf_.text = dataModal.yuex_;
    }
    else
    {
        monthSalaryTf_.text = @"";
    }
}

//保存
-(void) saveResume
{
    if( [self checkCanSave] )
    {
        [super saveResume];
        
        jobtype_    = @"";
        zw1_        = @"";
        zw2_        = @"";
        zw3_        = @"";
        region1_    = @"";
        region2_    = @"";
        region3_    = @"";
        workdate_   = @"";
        yuex_       = @"";
        grzz_       = @"";
        
        if( ![jobTypeBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
        {
            jobtype_ = jobTypeBtn_.titleLabel.text;
        }
        if( ![zw1Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
        {
            zw1_ = zw1Btn_.titleLabel.text;
        }
        if( ![zw2Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
        {
            zw2_ = zw2Btn_.titleLabel.text;
        }
        if( ![zw3Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
        {
            zw3_ = zw3Btn_.titleLabel.text;
        }
        
        if( ![region1Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
        {
            NSString *str = region1Btn_.titleLabel.text;
            if ([str isEqualToString:@"不限"] || [str isEqualToString:@"全国"]) {
                region1_ =  @"";
            }else{
                if ([str isEqualToString:@"北京市"]|| [str isEqualToString:@"上海市"]||
                    [str isEqualToString:@"重庆市"]||
                    [str isEqualToString:@"天津市"]) {
                    str = [str substringToIndex:2];
                }
                region1_ = [CondictionPlaceCtl getRegionId:str];
            }
        }
        if( ![region2Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
        {
            NSString *str = region2Btn_.titleLabel.text;
            if ([str isEqualToString:@"不限"] || [str isEqualToString:@"全国"]) {
                region2_ =  @"";
            }else{
                if ([str isEqualToString:@"北京市"]|| [str isEqualToString:@"上海市"]||
                    [str isEqualToString:@"重庆市"]||
                    [str isEqualToString:@"天津市"]) {
                    str = [str substringToIndex:2];
                }
                region2_ = [CondictionPlaceCtl getRegionId:str];
            }
           
        }
        if( ![region3Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
        {
            NSString *str = region3Btn_.titleLabel.text;
            if ([str isEqualToString:@"不限"] || [str isEqualToString:@"全国"]) {
                region3_ = @"";
            }else{
                if ([str isEqualToString:@"北京市"]|| [str isEqualToString:@"上海市"]||
                    [str isEqualToString:@"重庆市"]||
                    [str isEqualToString:@"天津市"]) {
                    str = [str substringToIndex:2];
                }
                region3_ = [CondictionPlaceCtl getRegionId:str];
            }
        }
        if( ![workDateBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
        {
            workdate_ = workDateBtn_.titleLabel.text;
        }
        yuex_ = monthSalaryTf_.text;
        
        [self saveWantJobInfo];
        
    }
}

#pragma TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL flag = [super textFieldShouldReturn:textField];
    
    return flag;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma ChooseHotCityDelegate
-(void) chooseHotCity:(RegionCtl *)ctl city:(NSString *)city
{
    CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
    dataModal.str_ = city;
    dataModal.id_ = [CondictionPlaceCtl getRegionId:city];
    
    //继续根据currentWantRegionType_来判断到底是哪种
    UIButton *btn = nil;
    switch ( currentWantRegionType_ ) {
        case Want_Region_1:
        {
            //如果选择了不限,则从第三个开始断判赋值
            if( !dataModal || dataModal == nil )
            {
                if( ![region3Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
                {
                    btn = region3Btn_;
                }else if( ![region2Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
                {
                    btn = region2Btn_;
                }else
                    btn = region1Btn_;
            }
            else{//如果有选择,则从自己开始
                btn = region1Btn_;
            }
        }
            break;
        case Want_Region_2:
        {
            //如果选择了不限
            if( !dataModal || dataModal == nil )
            {
                if( ![region3Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
                {
                    btn = region3Btn_;
                }else
                    btn = region2Btn_;
            }
            else
            {//有选择
                //如果第一意向还没有选,那么我们把其放入第一意向职位
                if( [region1Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
                {
                    btn = region1Btn_;
                }else
                    btn = region2Btn_;
            }
        }
            break;
        case Want_Region_3:
        {
            //如果选择了不限
            if( !dataModal || dataModal == nil )
            {
                btn = region3Btn_;
            }
            //有选择
            else
            {
                //判断前两个意向
                if( [region1Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
                {
                    btn = region1Btn_;
                }else if( [region2Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
                {
                    btn = region2Btn_;
                }else
                    btn = region3Btn_;
            }
            
        }
            break;
        default:
            break;
    }
    
    if( btn )
    {
        if( !dataModal || dataModal == nil )
        {
            [btn setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
        }else
        {
            //如果地区与前面的有重复
            if( ( [dataModal.str_ isEqualToString:region1Btn_.titleLabel.text] || [dataModal.str_ isEqualToString:region2Btn_.titleLabel.text] || [dataModal.str_ isEqualToString:region3Btn_.titleLabel.text] ) && ![dataModal.str_ isEqualToString:btn.titleLabel.text] )
            {
                [PreBaseUIViewController showAlertView:nil msg:@"您选择的地区已经存在,请重新选择" btnTitle:@"关闭"];
            }
            else
            {
                [btn setTitle:dataModal.str_ forState:UIControlStateNormal];
            }
            
        }
    }
}

-(void) condictionChooseComplete:(PreBaseUIViewController *)ctl dataModal:(CondictionList_DataModal *)dataModal type:(CondictionChooseType)type
{
    switch ( type ) {
        case GetJobType:
        {
            if( !dataModal || dataModal == nil )
            {
                [jobTypeBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
            }else
                [jobTypeBtn_ setTitle:dataModal.str_ forState:UIControlStateNormal];
        }
            break;
        case GetZWType:
        {
            [self changeJobWithModal:dataModal];
        }
            break;
        case GetWorkDateType:
        {
            if( !dataModal || dataModal == nil )
            {
                [workDateBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
            }else
                [workDateBtn_ setTitle:dataModal.str_ forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

-(void)changeJobWithModal:(CondictionList_DataModal *)dataModal
{
    if( !dataModal.id_ ){
        dataModal = nil;
    }
    //继续根据currentWantZWType_来判断到底是哪种
    UIButton *btn = nil;
    switch ( currentWantZWType_ ) {
        case Want_ZW_1:
        {
            //如果选择了不限,则从第三个开始断判赋值
            if( !dataModal || dataModal == nil )
            {
                if( ![zw3Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
                {
                    btn = zw3Btn_;
                }else if( ![zw2Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
                {
                    btn = zw2Btn_;
                }else
                    btn = zw1Btn_;
            }
            else
            {//如果有选择,则从自己开始
                btn = zw1Btn_;
            }
        }
            break;
        case Want_ZW_2:
        {
            //如果选择了不限
            if( !dataModal || dataModal == nil )
            {
                if( ![zw3Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
                {
                    btn = zw3Btn_;
                }else
                    btn = zw2Btn_;
            }
            else
            {//有选择
                //如果第一意向还没有选,那么我们把其放入第一意向职位
                if( [zw1Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
                {
                    btn = zw1Btn_;
                }else
                    btn = zw2Btn_;
            }
        }
            break;
        case Want_ZW_3:
        {
            //如果选择了不限
            if( !dataModal || dataModal == nil )
            {
                btn = zw3Btn_;
            }
            else
            {//有选择
                //判断前两个意向
                if( [zw1Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
                {
                    btn = zw1Btn_;
                }else if( [zw2Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
                {
                    btn = zw2Btn_;
                }else
                    btn = zw3Btn_;
            }
        }
            break;
        default:
            break;
    }
    
    if( btn )
    {
        if( !dataModal || dataModal == nil )
        {
            [btn setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
        }else
        {
            //判断意向职位是否选择重复
            if( ([dataModal.str_ isEqualToString:zw1Btn_.titleLabel.text] || [dataModal.str_ isEqualToString:zw2Btn_.titleLabel.text] || [dataModal.str_ isEqualToString:zw3Btn_.titleLabel.text] ) && ![dataModal.str_ isEqualToString:btn.titleLabel.text] )
            {
                [PreBaseUIViewController showAlertView:nil msg:@"您选择的职位已经存在,请重新选择" btnTitle:@"关闭"];
            }
            else
            {
                [btn setTitle:dataModal.str_ forState:UIControlStateNormal];
            }
        }
        
    }
}

-(void) buttonResponse:(id)sender
{
    //选择求职类型
    if( sender == jobTypeBtn_ )
    {
        [self.navigationController pushViewController:preCondictionListCtl animated:YES];
        preCondictionListCtl.delegate_ = self;
        [preCondictionListCtl beginGetData:nil exParam:nil type:GetJobType];
    }
    else if( sender == zw1Btn_ )
    {//意向职位
        currentWantZWType_ = Want_ZW_1;
//        [self.navigationController pushViewController:condictionZWCtl animated:YES];
//        condictionZWCtl.delegate_ = self;
        ELJobTypeChangeCtl *ctl = [[ELJobTypeChangeCtl alloc] init];
        ctl.type = 1;
        ctl.block = ^(TradeZWModel *model){
            CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
            dataModal.str_ = model.zwName;
            dataModal.id_ = model.zwid;
            [self changeJobWithModal:dataModal];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if( sender == zw2Btn_)
    {
        currentWantZWType_ = Want_ZW_2;
        ELJobTypeChangeCtl *ctl = [[ELJobTypeChangeCtl alloc] init];
        ctl.type = 1;
        ctl.block = ^(TradeZWModel *model){
            CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
            dataModal.str_ = model.zwName;
            dataModal.id_ = model.zwid;
            [self changeJobWithModal:dataModal];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if( sender == zw3Btn_ )
    {
        currentWantZWType_ = Want_ZW_3;
        ELJobTypeChangeCtl *ctl = [[ELJobTypeChangeCtl alloc] init];
        ctl.type = 1;
        ctl.block = ^(TradeZWModel *model){
            CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
            dataModal.str_ = model.zwName;
            dataModal.id_ = model.zwid;
            [self changeJobWithModal:dataModal];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if( sender == region1Btn_ )
    {//希望工作地区
        PersonDetailInfo_DataModal *dataModal = personDataModal;
        FBRegionCtl *ctl = [[FBRegionCtl alloc] init];
        ctl.isShowLocation = YES;
        ctl.showQuanGuo = YES;
        if (region1Btn_.titleLabel.text.length > 0 && ![region1Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue]) {
            ctl.selectName = region1Btn_.titleLabel.text;
            ctl.selectId = dataModal.city_;
            ctl.selectHotCity = hotCity;
        }
        ctl.block = ^(NSString *regionName,NSString *regionId,BOOL selectHotCity){
            if( ([regionName isEqualToString:region2Btn_.titleLabel.text] || [regionName isEqualToString:region3Btn_.titleLabel.text] ))
            {
                [PreBaseUIViewController showAlertView:nil msg:@"您选择的地区已经存在,请重新选择" btnTitle:@"关闭"];
            }
            else if(regionName.length > 0)
            {
                [region1Btn_ setTitle:regionName forState:UIControlStateNormal];
                dataModal.city_ = regionId;
                region1_ = regionId;
            }
            hotCity = selectHotCity;
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if( sender == region2Btn_ )
    {
        PersonDetailInfo_DataModal *dataModal = personDataModal;
        FBRegionCtl *ctl = [[FBRegionCtl alloc] init];
        ctl.isShowLocation = YES;
        ctl.showQuanGuo = YES;
        if (region2Btn_.titleLabel.text.length > 0 && ![region2Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue]) {
            ctl.selectName = region2Btn_.titleLabel.text;
            ctl.selectId = dataModal.gzdd1_;
            ctl.selectHotCity = hotCity1;
        }
        ctl.block = ^(NSString *regionName,NSString *regionId,BOOL selectHotCity){
            if( ( [regionName isEqualToString:region1Btn_.titleLabel.text] || [regionName isEqualToString:region3Btn_.titleLabel.text]))
            {
                [PreBaseUIViewController showAlertView:nil msg:@"您选择的地区已经存在,请重新选择" btnTitle:@"关闭"];
            }
            else if(regionName.length > 0)
            {
                [region2Btn_ setTitle:regionName forState:UIControlStateNormal];
                dataModal.gzdd1_ = regionId;
                region2_ = regionId;
            }
            hotCity1 = selectHotCity;
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if( sender == region3Btn_ )
    {
        PersonDetailInfo_DataModal *dataModal = personDataModal;
        FBRegionCtl *ctl = [[FBRegionCtl alloc] init];
        ctl.isShowLocation = YES;
        ctl.showQuanGuo = YES;
        if (region3Btn_.titleLabel.text.length > 0 && ![region3Btn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue]) {
            ctl.selectName = region3Btn_.titleLabel.text;
            ctl.selectId = dataModal.gzdd5_;
            ctl.selectHotCity = hotCity2;
        }
        ctl.block = ^(NSString *regionName,NSString *regionId,BOOL selectHotCity){
            if( ( [regionName isEqualToString:region1Btn_.titleLabel.text] || [regionName isEqualToString:region2Btn_.titleLabel.text]))
            {
                [PreBaseUIViewController showAlertView:nil msg:@"您选择的地区已经存在,请重新选择" btnTitle:@"关闭"];
            }
            else if(regionName.length > 0)
            {
                [region3Btn_ setTitle:regionName forState:UIControlStateNormal];
                dataModal.gzdd5_ = regionId;
                region3_ = regionId;
            }
            hotCity2 = selectHotCity;
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if( sender == workDateBtn_ )
    {//可到职日期
        [self.navigationController pushViewController:preCondictionListCtl animated:YES];
        preCondictionListCtl.delegate_ = self;
        [preCondictionListCtl beginGetData:nil exParam:nil type:GetWorkDateType];
    }
    else if( sender == saveBtn_ )//保存
    {
        [self saveResume];
    }
}

- (void)saveWantJobInfo
{
    NSArray *columnValueArr = [[NSArray alloc] initWithObjects: jobtype_,zw1_,zw2_,zw3_,region1_,region2_,region3_,workdate_,yuex_, nil];
    
    //求职类型 意向职位1 意向职位2 意向职位3 意向地区1 意向地区2 意向地区3 可到职日期 期望月薪
    NSArray *columnNameArr = [[NSArray alloc] initWithObjects: @"jobtype",@"job",@"jobs",@"job1",@"city",@"gzdd1",@"gzdd5",@"workdate",@"yuex", nil];
    
    NSMutableArray *updateArr = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < columnNameArr.count; i++) {
        
        NSString *columnValueStr = [columnValueArr objectAtIndex:i];
        NSString *columnNameStr = [columnNameArr objectAtIndex:i];
        
        NSMutableDictionary *columnDic = [[NSMutableDictionary alloc]init];
        [columnDic setObject:columnNameStr forKey:@"columnName"];
        [columnDic setObject:columnValueStr forKey:@"columnValue"];
        
        [updateArr addObject:columnDic];
    }
    
    NSString *whereId = [NSString stringWithFormat:@"id=%@",[Manager getUserInfo].userId_];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
    [paramDic setObject:[Manager getUserInfo].userId_ forKey:@"personId"];
    [paramDic setObject:updateArr forKey:@"update"];
    [paramDic setObject:whereId forKey:@"where"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *paramStr = [jsonWrite stringWithObject:paramDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"param=%@",paramStr];
    
    [ELRequest postbodyMsg:bodyMsg op:@"person_info_busi" func:@"updatePersonDetail" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dic = result;
        
        Status_DataModal *model = [[Status_DataModal alloc] init];
        model.status_ =  dic[@"status"];
        model.code_ =  dic[@"code"];
        model.des_ =  dic[@"status_desc"];
        
        if ([model.code_ isEqualToString:@"200"]) {
            
            PersonDetailInfo_DataModal *personInfoDataModal = personDetailInfoDataModal;
            personInfoDataModal.jobtype_        = jobtype_;
            personInfoDataModal.job_            = zw1_;
            personInfoDataModal.jobs_           = zw2_;
            personInfoDataModal.job1_           = zw3_;
            personInfoDataModal.city_           = region1_;
            personInfoDataModal.gzdd1_          = region2_;
            personInfoDataModal.gzdd5_          = region3_;
            personInfoDataModal.worddate_       = workdate_;
            personInfoDataModal.yuex_           = yuex_;
            personInfoDataModal.grzz_           = grzz_;
            if (self.backBlock) {
                self.backBlock(personDetailInfoDataModal);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SIMPLIFYREFRESH" object:nil];
            [BaseUIViewController showAutoDismissSucessView:nil msg:model.des_ seconds:2.0f];
        }
        else
        {
            [BaseUIViewController showAutoDismissSucessView:nil msg:model.des_ seconds:2.0f];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
    
}

- (void)backBarBtnResponse:(id)sender
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

@end

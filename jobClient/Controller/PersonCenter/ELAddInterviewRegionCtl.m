//
//  ELAddInterviewRegionCtl.m
//  jobClient
//
//  Created by YL1001 on 15/11/4.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELAddInterviewRegionCtl.h"
#import "ELInterviewPlaceCtl.h"
#import "ELRequest.h"
#import "SBJson.h"

//#define screenHeight [UIScreen mainScreen].bounds.size.height
//#define screenWidth [UIScreen mainScreen].bounds.size.width

@interface ELAddInterviewRegionCtl ()
{
    ELInterViewAdressCtl *interviewAddressCtl;
    
    IBOutlet UIView *placeBgView;
    NSInteger placeNum;         /**<约谈地点数量 */
    CGFloat placeCtlHeight;     /**<地点选择卡片高度 */
    
    BOOL isHaveSameAddress;
    
    UIView *pickerBgView;     /**<时间选择器背景 */
    UIDatePicker *datePicker; /**<时间选择器 */
    
    NSMutableArray *interviewPlaceArr; /**<约谈地点卡片 */
    NSInteger selectedBtnTag;  /**<选中按钮tag */
    UIView *maskView;   /**<遮罩View */
    
    IBOutlet NSLayoutConstraint *_placeBgViewAutoTop;
    IBOutlet NSLayoutConstraint *_placeBgViewAutoHeight;
    
}
@end

@implementation ELAddInterviewRegionCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加地址";

    placeBgView.layer.cornerRadius = 8.0f;
    placeBgView.layer.masksToBounds = YES;
    
    addTimeAndPlaceBtn.layer.cornerRadius = 4.0f;
    addTimeAndPlaceBtn.layer.masksToBounds = YES;
    
    interviewPlaceArr  = [[NSMutableArray alloc] init];
    placeCtlHeight = 8;
    
    confirmView.layer.cornerRadius = 8.0f;
    confirmView.layer.masksToBounds = YES;
    confirmView.frame = CGRectMake((ScreenHeight-288)/2, (ScreenHeight-133)/2, 288, 133);
    
    confirmBtn.layer.cornerRadius = 4.0;
    confirmBtn.layer.masksToBounds = YES;   
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    aspDataModal = dataModal;
}

- (void)btnResponse:(id)sender
{
    if (sender == addTimeAndPlaceBtn) {//添加地点卡片
        placeNum += 1;
        if (interviewPlaceArr.count < 4) {
            ELInterviewPlaceCtl *placeCtl = [[ELInterviewPlaceCtl alloc] init];
            placeCtl.view.tag = placeNum + 1000;
            placeCtl.view.frame = CGRectMake(0, placeCtlHeight, ScreenWidth, 129);
            placeCtl.titleLb.text = [NSString stringWithFormat:@"约谈%ld",(unsigned long)interviewPlaceArr.count + 1];
            [placeCtl.timeBtn addTarget:self action:@selector(placeCtlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            placeCtl.timeBtn.tag = 100 + placeNum;
            [placeCtl.placeBtn addTarget:self action:@selector(placeCtlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            placeCtl.placeBtn.tag = 10 + placeNum;
            [placeCtl.delectBtn addTarget:self action:@selector(placeCtlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            placeCtl.delectBtn.tag = 1000 + placeNum;
            [self.scrollView_ addSubview:placeCtl.view];
            placeCtlHeight += placeCtl.view.frame.size.height;
            
            _placeBgViewAutoTop.constant = placeCtlHeight + 10;
            

            [interviewPlaceArr addObject:placeCtl];
            
            if (interviewPlaceArr.count == 3) {
                placeBgView.hidden = YES;
            }
            
        }
    }
    else if (sender == commitBtn)
    {//提交
        if (interviewPlaceArr.count > 0)
        {
            for (NSInteger i = 0; i < interviewPlaceArr.count; i++)
            {
                ELInterviewPlaceCtl *ctl = [interviewPlaceArr objectAtIndex:i];
                NSString *timeTitle = ctl.timeBtn.titleLabel.text;
                NSString *placeTitle = ctl.placeBtn.titleLabel.text;
                
                if ([timeTitle isEqualToString:@"请选择时间"]) {
                    NSString *alertStr = [NSString stringWithFormat:@"约谈的第%d项，没有添加时间", i+1];
                    [BaseUIViewController showAutoDisappearAlertView:nil msg:alertStr seconds:1.0];
                    return;
                }
                
                if ([placeTitle isEqualToString:@"请编辑地点"]) {
                    NSString *alertStr = [NSString stringWithFormat:@"约谈的第%d项，没有添加地址", i+1];
                    [BaseUIViewController showAutoDisappearAlertView:nil msg:alertStr seconds:1.0];
                    return;
                }
            }
            
            [self haveSameAddress];
            if (isHaveSameAddress) {
                [BaseUIViewController showAutoDisappearAlertView:nil msg:@"请输入不同的时间地点" seconds:1.0];
                return;
            }
        }
        else {
            [BaseUIViewController showAutoDisappearAlertView:nil msg:@"请添加时间地点后再提交" seconds:1.0];
            return;
        }
        
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功后不可更改，若无法与来询者达成一致可私信沟通" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alerView.tag = 1000;
        [alerView show];
    }

}

- (void)placeCtlBtnClick:(UIButton *)sender
{
    if (sender.tag > 1000) {//删除时间、地点卡片
        for (ELInterviewPlaceCtl *placeCtl in interviewPlaceArr) {
            if (placeCtl.delectBtn.tag == sender.tag) {
                [placeCtl.view removeFromSuperview];
                [interviewPlaceArr removeObject:placeCtl];
                placeNum = sender.tag - 1001;
                if (interviewPlaceArr.count < 3) {
                    placeBgView.hidden = NO;
                }
                [self setDeleteLayout];
                break;
            }
        }
        
        NSInteger num = 0;
        for (ELInterviewPlaceCtl *placeCtl in interviewPlaceArr) {
            num += 1;
            placeCtl.titleLb.text = [NSString stringWithFormat:@"约谈%ld",(long)num];
        }
    }
    else if (sender.tag > 100) {//添加时间
        selectedBtnTag = sender.tag;
        [self showDatePicker];
        return;
    }
    else if (sender.tag > 10)
    {//添加地点
        selectedBtnTag = sender.tag;
        
        if (!interviewAddressCtl) {
            interviewAddressCtl = [[ELInterViewAdressCtl alloc] init];
            interviewAddressCtl.delegate = self;
        }
        [self.navigationController pushViewController:interviewAddressCtl animated:YES];
        [interviewAddressCtl beginLoad:aspDataModal exParam:nil];
        return;
    }
}

//设置删除地点卡片后的布局
- (void)setDeleteLayout
{
    placeCtlHeight = 8;
    if (interviewPlaceArr.count == 0) {

        _placeBgViewAutoTop.constant = placeCtlHeight;
        return;
    }
    
    for (ELInterviewPlaceCtl *ctl in interviewPlaceArr) {
        ctl.view.frame = CGRectMake(0, placeCtlHeight, ScreenWidth, 129);
        placeCtlHeight += ctl.view.frame.size.height;
        
        _placeBgViewAutoTop.constant = placeCtlHeight + 10;
    }
}

#pragma mark - 行家选择时间地点弹出框
//显示时间选择器
- (void)showDatePicker
{
    pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-200, self.view.bounds.size.width, 200)];
    pickerBgView.backgroundColor = [UIColor whiteColor];
    
    UIButton *timeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100, 5, 75, 30)];
    [timeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [timeBtn setBackgroundColor:[UIColor blueColor]];
    timeBtn.layer.cornerRadius = 4.0;
    [timeBtn addTarget:self action:@selector(timeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [pickerBgView addSubview:timeBtn];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 25, pickerBgView.frame.size.width, 170)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    [pickerBgView addSubview:datePicker];
    
    [self showMaskView:pickerBgView];
}
//完成时间选择
- (void)timeBtnClick
{
    [pickerBgView removeFromSuperview];
    // 获取用户通过UIDatePicker设置的日期和时间
    NSDate *selected = [datePicker date];
    // 创建一个日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    // 使用日期格式器格式化日期、时间
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    
    NSTimeInterval  timeInterval = [selected timeIntervalSinceNow];
    
    [self hiddenMaskView];
    if (timeInterval > 0) {
        for (ELInterviewPlaceCtl *placeCtl in interviewPlaceArr) {
            if (placeCtl.timeBtn.tag == selectedBtnTag) {
                [placeCtl.timeBtn setTitle:destDateString forState:UIControlStateNormal];
                return;
            }
        }
    }
    else
    {
        [BaseUIViewController showAutoDismissFailView:nil msg:@"已经过期的时间不能进行选择"];
    }
}

#pragma mark - chooseAddressDelegate
- (void)addInterviewAddressWithRegionName:(NSString *)regionName regionId:(NSString *)regionId
{
    for (ELInterviewPlaceCtl *placeCtl in interviewPlaceArr) {
        if (placeCtl.placeBtn.tag == selectedBtnTag) {
            [placeCtl.placeBtn setTitle:regionName forState:UIControlStateNormal];
            placeCtl.ydrId = regionId;
            return;
        }
    }
}

//判断是否存在相同的时间 地点
- (void)haveSameAddress
{
    for (NSInteger i = 0; i < interviewPlaceArr.count; i++) {
        ELInterviewPlaceCtl *ctl1 = [interviewPlaceArr objectAtIndex:i];
        
        for (NSInteger j = i+1; j < interviewPlaceArr.count; j++)
        {
            ELInterviewPlaceCtl *ctl2 = [interviewPlaceArr objectAtIndex:j];
            if ([ctl1.timeBtn.titleLabel.text isEqualToString:ctl2.timeBtn.titleLabel.text] && [ctl1.placeBtn.titleLabel.text isEqualToString:ctl2.placeBtn.titleLabel.text]) {
                isHaveSameAddress = YES;
                return;
            }
            else
            {
                isHaveSameAddress = NO;
            }
        }
    }
    
    /*
    if (interviewPlaceArr.count == 2) {
        ELInterviewPlaceCtl *ctl1 = [interviewPlaceArr firstObject];
        ELInterviewPlaceCtl *ctl2 = [interviewPlaceArr lastObject];
            
        if ([ctl1.timeBtn.titleLabel.text isEqualToString:ctl2.timeBtn.titleLabel.text] && [ctl1.placeBtn.titleLabel.text isEqualToString:ctl2.placeBtn.titleLabel.text]) {
            isHaveSameAddress = YES;
        }
        else
        {
            isHaveSameAddress = NO;
        }
    }
    else if (interviewPlaceArr.count == 3)
    {
        ELInterviewPlaceCtl *ctl1 = [interviewPlaceArr firstObject];
        ELInterviewPlaceCtl *ctl2 = [interviewPlaceArr objectAtIndex:1];
        ELInterviewPlaceCtl *ctl3 = [interviewPlaceArr lastObject];
        
        if ([ctl1.timeBtn.titleLabel.text isEqualToString:ctl2.timeBtn.titleLabel.text] && [ctl1.placeBtn.titleLabel.text isEqualToString:ctl2.placeBtn.titleLabel.text]) {
            isHaveSameAddress = YES;
        }
        else if ([ctl1.timeBtn.titleLabel.text isEqualToString:ctl3.timeBtn.titleLabel.text] && [ctl1.placeBtn.titleLabel.text isEqualToString:ctl3.placeBtn.titleLabel.text])
        {
            isHaveSameAddress =  YES;
        }
        else if ([ctl2.timeBtn.titleLabel.text isEqualToString:ctl3.timeBtn.titleLabel.text] && [ctl2.placeBtn.titleLabel.text isEqualToString:ctl3.placeBtn.titleLabel.text])
        {
            isHaveSameAddress = YES;
        }
        else
        {
            isHaveSameAddress = NO;
        }
    }
     */
}


/**
 * 行家为某约谈提供最多三项（时间+地点）的组合，可批量添加
 * @param  integer $hangjia_id     行家用户编号
 * @param  interger $record_id     约谈记录编号
 * @param  array   $timeRegionInfo 时间+地点的组合，如：
 *                                 [{"time":"2015-11-3 10:33:41","ydr_id":"123"},{"time":"2015-11-3 10:33:53","ydr_id":"456"}]
 * @param  array   $conditionArr   外部条件数组
 * @return {"status":"OK","status_desc"=>"这是描述信息"}
 *         {"status":"FAIL","code":"400","status_desc":"单项约谈，时间与地点的组合不能超过3项！"}
 */
- (void)provideTimeAndRegionBatch
{
    NSString *op = @"yl_daoshi_yuetan_region_busi";
    NSString *func = @"provideTimeAndRegionBatch";
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:@"["];
    
    for (NSInteger i = 0; i < interviewPlaceArr.count; i++) {
        ELInterviewPlaceCtl *regionCtl = [interviewPlaceArr objectAtIndex:i];
        NSString *ydrId = regionCtl.ydrId;
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:ydrId forKey:@"ydr_id"];
        [dic setObject:regionCtl.timeBtn.titleLabel.text forKey:@"time"];

        NSString *regionStr = [jsonWrite stringWithObject:dic];
        [mutableStr appendString:regionStr];
        if (i!=interviewPlaceArr.count-1 ) {
            [mutableStr appendString:@","];
        }
    }
    [mutableStr appendString:@"]"];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"hangjia_id=%@&record_id=%@&timeRegionInfo=%@&conditionArr=%@", aspDataModal.dis_personId, aspDataModal.recordId, mutableStr, nil];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        
        Status_DataModal *statuModal = [[Status_DataModal alloc] init];
        statuModal.status_ = result[@"status"];
        statuModal.code_ = result[@"code"];
        statuModal.status_desc = result[@"status_desc"];
        
        [BaseUIViewController showAutoDismissSucessView:@"" msg:statuModal.status_desc];
        if ([statuModal.code_ isEqualToString:@"200"]) {
            [self acceptOrrefuseInterview:@"accept"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }failure:^(NSURLSessionDataTask *operation, NSError *error){
        
    }];
}

/**
 * 行家处理约谈请求
 * @param  integer $hangjia_id
 * @param  integer $record_id   约谈记录
 * @param  string  $deal_type   accept表示接受
 *                              reject表示拒绝
 * @return {"status":"OK","code":"200","status_desc":"您已接受该约谈！"}
 *         {"status":"OK","code":"201","status_desc":"您已拒绝该约谈！"}
 */
- (void)acceptOrrefuseInterview:(NSString *)flag
{
    NSString *op = @"yuetan_record_busi";
    NSString *function= @"hangjiaDoCourseRequest";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"hangjia_id=%@&record_id=%@&deal_type=%@", aspDataModal.dis_personId, aspDataModal.recordId, flag];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        
        Status_DataModal *dataModal = [[Status_DataModal alloc] init];
        dataModal.status_ = result[@"status"];
        dataModal.code_ = result[@"code"];
        dataModal.status_desc = result[@"status_desc"];
        if ([dataModal.code_ isEqualToString:@"200"]) {
            
        }
    }failure:^(NSURLSessionDataTask *operation, NSError *error){
        
    }];
}

//重写返回button方法
- (void)backBarBtnResponse:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请添加时间地点供来询者选择，否则约谈无法顺利进行" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 100:
        {
            if (buttonIndex == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case 1000:
        {
            if (buttonIndex == 1) {
                [self provideTimeAndRegionBatch];
            }
        }
            break;
        default:
            break;
    }
}

//显示遮罩View
- (void)showMaskView:(UIView *)showView
{
    maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.0;
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenMaskView)];
    singleRecognizer.numberOfTapsRequired = 1;
    [maskView addGestureRecognizer:singleRecognizer];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:maskView];
    [[[UIApplication sharedApplication] keyWindow] addSubview:showView];
    
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0.5;
        showView.alpha = 1.0;
    }];
}

//隐藏遮罩View
- (void)hiddenMaskView
{
    [UIView animateWithDuration:0.1 animations:^{
        maskView.alpha = 0.0;
        pickerBgView.alpha = 0.0;
        confirmView.alpha = 0.0;
    }completion:^(BOOL finished){
        [maskView removeFromSuperview];
        [pickerBgView removeFromSuperview];
        [confirmView removeFromSuperview];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

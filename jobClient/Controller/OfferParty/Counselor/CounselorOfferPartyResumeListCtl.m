//
//  CounselorOfferPartyResumeListCtl.m
//  jobClient
//
//  Created by YL1001 on 16/9/14.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "CounselorOfferPartyResumeListCtl.h"
#import "ConditionItemCtl.h"
#import "CounselorOfferPartyResumeCell.h"
#import "OfferResumePreviewCtl.h"
#import "OfferPartyTalentsModel.h"

@interface CounselorOfferPartyResumeListCtl ()<ConditionItemCtlDelegate,OfferResumePreviewCtlDelegate>
{
    
    __weak IBOutlet UIButton *_typeBtn;
    __weak IBOutlet UITextField *_keyWordTF;
    __weak IBOutlet UIView *_searchBgView;
    __weak IBOutlet NSLayoutConstraint *_searchBgViewLeadSpace;
    __weak IBOutlet UIButton *_searchBtn;
    __weak IBOutlet UIImageView *_triangleImgView;
    
    NSString *_status;     //筛选条件
    NSString *_keywords;   //关键词
    
    BOOL _isShowReSetBtn;  //显示重置密码按钮
}
@end

@implementation CounselorOfferPartyResumeListCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _searchBgView.layer.borderWidth = 1;
    _searchBgView.layer.borderColor = UIColorFromRGB(0xececec).CGColor;
    
    if (_resumeListType == OPResumeListTypeAllResume || _resumeListType == OPResumeListTypeConfirmToAttend) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:@"CHRResumeListCtlRefresh" object:nil];
    }
    
    if (_resumeListType == OPResumeListTypeAllResume || _resumeListType == OPResumeListTypeConfirmToAttend || _resumeListType == OPResumeListTypeHasPresent) {
        _typeBtn.hidden = NO;
        _triangleImgView.hidden = NO;
        _searchBgViewLeadSpace.constant = 88;
    }
    else
    {
        _typeBtn.hidden = YES;
        _triangleImgView.hidden = YES;
        _searchBgViewLeadSpace.constant = 10;
    }
    
    _isShowReSetBtn = [self compareOfferPartyDate];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)refreshList:(NSNotification *)noty
{
    [self refreshLoad];
}

#pragma mark - 数据请求
- (void)beginLoad:(id)param exParam:(id)exParam
{
    [super beginLoad:param exParam:exParam];
    
    [self requestListData];
}

- (void)requestListData
{
    NSString *personType = [NSString stringWithFormat:@"%ld", (long)_resumeListType];
    
    NSString * function = @"getPersonListBysalerId";
    NSString * op = @"offerpai_busi";
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    if (!_keywords) {
        _keywords = @"";
    }
    [conditionDic setObject:_keywords forKey:@"search_name"];
    
    if (_status) {//状态
        [conditionDic setObject:_status forKey:@"ztai"];
    }
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"jobfair_id=%@&saler_id=%@&person_type=%@&conditionArr=%@",self.jobfair_id, [Manager getHrInfo].salerId, personType, conDicStr];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dic = result;
        [self parserPageInfo:dic];
        
        NSArray *dataArr = dic[@"data"];
        if ([dataArr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dataDic in dataArr) {
                User_DataModal *model = [[User_DataModal alloc]init];
                @try {
                    model.userId_ = dataDic[@"person_id"];
                    model.joinState = dataDic[@"join_state"];
                    model.jobfair_person_id = dataDic[@"jobfair_person_id"];
                    model.resumeId = dataDic[@"resume_id"];
                    model.recommendId = dataDic[@"tuijian_id"];
                    model.img_ = dataDic[@"pic"];
                    model.uname_ = dataDic[@"person_name"];
                    model.name_ = dataDic[@"person_name"];
                    model.isCanContract = dataDic[@"is_contract"];
                    model.isDown = dataDic[@"isdown"];
                    model.regionCity_ = dataDic[@"region"];
                    model.gzNum_ = dataDic[@"gznum"];
                    model.eduName_ = dataDic[@"eduId"];
                    model.job_ = dataDic[@"job"];
                    model.sendtime_ = dataDic[@"add_time"];
                    model.mobile_ = dataDic[@"shouji"];
                    model.sex_ = dataDic[@"sex"];
                    model.age_ = dataDic[@"nianling"];
                    model.filePath = dataDic[@"evaluate_filepath"];
                    model.pages = dataDic[@"pages"];
                    model.resumeType = [dataDic[@"recom_status"] integerValue];
                    model.joinstate = [dataDic[@"join_state"] integerValue];
                    model.isNewmail_ = [[dataDic objectForKey:@"newmail"] boolValue];
                    model.tuijianName = dataDic[@"tuijian_name"];
                    
                    if ([dataDic[@"recom_status"] integerValue ]== 8) {
                        model.resumeType = OPResumeTypeToInterview;//等候面试
                    }else if ([dataDic[@"recom_status"] integerValue ]== 6){
                        model.resumeType = OPResumeTypeInterviewed;//面试合格
                    }
                    
                    model.leaveState = dataDic[@"leave_state"];
                    if([dataDic[@"leave_state"] isEqualToString:@"1"]){
                        model.resumeType = OPResumeTypeLeaved;//已经离场
                    }
                    [_dataArray addObject:model];
                }
                @catch (NSException *exception) {
                    
                }
            }
        }
        
        [self.tableView reloadData];
        [self finishReloadingData];
        [self refreshEGORefreshView];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self finishReloadingData];
        [self refreshEGORefreshView];
    }];
}

#pragma mark - 代理
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"CounselorOfferPartyResumeCell";
    CounselorOfferPartyResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"CounselorOfferPartyResumeCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    User_DataModal *userModel = _dataArray[indexPath.row];
    cell.resumelistType = _resumeListType;
    cell.userModel = userModel;
    
    //不在判断是否到场 2016-11-29
    if (_resumeListType == OPResumeListTypeAllResume /*&& userModel.joinstate == 1 */&& [self.fromtype isEqualToString:@"offer"]) {
        if (_isShowReSetBtn) {
            cell.resetPasswordBtn.hidden = NO;
        }
    }
    else {
        cell.resetPasswordBtn.hidden = YES;
    }
    cell.resetPasswordBtn.tag = indexPath.row;
    [cell.resetPasswordBtn addTarget:self action:@selector(resetPasswordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_keyWordTF isFirstResponder]) {
        [_keyWordTF resignFirstResponder];
    }
    
    User_DataModal *userModel = _dataArray[indexPath.row];

    OfferResumePreviewCtl *offResumeCtl = [[OfferResumePreviewCtl alloc] init];
    if (userModel.jlType.length > 0 && userModel.recommendId.length > 0) {
        offResumeCtl.isRecommend = YES;
    }
    else{
        offResumeCtl.isRecommend = NO;
    }
    
    offResumeCtl.resumeListType = _resumeListType;
    offResumeCtl.delegate_ = self;
    offResumeCtl.jobfair_id = _jobfair_id;
    offResumeCtl.consultantCompanyFlag = NO;
    
    [self.navigationController pushViewController:offResumeCtl animated:YES];
    [offResumeCtl beginLoad:userModel exParam:nil];

}

#pragma mark scrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(scrollView == self.tableView){
        [_keyWordTF resignFirstResponder];
    }
}

#pragma mark ConditionItemCtlDelegate
- (void)conditionSeletedOK:(conditionType)type conditionName:(NSString *)conditionName conditionValue:(NSString *)conditionValue conditionValue1:(NSString *)conditionValue1
{
    [_typeBtn setTitle:conditionName forState:UIControlStateNormal];
    
    _status = conditionValue;
    if ([conditionValue isEqualToString:@"0"])
    {//所有人才
        _status = nil;
    }
    
    [self refreshDataSource];
}

#pragma mark OfferResumePreviewCtlDelegate
- (void)rejectResume:(User_DataModal *)dataModal passed:(BOOL)bePassed
{
    [self refreshLoad];
}

#pragma mark - BtnClick
- (void)btnResponse:(id)sender
{
    if (sender == _typeBtn) {
        ConditionItemCtl *conditionCtl = [[ConditionItemCtl alloc]init];
        conditionCtl.delegate_ = self;
        [self.navigationController pushViewController:conditionCtl animated:YES];
        if (_resumeListType == OPResumeListTypeHasPresent) {
            [conditionCtl beginLoad:@[@[@"所有", @"已推荐", @"未推荐", @"等候面试", @"初次面试合格"], @[@"0", @"2", @"1", @"3", @"6"]] exParam:nil];
        }else{
            [conditionCtl beginLoad:@[@[@"所有", @"已推荐", @"未推荐"], @[@"0", @"2", @"1"]] exParam:nil];
        }
    }
    else if (sender == _searchBtn)
    {
        [_keyWordTF resignFirstResponder];
        _keywords = _keyWordTF.text;
        [self refreshDataSource];
    }
}

//重置密码
- (void)resetPasswordBtnClick:(UIButton *)sender
{
    NSString *op = @"resume_salary_busi";
    NSString *func = @"resetPassword";
    
    User_DataModal *userModel = _dataArray[sender.tag];
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&sa_user=%@", userModel.userId_, [Manager getHrInfo].userName];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dic = result;
        Status_DataModal *modal = [[Status_DataModal alloc] init];
        modal.status_ = dic[@"status"];
        modal.code_ = dic[@"code"];
        modal.status_desc = dic[@"status_desc"];
        
        [BaseUIViewController showAutoDismissSucessView:nil msg:modal.status_desc];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (BOOL)compareOfferPartyDate
{
    // 当前时间字符串格式
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval1 = [date timeIntervalSince1970];
    

    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString* string = self.jobfair_time;
    NSDate* inputDate = [inputFormatter dateFromString:string];
    NSTimeInterval timeInterval2 = [inputDate timeIntervalSince1970];
    
    //15分钟 到 4小时之间
    if ((timeInterval1 - timeInterval2 >= 15 * 60) && (timeInterval1 - timeInterval2 <= 4 * 60 * 60)) {
        return YES;
    }
    
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

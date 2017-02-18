//
//  ELExpertCourseListCtl.m
//  jobClient
//
//  Created by YL1001 on 15/10/9.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELExpertCourseListCtl.h"
#import "ELCreateCourseCell.h"
#import "ELCreateCourseCtl.h"
#import "ELAspectantDiscuss_Modal.h"
#import "ELAspDisServiceDetailCtl.h"
#import "EditorManifestoCtl.h"
#import "PrestigeInstructionCtl.h"
#import "ELCourseAlertView.h"

@interface ELExpertCourseListCtl () <ELCourseAlertDelegate>
{
    ELCourseAlertView *alertView;
    __weak IBOutlet UIView *_headerView;
    
    ELRequest *courseRequest;
    ELRequest *introRequest;
    
    NSInteger selectRow;
}

@end

@implementation ELExpertCourseListCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getExpertIntro];
    
    [self setNavTitle:@"创建话题"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    addCourseBtn.layer.cornerRadius = 4.0;
    bgImg.layer.cornerRadius = 8.0;
    bgImg.layer.masksToBounds = YES;
    
    expertImg.layer.cornerRadius = 25.0;
    expertImg.layer.masksToBounds = YES;
    
    [expertImg sd_setImageWithURL:[NSURL URLWithString:[Manager getUserInfo].img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    
    [nameBtn setTitle:[Manager getUserInfo].name_ forState:UIControlStateNormal];
    
    position.layer.cornerRadius = 4.0;
    position.layer.masksToBounds = YES;
    position.text = [Manager getUserInfo].zye_;
    
    alertView.layer.cornerRadius = 8.0;
    alertView.layer.masksToBounds = YES;
    
    expertIntroBgView.layer.cornerRadius = 8.0;
    expertIntroBgView.layer.masksToBounds = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isRefresh) {
        [self refreshLoad];
    }
    [self setNavTitle:@"创建话题"];
}

#pragma mark - 请求数据
- (void)beginLoad:(id)param exParam:(id)exParam
{
    [super beginLoad:param exParam:exParam];
    
    [self getCourseList];
}

//课程列表
- (void)getCourseList
{
    NSString *userId = [Manager getUserInfo].userId_;
    
    NSString *op = @"yuetan_record_busi";
    NSString *func = @"getCourseList";
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId forKey:@"person_id"];
    
    self.pageInfo.pageSize_ = 20;
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchStr,conditionStr];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        
        [self parserPageInfo:result];
        
        NSDictionary *dic = result;
        NSArray *dataArray = dic[@"data"];
        if ([dataArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dataDic in dataArray) {
                ELAspectantDiscuss_Modal *aspctModal = [[ELAspectantDiscuss_Modal alloc] init];
                
                aspctModal.dis_personId = dataDic[@"person_id"];
                aspctModal.course_id = dataDic[@"course_id"];
                aspctModal.course_title = dataDic[@"course_title"];
                aspctModal.course_info = dataDic[@"course_intro"];
                aspctModal.course_price = dataDic[@"course_price"];
                aspctModal.course_long = dataDic[@"course_long"];
                aspctModal.course_status = dataDic[@"course_status"];
                aspctModal.personCount = dataDic[@"course_yuetan_cnt"];
                aspctModal.verifyReason = dataDic[@"verify_reason"];
                aspctModal.hasOrder = dataDic[@"_has_yuetan"];
                
                aspctModal.course_title = [MyCommon translateHTML:aspctModal.course_title];
                aspctModal.course_info = [MyCommon translateHTML:aspctModal.course_info];
                aspctModal.verifyReason = [MyCommon translateHTML:aspctModal.verifyReason];
                
                [_dataArray addObject:aspctModal];
            }
        }
        
        [self.tableView reloadData];
        [self finishReloadingData];
        [self refreshEGORefreshView];
        
        if (_dataArray.count <= 0) {
            [self showRefreshNoDateView:NO];
        }
    }failure:^(NSURLSessionDataTask *operation, NSError *error){
        [self finishReloadingData];
        [self refreshEGORefreshView];
    }];
}

//行家信息
- (void)getExpertIntro
{
    NSString *userId = [Manager getUserInfo].userId_;
    
    NSString *op = @"salarycheck_all_busi";
    NSString *func = @"getPersonIntro";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@",userId];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        
        NSDictionary *dic = result;
        NSString *str = dic[@"intro"];
        expertIntroLb.text = [MyCommon translateHTML:str];
        
    }failure:^(NSURLSessionDataTask *operation, NSError *error){
        
    }];
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ELCreateCourseCell";
    ELCreateCourseCell *cell = (ELCreateCourseCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ELCreateCourseCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    ELAspectantDiscuss_Modal *dataModal = [_dataArray objectAtIndex:indexPath.row];
    
    cell.titleLb.text = dataModal.course_title;
    cell.contentLb.text = dataModal.course_info;
    cell.personCount.text = dataModal.personCount;
    cell.courseTime.text = [NSString stringWithFormat:@"%@小时",dataModal.course_long];
    cell.coursePrice.text = [NSString stringWithFormat:@"￥%@元/次",dataModal.course_price];
    
    switch ([dataModal.course_status integerValue]) {
        case 0:
        {
            [cell.status setTitle:@"审核中" forState:UIControlStateNormal];
            cell.contentBgView.backgroundColor = UIColorFromRGB(0xBCBCBC);
        }
            break;
        case 1:
        {
            [cell.status setTitle:@"通过审核" forState:UIControlStateNormal];
        }
            break;
        case 5:
        {
            [cell.status setTitle:@"不合格" forState:UIControlStateNormal];
            cell.contentBgView.backgroundColor = UIColorFromRGB(0xBCBCBC);
        }
            break;
        case 7:
        {
            [cell.status setTitle:@"草稿" forState:UIControlStateNormal];
            cell.contentBgView.backgroundColor = UIColorFromRGB(0xBCBCBC);
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 199;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELAspectantDiscuss_Modal *dataModal = [_dataArray objectAtIndex:indexPath.row];
    selectRow = indexPath.row;
    ELCreateCourseCtl *createcourseCtl = [[ELCreateCourseCtl alloc] init];
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
                _isRefresh = YES;
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
            _isRefresh = YES;
        }
            break;
    }
}

//添加话题
- (IBAction)btnResponse:(id)sender {
    
    if (sender == addCourseBtn) {
        ELCreateCourseCtl *createcourseCtl = [[ELCreateCourseCtl alloc] init];
        [self.navigationController pushViewController:createcourseCtl animated:YES];
        _isRefresh = YES;
    }
    else if (sender == editBtn)
    {
        PersonCenterDataModel *inModal = [[PersonCenterDataModel alloc] init];
        inModal.userModel_.expertIntroduce_ = expertIntroLb.text;
        inModal.userModel_.isExpert_ = YES;
        EditorManifestoCtl * editorCtl = [[EditorManifestoCtl alloc] init];
        editorCtl.block = ^(){
            [self getExpertIntro];
        };
        
        [editorCtl beginLoad:inModal exParam:nil];
        [self.navigationController pushViewController:editorCtl animated:YES];
    }
    else if (sender == ExplainBtn)
    {
        PrestigeInstructionCtl *instructionCtl = [[PrestigeInstructionCtl alloc] init];
        instructionCtl.type = @"1";
        [self.navigationController pushViewController:instructionCtl animated:YES];
    }
}

//跳转到修改详情
-(void)delegateRightBtnClick{
    ELAspectantDiscuss_Modal *dataModal = [_dataArray objectAtIndex:selectRow];
    ELCreateCourseCtl *createcourseCtl = [[ELCreateCourseCtl alloc] init];
    [self.navigationController pushViewController:createcourseCtl animated:YES];
    [createcourseCtl beginLoad:dataModal exParam:nil];
}

//网络异常提示
- (void)showNoNetworkView:(BOOL)flag
{
    //显示
    if( flag ){
        UIView *superView = [self getSuperView];
        UIView *myView = [self getNoNetworkView];
        
        if( superView && myView ){
            [myView removeFromSuperview];
            [superView addSubview:myView];
            
            //set the rect
            CGRect rect = myView.frame;
            rect.origin.x = 0;
            rect.origin.y = 135;
            [myView setFrame:rect];
        }else{
            [MyLog Log:@"error view's super view or error view is null" obj:self];
        }
    }
    //不显示
    else{
        [[self getNoNetworkView] removeFromSuperview];
    }
}


@end

//
//  TheContactListCtl.m
//  jobClient
//
//  Created by 一览iOS on 15-5-7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "TheContactListCtl.h"
#import "InviteFansCtl_Cell.h"

#import "YLAddressBookListCtl.h"

#import "ELGroupDetailCtl.h"
#import "ELWebSocketManager.h"

@interface TheContactListCtl () <UISearchBarDelegate>
{
    BOOL showKeyBoard;
    BOOL isSearch;
    NSMutableArray *selVoArr;//选中的人
    NSMutableArray *selIdx;//选中的indexpath
    YLAddressBookListCtl * addressBookCtl;
}
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@end

@implementation TheContactListCtl


-(id)init
{
    self = [super init];
    bFooterEgo_ = YES;
    _isPushShareCtl = NO;
    return self;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _searchBar.text = @"";
    isSearch = NO;
    
    if (requestCon_ && ([requestCon_.dataArr_  count] == 0 || _shouldRefresh) )
    {
        [self refreshLoad:nil];
        _shouldRefresh = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_searchBar resignFirstResponder];
    
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_  egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        _shouldRefresh = YES;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_isPersonChat) {
        [self setNavTitle:@"发起会话"];
        myRightBarBtnItem_.hidden = YES;
    }
    else
    {
        [self setNavTitle:@"发起群聊"];
//        tableView_.editing = YES;
//        tableView_.allowsMultipleSelection = YES;
    }
    _searchBar.delegate = self;
    _searchBar.tintColor = UIColorFromRGB(0xe13e3e);
}


-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    selVoArr = [NSMutableArray array];
    selIdx = [NSMutableArray array];
}

-(void)getDataFunction:(RequestCon *)con
{
    NSString *searchStr = @"";
    if (isSearch) {
        searchStr = _searchBar.text;
    }
    [con getFriendWithUserId:[Manager getUserInfo].userId_ pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:15 groupId:@"" personIname:searchStr];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {

        case Request_GetFriend:
        {
            _shouldRefresh = NO;
            if (dataArr.count <= 0) {
                self.imgTopSpace = 60;
                self.noDataImgStr = @"img_search_noData.png";
                self.noDataTips = @"暂无相关结果，替换关键词再试试吧";
            }
        }
            break;
            
        case Request_getShareMessageOther:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            
            if ([dataModal.status_ isEqualToString:Success_Status])
            {
                [BaseUIViewController showAutoDismissSucessView:@"分享成功" msg:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [BaseUIViewController showAutoDismissFailView:dataModal.des_ msg:@"请稍后再试"];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InviteFansCtl_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    ELSameTradePeopleFrameModel * dataModal = requestCon_.dataArr_[indexPath.row];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if (_isPushShareCtl){
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        else{
//            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
//        }
//        cell.tintColor = UIColorFromRGB(0xe13e3e);
        
        UIImageView *markImg = [[UIImageView alloc]initWithFrame:CGRectMake(16, 17, 21, 21)];
        markImg.image = [UIImage imageNamed:@"ic_check_box_outline@2x"];
        markImg.tag = 10;
        [cell.contentView addSubview:markImg];
        
        UIImageView *imageTitle = [[UIImageView alloc] initWithFrame:CGRectMake(49,9,36,36)];
        imageTitle.clipsToBounds = YES;
        imageTitle.tag = 100;
        imageTitle.layer.cornerRadius = 3.0f;
        [cell.contentView addSubview:imageTitle];
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(imageTitle.frame.origin.x + imageTitle.frame.size.width + 4,15,250,25)];
        titleLable.font = FIFTEENFONT_TITLE;
        titleLable.tag = 200;
        [cell.contentView addSubview:titleLable];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10,54,ScreenWidth - 10,1)];
        image.image = [UIImage imageNamed:@"gg_home_line2@2x.png"];
        [cell.contentView addSubview:image];
        
        UIImageView *imageExpert = [[UIImageView alloc] initWithFrame:CGRectMake(imageTitle.frame.origin.x + imageTitle.frame.size.width + 4,20,13,15)];
        imageExpert.tag = 300;
        imageExpert.image = [UIImage imageNamed:@"expertsmark.png"];
        [cell.contentView addSubview:imageExpert];
    }
    
    UIImageView *titleImage = (UIImageView *)[cell viewWithTag:100];
    [titleImage sd_setImageWithURL:[NSURL URLWithString:dataModal.peopleModel.person_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    
    UILabel *titleLb = (UILabel *)[cell viewWithTag:200];
    titleLb.text = dataModal.peopleModel.person_iname;
    
    UIImageView *imageExpertView = (UIImageView *)[cell viewWithTag:300];
//    imageExpertView.alpha = 0.0;
//    titleLb.frame = CGRectMake(titleImage.frame.origin.x + titleImage.frame.size.width + 4,15,250,25);
    
    UIImageView *mark = (UIImageView *)[cell viewWithTag:10];
    
    if (_isPersonChat) {
        mark.hidden = YES;
        titleImage.frame = CGRectMake(16,9,36,36);
        if ([dataModal.peopleModel.is_expert boolValue]) {
            imageExpertView.alpha = 1.0;
            titleLb.frame = CGRectMake(titleImage.frame.origin.x + titleImage.frame.size.width + 4 + 20,15,250,25);
            imageExpertView.frame = CGRectMake(titleImage.frame.origin.x + titleImage.frame.size.width + 4, 20,13,15);
        }
        else{
            imageExpertView.alpha = 0;
            titleLb.frame = CGRectMake(titleImage.frame.origin.x + titleImage.frame.size.width + 4,15,250,25);
        }
    }
    else{
        mark.hidden = NO;
        titleImage.frame = CGRectMake(49,9,36,36);
        
        if ([dataModal.peopleModel.is_expert boolValue]) {
            imageExpertView.alpha = 1.0;
            titleLb.frame = CGRectMake(titleImage.frame.origin.x + titleImage.frame.size.width + 4 + 20,15,250,25);
        }
        else{
            imageExpertView.alpha = 0;
            titleLb.frame = CGRectMake(titleImage.frame.origin.x + titleImage.frame.size.width + 4,15,250,25);
        }
        
        NSLog(@"%@",selVoArr);
        if ([selIdx containsObject:indexPath]) {
            mark.image = [UIImage imageNamed:@"ic_check_box@2x"];
        }
        else{
            mark.image = [UIImage imageNamed:@"ic_check_box_outline@2x"];
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    NSLog(@"%ld",(long)indexPath.row);
    if (_isPersonChat) {
        if (!showKeyBoard)
        {
            ELSameTradePeopleFrameModel * dataModal = requestCon_.dataArr_[indexPath.row];
            if(_isPushShareCtl)
            {
                if (!shareCon) {
                    shareCon = [self getNewRequestCon:NO];
                }
                [shareCon getShareMessageWithSend_uid:[Manager getUserInfo].userId_ receiveId:dataModal.peopleModel.personId receiveName:dataModal.peopleModel.person_iname content:_shareDataModal.shareContent dataModal:_shareDataModal];
            }
            else
            {
                MessageContact_DataModel *modal = [[MessageContact_DataModel alloc] init];
                modal.userId = dataModal.peopleModel.personId;
                modal.userIname = dataModal.peopleModel.person_iname;
                MessageDailogListCtl *ctl = [[MessageDailogListCtl alloc]init];
                [self.navigationController pushViewController:ctl animated:YES];
                [ctl beginLoad:modal exParam:nil];
                
            }
        }
        else
        {
            [_searchBar resignFirstResponder];
        }

    }
    else{
        ELSameTradePeopleFrameModel * dataModal = requestCon_.dataArr_[indexPath.row];
        
        if (![selIdx containsObject:indexPath]) {
            [selVoArr addObject:dataModal];
            [selIdx addObject:indexPath];
        }
        else{
            NSInteger nowIdx = [selIdx indexOfObject:indexPath];
            [selVoArr removeObjectAtIndex:nowIdx];
            [selIdx removeObject:indexPath];
        }
        
        if(selVoArr.count > 0){
            [_sureBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        }
        else{
            [_sureBtn setTitleColor:UIColorFromRGB(0xf3b4b4) forState:UIControlStateNormal];
        }
        [tableView reloadData];
    }
}

////取消选择cell
//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ELSameTradePeopleFrameModel * dataModal = requestCon_.dataArr_[indexPath.row];
//    if ([selVoArr containsObject:dataModal]) {
//        [selVoArr removeObject:dataModal];
//    }
//    if ([selIdx containsObject:indexPath]) {
//        [selIdx removeObject:indexPath];
//    }
//    if(selVoArr.count > 0){
//        [_sureBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
//    }
//    else{
//        [_sureBtn setTitleColor:UIColorFromRGB(0xf3b4b4) forState:UIControlStateNormal];
//    }
//    [tableView reloadData];
//}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_isPersonChat) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 79)];
        headerView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.frame = CGRectMake(0, 0, ScreenWidth, 55);
        [btn setImage:[UIImage imageNamed:@"icon_contactbook@2x"] forState:UIControlStateNormal];
        [btn setTitle:@"通讯录好友" forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 26, 0, 0)];
        [btn setTitleColor:UIColorFromRGB(0x212121) forState:UIControlStateNormal] ;
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn addTarget:self action:@selector(friendListClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btn];
        
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(16, 55, ScreenWidth-16, 24)];
        lb.backgroundColor = UIColorFromRGB(0xf8f8f8);
        lb.textColor = UIColorFromRGB(0x9e9e9e);
        lb.text = @"最近联系人";
        lb.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:lb];
        return headerView;
    }
    else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_isPersonChat) {
        return 79;
    }
    else{
        return 0.0000001;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

#pragma mark - SearchBarDelegate

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (isSearch && [searchBar.text isEqualToString:@""]) {
        isSearch = NO;
        [self refreshLoad:nil];
    }
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = [MyCommon removeAllSpace:searchBar.text];
    
    isSearch = YES;
    
    [self refreshLoad:nil];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    showKeyBoard = YES;
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    showKeyBoard = NO;
    return YES;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

-(void)hideKeyboard
{
    [_searchBar resignFirstResponder];
}

#pragma mark--事件
-(IBAction)sureClick:(UIButton *)sender{
    _sureBtn.enabled = NO;
    //RequestCon *con = [self getNewRequestCon:YES];
    if (selVoArr.count > 0) {
       // [con newGroupUserId:[Manager getUserInfo].userId_ members:selVoArr];
         NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
        for(int i = 0;i < selVoArr.count;i++){
            //SBJsonWriter * json = [[SBJsonWriter alloc] init];
            ELSameTradePeopleFrameModel * vo = selVoArr[i];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:vo.peopleModel.personId forKey:@"id"];
            [dic setObject:vo.peopleModel.person_iname forKey:@"name"];
            
            //NSString *jsonDicStr = [json stringWithObject:dic];
            [conditionDic setObject:dic forKey:[NSString stringWithFormat:@"%d",i]];
        }
        
        SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
        
        NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
        //设置请求参数
        NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&members=%@&option=%@",[Manager getUserInfo].userId_,conditionStr,@""];
        NSString * function = @"launchGroupChat";
        NSString * op = @"groups_busi";
        [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
            _sureBtn.enabled = YES;
            NSDictionary *dic = (NSDictionary *)result;
            NSDictionary *infoDic = dic[@"info"];
            if ([dic[@"status"] isEqualToString:@"OK"] && [dic[@"code"] isEqualToString:@"200"]) {
                [[ELWebSocketManager defaultManager] openServer];
                ELGroupDetailCtl *groupvc = [[ELGroupDetailCtl alloc]init];
                groupvc.isSwipe = YES;
                [groupvc beginLoad:infoDic[@"group_id"] exParam:nil];
                [self.navigationController pushViewController:groupvc animated:YES];
            }
            else if([dic[@"status"] isEqualToString:@"FAIL"] && [dic[@"code"] isEqualToString:@"301"]){
                [BaseUIViewController showAutoDismissFailView:@"" msg:@"此社群名已经创建过" seconds:1];
            }
            else{
                [BaseUIViewController showAutoDismissFailView:@"" msg:@"创建社群失败" seconds:1];
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
             _sureBtn.enabled = YES;
        }];
    }
}

-(void)friendListClick:(UIButton *)sender{
    if ([MFMessageComposeViewController canSendText])
    {
        ABAddressBookRef addressBooks = nil;
        
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        
        //获取通讯录权限
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        BOOL accessStatus = [[Manager shareMgr] getAddressBookAccessStatusWithCancel:^{}];
        if (!accessStatus) {
            return;
        }
        
        if (!addressBooks)
        {
            return ;
        }
        BOOL isFirst = NO;
        if (!addressBookCtl)
        {
            addressBookCtl = [[YLAddressBookListCtl alloc] init];
            isFirst = YES;
        }
        addressBookCtl.whereForm = @"YLFRIEND";
//        _phoneCount = 0;
        [tableView_ reloadData];
        [[Manager shareMgr].messageCenterListCtl refreshAddressBookRedDot];
        [self.navigationController pushViewController:addressBookCtl animated:YES];
        
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"addressBookTelephoneList"];
        NSArray *arrOne = [[NSUserDefaults standardUserDefaults] objectForKey:@"userListId"];
        NSString *currentPersonId = [[NSUserDefaults standardUserDefaults] objectForKey:@"addressBookCurrentPersonId"];
        if (arr == nil || arrOne == nil || ![arrOne containsObject:[Manager getUserInfo].userId_])
        {
            
        }
        else if(isFirst || ![currentPersonId isEqualToString:[Manager getUserInfo].userId_])
        {
            [BaseUIViewController showLoadView:YES content:nil view:nil];
        }
    }
    else
    {
        [BaseUIViewController showAlertView:@"设备没有短信功能" msg:nil btnTitle:@"关闭"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

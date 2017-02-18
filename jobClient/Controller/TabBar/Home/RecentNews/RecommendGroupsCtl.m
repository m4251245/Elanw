//
//  RecommendGroupsCtl.m
//  Association
//
//  Created by 一览iOS on 14-1-21.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "RecommendGroupsCtl.h"
#import "RecommendGroups_Cell.h"
//#import "ZBarScanLoginCtl.h"
#import "NoLoginPromptCtl.h"

@interface RecommendGroupsCtl () <NoLoginDelegate>
{
    BOOL shouldBeginEditing;
    
}

@property (strong, nonatomic) IBOutlet UILabel *headerLable;


@end

@implementation RecommendGroupsCtl
@synthesize searchBar_,type_;

-(id)init
{
    self = [super init];
    
    imageConArr_ = [[NSMutableArray alloc] init];
    bFooterEgo_ = YES;
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //增加键盘事件的通知
        shouldBeginEditing = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
    
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"加入新社群";
    [self setNavTitle:@"加入新社群"];
    searchBar_.delegate = self;
    searchBar_.backgroundColor = [UIColor whiteColor];
    searchBar_.tintColor = UIColorFromRGB(0xe13e3e);
    tableView_.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
    tableView_.backgroundView = nil;
    topView_.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
    topView_.layer.borderWidth = 0.5;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_.showsVerticalScrollIndicator = NO;
    
    CALayer *layer=[searchBar_ layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:0.0];
    [layer setBorderWidth:1];
    [layer setBorderColor:[[UIColor clearColor] CGColor]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
//    self.navigationItem.title = @"加入新社群";
    if ([requestCon_.dataArr_  count] == 0) {
        [self refreshLoad:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [searchBar_ resignFirstResponder];
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_  egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

-(void)getDataFunction:(RequestCon *)con
{
    NSString * userId = [Manager getUserInfo].userId_;
    if (!userId || [userId isEqualToString:@""]) {
        userId = @"";
    }
    [con getGroupsBySearch:userId keyword:searchBar_.text page:requestCon_.pageInfo_.currentPage_ pageSize:10];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_JoinGroup:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            UIButton *btn = (UIButton *)[tableView_ viewWithTag:indexTag+1000];
            Groups_DataModal *model = [requestCon_.dataArr_ objectAtIndex:indexTag];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                if ([dataModal.code_ isEqualToString:@"200"]) {
                    //审核中
                    [btn setTitle:@"已申请" forState:UIControlStateNormal];
                    [btn.titleLabel setTextColor:GRAYCOLOR];
                    btn.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
                    [btn setUserInteractionEnabled:NO];
                    [btn setHidden:NO];
                    model.code_ = @"199";
                    [BaseUIViewController showAutoDismissSucessView:@"申请成功,等待审核" msg:nil];
                }else if ([dataModal.code_ isEqualToString:@"100"]){
                    [btn setHidden:YES];
                    model.code_ = @"11";
                    [BaseUIViewController showAutoDismissSucessView:@"加入成功" msg:nil];
                    //刷新社群列表
                    Groups_DataModal *dataModal = [requestCon_.dataArr_ objectAtIndex:indexTag];
                    ELGroupDetailCtl *detaliCtl = [[ELGroupDetailCtl alloc]init];
                    detaliCtl.delegate = self;
                    [self.navigationController pushViewController:detaliCtl animated:YES];
                    [detaliCtl beginLoad:dataModal exParam:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CREATEGROUPSUCCESS" object:nil];
                }
            }
            
            else
            {
                [BaseUIViewController showAutoDismissFailView:dataModal.des_ msg:@"请稍后再试"];
            }
        }
            break;
        case Request_SearchGroup:
        {
            //zbarBtn_.alpha = 1.0;
        }
            break;
        case Request_RecommendGroup:
        {
            //zbarBtn_.alpha = 1.0;
        }
            break;
        case Request_Image:
        {
            @try {
                for (Groups_DataModal * dataModal in requestCon_.dataArr_) {
                    if (![dataModal.pic_ isEqual:[NSNull null]]) {
                        if ([dataModal.pic_ isEqualToString:requestCon.url_]) {
                            dataModal.imageData_ = [dataArr objectAtIndex:0];
                        }
                    }
                    
                }
                [imageConArr_ removeObject:requestCon];
                [tableView_ reloadData];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }

        }
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecommendGroupsCtlCell";
    RecommendGroups_Cell *cell = (RecommendGroups_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecommendGroups_Cell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }

    Groups_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    
    [cell cellGiveDataWith:dataModal];
    
    [cell.joinBtn_ addTarget:self action:@selector(jionClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.joinBtn_ setTag:indexPath.row + 1000];
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 132;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (![Manager shareMgr].haveLogin) {
        return 40.0f;
    }
    return 0.1f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (![Manager shareMgr].haveLogin) {
        return _headerLable;
    }
    UIView *view = [[UIView alloc] init];
    return view;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [searchBar_ resignFirstResponder];
    
    if ([Manager shareMgr].haveLogin) {
        [super loadDetail:selectData exParam:exParam indexPath:indexPath];
        ELGroupDetailCtl *detaliCtl = [[ELGroupDetailCtl alloc]init];
        detaliCtl.delegate = self;
        [self.navigationController pushViewController:detaliCtl animated:YES];
        [detaliCtl beginLoad:selectData exParam:nil];
    }
    
    else
    {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
       // [ self showChooseAlertView:1 title:@"无法查看社群详情" msg:@"请先登录" okBtnTitle:@"登录" cancelBtnTitle:@"取消"];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self beginLoad:nil exParam:nil];
    searchBar_.text = @"";
    [searchBar_ resignFirstResponder];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar_ resignFirstResponder];
    searchBar_.text = [searchBar_.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self refreshLoad:nil];

}

- (void)jionClick:(UIButton *)btn
{
    if ([Manager shareMgr].haveLogin) {
        Groups_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:btn.tag - 1000];
        indexTag = btn.tag - 1000;
        //私密社群
        if (!joinCon_) {
            joinCon_ = [self getNewRequestCon:NO];
        }
        if([dataModal.openstatus_ isEqualToString:@"3"]){
            JionGroupReasonCtl *jionGroupCtl = [[JionGroupReasonCtl alloc]init];
            jionGroupCtl.delegate = self;
            [jionGroupCtl beginLoad:dataModal exParam:nil];
            [self.navigationController pushViewController:jionGroupCtl animated:YES];
        }else{
             //其他社群
            [joinCon_ joinGroup:[Manager getUserInfo].userId_ group:dataModal.id_ content:@""];
        }
    }else{
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        //[ self showChooseAlertView:1 title:@"无法加入社群" msg:@"请先登录" okBtnTitle:@"登录" cancelBtnTitle:@"取消"];
    }
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    BOOL boolToReturn = shouldBeginEditing;
    shouldBeginEditing = YES;
    return boolToReturn;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchBar isFirstResponder]) {
        shouldBeginEditing = NO;
        if ([searchBar_.text length] == 0) {
            [searchBar_ resignFirstResponder];
            
        }

    }
}

-(void)btnResponse:(id)sender
{
    if (sender==zbarBtn_) {
        
        if ([Manager shareMgr].haveLogin) {
//            ZBarScanLoginCtl *ctl = [[ZBarScanLoginCtl alloc] init];
            ELScanQRCodeCtl *ctl = [[ELScanQRCodeCtl alloc] init];
            ctl.isZbar = YES;
            [self.navigationController pushViewController:ctl animated:YES];
        }
        else
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            //[self showChooseAlertView:1 title:@"无法加入社群" msg:@"请先登录" okBtnTitle:@"登录" cancelBtnTitle:@"取消"];
        }
    }

//    if (sender == searchBtn_) {
//        [searchBar_ resignFirstResponder];
//        searchBar_.text = [searchBar_.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//        [self refreshLoad:nil];
//    }
    
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

-(void)updateCell
{
    
}

-(void)backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
    searchBar_.text = @"";
    [searchBar_ resignFirstResponder];
}

#pragma ELGroupDetailCtlDelegate
-(void)refresh
{
    [self refreshLoad:nil];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
}

#pragma Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    if( !singleTapRecognizer_ )
        singleTapRecognizer_ = [MyCommon addTapGesture:self.view target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    //singleTapRecognizer_.delegate = self;
    
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (singleTapRecognizer_) {
        [MyCommon removeTapGesture:self.view ges:singleTapRecognizer_];
        singleTapRecognizer_ = nil;
        
    }
    
}

//自己视图的单击事件
-(void) viewSingleTap:(id)sender
{
    if (singleTapRecognizer_) {
        [MyCommon removeTapGesture:self.view ges:singleTapRecognizer_];
        singleTapRecognizer_ = nil;
        
    }
    [searchBar_ resignFirstResponder];
    
}

#pragma mark - 加入社群成功回调

- (void)joinGroupSuccess
{
    UIButton *btn = (UIButton *)[tableView_ viewWithTag:indexTag+1000];
    Groups_DataModal *model = [requestCon_.dataArr_ objectAtIndex:indexTag];
    [btn setTitle:@"已申请" forState:UIControlStateNormal];
    [btn.titleLabel setTextColor:GRAYCOLOR];
    btn.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
    [btn setUserInteractionEnabled:NO];
    [btn setHidden:NO];
    model.code_ = @"199";
}

@end

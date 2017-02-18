//
//  CareerTailDetailCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-7-9.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "CareerTailDetailCtl.h"
#import "CareerTailDetailCell.h"
#import "ExRequetCon.h"
#import "PositionDetailCtl.h"
#import "ZWDetail_DataModal.h"
#import "NoLoginPromptCtl.h"

#import "NewCareerTalkDataModal.h"

@interface CareerTailDetailCtl () <NoLoginDelegate>
{
    NewCareerTalkDataModal *dataModalOne;
    NSInteger WEB_TAG;
    NSInteger CELL_TAG;
}
@end

@implementation CareerTailDetailCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        bFooterEgo_ = NO;
        rightNavBarStr_ = @"分享";
        WEB_TAG = 1111111;
        CELL_TAG = 11111;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
    
//    self.navigationItem.title = @"宣讲会详情";
    [self setNavTitle:@"宣讲会详情"];
    // Do any additional setup after loading the view from its nib.
    [tableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    isReadData_ = NO;
}

//设置右按扭的属性
-(void) setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"" forState:UIControlStateNormal];
    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if( [rightNavBarStr_ length] >= 4 ){
        [rightBarBtn_ setFrame:CGRectMake(0, 0, 40, 40)];
    }else
        [rightBarBtn_ setFrame:CGRectMake(0, 0, 40, 40)];
    
    rightBarBtn_.titleLabel.font = [UIFont boldSystemFontOfSize:13];//[UIFont boldSystemFontOfSize:14];
    
    
    [rightBarBtn_ setImage:[UIImage imageNamed:@"share_white-2"] forState:UIControlStateNormal];
    //[rightBarBtn_ setBackgroundImage:[UIImage imageNamed:@"icon_share_off"] forState:UIControlStateHighlighted];
}


-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    if (isFollow_ == YES) {
        [attenBtn_ setImage:[UIImage imageNamed:@"bton_attended"] forState:UIControlStateNormal];
        [attenBtn_ setEnabled:NO];
    }else{
        [attenBtn_ setImage:[UIImage imageNamed:@"bton_attend.png"] forState:UIControlStateNormal];
    }
    
}


-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:nil];
    inModal_ = dataModal;
    if ([inModal_.attention isEqualToString:@"1"]) {
        isFollow_ = YES;
    }
}

-(void)getDataFunction:(RequestCon *)con
{
    NSString *userId;
    if ([Manager shareMgr].haveLogin) {
        userId = [Manager getUserInfo].userId_;
    }
    else
    {
        userId = @"";
    }
    [con getXjhDetail:inModal_.xjhId personId:userId];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    
    switch (type) {
        case Request_XjhDetail:
        {
            isReadData_ = YES;
            dataModalOne = [requestCon_.dataArr_ objectAtIndex:0];
            if ([dataModalOne.attention isEqualToString:@"1"]) {
                isFollow_ = YES;
            }
            else
            {
                isFollow_ = NO;
            }
            [tableView_ reloadData];
        }
            break;
        case Request_AttendCareerSchool:
        {
            NSString *status = [dataArr objectAtIndex:0];
            if ([status isEqualToString:@"OK"]) {
                [attenBtn_ setImage:[UIImage imageNamed:@"bton_attended"] forState:UIControlStateNormal];
                [BaseUIViewController showAutoDismissSucessView:@"关注成功" msg:nil];
                inModal_.attention = @"1";
                isFollow_ = YES;
            }else{
                [BaseUIViewController showAutoDismissFailView:@"关注失败" msg:nil];
            }
        }
            break;
        case Request_ChangAttendCareerSchool:
        {
            NSString *status = [dataArr objectAtIndex:0];
            if ([status isEqualToString:@"OK"]) {
                [attenBtn_ setImage:[UIImage imageNamed:@"bton_attend.png"] forState:UIControlStateNormal];
                [BaseUIViewController showAutoDismissSucessView:@"取消关注成功" msg:nil];
                isFollow_ = NO;
            }else{
                [BaseUIViewController showAutoDismissFailView:@"取消关注失败" msg:nil];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([requestCon_.dataArr_ count]!=0) {
        return [requestCon_.dataArr_ count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CareerTailDetailCell";
    
    CareerTailDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CareerTailDetailCell" owner:self options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NewCareerTalkDataModal *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];

    [titleLb_ setText:[MyCommon translateHTML:model.title]];
    //时间处理
    [timeLb_ setText:[NSString stringWithFormat:@"%@",model.sdate]];
    //地址
    [addLb_ setText:[NSString stringWithFormat:@"%@  %@",[MyCommon translateHTML:model.sname], [MyCommon translateHTML:model.addr]]];
    
    if([model.contents length] >= 5)
    {
        if ([[model.contents substringToIndex:5] isEqualToString:@"温馨提示:"]) {
            model.contents = [model.contents substringFromIndex:5];
        }
    }
    [companyName setText:[MyCommon translateHTML:model.cname]];
    
    cell.webView_.delegate = self;
    cell.webView_.scrollView.alwaysBounceHorizontal = YES;
    cell.webView_.userInteractionEnabled = YES;    //勿改
    NSMutableString *webStr = [MyCommon convertHtmlStyle:model.contents];
    NSRange rang;
    rang.location = 0;
    rang.length = [webStr length];
    [webStr replaceOccurrencesOfString:@"<img" withString:[NSString stringWithFormat:@"<img width=%.0f",cell.webView_.frame.size.width-15.0] options:NSCaseInsensitiveSearch range:rang];
    
    [cell.webView_ loadHTMLString:webStr baseURL:nil];
    cell.webView_.tag = WEB_TAG + indexPath.row;
    cell.tag = CELL_TAG + indexPath.row;
    cell.webView_.scrollView.bounces = NO;
    cell.webView_.scrollView.showsHorizontalScrollIndicator = NO;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight_;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (requestCon_.dataArr_.count != 0) {
        if (![dataModalOne.cid isEqualToString:@"0"]) {
            companyView.frame = CGRectMake(0,170,ScreenWidth,40);
            [headView_ addSubview:companyView];
            return 210.0;
        }
    }
    return 170.0;
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return headView_;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CareerTailDetailCell *cell = (CareerTailDetailCell *)[self.view viewWithTag:webView.tag - WEB_TAG + CELL_TAG];
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue];
    height = height > 65? height : 65;
    cell.webHeight.constant = height;
    //    CGRect rect = webView.frame;
    //    rect.size.height = height;
    //    [webView setFrame:rect];
    //    [(UIScrollView *)[[webView subviews] objectAtIndex:0] setBounces:NO];
    //    cellHeight_ = rect.origin.y + rect.size.height + 10;
    cellHeight_ = 180 + height + 10;
    if (isReadData_) {
        isReadData_ = NO;
        [tableView_ reloadData];
    }
}

- (void)btnResponse:(id)sender
{
    if (sender == attenBtn_) {
        if ([Manager shareMgr].haveLogin) {
            if (sender == attenBtn_) {
                if (!attendCon_) {
                    attendCon_ = [self getNewRequestCon:NO];
                }
                //添加关注
                if (isFollow_ == NO) {
                    [attendCon_ attendCareerSchoolWithSchollId:dataModalOne.sid userId:[Manager getUserInfo].userId_];
                }else{
                    [attendCon_ changAttendCareerSchoolWithSchoolId:dataModalOne.sid userId:[Manager getUserInfo].userId_];
                }
            }
        }else{
            if (![Manager shareMgr].haveLogin) {
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                //[ self showChooseAlertView:1 title:@"您尚未登录" msg:@"请先登录" okBtnTitle:@"登录" cancelBtnTitle:@"取消"];
                return;
            }
        }
    }
    else if (sender == companyBtn)
    {
        PositionDetailCtl *ctl = [[PositionDetailCtl alloc] init];
        ctl.type_ = 2;
        NewCareerTalkDataModal *model = [requestCon_.dataArr_ objectAtIndex:0];
        ZWDetail_DataModal *modelOne = [[ZWDetail_DataModal alloc] init];
        modelOne.companyID_ = model.cid;
        modelOne.zwName_ = model.cname;
        modelOne.zwID_ = model.xjhId;
        ctl.isXjh = YES;
        ctl.careerCtl = self;
        [self.navigationController pushViewController:ctl animated:YES];
        
        [ctl beginLoad:modelOne exParam:nil];
    }

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

-(void)rightBarBtnResponse:(id)sender
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1024" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    if (requestCon_.dataArr_.count <= 0) {
        return;
    }
    NewCareerTalkDataModal *myModal_ = [requestCon_.dataArr_ objectAtIndex:0];

    NSString * str = @"";
    @try {
        str = [MyCommon removeHTML2:myModal_.contents];
        str = [MyCommon filterHTML:str];
        str = [MyCommon removeHtmlTags:str];
        str = [str substringToIndex:50];
    }
    @catch (NSException *exception) {
        str = myModal_.contents;
    }
    @finally {
        
    }
    
    NSString * sharecontent = str;
    
    NSString * titlecontent = [NSString stringWithFormat:@"%@",myModal_.title];
    
    sharecontent = [sharecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    titlecontent = [titlecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString * url = [NSString stringWithFormat:@"http://m.job1001.com/xjh/detail/%@.htm",inModal_.xjhId];
    
    //调用分享
    [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url];
}

@end

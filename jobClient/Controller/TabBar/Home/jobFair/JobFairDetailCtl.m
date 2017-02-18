//
//  JobFairDetailCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-7-10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "JobFairDetailCtl.h"
#import "ExRequetCon.h"
#import "JobFairDetailCell.h"
#import "NewCareerTalkDataModal.h"

@interface JobFairDetailCtl (){
    NewCareerTalkDataModal *zphDetailVO;
    NSInteger WEB_TAG;
    NSInteger CELL_TAG;
}

@end

@implementation JobFairDetailCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rightNavBarStr_ = @"分享";
        WEB_TAG = 111111;
        CELL_TAG = 111111111;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
    
//    self.navigationItem.title = @"招聘会详情";
    [self setNavTitle:@"招聘会详情"];
    bFooterEgo_ = NO;
    
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
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:nil];
    zphDetailVO = dataModal;
}

-(void)getDataFunction:(RequestCon *)con
{
    [con getZphDetail:zphDetailVO.xjhId];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    
    
    switch (type) {
        case Request_ZphDetail:
        {
            isReadData_ = YES;
            [tableView_ reloadData];
        }
            break;
        default:
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([requestCon_.dataArr_ count]!=0) {
        return [requestCon_.dataArr_ count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"JobFairDetailCell";
    
    JobFairDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JobFairDetailCell" owner:self options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NewCareerTalkDataModal *detailVO = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    [titleLb_ setText:[MyCommon translateHTML:detailVO.title]];
    CGRect timeAddRect = timeAndAddView_.frame;
    
    CGRect headRect = headView_.frame;
    headRect.size.height = timeAddRect.origin.y+timeAddRect.size.height;
    [headView_ setFrame:headRect];
    tableView_.tableHeaderView = headView_;
    
    //时间处理
    [timeLb_ setText:[NSString stringWithFormat:@"%@",detailVO.sdate]];
    //地址
    [addLb_ setText:detailVO.addr];

    cell.tipsWebView_.delegate = self;
    cell.tipsWebView_.userInteractionEnabled = YES;  //勿改
    NSMutableString *webStr = [MyCommon convertHtmlStyle:detailVO.content];
    NSRange rang;
    rang.location = 0;
    rang.length = [webStr length];
    [webStr replaceOccurrencesOfString:@"<img" withString:[NSString stringWithFormat:@"<img width=%.0f",cell.tipsWebView_.frame.size.width] options:NSCaseInsensitiveSearch range:rang];
    [cell.tipsWebView_ loadHTMLString:webStr baseURL:nil];
    
    cell.tipsWebView_.scrollView.alwaysBounceHorizontal = YES;
    cell.tipsWebView_.scrollView.scrollEnabled = NO;
    cell.tipsWebView_.scrollView.bounces = NO;
    cell.tag = CELL_TAG + indexPath.row;
    cell.tipsWebView_.tag = WEB_TAG + indexPath.row;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight_;
}

#pragma UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    JobFairDetailCell *cell = (JobFairDetailCell *)[self.view viewWithTag:webView.tag - WEB_TAG + CELL_TAG];
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue];
    height = height > 65? height : 65;
    cell.webViewHeight.constant = height;
    cellHeight_ = 100 + height + 10;
    if (isReadData_) {
        isReadData_ = NO;
        [tableView_ reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)rightBarBtnResponse:(id)sender
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1024" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (requestCon_.dataArr_.count <= 0) {
        return;
    }
    NewCareerTalkDataModal *detailVO = [requestCon_.dataArr_ objectAtIndex:0];
    NSString * str = @"";
    @try {
        str = [MyCommon removeHTML2:detailVO.content];
        str = [MyCommon filterHTML:str];
        str = [MyCommon removeHtmlTags:str];
        str = [str substringToIndex:50];
    }
    @catch (NSException *exception) {
        str = detailVO.content;
    }
    @finally {
        
    }
    NSString * sharecontent = str;
    
    NSString * titlecontent = [NSString stringWithFormat:@"%@",detailVO.title];
    
    sharecontent = [sharecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    titlecontent = [titlecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString * url = [NSString stringWithFormat:@"http://m.job1001.com/zph/detail/%@.htm",detailVO.xjhId];
    
    //调用分享
    [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url];
   
}

@end

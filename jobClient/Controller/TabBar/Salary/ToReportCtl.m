//
//  ToReportCtl.m
//  jobClient
//
//  Created by YL1001 on 14/11/28.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "ToReportCtl.h"
#import "ToReportCtl_Cell.h"

@interface ToReportCtl ()
{
    NSArray * titleArr_;
    NSString * seletedStr_;
}

@end

@implementation ToReportCtl

-(id)init
{
    self = [super init];
    rightNavBarStr_ = @"提交";
    bHeaderEgo_ = NO;
    //增加键盘事件的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mykeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mykeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"举报";
    [self setNavTitle:@"举报"];
    
    reasonTX_.delegate = self;
    reasonTX_.placeholder = @"你可以详细描述恶意行为（如帖子当中的不良信息）";
    titleArr_ = [NSArray arrayWithObjects:@"色情",@"谣言",@"欺诈骗钱",@"政治反动",@"广告骚扰",@"其他", nil];
    seletedStr_ = @"";
    tableView_.scrollEnabled = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    inModal_ = dataModal;
    [tableView_ reloadData];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_ToReport:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [BaseUIViewController showAutoDismissSucessView:@"提交成功" msg:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
                [BaseUIViewController showAutoDismissFailView:@"提交失败" msg:dataModal.des_];
        }
            break;
            
        default:
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ToReportCtl_Cell";
    
    ToReportCtl_Cell *cell = (ToReportCtl_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ToReportCtl_Cell" owner:self options:nil] lastObject];
    }
    
    [cell.titleLb_ setText:[titleArr_ objectAtIndex:indexPath.row]];
    if([seletedStr_ isEqualToString:cell.titleLb_.text])
    {
        cell.bChoosedLb_.alpha = 1.0;
    }
    else
        cell.bChoosedLb_.alpha = 0.0;
    
    
    
    return cell;

}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    seletedStr_ = [titleArr_ objectAtIndex:indexPath.row];
    [tableView_ reloadData];
    
    
}

//自己视图的单击事件
-(void) viewSingleTap:(id)sender
{
    [reasonTX_ resignFirstResponder];
}

#pragma UIKeyboardNotification
-(void)mykeyboardWillShow:(NSNotification *)notification
{
    //添加点击事件
    if( !singleTapRecognizer_ )
        singleTapRecognizer_ = [MyCommon addTapGesture:self.view target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    
    [tableView_ setContentOffset:CGPointMake(0, 245) animated:YES];
    
}

-(void)mykeyboardWillHide:(NSNotification *)notification
{
    [MyCommon removeTapGesture:self.view ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    
    [tableView_ setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

-(void)submit
{
    if (!seletedStr_ || [seletedStr_ isEqualToString:@""]) {
        [BaseUIViewController showAlertView:@"请选择相关原因" msg:nil btnTitle:@"确定"];
        return;
    }
    if (!submitCon_) {
        submitCon_ = [self getNewRequestCon:NO];
    }
    [submitCon_ toReportIllegalArticle:seletedStr_ content:reasonTX_.text personId:[Manager getUserInfo].userId_ productCode:@"YL1001_ARTICLE" productId:inModal_.article_id];
}

-(void)rightBarBtnResponse:(id)sender
{
    [reasonTX_ resignFirstResponder];
    [self submit];
}



@end

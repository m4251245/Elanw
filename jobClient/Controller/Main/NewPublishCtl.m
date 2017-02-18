//
//  ExpertPublishCtl.m
//  Association
//
//  Created by YL1001 on 14-6-20.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "NewPublishCtl.h"
#import "MyPubilshCtl_Cell.h"
#import "Article_DataModal.h"
#import "TodayFocus_Cell.h"

#define INDEX_OFFSET 1001
#define CELL_TAG 123456789
@interface NewPublishCtl ()<SalaryIrrigationDetailDelegate>{

}

@end

@implementation NewPublishCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bFooterEgo_ = YES;
        bHeaderEgo_ = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tableView_.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    tableView_.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
    tableView_.backgroundView = nil;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setNavTitle:@"新的发表"];
}


#pragma mark--加载数据
-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    if (!con) {
        con = [self getNewRequestCon:YES];
    }
    [con getNewPublicArticle:[Manager getUserInfo].userId_ pageSize:12 pageIndex:requestCon_.pageInfo_.currentPage_];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type){
        case request_NewPublicArticle:
        {
            [tableView_ reloadData];
        }
            break;
        default:
            break;
    }
}

#pragma mark--tableView 代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return requestCon_.dataArr_.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodayFocusFrame_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    static NSString *reuseIdentifier = @"TodayFocus_Cell";
    TodayFocus_Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"TodayFocus_Cell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        cell.model = dataModal;
        cell.tag = indexPath.row + CELL_TAG;
        cell.tipsLb.hidden = YES;
        if ([dataModal.sameTradeArticleModel._is_new boolValue]) {
            [cell.isNewImg setHidden:NO];
            cell.artilceTitleLb.textColor = [UIColor blackColor];
        }else{
            cell.artilceTitleLb.textColor = UIColorFromRGB(0x666666);
            [cell.isNewImg setHidden:YES];
        }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodayFocusFrame_DataModal *articleModel = requestCon_.dataArr_[indexPath.row];
    return articleModel.height + CELL_MARGIN_TOP;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    TodayFocusFrame_DataModal * dataModal = selectData;
    if ([dataModal.sameTradeArticleModel._is_new  boolValue]) {
        dataModal.sameTradeArticleModel._is_new = @"";
        [tableView_ reloadData];
    }
    ArticleDetailCtl* contentDetailCtl = [[ArticleDetailCtl alloc] init];
    [self.navigationController pushViewController:contentDetailCtl animated:YES];
    [contentDetailCtl beginLoad:dataModal.sameTradeArticleModel.article_id exParam:nil];
    NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"文章详情",NSStringFromClass([self class])]};
    [MobClick event:@"buttonClick" attributes:dict];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

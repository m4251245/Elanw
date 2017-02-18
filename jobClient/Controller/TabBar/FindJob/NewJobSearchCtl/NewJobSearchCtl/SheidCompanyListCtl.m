//
//  SheidCompanyListCtl.m
//  jobClient
//
//  Created by 一览ios on 15/3/3.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "SheidCompanyListCtl.h"
#import "ExRequetCon.h"
#import "SearchCell.h"

@interface SheidCompanyListCtl ()

@end

@implementation SheidCompanyListCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        rightNavBarStr_ = @"搜索";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    bHeaderEgo_ = YES;
    bFooterEgo_ = YES;
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 130, 44)];
    UIImageView *bgImgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, ScreenWidth - 130, 32)];
    [bgImgv setImage:[UIImage imageNamed:@"companysearchBg.png"]];
    [searchView addSubview:bgImgv];
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth - 130, 32)];
    
    searchTextField.delegate = self;
    [searchTextField setPlaceholder:@"搜索公司关键字"];
    [searchTextField setFont:FOURTEENFONT_CONTENT];
    [searchTextField setTextColor:BLACKCOLOR];
    searchTextField.textAlignment = NSTextAlignmentCenter;
    searchTextField.tintColor = GRAYCOLOR;
    
    [searchView addSubview:searchTextField];
    self.navigationItem.titleView = searchView;
    rightNavBarStr_ = @"搜索";
    resultArray = [[NSMutableArray alloc] init];
}


- (void)setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"搜索" forState:UIControlStateNormal];
    rightBarBtn_.layer.cornerRadius = 2.0;
    [rightBarBtn_ setBackgroundColor:[UIColor clearColor]];
    [rightBarBtn_ setFrame:CGRectMake(0, 0, 55, 26)];
    [rightBarBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

- (void)getDataFunction:(RequestCon *)con
{
    [con getCompanyWithCompanyName:keyWordString pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:20];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetCompany:
        {
            if (requestCon.pageInfo_.currentPage_ == 1) {
                resultArray = [dataArr mutableCopy];
            }else{
                [resultArray addObjectsFromArray:dataArr];
            }
        }
            break;
        default:
            break;
    }
}

- (void)rightBarBtnResponse:(id)sender
{
    [searchTextField resignFirstResponder];
    keyWordString = [MyCommon removeSpaceAtSides:searchTextField.text];
    [self refreshLoad:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([resultArray count] !=0) {
        return [resultArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchCell";
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
       cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    WorkApplyDataModel *model = resultArray[indexPath.row];
    cell.nameLb.text = model.companyName_;
    return cell;
}


- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    WorkApplyDataModel *model = [resultArray objectAtIndex:indexPath.row];
    if (self.block) {
        self.block(model.companyName_);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
    [searchTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end

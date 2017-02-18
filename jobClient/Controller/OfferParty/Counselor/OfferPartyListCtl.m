//
//  OfferPartyListCtl.m
//  jobClient
//
//  Created by 一览ios on 15/7/3.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "OfferPartyListCtl.h"
#import "OfferPartyCenterCtl.h"
#import "OfferPartyTalentsModel.h"
#import "ELOfferPartyListCell.h"
#import "ELAnswerLableView.h"

@interface OfferPartyListCtl ()<UITextFieldDelegate, UIGestureRecognizerDelegate>
{
    UITextField *keyWorkTf;
    ELRequest *request;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutY;
@end

@implementation OfferPartyListCtl

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    self.showNoDataViewFlag = YES;
    self.showNoMoreDataViewFlag = YES;
    
    [super viewDidLoad];
//    self.navigationItem.title = @"Offer派 快聘宝 V聘会";
    [self setNavTitle:@"览英荟"];
    //搜索框
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    searchView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:searchView];
    UIImageView *bgImgv = [[UIImageView alloc]init];
    [bgImgv setFrame:CGRectMake(10, 5, ScreenWidth-20, 30)];
    bgImgv.layer.cornerRadius = 6;
    bgImgv.layer.masksToBounds = YES;
    bgImgv.userInteractionEnabled = YES;
    bgImgv.backgroundColor = [UIColor whiteColor];
    [searchView addSubview:bgImgv];
    
    
    keyWorkTf = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 30)];
    keyWorkTf.textAlignment = NSTextAlignmentCenter;
    keyWorkTf.returnKeyType = UIReturnKeySearch;
    keyWorkTf.placeholder = @"请搜索项目名称";//默认文字居中处理
    [keyWorkTf setFont:FOURTEENFONT_CONTENT];
    [keyWorkTf setTextColor:BLACKCOLOR];
    keyWorkTf.delegate = self;
    [keyWorkTf setBackgroundColor:[UIColor clearColor]];
    [searchView addSubview:keyWorkTf];
    
//    self.tableView.frame = CGRectMake(0, 40,ScreenWidth, ScreenHeight-104);
    self.tableViewLayoutY.constant = 40;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gest:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    [self refreshLoad];
}

-(void)gest:(UIGestureRecognizer *)sender
{
    [keyWorkTf resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == keyWorkTf) {
        [keyWorkTf resignFirstResponder];
        [self refreshLoad];
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([keyWorkTf isFirstResponder]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    
    NSString *keyword = @"";
    if (keyWorkTf.text && ![keyWorkTf.text isEqualToString:@""]) {
        keyword = keyWorkTf.text;
    }
    keyword = [MyCommon removeAllSpace:keyword];
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc]init];
    [searchDic setObject:keyword forKey:@"project_title"];
    SBJsonWriter *jsonWriter1 = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter1 stringWithObject:searchDic];
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc]init];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_] forKey:@"page"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *salerId = [Manager getHrInfo].salerId;
    
    NSString *bodyMsg = [NSString stringWithFormat:@"sa_user_id=%@&searchArr=%@&conditionArr=%@",salerId,searchStr,conDicStr];
    NSString *op = @"app_jjr_api_busi";
    NSString *func = @"getMyProjectList";
            
    [ELRequest newBodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        [self parserPageInfo:result];
        NSArray *arr= result[@"data"];
        if ([arr isKindOfClass:[NSArray class]]){
            ELAnswerLableView *lableView = [[ELAnswerLableView alloc] initWithMaxCount:7];
            lableView.frame = CGRectMake(0,0,ScreenWidth-20,0);
            for (NSDictionary *dataDic in arr) {
                ELOfferListModel *model = [[ELOfferListModel alloc] initWithDic:dataDic];
                [model creatLabel];
                CGFloat height = [lableView getViewHeightWithModel:model.lableArr];
                model.lableViewFrame = CGRectMake(10,92,ScreenWidth-20,height);
                model.cellHeight = CGRectGetMaxY(model.lableViewFrame)+16;
                [_dataArray addObject:model];
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

#pragma mark - tableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELOfferListModel *dataModel = _dataArray[indexPath.row];
    return dataModel.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELOfferListModel *dataModel = _dataArray[indexPath.row];
    ELOfferPartyListCell *cell = [ELOfferPartyListCell getCellWithTableView:tableView];
    [cell setDataModel:dataModel];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([keyWorkTf isFirstResponder]) {
        [keyWorkTf resignFirstResponder];
        return;
    }
    
    OfferPartyCenterCtl *offerDetailCtl = [[OfferPartyCenterCtl alloc]init];
    ELOfferListModel *model = _dataArray[indexPath.row];
    offerDetailCtl.jobfair_id = model.jobfair_id;
    offerDetailCtl.fromtype = model.fromtype;
    offerDetailCtl.jobfair_name = model.project_title;
    offerDetailCtl.jobfair_time = model.project_holdtime;
    offerDetailCtl.place_name = model.place_name;
    offerDetailCtl.logo_src = model.logo_src;
//    if (_isGuwen == YES && [offerDetailCtl.fromtype isEqualToString:@"kpb"]){
//        [BaseUIViewController showAutoDismissAlertView:@"无权限访问" msg:nil seconds:2];
//        return ;
//    }
    [ self.navigationController pushViewController:offerDetailCtl animated:YES];
    [offerDetailCtl beginLoad:nil exParam:nil];
}


@end

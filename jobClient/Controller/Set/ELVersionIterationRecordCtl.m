//
//  ELVersionIterationRecordCtl.m
//  jobClient
//
//  Created by YL1001 on 15/12/23.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "ELVersionIterationRecordCtl.h"
#import "ELVersionIterationRecordCell.h"
#import "VersionInfoModel.h"
#import "SBJson.h"

@interface ELVersionIterationRecordCtl ()
{
    NSMutableArray *versionArr;
    NSMutableArray *dateArr;
    NSMutableArray *versionInfoArr;
}
@end

@implementation ELVersionIterationRecordCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.title = @"一览APP版本迭代记录";
    [self setNavTitle:@"一览APP版本迭代记录"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)beginLoad:(id)param exParam:(id)exParam
{
    [super beginLoad:param exParam:exParam];
    [self getVersionInfo];
}

- (void)getVersionInfo
{
    NSString *opStr = @"yl_es_person_busi";
    NSString *funcStr = @"getappinfolist";
    
    NSMutableDictionary *condictionDic = [[NSMutableDictionary alloc] init];
    [condictionDic setValue:pageParams forKey:@"page_size"];
    [condictionDic setValue:[NSString stringWithFormat:@"%ld", (long)self.pageInfo.currentPage_] forKey:@"page"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *condictionStr = [jsonWrite stringWithObject:condictionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"arr=%@", condictionStr];
    
    [ELRequest postbodyMsg:bodyMsg op:opStr func:funcStr requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        [self parserPageInfo:result];
        NSArray *modelArr = result[@"data"];
        if ([modelArr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in modelArr) {
                VersionInfoModel *model = [[VersionInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"IterationRecordCell";
    ELVersionIterationRecordCell *cell = (ELVersionIterationRecordCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ELVersionIterationRecordCell" owner:self options:nil] lastObject];
        
        cell.infoLb.font = THIRTEENFONT_CONTENT;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    VersionInfoModel *dataModel = [_dataArray objectAtIndex:indexPath.row];
    
    cell.versionLb.text = dataModel.source;
    cell.dateTimeLb.text = dataModel.ctime;
    
    NSString *testStr = [MyCommon removeHtmlTags:dataModel.content];
    testStr = [self removeWarpLine:testStr];
    
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc]init];
    pStyle.lineSpacing = 4.f;
    NSDictionary *attrDic = @{NSParagraphStyleAttributeName:pStyle, NSFontAttributeName:THIRTEENFONT_CONTENT};
    NSMutableAttributedString * infoStr = [[NSMutableAttributedString alloc]initWithString:testStr];
    [infoStr addAttributes:attrDic range:NSMakeRange(0, [testStr length])];
    
    cell.infoLb.attributedText = infoStr;
    
    CGSize size = [testStr boundingRectWithSize:CGSizeMake(ScreenWidth - 25, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrDic context:nil].size;
    CGRect lbFrame = cell.infoLb.frame;
    lbFrame.size.width = ScreenWidth - 25;
    lbFrame.size.height = size.height;
    cell.infoLb.frame = lbFrame;
    
    CGRect frame = cell.contentBgView.frame;
    frame.size.height = CGRectGetMaxY(cell.infoLb.frame) + 8;
    cell.contentBgView.frame = frame;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VersionInfoModel *dataModel = [_dataArray objectAtIndex:indexPath.row];
    
    NSString *testStr = [MyCommon removeHtmlTags:dataModel.content];
    testStr = [self removeWarpLine:testStr];
    
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc]init];
    pStyle.lineSpacing = 4.f;
    NSDictionary *attrDic = @{NSParagraphStyleAttributeName:pStyle, NSFontAttributeName:THIRTEENFONT_CONTENT};
    CGSize size = [testStr boundingRectWithSize:CGSizeMake(ScreenWidth - 25, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrDic context:nil].size;
    
    return size.height + 55 + 16;
}

- (NSString*)removeWarpLine:(NSString *)str
{
    if( !str || ![str isKindOfClass:[NSString class]] ){
        return @"";
    }
    NSMutableString * myStr = [NSMutableString stringWithString:str];
    NSRange rang;
    rang.location = 0;

    rang.length = [myStr length];
    [myStr replaceOccurrencesOfString:@"&nbsp;" withString:@"" options:NSCaseInsensitiveSearch range:rang];
    
    rang.length = [myStr length] ;
    [myStr replaceOccurrencesOfString:@"mdash;" withString:@"--" options:NSCaseInsensitiveSearch range:rang];
    
    rang.length = [myStr length] ;
    [myStr replaceOccurrencesOfString:@"&ldquo;" withString:@"“" options:NSCaseInsensitiveSearch range:rang];
    
    rang.length = [myStr length] ;
    [myStr replaceOccurrencesOfString:@"&rdquo;" withString:@"”" options:NSCaseInsensitiveSearch range:rang];
    
    return myStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

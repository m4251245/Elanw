//
//  ELJobSearchChangeListCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/12/20.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELJobSearchChangeListCtl.h"
#import "JobSearchTableViewCell.h"

@interface ELJobSearchChangeListCtl () <ELSearchRequestDataDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIView *clearView;
    UIButton *clearBtn_;
    DBTools *db_;
    NSMutableArray *searchHistoryArray_;
    NSMutableArray *hotArr;
    BOOL isSearchList;
    UIView *tableHeadView;
    NSInteger selectIndex;
    NSMutableArray *requestConArr;
    
    ELJobRequestListModel *currentModel;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    UIView *noDataView;
    NSString *searchKeyWord;
}
@end

@implementation ELJobSearchChangeListCtl

-(instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight-64);
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height) style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        
        _tableView = tableView;
        
        clearView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,44)];
        clearBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearBtn_ setTitle:@"" forState:UIControlStateNormal];
        [clearBtn_ setTitleColor:UIColorFromRGB(0x262626) forState:UIControlStateNormal];
        clearBtn_.frame = CGRectMake(0,0,self.frame.size.width,44);
        clearBtn_.titleLabel.font = [UIFont systemFontOfSize:14];
        [clearBtn_ addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
        [clearView addSubview:clearBtn_];
        tableView.tableFooterView = clearView;
        
        [self refreshHistoryBtnStatus];
        isSearchList = NO;
        [clearBtn_.titleLabel setTextColor:BLACKCOLOR];
        
        [_tableView reloadData];
        [self requestHotArr];

    }
    return self;
}

-(void)refreshHistoryBtnStatus{
     searchHistoryArray_ = [self loadDataInDataBase:[Manager getUserInfo].userId_];
    if ([searchHistoryArray_ count] !=0) {
        [clearBtn_ setTitle:@"[清空历史记录]" forState:UIControlStateNormal];
    }else{
        [clearBtn_ setTitle:@"暂无历史搜索记录" forState:UIControlStateNormal];
    }
}

-(void)requestHotArr{
    hotArr = nil;
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    if (_tradeId && ![_tradeId isEqualToString:@""]) {
        [conditionDic setObject:_tradeId forKey:@"tradeid"];
    }
    NSString *conditionStr = @"";
    if (conditionDic.count > 0) {
        SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
        conditionStr = [jsonWriter2 stringWithObject:conditionDic]; 
    }
    
    NSString *personId = [Manager getUserInfo].userId_;
    if (![Manager shareMgr].haveLogin) {
        personId = @"";
    }
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&device_id=%@&condition_arr=%@",personId,[MyCommon getUUID],conditionStr];
    [ELRequest newThreeBodyMsg:bodyMsg op:@"j_user_mata_busi" func:@"get_mobile_search_hot_key" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            if ([dic[@"status"] isEqualToString:@"OK"]) {
                NSArray *arr = dic[@"info"];
                if ([arr isKindOfClass:[NSArray class]]) {
                    if (arr.count > 0) {
                       hotArr = [[NSMutableArray alloc] initWithArray:arr]; 
                       [self refreshHotView];
                    }
                }
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)refreshHotView{
    if (isSearchList){
        _tableView.tableHeaderView = nil;
        return;
    }
    if (hotArr){
        if (!tableHeadView){
            tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,100)];
            tableHeadView.backgroundColor = UIColorFromRGB(0xf5f5f5);
            for (NSInteger i = 0;i<8;i++) {
                UILabel *lable = [[UILabel alloc] init];
                lable.font = [UIFont systemFontOfSize:12];
                lable.textColor = UIColorFromRGB(0x424242);
                lable.backgroundColor = [UIColor whiteColor];
                lable.textAlignment = NSTextAlignmentCenter;
                lable.tag = 100+i;
                lable.layer.cornerRadius = 15.0;
                lable.layer.borderColor = UIColorFromRGB(0xd4d4d4).CGColor;
                lable.layer.borderWidth = 1.0;
                lable.layer.masksToBounds = YES;
                lable.userInteractionEnabled = YES;
                [lable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hotLableTap:)]];
                [tableHeadView addSubview:lable];
            }
            UILabel *lable = [[UILabel alloc] init];
            lable.font = [UIFont systemFontOfSize:12];
            lable.textColor = UIColorFromRGB(0x424242);
            lable.text = @"热门职位";
            [lable sizeToFit];
            lable.frame = CGRectMake(15,19,lable.frame.size.width,lable.frame.size.height);
            [tableHeadView addSubview:lable];
        }
        NSInteger count = hotArr.count <= 8 ? hotArr.count:8;
        CGFloat maxX = 0;
        CGFloat maxY = 0;
        CGFloat LRPadding = 15;
        CGFloat LRWidth = 10;
        CGFloat TBHeight = 10;
        CGFloat startX = 15;
        CGFloat startY = 45;
        NSInteger lines = 1;
        for (NSInteger i = 0;i<8; i++){
            UILabel *lable = (UILabel *)[tableHeadView viewWithTag:100+i];
            if (i<count && lines <=2) {
                lable.hidden = NO;
                NSString *name = hotArr[i];
                lable.text = name;
                [lable sizeToFit];
                CGFloat lbWidth = lable.frame.size.width <= 120 ?lable.frame.size.width:120;
                CGFloat lableX = maxX+LRWidth;
                if ((lbWidth+lableX+2*LRPadding+5)>ScreenWidth) {
                    startY = startY+30+TBHeight;
                    lableX = startX;
                    lines ++;
                }else if (maxX <= 0){
                    lableX = startX;
                }
                if (lines <=2) {
                    lable.frame = CGRectMake(lableX,startY,lbWidth+LRPadding*2,30);
                    maxX = CGRectGetMaxX(lable.frame);
                    maxY = CGRectGetMaxY(lable.frame);
                }else{
                   lable.hidden = YES; 
                }
            }else{
               lable.hidden = YES; 
            }
        }
        tableHeadView.frame = CGRectMake(0,0,self.frame.size.width,maxY+25);
        _tableView.tableHeaderView = tableHeadView;
    }else{
        _tableView.tableHeaderView = nil;
    }
}

-(UIView *)getNoDataFooterView{
    if (!noDataView){
        noDataView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,300)];
        noDataView.backgroundColor = [UIColor clearColor];
        for (NSInteger i = 0;i<8;i++) {
            UILabel *lable = [[UILabel alloc] init];
            lable.font = [UIFont systemFontOfSize:12];
            lable.textColor = UIColorFromRGB(0x424242);
            lable.backgroundColor = [UIColor whiteColor];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.tag = 100+i;
            lable.layer.cornerRadius = 15.0;
            lable.layer.borderColor = UIColorFromRGB(0xd4d4d4).CGColor;
            lable.layer.borderWidth = 1.0;
            lable.layer.masksToBounds = YES;
            lable.userInteractionEnabled = YES;
            [lable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hotLableTap:)]];
            [noDataView addSubview:lable];
        }
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-213)/2.0,0,213,179)];
        image.image = [UIImage imageNamed:@"img_search_noData"];
        [noDataView addSubview:image];
        
        UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(image.frame)-20,ScreenWidth,20)];
        searchLabel.font = [UIFont systemFontOfSize:15];
        searchLabel.textColor = UIColorFromRGB(0x424242);
        searchLabel.backgroundColor = [UIColor clearColor];
        searchLabel.textAlignment = NSTextAlignmentCenter;
        searchLabel.text = @"暂无相关搜索结果";
        [noDataView addSubview:searchLabel];
        
        UILabel *hotLable = [[UILabel alloc] init];
        hotLable.font = [UIFont systemFontOfSize:12];
        hotLable.textColor = UIColorFromRGB(0x424242);
        hotLable.text = @"热门职位";
        [hotLable sizeToFit];
        hotLable.frame = CGRectMake(15,CGRectGetMaxY(searchLabel.frame)+30,hotLable.frame.size.width,hotLable.frame.size.height);
        [noDataView addSubview:hotLable];
        NSInteger count = hotArr.count <= 8 ? hotArr.count:8;
        CGFloat maxX = 0;
        CGFloat maxY = 0;
        CGFloat LRPadding = 15;
        CGFloat LRWidth = 10;
        CGFloat TBHeight = 10;
        CGFloat startX = 15;
        CGFloat startY = CGRectGetMaxY(hotLable.frame)+15;
        NSInteger lines = 1;
        for (NSInteger i = 0;i<8; i++){
            UILabel *lable = (UILabel *)[noDataView viewWithTag:100+i];
            if (i<count && lines <=2) {
                lable.hidden = NO;
                NSString *name = hotArr[i];
                lable.text = name;
                [lable sizeToFit];
                CGFloat lbWidth = lable.frame.size.width <= 120 ?lable.frame.size.width:120;
                CGFloat lableX = maxX+LRWidth;
                if ((lbWidth+lableX+2*LRPadding+5)>ScreenWidth) {
                    startY = startY+30+TBHeight;
                    lableX = startX;
                    lines ++;
                }else if (maxX <= 0){
                    lableX = startX;
                }
                if (lines <=2) {
                    lable.frame = CGRectMake(lableX,startY,lbWidth+LRPadding*2,30);
                    maxX = CGRectGetMaxX(lable.frame);
                    maxY = CGRectGetMaxY(lable.frame);
                }else{
                    lable.hidden = YES; 
                }
            }else{
                lable.hidden = YES; 
            }        }
        noDataView.frame = CGRectMake(0,0,ScreenWidth,maxY);
    }
    return noDataView;
}

-(void)hotLableTap:(UITapGestureRecognizer *)sender
{
    NSInteger index = sender.view.tag-100;
    NSString *str = [hotArr objectAtIndex:index];
    if ([_searchDelegate respondsToSelector:@selector(selectCellRefreshKeyWord:)]) {
        [_searchDelegate selectCellRefreshKeyWord:str];
    }
}

-(NSMutableArray *)loadDataInDataBase:(NSString *)personId
{
    if (!db_) {
        db_ = [[DBTools alloc]init];
    }
    return [db_ inquireForSearch:[Manager getUserInfo].userId_];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isSearchList) {
       return _dataArray.count;
    }
    if ([searchHistoryArray_ count] != 0 && [searchHistoryArray_  count] <= 5) {
        return [searchHistoryArray_ count];        
    }else if([searchHistoryArray_  count] >5){
        return 5;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isSearchList) {
        ELJobRequestJsonModel *model = _dataArray[indexPath.row];
        if (model.isZW) {
            return 49;
        }else{
            return 80;
        }
    }
    return 49;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isSearchList) {
        ELJobRequestJsonModel *model = _dataArray[indexPath.row];
        if (model.isZW) {
            static NSString *CellIdentifier = @"ZWTableViewCell";
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(15,16,17,17)];
                image.image = [UIImage imageNamed:@"jobsearch_search"];
                [cell.contentView addSubview:image];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+9,16,ScreenWidth-CGRectGetMaxX(image.frame)-19,17)];
                label.textColor = UIColorFromRGB(0x333333);
                label.font = [UIFont systemFontOfSize:15];
                label.numberOfLines = 1;
                label.tag = 100;
                [cell.contentView addSubview:label];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15,48,ScreenWidth-30,1)];
                line.backgroundColor = UIColorFromRGB(0xe0e0e0);
                [cell.contentView addSubview:line];
            }
            UILabel *lable = (UILabel *)[cell.contentView viewWithTag:100];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:model.jtzw];
            if ([model.jtzw rangeOfString:searchKeyWord options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                for (NSInteger i = 0; i<=(model.jtzw.length-searchKeyWord.length) ;i++)
                {
                    NSString *str = [model.jtzw substringWithRange:NSMakeRange(i,searchKeyWord.length)];
                    if ([str rangeOfString:searchKeyWord options:NSCaseInsensitiveSearch].location != NSNotFound)
                    {
                        [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe13e3e) range:NSMakeRange(i,searchKeyWord.length)];
                    }
                }
            }
            [lable setAttributedText:string];
            return cell;
        }else{
            static NSString *CellIdentifier = @"CMTableViewCell";
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(15,17,75,45)];
                image.tag = 300;
                [cell.contentView addSubview:image];
                
                image = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-22,34,7,12)];
                image.image = [UIImage imageNamed:@"jobsearch_right"];
                [cell.contentView addSubview:image];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100,18,ScreenWidth-125,20)];
                label.textColor = UIColorFromRGB(0xe13e3e);
                label.font = [UIFont systemFontOfSize:16];
                label.numberOfLines = 1;
                label.tag = 100;
                [cell.contentView addSubview:label];
                
                label = [[UILabel alloc] initWithFrame:CGRectMake(100,45,ScreenWidth-125,17)];
                label.textColor = UIColorFromRGB(0x757575);
                label.font = [UIFont systemFontOfSize:14];
                label.numberOfLines = 1;
                label.tag = 200;
                [cell.contentView addSubview:label];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,79,ScreenWidth,1)];
                line.backgroundColor = UIColorFromRGB(0xe0e0e0);
                [cell.contentView addSubview:line];
            }
            UILabel *companyLable = (UILabel *)[cell.contentView viewWithTag:100];
            UILabel *contentLable = (UILabel *)[cell.contentView viewWithTag:200];
            UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:300];
            companyLable.text = model.cname;
            NSString *content = nil;
            if (model.region && ![model.region isEqualToString:@""]) {
                content = model.region;
            }
            
            if (model.cxz && ![model.cxz isEqualToString:@""]) {
                if (content) {
                    content = [NSString stringWithFormat:@"%@|%@",content,model.cxz];
                }else{
                    content = model.cxz;
                }
            }
            if (model.zw_cnt && ![model.zw_cnt isEqualToString:@""]) {
                if (content) {
                    content = [NSString stringWithFormat:@"%@|%@个在招职位",content,model.zw_cnt];
                }else{
                    content = [NSString stringWithFormat:@"%@个在招职位",model.zw_cnt];
                }
            }
            contentLable.text = content;
            [image sd_setImageWithURL:[NSURL URLWithString:model.logopath] placeholderImage:[UIImage imageNamed:@"positionDefaulLogo"]];
            return cell;
        }
    }
    static NSString *CellIdentifier = @"JobSearchTableViewCell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(15,16,17,17)];
        image.image = [UIImage imageNamed:@"jobsearch_history"];
        [cell.contentView addSubview:image];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+9,16,ScreenWidth-CGRectGetMaxX(image.frame)-19,17)];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:15];
        label.numberOfLines = 1;
        label.tag = 100;
        [cell.contentView addSubview:label];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15,48,ScreenWidth-30,1)];
        line.backgroundColor = UIColorFromRGB(0xe0e0e0);
        [cell.contentView addSubview:line];
    }
    SearchParam_DataModal *dataModal = [searchHistoryArray_ objectAtIndex:indexPath.row];
    UILabel *lable = (UILabel *)[cell.contentView viewWithTag:100];
    lable.text = dataModal.searchKeywords_;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isSearchList){
        ELJobRequestJsonModel *model = _dataArray[indexPath.row];
        if (model.isZW) {
            if ([_searchDelegate respondsToSelector:@selector(selectCellRefreshKeyWord:)]) {
                [_searchDelegate selectCellRefreshKeyWord:model.jtzw];
            }
        }else{
            ZWDetail_DataModal * dataModel =[[ZWDetail_DataModal alloc] init];
            dataModel.companyID_ = model.cid;
            dataModel.companyName_ = model.cname;
            dataModel.companyLogo_ = model.logopath;
            
            PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
            positionCtl.type_ = 2;
            positionCtl.backTwoTier = YES;
            [[Manager shareMgr].centerNav_ pushViewController:positionCtl animated:YES];
            [positionCtl beginLoad:dataModel exParam:nil];
        }
        return;
    }
    SearchParam_DataModal *dataModal = [searchHistoryArray_ objectAtIndex:indexPath.row];
    [_searchDelegate selectCellRefreshKeyWord:dataModal.searchKeywords_];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_iskeyboardShow) {
        if ([_searchDelegate respondsToSelector:@selector(searchHideKeyBoard)]) {
            [_searchDelegate searchHideKeyBoard];
        } 
    }
}

-(void)btnResponse:(id)sender{
    if (sender == clearBtn_){
        if (!db_) {
            db_ = [[DBTools alloc]init];
        }
        [db_ deleteData:[Manager getUserInfo].userId_];
        [clearBtn_ setTitle:@"暂无历史搜索记录" forState:UIControlStateNormal];
        [searchHistoryArray_ removeAllObjects];
        [_tableView reloadData];
    }
}

#pragma mark - 保存搜索记录
-(void)saveKeyWord:(NSString *)keyWord searchModel:(SearchParam_DataModal *)model{
    if (![keyWord isEqualToString:@""] &&![keyWord isKindOfClass:[NSNull class]] && keyWord != nil)
    {
        if (!db_) {
            db_ = [[DBTools alloc]init];
        }
        [db_ createTableForSearch];
//        [db_ deleteData:[Manager getUserInfo].userId_ searchKeyWords:keyWord regionStr:model.regionStr_ tradeStr:model.tradeStr_];
//        [db_ insertTableForSearch:[Manager getUserInfo].userId_ searchKeyWords:keyWord regionId:model.regionId_ regionStr:model.regionStr_ tradeId:model.tradeId_ tradeStr:model.tradeStr_ searchTime:[PreCommon getCurrentDateTime] searchType:[NSString stringWithFormat:@"%ld",(long)model.searchType_]];
        [db_ deleteData:[Manager getUserInfo].userId_ searchKeyWords:keyWord regionStr:@"" tradeStr:@""];
        [db_ insertTableForSearch:[Manager getUserInfo].userId_ searchKeyWords:keyWord regionId:@"" regionStr:@"" tradeId:@"" tradeStr:@"" searchTime:[PreCommon getCurrentDateTime] searchType:[NSString stringWithFormat:@"%ld",(long)model.searchType_]];
    }
}

-(void)searchBarDidChange:(NSString *)searchText tradeId:(NSString *)tradeId regionId:(NSString *)regionId{
    NSString *searchStr = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    searchKeyWord = searchStr;
    if (searchStr.length > 0){
        if (!isSearchList) {
            isSearchList = YES;
            _tableView.tableHeaderView = nil;
            _tableView.tableFooterView = nil;
            [_tableView reloadData];
        }
        NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
        if (tradeId && ![tradeId isEqualToString:@""]) {
            [conditionDic setObject:tradeId forKey:@"tradeid"];
        }
        if (regionId && ![regionId isEqualToString:@""]) {
            [conditionDic setObject:regionId forKey:@"regionid"];
        }
        NSString *conditionStr = @"";
        if (conditionDic.count > 0) {
            SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
            conditionStr = [jsonWriter2 stringWithObject:conditionDic]; 
        }
        [self requestKeyWordWithStr:searchStr withBodyMsg:[NSString stringWithFormat:@"search_arr=%@&keyword=%@",conditionStr,searchStr]]; 
    }else{
        isSearchList = NO;
        _tableView.tableHeaderView = tableHeadView;
        _tableView.tableFooterView = clearView;
        [self refreshHistoryBtnStatus];
        [_tableView reloadData];
    }
}

-(void)requestKeyWordWithStr:(NSString *)keyWord withBodyMsg:(NSString *)bodyMsg{
    ELJobRequestListModel *model = [[ELJobRequestListModel alloc] init];
    model.delegate = self;
    model.keyWord = keyWord;
    currentModel = model;
    [model requestDataWithBodyMsg:bodyMsg];
    
}

-(void)requestFinish:(NSString *)key{
    if ([key isEqualToString:currentModel.keyWord]) {
        if (currentModel.dataArr.count > 0){
            _dataArray = [[NSMutableArray alloc] initWithArray:currentModel.dataArr];
            [_tableView reloadData];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end


@implementation ELJobRequestListModel

-(instancetype)init{
    self = [super init];
    if (self) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)requestDataWithBodyMsg:(NSString *)bodyMsg{
    [_dataArr removeAllObjects];
    [ELRequest newThreeBodyMsg:bodyMsg op:@"person_job_fit_busi" func:@"get_mobile_zw_tips" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            if ([dic[@"status"] isEqualToString:@"OK"]){
                NSDictionary *info = dic[@"info"];
                if ([info isKindOfClass:[NSDictionary class]]) {
                    NSArray *zw_tips = info[@"zw_tips"];
                    NSArray *company_tips = info[@"company_tips"];
                    if ([zw_tips isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *subDic in zw_tips) {
                            ELJobRequestJsonModel *model = [[ELJobRequestJsonModel alloc] init];
                            model.isZW = YES;
                            model.jtzw = subDic[@"jtzw"];
                            [_dataArr addObject:model];
                        }
                    }
                    if ([company_tips isKindOfClass:[NSArray class]]){
                        for (NSDictionary *subDic in company_tips) {
                            ELJobRequestJsonModel *model = [[ELJobRequestJsonModel alloc] initWithDictionary:subDic];
                            model.isZW = NO;
                            [_dataArr addObject:model];
                        }
                    }
                    if ([_delegate respondsToSelector:@selector(requestFinish:)]) {
                        [_delegate requestFinish:_keyWord];
                    }
                }
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}   

@end

@implementation ELJobRequestJsonModel

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key]; 
}

@end

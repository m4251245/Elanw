//
//  MyJobGuideCtl.m
//  jobClient
//
//  Created by 一览iOS on 15-1-20.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MyJobGuideCtl.h"
#import "MyJobGuideCtl_Cell.h"
#import "myJobGroupSearchCtr.h"
#import "NoLoginPromptCtl.h"
#import "JobGuideTypeAQListCtl.h"
#import "MyJobGuideCollectionViewCell.h"
#import "MyJobGuide_RewardCell.h"
#import "JobGuideQuizModal.h"
#import "UIImageView+WebCache.h"
#import "ELLineView.h"
#import "ELAnswerListCell.h"
#import "ELAnswerLableModel.h"
#import "ELAnswerLableView.h"
#import "ELButtonView.h"
#import "ELRecommendView.h"

@interface MyJobGuideCtl () <NoLoginDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSArray *typeArray;
    
    UIView *sengmentView; //导航栏
    UIButton *segmentLeftButton; //导航栏左边按钮
    UIButton *segmentRightButton;//导航栏右边按钮
    BOOL selectRightButton; //当前是否选中了右边按钮
    
    JobGuideQuizModal *recommentModal; //顶部广告数据model
    
    NSMutableArray *leftArr; //存放左边列表数据
    NSMutableArray *rightArr;   //存放右边列表数据
    PageInfo *leftPage; //左边分页参数信息
    PageInfo *rightPage; //右边分页参数信息
    
    UIView *noDataView; //没有请求到数据时显示的view
    CGSize collotionSize; //存储广告下方列表的大小
    
    UICollectionView *typeColletionView; //广告下方列表
    UIView *colletionBackView;//广告下方列表背景
    
    UIView *searchBackView; //顶部搜索栏
    UIView *searchView;
    UIButton *searchBtn; //顶部搜索按钮

    CGFloat oldTableContentSetY; //记录tableview偏移量
    
    BOOL finishAnimation; //表示导航栏动画是否结束
    
    NSInteger sectionCount;
    CGFloat viewHeight;
    
    ELRecommendView *_recommendView;
}
@end

@implementation MyJobGuideCtl

-(id) init
{
    self = [super init];
    self.footerRefreshFlag = YES;
    sectionCount = 0;
    viewHeight = ScreenHeight-64-49;
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad{
    self.view.frame = CGRectMake(0,0,ScreenWidth,viewHeight);
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0,46,ScreenWidth,viewHeight-46) style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    
    self.tableView = table;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    rightPage = [[PageInfo alloc] init];
    leftPage = [[PageInfo alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0,0,60,40)];
    lable.font = [UIFont systemFontOfSize:17];
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"问答";
    self.navigationItem.titleView = lable;
    [self.tableView registerNib:[UINib nibWithNibName:@"ELAnswerListCell" bundle:nil] forCellReuseIdentifier:@"ELAnswerListCell"];
    selectRightButton = NO;
    [self refreshLoad];
    [self requestRight:NO];
    oldTableContentSetY = 0;
    
    searchBackView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,46)];
    searchBackView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [self.view addSubview:searchBackView];
    
    searchView = [[UIView alloc] initWithFrame:CGRectMake(10,8,ScreenWidth-20,30)];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.clipsToBounds = YES;
    searchView.layer.cornerRadius = 5.0f;
    [searchBackView addSubview:searchView];
    
    searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0,0,ScreenWidth-20,30);
    [searchBtn setTitle:@"      输入问题关键词" forState:UIControlStateNormal];
    [searchBtn setTitleColor:UIColorFromRGB(0xAAAAAA) forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBtn];
    
   // self.navigationController.toolbarHidden = YES;
    
    [self setRightButton];
    [self creatTypeList];
    
    if (!_noSegment) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItems = nil;
    }
}

-(void)setNoSegment:(BOOL)noSegment{
    _noSegment = noSegment;
    if (noSegment){
        viewHeight = ScreenHeight-64;
    }else{
        viewHeight = ScreenHeight-64-49;
    }
}

#pragma mark - 设置导航右侧按钮
-(void)setRightButton{
    UIButton *rightBarBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarBtn_ setTitle:@"提问" forState:UIControlStateNormal];
    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarBtn_ setFrame:CGRectMake(0, 0, 45, 31)];
    rightBarBtn_.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [rightBarBtn_ addTarget:self action:@selector(rightBarBtnResponse:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn_];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];
}

#pragma mark - 创建类型列表和经纪人卡片
-(void)creatTypeList{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.headerReferenceSize = CGSizeZero;
    flowLayout.footerReferenceSize = CGSizeZero;
    typeColletionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenWidth_Four) collectionViewLayout:flowLayout];
    typeColletionView.delegate = self;
    typeColletionView.dataSource = self;
    typeColletionView.backgroundColor = [UIColor whiteColor];
    typeColletionView.bounces = NO;
    typeColletionView.showsHorizontalScrollIndicator = NO;
    
    [typeColletionView registerNib:[UINib nibWithNibName:@"MyJobGuideCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyJobGuideCollectionViewCell"];
    typeColletionView.allowsMultipleSelection = YES;
    typeArray = @[
                  @{@"title":@"行业问答",@"img":@"typeBgImg",@"type":@"8581399449565705"},
                  @{@"title":@"简历指导",@"img":@"resumeBgImg",@"type":@"2"},
                  @{@"title":@"职业定位",@"img":@"jobLocationBgImg",@"type":@"1"},
                  @{@"title":@"职业困惑",@"img":@"puzziBgImg",@"type":@"5"},
                  @{@"title":@"薪酬行情",@"img":@"salaryBgImg",@"type":@"4"},
                  @{@"title":@"晋升通道",@"img":@"promotionBgImg",@"type":@"6"},
                  @{@"title":@"面试技巧",@"img":@"mailBgImg",@"type":@"3"},
                  @{@"title":@"志愿填报",@"img":@"volunteerBgImg",@"type":@"8161394610695137"},
                  @{@"title":@"劳动法规",@"img":@"laborBgImg",@"type":@"2251394610721631"},
                  @{@"title":@"其他类型",@"img":@"otherTypeBgImg",@"type":@"0"}];
    
    CGFloat scale = 20.0/17.0;
    CGFloat width = (ScreenWidth*4)/15.0;
    CGFloat height = width/scale;
    collotionSize = CGSizeMake(width,height);
    
    [typeColletionView reloadData];
    
    colletionBackView = [[UIView alloc] init];
    colletionBackView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    _recommendView = [[ELRecommendView alloc]init];
    _recommendView.recommendArr = @[@"jingjr",@"zhiyeghs"];
    _recommendView.frame = CGRectMake(0,5,_recommendView.frame.size.width,_recommendView.frame.size.height);
    [colletionBackView addSubview:_recommendView];
    
    typeColletionView.frame = CGRectMake(0,CGRectGetMaxY(_recommendView.frame),ScreenWidth,collotionSize.height);
    [colletionBackView addSubview:typeColletionView];
    
    colletionBackView.frame = CGRectMake(0,0,ScreenWidth,CGRectGetMaxY(typeColletionView.frame)+5);
}

#pragma mark - 重写父类的刷新数据方法
-(void)refreshLoad{
    if (selectRightButton){
        self.pageInfo = rightPage;
        [rightArr removeAllObjects];
    }else{
        self.pageInfo = leftPage;
        [leftArr removeAllObjects];
    }
    [self refreshDataSource];
}

#pragma mark - 请求顶部广告
-(void)requestAd{
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:@"1" forKey:@"num"];
    SBJsonWriter *jsonWriter1 = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter1 stringWithObject:searchDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"arr=%@",searchStr];
    [ELRequest postbodyMsg:bodyMsg op:@"zd_ask_question_busi" func:@"get_place_recommend_question" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSArray *arr= result;
        if ([arr isKindOfClass:[NSArray class]]) {
            if (arr.count > 0) {
               JobGuideQuizModal *dataModal = [[JobGuideQuizModal alloc] initWithDictionary:arr[0]];
                recommentModal = dataModal;
                [self.tableView reloadData];
                [self adjustFooterViewFrame];
            }           
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark - 刷新和加载更多数据
-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    if (selectRightButton){
        self.pageInfo = rightPage;
        [self requestRight:YES];
    }else{
        self.pageInfo = leftPage;
        [self requestLeft:YES];
    }
    [self requestAd];
}

-(void)requestLeft:(BOOL)isListRequest{
    NSString *bodyMsg = [self getBodyMsgWithPage:leftPage.currentPage_ qt:@"na"];
    NSString * function = @"get_new_question_answer_list";
    NSString * op = @"zd_ask_question_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        sectionCount = 2;
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            if (isListRequest) {
                [_dataArray removeAllObjects];
                [self parserPageInfo:dic]; 
            }else{
                NSDictionary *dicOne = [dic objectForKey:@"pageparam"];
                leftPage.pageCnt_ = [[dicOne objectForKey:@"pages"] intValue];
                leftPage.totalCnt_ = [[dicOne objectForKey:@"sums"] intValue];
                
                if(![dicOne objectForKey:@"pages"] || [[dicOne objectForKey:@"pages"] isEqualToString:@""]){
                    leftPage.pageCnt_ = 0;
                }
                
                if (leftPage.totalCnt_ == 0)
                {
                    leftPage.lastPageFlag = YES;
                }else{
                    if (leftPage.currentPage_ >= leftPage.pageCnt_ || [[dicOne objectForKey:@"pages"] isEqualToString:[dicOne objectForKey:@"page"]] || leftPage.pageCnt_ == 0) {
                        leftPage.lastPageFlag = YES;
                    }else{
                        leftPage.lastPageFlag = NO;
                    }
                    leftPage.currentPage_ += 1;
                }
            }
            NSArray * arr = [dic objectForKey:@"data"];
            if ([arr isKindOfClass:[NSArray class]]){
                NSMutableArray *subArr = [self jsonArrWithArr:arr];
                if (!leftArr) {
                    leftArr = [[NSMutableArray alloc] init];
                }
                [leftArr addObjectsFromArray:subArr];
                if (isListRequest) {
                    [_dataArray addObjectsFromArray:leftArr];
                    self.tableView.tableFooterView = nil;
                    [self.tableView reloadData];
                }
            }
        }
        if (isListRequest) {
            [self finishReloadingData];
            [self refreshEGORefreshView];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        sectionCount = 2;
        if (isListRequest) {
            [self finishReloadingData];
            [self refreshEGORefreshView];
        }
    }];
}

-(void)requestRight:(BOOL)isListRequest{
    
    NSString *bodyMsg = [self getBodyMsgWithPage:rightPage.currentPage_ qt:@"nq"];
    NSString * function = @"get_new_question_answer_list";
    NSString * op = @"zd_ask_question_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        NSDictionary *dic = result;
        sectionCount = 2;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            if (isListRequest) {
                [_dataArray removeAllObjects];
                [self parserPageInfo:dic]; 
            }else{
                NSDictionary *dicOne = [dic objectForKey:@"pageparam"];
                rightPage.pageCnt_ = [[dicOne objectForKey:@"pages"] intValue];
                rightPage.totalCnt_ = [[dicOne objectForKey:@"sums"] intValue];
                
                if(![dicOne objectForKey:@"pages"] || [[dicOne objectForKey:@"pages"] isEqualToString:@""]){
                    rightPage.pageCnt_ = 0;
                }
                if (rightPage.totalCnt_ == 0)
                {
                    rightPage.lastPageFlag = YES;
                }else{
                    if (rightPage.currentPage_ >= rightPage.pageCnt_ || [[dicOne objectForKey:@"pages"] isEqualToString:[dicOne objectForKey:@"page"]] || rightPage.pageCnt_ == 0) {
                        rightPage.lastPageFlag = YES;
                    }else{
                        rightPage.lastPageFlag = NO;
                    }
                    rightPage.currentPage_ += 1;
                }
            }
            NSArray * arr = [dic objectForKey:@"data"];
            if ([arr isKindOfClass:[NSArray class]]){
                NSMutableArray *subArr = [self jsonArrWithArr:arr];
                if (!rightArr) {
                    rightArr = [[NSMutableArray alloc] init];
                }
                [rightArr addObjectsFromArray:subArr];
                if (isListRequest) {
                    [_dataArray addObjectsFromArray:rightArr];
                    self.tableView.tableFooterView = nil;
                    [self.tableView reloadData];
                }
            }
        }
        if (isListRequest) {
            [self finishReloadingData];
            [self refreshEGORefreshView];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        sectionCount = 2;
        if (isListRequest) {
            [self finishReloadingData];
            [self refreshEGORefreshView];
        }
    }];
}

-(NSString *)getBodyMsgWithPage:(NSInteger)page qt:(NSString *)qt{
    NSString *personId = @"";
    if ([Manager shareMgr].haveLogin) {
        personId = [Manager getUserInfo].userId_;
    }
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%@",@""] forKey:@"question_targ"];
    [conditionDic setObject:@"" forKey:@"question_title"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:qt forKey:@"qt"];
    [searchDic setObject:personId forKey:@"person_id"];
    
    SBJsonWriter *jsonWriter1 = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter1 stringWithObject:searchDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"conditionArr=%@&searchArr=%@",conditionStr,searchStr];
    return bodyMsg;
}

-(NSMutableArray *)jsonArrWithArr:(NSArray *)arr
{
    NSMutableArray *subArr = [[NSMutableArray alloc] init];    
    ELAnswerLableView *lableView = [[ELAnswerLableView alloc] init];
    lableView.frame = CGRectMake(0,0,ScreenWidth-16,0);
    UILabel *lable = [[UILabel alloc] init];
    lable.numberOfLines = 2;
    lable.font = [UIFont systemFontOfSize:16];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSParagraphStyleAttributeName:paragraphStyle};
    
    UILabel *detailLb = [[UILabel alloc] init];
    detailLb.numberOfLines = 3;
    detailLb.font = THIRTEENFONT_CONTENT;
    NSDictionary *detailDic = @{NSFontAttributeName:THIRTEENFONT_CONTENT};
    
    UILabel *commentLb = [[UILabel alloc] init];
    commentLb.numberOfLines = 2;
    
    for (NSDictionary * subDic in arr) {
        JobGuideQuizModal *dataModal = [[JobGuideQuizModal alloc] initWithDictionary:subDic];  
        if (dataModal.tradeid && [dataModal.tradeid integerValue] != 0) {
            CondictionList_DataModal *model = [CondictionTradeCtl returnModelWithTradeId:dataModal.tradeid];
            if (model){
                model.pName = [CondictionTradeCtl getTotalNameWithTotalId:model.pId_];
                if (!dataModal.lableArr) {
                    dataModal.lableArr = [[NSMutableArray alloc] init];
                }
                ELAnswerLableModel *lableModel = [[ELAnswerLableModel alloc] init];
                lableModel.name = [NSString stringWithFormat:@"%@-%@",model.pName,model.str_];
                lableModel.colorType = GrayColorType;
                lableModel.tradeModel = model;
                [dataModal.lableArr addObject:lableModel];
            }
        }
        if ([dataModal.targ isKindOfClass:[NSArray class]]) {
            if (!dataModal.lableArr) {
                dataModal.lableArr = [[NSMutableArray alloc] init];
            }
            for (NSDictionary *dic in dataModal.targ) {
                ELAnswerLableModel *lableModel = [[ELAnswerLableModel alloc] init];
                lableModel.name = dic[@"ylt_name"];
                lableModel.colorType = CyanColorType;
                [dataModal.lableArr addObject:lableModel];
            }
        }
        //用户名及行业
        NSMutableAttributedString *personStr;
        if (dataModal.person_detail.person_job_now && ![dataModal.person_detail.person_job_now isEqualToString:@""]){
            personStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ · %@",dataModal.person_detail.person_iname,dataModal.person_detail.person_job_now]];
            [personStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xbdbdbd) range:NSMakeRange(dataModal.person_detail.person_iname.length,personStr.string.length - dataModal.person_detail.person_iname.length)];
        }else if (dataModal.person_detail.person_zw && ![dataModal.person_detail.person_zw isEqualToString:@""]){
            personStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ · %@",dataModal.person_detail.person_iname,dataModal.person_detail.person_zw]];
            [personStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xbdbdbd) range:NSMakeRange(dataModal.person_detail.person_iname.length,personStr.string.length - dataModal.person_detail.person_iname.length)];
        }else{
            personStr = [[NSMutableAttributedString alloc] initWithString:dataModal.person_detail.person_iname];
        }
        dataModal.personNameAttString = personStr;
        
        CGFloat cellHeight = 48;
        //计算问题
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:dataModal.question_title attributes:attributes];
        lable.frame = CGRectMake(0,0,ScreenWidth-28,0);
        [lable setAttributedText:string];
        [lable sizeToFit];
        dataModal.contentAttString = string;
        cellHeight += (lable.height+18);
        //标签计算
        if (dataModal.lableArr) {
           CGFloat lableHeight = [lableView getViewHeightWithModel:dataModal.lableArr];
            if (lableHeight > 0) {
                cellHeight += (lableHeight + 18);
            }
        }
        //问题描述
        if(dataModal.question_content && ![dataModal.question_content isEqualToString:@""]){
            NSMutableAttributedString *detailStr = [[NSMutableAttributedString alloc] initWithString:dataModal.question_content attributes:detailDic];
            detailLb.frame = CGRectMake(0,0,ScreenWidth-28,0);
            [detailLb setAttributedText:detailStr];
            [detailLb sizeToFit];
            dataModal.answerDetailAtt = detailStr;
            cellHeight += (detailLb.height+18);
        }
        
        //浏览、评论个数高度
        cellHeight += 22;
        
        //评论高度
        CGFloat commentHeight = 0;
        if (dataModal.answer_detail.count > 0){
            AnswerListModal *answer1 = [dataModal.answer_detail objectAtIndex:0];
            NSString *comment1 = answer1.answer_content;
            NSString *personName1 = answer1.answer_person_detail.person_iname;
            NSString *personId1 = answer1.answer_person_detail.personId;
            
            if (comment1 && ![comment1 isEqualToString:@""]){
                dataModal.commentOneArr = [[NSMutableArray alloc] init];
                TextSpecial *text = [[TextSpecial alloc] init];
                text.range = NSMakeRange(0,personName1.length);
                text.color = UIColorFromRGB(0xbdbdbd);
                text.key = personId1;
                [dataModal.commentOneArr addObject:text];
                
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",personName1,comment1] attributes:@{NSFontAttributeName:THIRTEENFONT_CONTENT}];
                [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4570aa) range:NSMakeRange(0,personName1.length)];
                [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x616161) range:NSMakeRange(personName1.length,comment1.length+1)];    
                string = [[Manager shareMgr] getEmojiStringWithAttString:string withImageSize:CGSizeMake(18,18)];
                dataModal.commentOneAtt = string;
                
                text = [[TextSpecial alloc] init];
                text.range = NSMakeRange(0,string.length);
                text.color = UIColorFromRGB(0xbdbdbd);
                [dataModal.commentOneArr addObject:text];
                
                commentLb.frame = CGRectMake(0,0,ScreenWidth-48,0);
                [commentLb setAttributedText:string];
                [commentLb sizeToFit];
                dataModal.commentOneFrame = CGRectMake(8,14,ScreenWidth-48,commentLb.frame.size.height);
                commentHeight = CGRectGetMaxY(dataModal.commentOneFrame);
            }
            
            if (dataModal.answer_detail.count >1) {
                AnswerListModal *answer2 = [dataModal.answer_detail objectAtIndex:1];
                NSString *comment2 = answer2.answer_content;
                NSString *personName2 = answer2.answer_person_detail.person_iname;
                NSString *personId2 = answer2.answer_person_detail.personId;
                if (comment2 && ![comment2 isEqualToString:@""]){
                    dataModal.commentTwoArr = [[NSMutableArray alloc] init];
                    TextSpecial *text = [[TextSpecial alloc] init];
                    text.range = NSMakeRange(0,personName2.length);
                    text.color = UIColorFromRGB(0xbdbdbd);
                    text.key = personId2;
                    [dataModal.commentTwoArr addObject:text];
                    
                    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",personName2,comment2] attributes:@{NSFontAttributeName:THIRTEENFONT_CONTENT}];
                    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4570aa) range:NSMakeRange(0,personName2.length)];
                    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x616161) range:NSMakeRange(personName2.length,comment2.length+1)];    
                    string = [[Manager shareMgr] getEmojiStringWithAttString:string withImageSize:CGSizeMake(18,18)];
                    dataModal.commentTwoAtt = string;
                    
                    text = [[TextSpecial alloc] init];
                    text.range = NSMakeRange(0,string.length);
                    text.color = UIColorFromRGB(0xbdbdbd);
                    [dataModal.commentTwoArr addObject:text];
                    
                    commentLb.frame = CGRectMake(0,0,ScreenWidth-48,0);
                    [commentLb setAttributedText:string];
                    [commentLb sizeToFit];
                    dataModal.commentTwoFrame = CGRectMake(8,commentHeight+9,ScreenWidth-48,commentLb.frame.size.height);
                    commentHeight = (CGRectGetMaxY(dataModal.commentTwoFrame));
                }
            }
        }   
        if (commentHeight > 0){
            commentHeight += 6;
            dataModal.cellHeight = cellHeight+commentHeight+17+10;
            dataModal.commentViewFrame = CGRectMake(16,cellHeight,ScreenWidth-32,commentHeight);
        }else{
            dataModal.cellHeight = cellHeight+10;
        }
        
        if ([dataModal.is_recommend isEqualToString:@"1"]){
            recommentModal = dataModal;
        }else{
            [subArr addObject:dataModal];  
        }
    }
    return subArr;
}

#pragma mark - UIColletionViewDelegate
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collotionSize;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return typeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyJobGuideCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyJobGuideCollectionViewCell" forIndexPath:indexPath];
    if (typeArray.count > indexPath.row) {
        NSDictionary *dic = [typeArray objectAtIndex:indexPath.row];
        cell.typeTitle.text = dic[@"title"];
        cell.typeImg.image = [UIImage imageNamed:dic[@"img"]];
        cell.viewLine.center = CGPointMake(0,collotionSize.height/2.0);
        if (indexPath.row == 0) {
            cell.viewLine.hidden = YES;
        }else{
            cell.viewLine.hidden = NO;
        }
    }   
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *num = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSDictionary *dic = [typeArray objectAtIndex:indexPath.row];
    NSString *title = dic[@"title"];
    NSString *type = dic[@"type"];
    JobGuideTypeAQListCtl *typeAQList = [[JobGuideTypeAQListCtl alloc] init];
    if ([title isEqualToString:@"行业问答"]) {
        typeAQList.showTradeChange = YES;
    }
    typeAQList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:typeAQList animated:YES];
    [typeAQList beginLoad:type exParam:title];
}


#pragma mark - UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {//悬赏问答
        if (indexPath.row == 0) {
            JobGuideQuizModal * dataModal = recommentModal;
            static NSString *rewardCellIden = @"MyJobGuide_RewardCell";
            MyJobGuide_RewardCell *rewardCell = (MyJobGuide_RewardCell *)[tableView dequeueReusableCellWithIdentifier:rewardCellIden];
            if (rewardCell == nil)
            {
                rewardCell = [[[NSBundle mainBundle] loadNibNamed:@"MyJobGuide_RewardCell" owner:self options:nil] lastObject];
                [rewardCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            [rewardCell setCount:dataModal.hot_count withContent:[MyCommon translateHTML:dataModal.question_title]];
            return rewardCell;
        }else{
            static NSString *indentifier = @"adCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:colletionBackView];
            }
            return cell;
        }
    }
    ELAnswerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ELAnswerListCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    JobGuideQuizModal *modal = _dataArray[indexPath.row];
    [cell giveDataWithModal:modal];
    if (!cell.lineView) {
        cell.lineView = [[ELLineView alloc] initWithFrame:CGRectMake(0,modal.cellHeight-10,ScreenWidth,10) WithColor:UIColorFromRGB(0xf5f5f5)];
        [cell.contentView addSubview:cell.lineView];
    }
    cell.lineView.frame = CGRectMake(0,modal.cellHeight-10,ScreenWidth,10);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (recommentModal && indexPath.row == 0) {
            return [MyJobGuide_RewardCell getCellHeight];
        }else if (indexPath.row == 1){
            return colletionBackView.frame.size.height;
        }
        else{
            return 0;
        }
    }
    JobGuideQuizModal * dataModal = [_dataArray objectAtIndex:indexPath.row];
    return dataModal.cellHeight;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sectionCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        NSInteger count = 1;
        if (recommentModal) {
            count ++;
        }
        return count;
    }
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 43;
    }
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        if (!sengmentView) {
            sengmentView = [[UIView alloc] init];
            sengmentView.frame = CGRectMake(0,0,ScreenWidth,43);
            sengmentView.backgroundColor = [UIColor whiteColor];
            
            segmentLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [segmentLeftButton setTitle:@"最新" forState:UIControlStateNormal];
            segmentLeftButton.titleLabel.font = [UIFont systemFontOfSize:16];
            segmentLeftButton.frame = CGRectMake(ScreenWidth_Four-50,0,100,43);
            [segmentLeftButton addTarget:self action:@selector(changeDateButtonRespone:) forControlEvents:UIControlEventTouchUpInside];
            [sengmentView addSubview:segmentLeftButton];
            
            segmentRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [segmentRightButton setTitle:@"最热" forState:UIControlStateNormal];
            segmentRightButton.titleLabel.font = [UIFont systemFontOfSize:16];
            segmentRightButton.frame = CGRectMake((ScreenWidth_Four*3)-50,0,100,40);
            [segmentRightButton addTarget:self action:@selector(changeDateButtonRespone:) forControlEvents:UIControlEventTouchUpInside];
            [sengmentView addSubview:segmentRightButton];
            
            ELLineView *line1 = [[ELLineView alloc] initWithFrame:CGRectMake(ScreenWidth/2.0,11,1,21) WithColor:UIColorFromRGB(0xe0e0e0)];
            [sengmentView addSubview:line1];
            
            ELLineView *line2 = [[ELLineView alloc] initWithFrame:CGRectMake(0,42,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)];
            [sengmentView addSubview:line2];
            
            [self changeButtonStatus];
        }
        return sengmentView;
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        NSDictionary * dict = @{@"Function":@"职导"};
        [MobClick event:@"personused" attributes:dict];
        
        JobGuideQuizModal *selectModal = _dataArray[indexPath.row];
        AnswerDetailCtl *answerDetailCtl = [[AnswerDetailCtl alloc] init];
        answerDetailCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:answerDetailCtl animated:YES];
        [answerDetailCtl beginLoad:selectModal.question_id exParam:nil];
    }else if (indexPath.section == 0 && indexPath.row == 0){
        //记录友盟统计模块使用量
        NSString *dictStr = [NSString stringWithFormat:@"%@_%@", @"我要拿现金", [self class]];
        NSDictionary *dict = @{@"Function" : dictStr};
        [MobClick event:@"buttonClick" attributes:dict];
        
        AnswerDetailCtl *answerDetailCtl = [[AnswerDetailCtl alloc] init];
        answerDetailCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:answerDetailCtl animated:YES];
        [answerDetailCtl beginLoad:recommentModal.question_id exParam:nil];
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
    if (scrollView == self.tableView && [self.tableView numberOfSections] > 0){
        if (_refreshHeaderView.state == ELEGOOPullRefreshLoading) {
            if (scrollView.contentOffset.y > 0){
                [self.tableView setContentInset:UIEdgeInsetsZero];
            }
        }
        CGRect headFrame = [self.tableView rectForHeaderInSection:1];
        CGFloat moveHeight = searchBackView.top;
        if (scrollView.contentOffset.y <= 46 || scrollView.contentOffset.y > headFrame.origin.y){
            if (scrollView.contentOffset.y > oldTableContentSetY){
                moveHeight = -46;
            }else if(scrollView.contentOffset.y < oldTableContentSetY){
                moveHeight = 0;
            }
        }

        if (moveHeight != searchBackView.top && !finishAnimation){
            finishAnimation = YES;
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                searchBackView.frame = CGRectMake(0,moveHeight,ScreenWidth,46);
                self.tableView.frame = CGRectMake(0,moveHeight+46,ScreenWidth,viewHeight-46-moveHeight);
            } completion:^(BOOL finished) {
                finishAnimation = NO;
            }];
        }
        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y <(scrollView.contentSize.height-scrollView.height)) {
            oldTableContentSetY = scrollView.contentOffset.y;
        }
    }
}

#pragma mark - 左右列表切换
-(void)changeDateButtonRespone:(UIButton *)sender{
    if (_refreshHeaderView.state == ELEGOOPullRefreshLoading || _refreshFooterView.state == ELEGOOPullRefreshLoading || [self.tableView numberOfSections] <= 0) {
        return;
    }    
    [_dataArray removeAllObjects];
    CGRect headFrame = [self.tableView rectForHeaderInSection:1];
    if (self.tableView.contentOffset.y >= headFrame.origin.y){
        oldTableContentSetY = headFrame.origin.y;
        self.tableView.contentOffset = CGPointMake(0,headFrame.origin.y);
    }
    self.tableView.tableFooterView = nil;
    if (sender == segmentLeftButton){
        selectRightButton = NO;
        if (leftArr.count > 0) {
            [_dataArray addObjectsFromArray:leftArr];
            self.tableView.tableFooterView = nil;
        }
        [self.tableView reloadData];
    }else if (sender == segmentRightButton){
        selectRightButton = YES;
        if (rightArr.count > 0) {
            [_dataArray addObjectsFromArray:rightArr];
            self.tableView.tableFooterView = nil;
        }
        [self.tableView reloadData];
    }
    [self changeButtonStatus];
    [self refreshEGORefreshView];
    [self adjustFooterViewFrame];
}

-(void)changeButtonStatus{
    if (!selectRightButton){
        [segmentLeftButton setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateNormal];
        [segmentRightButton setTitleColor:UIColorFromRGB(0x9e9e9e) forState:UIControlStateNormal];
    }else{
        [segmentRightButton setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateNormal];
        [segmentLeftButton setTitleColor:UIColorFromRGB(0x9e9e9e) forState:UIControlStateNormal];
    }
}

#pragma mark - 点击事件
-(void)btnResponse:(id)sender{
    if (sender == searchBtn) {
        myJobGroupSearchCtr *searchCtr = [[myJobGroupSearchCtr alloc] init];
        searchCtr.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr].centerNav_ pushViewController:searchCtr animated:YES];
    }
}

-(void)rightBarBtnResponse:(id)sender
{
    if ([Manager shareMgr].haveLogin) {
        AskDefaultCtl* askDefaultCtl_ = [[AskDefaultCtl alloc]init];
        askDefaultCtl_.backCtlIndex = self.navigationController.viewControllers.count-1;
        askDefaultCtl_.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:askDefaultCtl_ animated:YES];
        [askDefaultCtl_ beginLoad:nil exParam:nil];
    }
    else{
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_Set_Question;
        return;
    }
    NSString *dictStr = [NSString stringWithFormat:@"%@_%@", @"提问", [self class]];
    NSDictionary *dict = @{@"Function" : dictStr};
    [MobClick event:@"buttonClick" attributes:dict];
}

#pragma mark - NoLoginDelegate跳转登录的代理
-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_Set_Question:
        {
            AskDefaultCtl* askDefaultCtl_ = [[AskDefaultCtl alloc]init];
            askDefaultCtl_.backCtlIndex = self.navigationController.viewControllers.count-1;
            askDefaultCtl_.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:askDefaultCtl_ animated:YES];
            [askDefaultCtl_ beginLoad:nil exParam:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 我来回答
- (void)answerBtnclick:(UIButton *)sender
{
    //记录友盟统计模块使用量
    NSString *dictStr = [NSString stringWithFormat:@"%@_%@", @"我来回答", [self class]];
    NSDictionary *dict = @{@"Function" : dictStr};
    [MobClick event:@"buttonClick" attributes:dict];
    
    JobGuideQuizModal *selectModal = [_dataArray objectAtIndex:sender.tag];
    
    AnswerDetailCtl *answerDetailCtl = [[AnswerDetailCtl alloc] init];
    answerDetailCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:answerDetailCtl animated:YES];
    [answerDetailCtl beginLoad:selectModal.question_id exParam:nil];
}

#pragma mark - 悬赏问答卡片按钮点击
- (void)cellAnswerBtnclick:(UIButton *)sender
{
    //记录友盟统计模块使用量
    NSString *dictStr = [NSString stringWithFormat:@"%@_%@", @"我要拿现金", [self class]];
    NSDictionary *dict = @{@"Function" : dictStr};
    [MobClick event:@"buttonClick" attributes:dict];
    
    AnswerDetailCtl *answerDetailCtl = [[AnswerDetailCtl alloc] init];
    answerDetailCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:answerDetailCtl animated:YES];
    [answerDetailCtl beginLoad:recommentModal.question_id exParam:nil];
}

#pragma mark - 重写父类的相关方法
-(void)parserPageInfo:(NSDictionary *)dic
{
    if (selectRightButton) {
        self.pageInfo = rightPage;
    }else{
        self.pageInfo = leftPage;
    }
    [super parserPageInfo:dic];
}

- (void)finishReloadingData{
    if (selectRightButton) {
        self.pageInfo = rightPage;
    }else{
        self.pageInfo = leftPage;
    }
    [super finishReloadingData];
}
-(void)refreshDataSource{
    if (selectRightButton){
        self.pageInfo = rightPage;
        [rightArr removeAllObjects];
    }else{
        self.pageInfo = leftPage;
        [leftArr removeAllObjects];
    }
    [super refreshDataSource];
}

-(void)refreshEGORefreshView
{
    if (selectRightButton) {
        self.pageInfo = rightPage;
    }else{
        self.pageInfo = leftPage;
    }
    if (_dataArray.count <= 0) {//没有任何数据
        self.pageInfo.lastPageFlag = YES;
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable)
        {//有网络
            [self showRefreshNoDateView:YES];
        }
        [self removeFooterView];
    }else{
        [self showNoNetworkView:NO];
        [self showRefreshNoDateView:NO];
        [self showNoMoreDataView:NO];
        //currentPage_ 从0开始
        if (self.pageInfo.currentPage_ >= self.pageInfo.pageCnt_ && self.pageInfo.lastPageFlag)
        {//最后一页
            self.pageInfo.lastPageFlag = YES;
            _refreshFooterView.hidden = YES;
            [self showNoMoreDataView:YES];
        }
        else{
            self.pageInfo.lastPageFlag = NO;
            [self setFooterView];
        }
    }
}

-(void)showRefreshNoDateView:(BOOL) flag
{
    if (flag) {
        if (self.showNoDataViewFlag) {
            if (!noDataView) {
                noDataView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,300)];
                [noDataView setBackgroundColor:UIColorFromRGB(0xffffff)];
                
                UIImageView *imagevv = [[UIImageView alloc] initWithFrame:CGRectMake((noDataView.frame.size.width - 213)/2,20, 213, 179)];
                [imagevv setImage:[UIImage imageNamed:@"img_noData.png"]];
                UILabel *tipsLb = [[UILabel alloc] initWithFrame:CGRectMake(0,imagevv.bottom + 14,noDataView.frame.size.width, 30)];
                [tipsLb setText:@"没有请求到数据哦!请下拉试试!"];
                tipsLb.textAlignment = NSTextAlignmentCenter;
                tipsLb.font = [UIFont fontWithName:@"Helvetica-Regular" size:14];
                tipsLb.textColor = UIColorFromRGB(0xbbbbbb);
                [noDataView addSubview:tipsLb];
                [noDataView addSubview:imagevv];
            }
            self.tableView.tableFooterView = noDataView;
        }
    }
    else{
        if (noDataView) {
            [noDataView removeFromSuperview];
            noDataView = nil;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

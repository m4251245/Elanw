//
//  AnswerDetailCtl.m
//  Association
//
//  Created by 一览iOS on 14-3-7.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "AnswerDetailCtl.h"
#import "CommentListCtlOld.h"
#import "MLEmojiLabel.h"
#import "FaceScrollView.h"
#import "Comment_DataModal.h"
#import "FaceScrollView.h"
#import "NoLoginPromptCtl.h"
#import "AddAppraiseViewCtl.h"
#import "ELExpertStarView.h"
#import "RewardAmountCtl.h"
#import "ELPersonCenterCtl.h"
#import "ELRewardLuckyBagAnimationCtl.h"
#import "Reward_DataModal.h"
#import "TextFlowView.h"
#import "UIImageView+WebCache.h"
#import "ELAnswerLableView.h"
#import "ELAnswerLableModel.h"
#import "ELAnswerEditorCtl.h"
#import "ELButtonView.h"

@interface AnswerDetailCtl () <NoLoginDelegate,buttonDelegate,UIAlertViewDelegate,RefreshDelegate>
{
    
    BOOL shouldRefresh_;
    NSInteger answerType;   /**<回答类型 */
    NSInteger rowNum;       /**<表的某一行 */
        
    NSInteger   supBtnCount_;
    NSInteger   supBtnTag_;
    
    AddAppraiseViewCtl *addAppraiseView;    /**<评价 */
    AnswerListModal *newAnswerDataModal;
    ELExpertStarView *starView;
    
    BOOL isAppraiseView;
    
    
    IBOutlet UIImageView *_quizzPersonImg;  /**<提问者头像 */
    
    __weak IBOutlet UILabel *questionLable;
    
    IBOutlet UIView *_rewardInfoView;       /**<打赏信息背景 */
    NSMutableArray *rewardInfoArr;
    
    TextFlowView *rewardLb;
    
    __weak IBOutlet NSLayoutConstraint *questionLbTop;
    
    __weak IBOutlet NSLayoutConstraint *anserTagViewHeight;
    
    __weak IBOutlet UILabel *qeustionText;
    
    __weak IBOutlet NSLayoutConstraint *dateLableBotton;
    
    __weak IBOutlet UIButton *changeButton;
    
    __weak IBOutlet NSLayoutConstraint *bottomButtomBottom;
    
    __weak IBOutlet UIButton *bottomButton;
    
    AnswerListModal *myAnswerModel;
    
    UIView *noDataLableView;
    
    ELAnswerLableView *lableView;
    
    UIView *aboutAnswerView;
    ELButtonView *contentText;
}

@end

@implementation AnswerDetailCtl
@synthesize questionLb_,headView_,questionTimeLb_,questionNameBtn_;

-(id)init
{
    self  = [super init ];
    
    bFooterEgo_ = YES;
    rightNavBarStr_ = @"分享";
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self setFd_prefersNavigationBarHidden:NO];
    [super viewWillDisappear:animated];
    
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_  egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        shouldRefresh_ = YES;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"parserAnswerDetailNew" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavTitle:@"问答详情"];
    [self setFd_prefersNavigationBarHidden:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(questionInfo:) name:@"parserAnswerDetailNew" object:nil];
    if (requestCon_ && ([requestCon_.dataArr_  count] == 0 || shouldRefresh_) ) {
        [self refreshLoad:nil];
    }
    if ([Manager shareMgr].isShowRewardAnimat) {
        [self starAnimation];
        [self refreshLoad:nil];
    }
}

-(void)viewDidLayoutSubviews{
    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
//    self.navigationItem.title = @"问答详情";
    
//    [_faceBtn setImage:[UIImage imageNamed:@"icon_keyboard.png"] forState:UIControlStateSelected];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _quizzPersonImg.layer.cornerRadius = 4.0;
    _quizzPersonImg.layer.masksToBounds = YES;
    _quizzPersonImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quizzPersonImgTap)];
    [_quizzPersonImg addGestureRecognizer:singleTap];
    
    questionLable.userInteractionEnabled = YES;
    [questionLable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quizzPersonImgTap)]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWithEditorSuccess) name:@"answerEditorSuccessRefresh" object:nil];
    isAppraiseView = NO;
    headView_.hidden = YES;
}

-(void)refreshWithEditorSuccess{
    [self refreshLoad:nil];
}

#pragma mark - 请求加载数据
- (void)questionInfo:(NSNotification *)tification
{
    AnswerDetialModal * dataModal = tification.userInfo[@"modal"];
    answerDetialModal = dataModal;
    if (![[Manager getUserInfo].userId_ isEqualToString:answerDetialModal.person_id]){
        if ([dataModal.question_status integerValue] == 0 || [dataModal.question_status integerValue] == 2) {
            rightBarBtn_.hidden = YES;
            tableView_.hidden = YES;
            CGFloat centerY = (ScreenHeight-64)/2.0;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,55,50)];
            imageView.image = [UIImage imageNamed:@"article_delete_image"];
            imageView.center = CGPointMake(ScreenWidth/2.0,centerY-50);
            [self.view addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(imageView.frame)+10,ScreenWidth,40)];
            label.font = [UIFont systemFontOfSize:15];
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:label];
            
            if ([dataModal.question_status integerValue] == 2) {
                label.text = @"该问题违反相关法律法规以及道德规范的内容\n已被禁用或删除";
            }else if ([dataModal.question_status integerValue] == 0){
                label.text = @"该提问正在审核中，暂不能查看\n请耐心等待...";
            }
            return;
        }
    }
    rightBarBtn_.hidden = NO;
    if ([answerDetialModal.is_recommend isEqualToString:@"1"]) {
        [self getRewardInfo];
    }
    if (answerDetialModal.question_replys_count == nil || [answerDetialModal.question_replys_count isEqualToString:@""] || [answerDetialModal.question_replys_count isEqualToString:@"0"]) {
        if (!noDataLableView) {
            noDataLableView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,60)];
            noDataLableView.backgroundColor = [UIColor clearColor];
            if ([Manager shareMgr].haveLogin && [[Manager getUserInfo].userId_ isEqualToString:answerDetialModal.person_id]) {
                UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0,22,ScreenWidth,15)];
                lable.font = [UIFont systemFontOfSize:13];
                lable.textColor = UIColorFromRGB(0xbdbdbd);
                lable.textAlignment = NSTextAlignmentCenter;
                lable.text = @"不能回答自己提出的问题";
                [noDataLableView addSubview:lable];
            }
            UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0,40,ScreenWidth,15)];
            lable1.font = [UIFont systemFontOfSize:13];
            lable1.textColor = UIColorFromRGB(0xbdbdbd);
            lable1.textAlignment = NSTextAlignmentCenter;
            lable1.text = @"暂无回答";
            [noDataLableView addSubview:lable1];
        }
        tableView_.tableFooterView = noDataLableView;
    }
    [self updateInfo];
    [tableView_ reloadData];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    
    if (!answerDetialModal) {
        answerDetialModal = [[AnswerDetialModal alloc] init];
    }
    answerDetialModal.question_id = dataModal;
}

-(void)getDataFunction:(RequestCon *)con
{
    NSString * userId = [Manager getUserInfo].userId_;
    if (![Manager shareMgr].haveLogin) {
        userId = @"";
    }
    [con getAnswerDetailNew:answerDetialModal.question_id pageSize:20 pageIndex:requestCon_.pageInfo_.currentPage_ personId:userId];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_AnswerDetailNew:
        {
            super.noDataTips = @"";
            shouldRefresh_ = NO;
            for (AnswerListModal *model in requestCon.dataArr_) {
                if ([Manager shareMgr].haveLogin && [model.answer_person_detail.person_id isEqualToString:[Manager getUserInfo].userId_]) {
                    myAnswerModel = model;
                    [self refreshBottomButton];
                    break;
                }
            }
        }
            break;
        case Request_UpdateAnserSupportCount:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:@"OK"]) {
                [BaseUIViewController showAutoDismissSucessView:@"赞了一下" msg:nil];
                AnswerListModal * dataModal = [requestCon_.dataArr_ objectAtIndex:supBtnTag_ - 200000];
                dataModal.is_support = @"1";
               [dataModal setAnswer_support_count:[NSString stringWithFormat:@"%d",[dataModal.answer_support_count intValue] + 1]];
                [tableView_ reloadData];
            }else{
                [BaseUIViewController showAutoDismissFailView:@"您已经赞过了" msg:nil];
            }
            
        }
            break;
        case Request_AnswerQuestion:
        {
//            Status_DataModal *model = [dataArr objectAtIndex:0];
//            if ([model.status_ isEqualToString:@"OK"]) {
//                [self.giveCommentTv_ setText:@""];
//                [self refreshLoad:nil];
//                [BaseUIViewController showAutoDismissSucessView:model.des_ msg:nil];
//
//                [self.giveCommentTv_ resignFirstResponder];
//                [self changeTextViewFrame];
//            }
//            else if([model.code_ isEqualToString:@"400"]){
//                [BaseUIViewController  showAutoDismissFailView:model.des_ msg:nil];
//            }
//            else if ([model.code_ isEqualToString:@"401"]){
//                [BaseUIViewController showAutoDismissFailView:model.des_ msg:nil];
//            }
        }
            break;
        case Request_GetAddtExpertComment:
        {
            [BaseUIViewController showAlertViewContent:@"评价成功" toView:nil second:2.0 animated:YES];
            addAppraiseView.textView_.text = @"";
            addAppraiseView.tipLb_.text = @"输入对行家回答的看法";
        }
            break;
        default:
            break;
    }
}

#pragma mark 更新数据
- (void)updateInfo
{
    //打赏信息走马灯
    NSString *rewardInfo = nil;
    if (rewardInfoArr.count > 3) {
        _rewardInfoView.hidden = NO;
        for (Reward_DataModal *rewardModel in rewardInfoArr) {
            
            if (rewardInfo.length > 0) {
                rewardInfo = [NSString stringWithFormat:@"%@,%@获得%@元现金打赏", rewardInfo, rewardModel.name_,rewardModel.money];
            }
            else
            {
                rewardInfo = [NSString stringWithFormat:@"%@获得%@元现金打赏", rewardModel.name_,rewardModel.money];
            }
        }
        
        CGSize rewardInfoSize = [rewardInfo sizeNewWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(MAXFLOAT, 16)];
        if (!rewardLb) {
            rewardLb =[[TextFlowView alloc] initWithFrame:CGRectMake(30, 6, rewardInfoSize.width, 16) Text:rewardInfo];
            [rewardLb setColor:UIColorFromRGB(0xE4403a)];
            [rewardLb setFont:[UIFont systemFontOfSize:13.0f]];
            [_rewardInfoView addSubview:rewardLb];
            
        }
        questionLbTop.constant = 40;
    }
    else
    {
        _rewardInfoView.hidden = YES;
        questionLbTop.constant = 12;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    questionLb_.attributedText = [[NSAttributedString alloc] initWithString:answerDetialModal.question_title attributes:attributes];
    
    
    if (answerDetialModal.old_question_content && ![answerDetialModal.old_question_content isEqualToString:@""])
    {
        NSString *content = answerDetialModal.old_question_content;
        content = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><meta charset=\"utf-8\"><style type=\"text/css\">img{display: inline-block;height:auto;}</style></head><body>%@</body></html>",content];
        
        content = [content stringByReplacingOccurrencesOfString:@"<img " withString:[NSString stringWithFormat:@"<img style=\"max-width:%fpx\" ",ScreenWidth-16]];
        
        qeustionText.hidden = NO;
        [self.view layoutIfNeeded];

        NSMutableAttributedString *string = [content getHtmlAttString];
        [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x666666) range:NSMakeRange(0,string.length)];
        [string addAttributes:attributes range:NSMakeRange(0,string.length)];
        string = [[Manager shareMgr] getEmojiStringWithAttString:string withImageSize:CGSizeMake(18,18)];
        
        if (!contentText) {
            contentText = [[ELButtonView alloc] initWithTwoTypeFrame:CGRectMake(0,0,ScreenWidth-20,30)];
            [headView_ addSubview:contentText];
        }
        contentText.frame = CGRectMake(0,0,ScreenWidth-20,30);
        [contentText setAttributedText:string];
        [contentText layoutFrame];
        CGRect frame = contentText.frame;
        frame.origin.x = 8;
        frame.origin.y = CGRectGetMaxY(qeustionText.frame)+8;
        contentText.frame = frame;
        
    }else{
        qeustionText.hidden = YES;
    }
    
    [_quizzPersonImg sd_setImageWithURL:[NSURL URLWithString:answerDetialModal.person_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"] options:SDWebImageAllowInvalidSSLCertificates];
    
    //提问者名字
    if (!answerDetialModal.person_iname) {
        answerDetialModal.person_iname = @"";
    }
    [questionNameBtn_ setTitle:answerDetialModal.person_iname forState:UIControlStateNormal];
    
    NSString *questionTime = [MyCommon getShortTime:answerDetialModal.question_idate];
    questionTimeLb_.text = [NSString stringWithFormat:@"提问于%@",questionTime];
    
    NSMutableArray *tagArr;
    if (answerDetialModal.tradeid && [answerDetialModal.tradeid integerValue] != 0) {
        CondictionList_DataModal *model = [CondictionTradeCtl returnModelWithTradeId:answerDetialModal.tradeid];
        if (model){
            model.pName = [CondictionTradeCtl getTotalNameWithTotalId:model.pId_];
            if (!tagArr) {
                tagArr = [[NSMutableArray alloc] init];
            }
            ELAnswerLableModel *lableModel = [[ELAnswerLableModel alloc] init];
            lableModel.name = [NSString stringWithFormat:@"%@-%@",model.pName,model.str_];
            lableModel.colorType = GrayColorType;
            lableModel.tradeModel = model;
            [tagArr addObject:lableModel];
        }
    }
    
    if (answerDetialModal.tag_info.count > 0) {
        if (!tagArr) {
            tagArr = [[NSMutableArray alloc] init];
        }
        for (NSInteger i = 0;i<answerDetialModal.tag_info.count; i++) {
            ELAnswerLableModel *lableModel = [[ELAnswerLableModel alloc] init];
            lableModel.name = answerDetialModal.tag_info[i];
            lableModel.colorType = CyanColorType;
            [tagArr addObject:lableModel];
        }
    }
    
    if (tagArr) {
        if (!lableView) {
            lableView = [[ELAnswerLableView alloc] init];
            [_anserTagView_ addSubview:lableView];
        }
        lableView.frame = CGRectMake(8,0,ScreenWidth-8,0);
        [lableView giveDataModalWithArr:tagArr];
        anserTagViewHeight.constant = 45+lableView.height+17;
        lableView.hidden = NO;
    }else{
        anserTagViewHeight.constant = 45;
        if (lableView) {
            lableView.hidden = YES;
        }
    }
    
    [self refreshBottomButton];
   
    [self.view layoutIfNeeded];
    CGFloat height = CGRectGetMaxY(questionLb_.frame)+14;
    if (contentText){
        height = CGRectGetMaxY(contentText.frame)+14;
    }
    headView_.frame = CGRectMake(0, 0, ScreenWidth, height+anserTagViewHeight.constant + 10);
    
    [self getNoDataView].hidden = YES;
    headView_.hidden = NO;
    tableView_.tableHeaderView = headView_;
    [tableView_ reloadData];
    [self adjustFooterViewFrame];
}

-(void)refreshBottomButton{
    if ([[Manager getUserInfo].userId_ isEqualToString:answerDetialModal.person_id] && [Manager shareMgr].haveLogin) {
        changeButton.hidden = NO;
        dateLableBotton.constant = 38;
        bottomButtomBottom.constant = -44;
    }else{
        if (myAnswerModel) {
            [bottomButton setTitle:@"修改我的回答" forState:UIControlStateNormal];
        }else{
            [bottomButton setTitle:@"回答" forState:UIControlStateNormal];
        }
        changeButton.hidden = YES;
        dateLableBotton.constant = 30;
        bottomButtomBottom.constant = 0;
    }
}

#pragma mark - TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if ([answerDetialModal.relative_question_list isKindOfClass:[NSArray class]] && answerDetialModal.relative_question_list.count > 0) {
        if( [requestCon_.dataArr_ count] > 0 ){
            if( requestCon_.pageInfo_.currentPage_ > requestCon_.pageInfo_.pageCnt_ ){
                return 2;
            }
        }else{
           return 2; 
        }
    }
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return answerDetialModal.relative_question_list.count;
    }
    return requestCon_.dataArr_.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        static NSString *cellStr = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xf0f0f0);
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(8,15,ScreenWidth-16,20)];
            lable.tag = 1001;
            lable.font = FIFTEENFONT_TITLE;
            lable.textColor = UIColorFromRGB(0x424242);
            [cell.contentView addSubview:lable];
            
            [cell.contentView addSubview:[[ELLineView alloc] initWithFrame:CGRectMake(8,47,ScreenWidth-8,1) WithColor:UIColorFromRGB(0xe0e0e0)]];
        }
        UILabel *lable = (UILabel *)[cell.contentView viewWithTag:1001];
        NSDictionary *dic = answerDetialModal.relative_question_list[indexPath.row];
        lable.text = dic[@"question_title"];
        return cell;
    }
    AnswerDetailCtl_Cell *cell = [AnswerDetailCtl_Cell getTableViewCellWithTableView:tableView];        
    AnswerListModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    
    [cell giveAnswerListModel:dataModal andAnswerDetialModal:answerDetialModal];
    
    [cell.imgViewBtn_ addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.imgViewBtn_ setTag:indexPath.row + 100000];
    
    [cell.supportCountBtn_ addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.supportCountBtn_ setTag:indexPath.row + 200000];
    
    [cell.appraiseBtn_ addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.appraiseBtn_ setTag:indexPath.row + 300000];
    
    [cell.payBtn_ addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.payBtn_ setTag:indexPath.row + 400000];
    
    [cell.commentCountBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentCountBtn setTag:indexPath.row + 500000];
    
    cell.morePl.userInteractionEnabled = YES;
    cell.morePl.tag = 2000+indexPath.row;
    [cell.morePl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreTap:)]];
    
    return cell;
}

-(void)moreTap:(UITapGestureRecognizer *)sender{
    AnswerListModal * dataModal = [requestCon_.dataArr_ objectAtIndex:sender.view.tag - 2000];
    CommentListCtlOld *commentListOld = [[CommentListCtlOld alloc] init];
    commentListOld.delegate_ = self;
    [self.navigationController pushViewController:commentListOld animated:YES];
    [commentListOld beginLoad:dataModal exParam:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 48;
    }
    AnswerListModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    return dataModal.cellHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        if (!aboutAnswerView) {
            aboutAnswerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,48)];
            aboutAnswerView.backgroundColor = UIColorFromRGB(0xf5f5f5);
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,15,ScreenWidth,38)];
            backView.backgroundColor = [UIColor whiteColor];
            [aboutAnswerView addSubview:backView];
            
            [backView addSubview:[[ELLineView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)]];
            [backView addSubview:[[ELLineView alloc] initWithFrame:CGRectMake(0,37,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)]];
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(8,9,100,20)];
            lable.font = [UIFont systemFontOfSize:14];
            lable.textColor = UIColorFromRGB(0x9e9e9e);
            lable.text = @"相关问题";
            [backView addSubview:lable];
        }
        return aboutAnswerView;
    }
    if ([answerDetialModal.question_status integerValue] == 0 && answerDetialModal.question_title) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,16,ScreenWidth-32,46)];
        view.backgroundColor = UIColorFromRGB(0xfff8e3);
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(16,8,ScreenWidth-32,30)];
        lable.text = @"提交或修改的问题需要审核通过后，其他用户才能看到，请耐心等待，正在审核中...";
        lable.numberOfLines = 2;
        lable.font = [UIFont systemFontOfSize:12];
        lable.textColor = UIColorFromRGB(0xff6600);
        [view addSubview:lable];
        return view; 
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,15)];
        view.backgroundColor = UIColorFromRGB(0xf5f5f5);
        return view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 48;
    }
    if ([answerDetialModal.question_status integerValue] == 0 && answerDetialModal.question_title) {
        return 46;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 1){
        return 15;
    }
    return 0.1;
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSDictionary *dic = answerDetialModal.relative_question_list[indexPath.row];
        NSString *questionId = dic[@"question_id"];
        if (questionId && ![questionId isEqualToString:@""]) {
            AnswerDetailCtl * detailCtl = [[AnswerDetailCtl alloc] init];
            [[Manager shareMgr].centerNav_ pushViewController:detailCtl animated:YES];
            [detailCtl beginLoad:questionId exParam:exParam];
        }
        return;
    }
}

#pragma mark - 提问者头像单击
- (void)quizzPersonImgTap
{
    ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
    [personCenterCtl beginLoad:answerDetialModal.person_id exParam:nil];
    [self.navigationController pushViewController:personCenterCtl animated:YES];
}

#pragma mark - 设置右按扭的属性
-(void) setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"" forState:UIControlStateNormal];
    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if( [rightNavBarStr_ length] >= 4 ){
        [rightBarBtn_ setFrame:CGRectMake(0, 0, 40, 40)];
    }else{
        [rightBarBtn_ setFrame:CGRectMake(0, 0, 40, 40)];
    }
    rightBarBtn_.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [rightBarBtn_ setImage:[UIImage imageNamed:@"share_white-2"] forState:UIControlStateNormal];
}
#pragma mark - 点击事件
-(void)rightBarBtnResponse:(id)sender
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1024" ofType:@"png"];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    AnswerListModal *myModal;
    NSString * sharecontent;
    if (requestCon_.dataArr_.count)
    {
        myModal = [requestCon_.dataArr_ objectAtIndex:0];
        sharecontent = myModal.answer_content;
    }
    
    NSString * titlecontent = [NSString stringWithFormat:@"%@",answerDetialModal.question_title];
    
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/answer_detail/%@.htm?type=all",answerDetialModal.question_id];
    //分享
    [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url];
}


-(void) backBarBtnResponse:(id)sender
{
    if (_isAsk){
        NSArray *array = [self.navigationController viewControllers];
        UIViewController *viewCtl = [array objectAtIndex:0];
        if (_backCtlIndex > 0 && _backCtlIndex < array.count){
            viewCtl = [array objectAtIndex:_backCtlIndex];
        }
        [self.navigationController popToViewController:viewCtl animated:YES];
    }else{
        [super backBarBtnResponse:sender];
    }
}

- (void)btnResponse:(id)sender
{
    UIButton *btn = sender;
    if ([sender isKindOfClass:[UIButton class]] && btn.tag/100000 == 1)
    {//跳转个人主页
        //记录友盟统计模块使用量
        NSString *dictStr = [NSString stringWithFormat:@"%@_%@", @"跳转个人主页", [self class]];
        NSDictionary *dict = @{@"Function" : dictStr};
        [MobClick event:@"buttonClick" attributes:dict];
        
        AnswerListModal * dataModal = [requestCon_.dataArr_ objectAtIndex:btn.tag - 100000];
        ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
        [personCenterCtl beginLoad:dataModal.answer_person_detail.person_id exParam:nil];
        [self.navigationController pushViewController:personCenterCtl animated:YES];
        return;
    }else if (sender == questionNameBtn_){
        ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
        [self.navigationController pushViewController:personCenterCtl animated:YES];
        [personCenterCtl beginLoad:answerDetialModal.person_id exParam:nil];
        return;
    }

    
#pragma mark - 需要登录才能做的操作，无需登录的操作写在上面    
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        [NoLoginPromptCtl getNoLoginManager].loginType = LoginFollow_AnswerDetail;
        [NoLoginPromptCtl getNoLoginManager].button = btn;
        return;
    }
    if ([sender isKindOfClass:[UIButton class]] && btn.tag/100000 == 3)
    {//评论回答
        //记录友盟统计模块使用量
        NSString *dictStr = [NSString stringWithFormat:@"%@_%@", @"评论回答", [self class]];
        NSDictionary *dict = @{@"Function" : dictStr};
        [MobClick event:@"buttonClick" attributes:dict];
        
        if (!addAppraiseView) {
            addAppraiseView = [[AddAppraiseViewCtl alloc] init];
            addAppraiseView.btnDelegate = self;
            [addAppraiseView.view setFrame:[UIScreen mainScreen].bounds];
        }
        [addAppraiseView showViewCtl];
        if (!starView) {
            starView = [[ELExpertStarView alloc] initWithFrame:CGRectMake(10,25,200,30)];
            starView.selectedBtn = YES;
        }
        [starView removeFromSuperview];
        [addAppraiseView.bgView_ addSubview:starView];
        [starView giveDataWithStar:5];
        newAnswerDataModal = [requestCon_.dataArr_ objectAtIndex:btn.tag - 300000];
        isAppraiseView = YES;
        return;
    }
    else if ([sender isKindOfClass:[UIButton class]] && btn.tag/100000 == 2)
    {//点赞回答
        //记录友盟统计模块使用量
        NSString *dictStr = [NSString stringWithFormat:@"%@_%@", @"点赞回答", [self class]];
        NSDictionary *dict = @{@"Function" : dictStr};
        [MobClick event:@"buttonClick" attributes:dict];
        
        AnswerListModal * dataModal = [requestCon_.dataArr_ objectAtIndex:btn.tag - 200000];
        if (!addSupportCon_) {
            addSupportCon_ = [self getNewRequestCon:NO];
        }
        supBtnCount_ = [btn.titleLabel.text intValue];
        supBtnTag_ = btn.tag;
        [addSupportCon_ updateAnserSupportCount:[Manager getUserInfo].userId_ anserId:dataModal.answer_id type:@"support" updateType:@"add" updateNum:@"1"];
        return;
    }
    else if ([sender isKindOfClass:[UIButton class]] && btn.tag/100000 == 4)
    {//打赏回答
        //记录友盟统计模块使用量
        NSString *dictStr = [NSString stringWithFormat:@"%@_%@", @"打赏回答", [self class]];
        NSDictionary *dict = @{@"Function" : dictStr};
        [MobClick event:@"buttonClick" attributes:dict];
        
        [Manager shareMgr].dashangBackCtlIndex = self.navigationController.viewControllers.count-1;
        AnswerListModal * dataModal = [requestCon_.dataArr_ objectAtIndex:btn.tag - 400000];
        RewardAmountCtl *rewardAmountCtl = [[RewardAmountCtl alloc] init];
        rewardAmountCtl.personId = dataModal.answer_person_detail.person_id;
        rewardAmountCtl.personName = dataModal.answer_person_detail.person_iname;
        rewardAmountCtl.personPic = dataModal.answer_person_detail.person_pic;
        rewardAmountCtl.productId = dataModal.answer_id;
        rewardAmountCtl.productType = @"1";
        [self.navigationController pushViewController:rewardAmountCtl animated:YES];
    }else if ([sender isKindOfClass:[UIButton class]] && btn.tag/100000 == 5){
        AnswerListModal * dataModal = [requestCon_.dataArr_ objectAtIndex:btn.tag - 500000];
        CommentListCtlOld *commentListOld = [[CommentListCtlOld alloc] init];
        commentListOld.delegate_ = self;
        [self.navigationController pushViewController:commentListOld animated:YES];
        [commentListOld beginLoad:dataModal exParam:nil];
    }else if (sender == bottomButton){
        ELAnswerEditorCtl *ctl = [[ELAnswerEditorCtl alloc] init];
        ctl.questionId = answerDetialModal.question_id;
        ctl.editorModel = myAnswerModel;
        ctl.questionTitle = answerDetialModal.question_title;
        ctl.questionContent = answerDetialModal.question_content;
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (sender == changeButton){
        AskDefaultCtl* askDefaultCtl_ = [[AskDefaultCtl alloc]init];
        AnswerDetialModal *model = [[AnswerDetialModal alloc] init];
        model.question_id = answerDetialModal.question_id;
        model.question_title = answerDetialModal.question_title;
        model.question_content = answerDetialModal.question_content;
        model.tag_info = answerDetialModal.tag_info;
        model.tradeid = answerDetialModal.tradeid;
        model.totalid = answerDetialModal.totalid;
        askDefaultCtl_.editorModel = model;
        [self.navigationController pushViewController:askDefaultCtl_ animated:YES];
        [askDefaultCtl_ beginLoad:nil exParam:nil];
        NSString *dictStr = [NSString stringWithFormat:@"%@_%@", @"修改问答详情", [self class]];
        NSDictionary *dict = @{@"Function" : dictStr};
        [MobClick event:@"buttonClick" attributes:dict];
    }
}

#pragma mark - 其他界面的代理方法 AddAppraiseViewCtlDelegate
- (void)btnResponeWitnIndex:(NSInteger)index
{
    if (index == 111) {
        if (!appraiseCon) {
            appraiseCon = [self getNewRequestCon:NO];
        }
        if ([addAppraiseView.textView_.text isEqualToString:@""]) {
            [addAppraiseView showTextOnly];
        }
        else
        {
            [appraiseCon getAddExpertComment:[Manager getUserInfo].userId_ expertId:newAnswerDataModal.answer_person_detail.person_id content:addAppraiseView.textView_.text type:@"1" typeId:newAnswerDataModal.answer_id star:starView.currentStar];
            [self hideView];
        }
    }else{
        [self hideView];
    }
}

#pragma mark -  行家评价代理buttonDelegate
- (void)setTextViewLayout
{
    if (addAppraiseView.isEdit)
    {
        CGFloat height = 120;
        if (ScreenHeight > 480) {
            height = 220;
        }
        addAppraiseView.bgViewCenterY.constant = height-(ScreenHeight/2.0);
        [UIView animateWithDuration:0.26 animations:^{
            [addAppraiseView.view layoutIfNeeded];
        }];
    }
    addAppraiseView.tipLb_.text = @"";
    addAppraiseView.isEdit = NO;
}

- (void)hideView
{
    if (!addAppraiseView.isEdit) {
        addAppraiseView.isEdit = YES;
        
        if ([addAppraiseView.textView_.text isEqualToString:@""]) {
            addAppraiseView.textView_.text = @"";
            addAppraiseView.tipLb_.text = @"输入对行家回答的看法";
        }
    }
    [addAppraiseView.textView_ resignFirstResponder];
    [addAppraiseView.view removeFromSuperview];
    addAppraiseView = nil;
}

#pragma mark - 打赏成功动画
- (void)starAnimation
{
    ELRewardLuckyBagAnimationCtl *luckyBagCtl = [[ELRewardLuckyBagAnimationCtl alloc] init];
    luckyBagCtl.view.frame = [UIScreen mainScreen].bounds;
    [[[UIApplication sharedApplication] keyWindow] addSubview:luckyBagCtl.view];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:luckyBagCtl.view];
    [luckyBagCtl initBagView];
    [Manager shareMgr].isShowRewardAnimat = NO;
}

#pragma mark - 未登录代理
-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginFollow_AnswerDetail:
        {
            [self btnResponse:[NoLoginPromptCtl getNoLoginManager].button];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 获取当前问答的打赏信息
- (void)getRewardInfo
{
    if (!rewardInfoArr) {
        rewardInfoArr = [[NSMutableArray alloc] init];
    }
    
    if (rewardInfoArr.count != 0) {
        [rewardInfoArr removeAllObjects];
    }
    
    NSString *bodyMsg = [NSString stringWithFormat:@"question_id=%@",answerDetialModal.question_id];
    
    [ELRequest postbodyMsg:bodyMsg op:@"zd_ask_question_busi" func:@"getQuestionLatestDashang" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSArray *rewardArr = result[@"data"];
        if ([rewardArr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in rewardArr) {
                Reward_DataModal *model = [[Reward_DataModal alloc] init];
                model.name_ = dic[@"_target_person_detail"][@"person_iname"];
                model.personId = dic[@"_target_person_detail"][@"personId"];
                model.money = dic[@"money"];
                [rewardInfoArr addObject:model];
            }
        }
        
        [self updateInfo];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

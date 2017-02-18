//
//  SalaryIrrigationCtl.m
//  Association
//
//  Created by 一览iOS on 14-7-2.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "SalaryIrrigationCtl.h"
#import "Comment_DataModal.h"
#import "SalaryIrrigationCtl_Cell.h"
#import "RecommendGXS_Cell.h"
#import "SalaryIrrigationDetailCtl.h"
#import "SalaryChangeTypeCtl.h"
#import "MLEmojiLabel.h"
#import "NoLoginPromptCtl.h"
#import "YLTheTopicCell.h"
#import "ElSalaryModel.h"


@interface SalaryIrrigationCtl () <UISearchBarDelegate,NoLoginDelegate,SalaryIrrigationDetailDelegate,YLTheTopicCellDeletage>
{
    Article_DataModal   * bChooseArticle_;
    NSArray             * colorArr_;
    BOOL                  shouldRefresh_ ;
    BOOL showKeyBoard;
    BOOL isBeginLoad;
    CGPoint scrollSet;
    RequestCon *voteCon;
    NSIndexPath *changPath;
    __weak IBOutlet UIButton *mySalaryBtn;
    IBOutlet UIButton *rightBtnOne;
    NSString *searchKeyWord;
}

@end

@implementation SalaryIrrigationCtl
@synthesize commentTF_,commentView_,giveCommentBtn_;
#pragma mark LifeCycle
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        bHeaderEgo_ = YES;
        bFooterEgo_ = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(salaryIrrigation:) name:@"ShareSalaryArticleOK" object:nil];
        //增加键盘事件的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mykeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mykeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"灌薪水";
    [self setNavTitle:@"灌薪水"];
    publishBtn_.layer.cornerRadius = 4.0;
    searchBtn_.enabled = NO;
    searchBtn_.tintColor = UIColorFromRGB(0xe13e3e);
    kwTF_.delegate = self;
    isSearch = NO;
    showKeyBoard = NO;
    [tableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [kwTF_ setBackgroundImage:[UIImage imageNamed:@""]];
    [kwTF_ setBackgroundColor:PINGLUNHONG];
    kwTF_.tintColor = UIColorFromRGB(0xe13e3e);
    self.navigationItem.titleView = kwTF_;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtnOne];
    tableView_.hidden = YES;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [kwTF_ resignFirstResponder];
    //self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isSalarySearch) {
        [kwTF_ becomeFirstResponder];
        _isSalarySearch = NO;
    }
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inModel_ = dataModal;
    isBeginLoad = YES;
}

-(void)refreshLoad:(RequestCon *)con
{
    [super refreshLoad:con];
    [self hideKeyboard];
}

-(void)getDataFunction:(RequestCon *)con
{
    NSString * userId = [Manager getUserInfo].userId_;
    if (!userId) {
        userId = @"";
    }
    NSString * kw = kwTF_.text;
    if (kw.length > 0) {
        searchKeyWord = kw;
    }
    else if(searchKeyWord.length > 0)
    {
        kw = searchKeyWord;
    }
    [con getSalaryArticleByES:kw pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:12 personId:userId];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetSalaryArticleByES:
        {
            if (dataArr.count <= 0) {
                self.noDataTips = @"暂无相关结果，替换关键词再试试吧";
                self.noDataImgStr = @"img_search_noData.png";
            }
        }
            break;
        case Request_AddVoteLogs:
        {
            NSDictionary *dicVote = dataArr[0];
            if ([dicVote[@"status"] isEqualToString:@"OK"])
            {
                Article_DataModal *dataModal = requestCon_.dataArr_[changPath.row];
                dataModal.isVote = dicVote[@"is_vote"];
                dataModal.canVote = dicVote[@"can_vote"];
                dataModal.status = dicVote[@"status"];
                dataModal.allVote = dicVote[@"all_vote"];
                NSArray *voteArr = dicVote[@"option_info"];
                if (!dataModal.resultDataArr) {
                    dataModal.resultDataArr = [[NSMutableArray alloc] init];
                }
                [dataModal.resultDataArr removeAllObjects];
                for (NSDictionary *dicTwo in voteArr) {
                    YLVoteDataModal *voteModal = [[YLVoteDataModal alloc] init];
                    voteModal.gaapName = dicTwo[@"gaap_name"];
                    voteModal.gaapId = dicTwo[@"gaap_id"];
                    voteModal.sort = dicTwo[@"sort"];
                    voteModal.isBest = dicTwo[@"is_best"];
                    voteModal.result = dicTwo[@"result"];
                    [dataModal.resultDataArr addObject:voteModal];
                }
                [tableView_ reloadData];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELSalaryModel * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    
    if ([dataModal.status isEqualToString:@"OK"]) {
        static NSString *cellStr = @"YLTheTopicCell";
        
        YLTheTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"YLTheTopicCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.likeBtn.tag = 1000 + indexPath.row;
        cell.shareBtn.tag = 3000 + indexPath.row;
        [cell.likeBtn addTarget:self action:@selector(addArticleLike:) forControlEvents:UIControlEventTouchUpInside];
        [cell.shareBtn addTarget:self action:@selector(shareArticle:) forControlEvents:UIControlEventTouchUpInside];
        cell.cellDelegate = self;
        dataModal.indexpath = indexPath;
        [cell giveDateModal:dataModal];
        [cell.imageLine removeFromSuperview];
        cell.imageLine.frame = CGRectMake(-10,0,330,1);
        [cell.contentView addSubview:cell.imageLine];
        return cell;
    }
    
    if ([dataModal.is_recommend isEqualToString:@"0"]) {
        static NSString *CellIdentifier = @"SalaryIrrigationCtlCell";
        
        SalaryIrrigationCtl_Cell *cell = (SalaryIrrigationCtl_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SalaryIrrigationCtl_Cell" owner:self options:nil] lastObject];
            [cell addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.tag = indexPath.row + 1000;
        [cell giveDataCellWithModal:dataModal];

        cell.likeBtn_.tag = indexPath.row + 1000;
        cell.commentCntBtn_.tag = indexPath.row + 2000;
        cell.shareBtn_.tag = indexPath.row + 3000;
        
        if (!dataModal.isLike_) {
            [cell.likeBtn_ addTarget:self action:@selector(addArticleLike:) forControlEvents:UIControlEventTouchUpInside];
        }

        [cell.commentCntBtn_ addTarget:self action:@selector(commentCntBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.shareBtn_ addTarget:self action:@selector(shareArticle:) forControlEvents:UIControlEventTouchUpInside];

        if (dataModal.is_system && ![dataModal.is_system isEqualToString:@""])
        {
            cell.sourceLb_.userInteractionEnabled = YES;
            cell.sourceLb_.tag = 50 + indexPath.row;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSource:)];
            [cell.sourceLb_ addGestureRecognizer:tap];
            
        }
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"RecommendGXSCell";
        
        RecommendGXS_Cell *cell = (RecommendGXS_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RecommendGXS_Cell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell.bgImage_ sd_setImageWithURL:[NSURL URLWithString:dataModal.thumb] placeholderImage:nil];
        if(dataModal.content)
        {
            NSMutableAttributedString * mabstring = [[NSMutableAttributedString alloc]initWithString:dataModal.content];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:10];//调整行间距
            [mabstring addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:FIFTEENFONT_TITLE} range:NSMakeRange(0, [dataModal.content length])];
            cell.contentLb_.attributedText = mabstring;
            cell.contentLb_.textAlignment = NSTextAlignmentCenter;
            cell.contentLb_.lineBreakMode = NSLineBreakByTruncatingTail;
        }
        
        cell.publishBtn_.layer.cornerRadius = 4.0;
        cell.shareBtn_.layer.cornerRadius = 4.0;
        cell.shareBtn_.tag = 4000 + indexPath.row;
        cell.publishBtn_.tag = 5000 + indexPath.row;
        [cell.publishBtn_ addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
        [cell.shareBtn_ addTarget:self action:@selector(shareQuestion:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

#pragma mark 灌薪水内容copy
- (void)cellLongPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {//开始长按
        UITableViewCell *cell = (UITableViewCell *)sender.view;
        CGPoint point = [sender locationInView:sender.view];
        [_myCopyBtn removeFromSuperview];
        _myCopyBtn.center = point;
        _myCopyBtn.tag =  cell.tag - 1000 + 2000;
        [cell.contentView addSubview:_myCopyBtn];
    }
}

-(void)tapSource:(UITapGestureRecognizer *)sender
{
    ELSalaryModel *model = requestCon_.dataArr_[sender.view.tag - 50];
    
    model.bgColor_ = WhiteColor;
    
    SalaryIrrigationDetailCtl *detailCtl = [[SalaryIrrigationDetailCtl alloc] init];
    detailCtl.salaryDetailDelegate = self;
    detailCtl.path = sender.view.tag - 50;
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:model exParam:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ELSalaryModel * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    
    if ([dataModal.status isEqualToString:@"OK"])
    {
        CGSize size = [dataModal.content sizeNewWithFont:[UIFont systemFontOfSize:15]];
        CGFloat height = 0;
        if (size.width > 288) {
            height = 40;
        }
        else
        {
            height = 20;
        }
        return height + 60 + 45 * dataModal.resultDataArr.count + 60;
    }
    
    if ([dataModal.is_recommend isEqualToString:@"0"])
    {
        CGFloat heightLabel = 25;
        
        if (dataModal.is_jing && ![dataModal.is_jing isEqualToString:@""]) {
            heightLabel = 31 + 25;
        }
        
        if (dataModal.is_system && ![dataModal.is_system isEqualToString:@""]) {

            heightLabel += 16 + 15;
        }
        
        MLEmojiLabel *emoji = [self emojiLabel:dataModal.content numberOfLines:5 textColor:UIColorFromRGB(0x333333)];
        emoji.frame = CGRectMake(30,heightLabel,260,0);
        [emoji sizeToFit];
        
        return 60 + heightLabel + emoji.frame.size.height;
    }
    return 246.0;
}

-(void)changeBtnModal:(YLVoteDataModal *)modal indexPath:(NSIndexPath *)path
{
    changPath = path;
    ELSalaryModel *dataModal = requestCon_.dataArr_[path.row];
    dataModal.isVote = @"1";
    if (!voteCon) {
        voteCon = [self getNewRequestCon:NO];
    }
    [voteCon sendAddVoteLogsGaapId:modal.gaapId personId:[Manager getUserInfo].userId_ clientId:[MyCommon getAddressBookUUID]];
}

-(MLEmojiLabel *)emojiLabel:(NSString *)text numberOfLines:(int)num textColor:(UIColor *)color
{
    MLEmojiLabel * emojiLabel;
    emojiLabel = [[MLEmojiLabel alloc]init];
    emojiLabel.numberOfLines = num;
    emojiLabel.font = FIFTEENFONT_TITLE;
    emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    if (color) {
        emojiLabel.textColor = color;
    }
    emojiLabel.backgroundColor = [UIColor clearColor];
    emojiLabel.textAlignment = NSTextAlignmentCenter;
    emojiLabel.lineSpacing = 10.0;
    emojiLabel.isNeedAtAndPoundSign = YES;
    emojiLabel.customEmojiRegex = Custom_Emoji_Regex;
    emojiLabel.customEmojiPlistName = @"emoticons.plist";
    [emojiLabel setEmojiText:text];
    return emojiLabel;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,40)];
    view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,40)];
    view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    ELSalaryModel * dataModal = selectData;
    dataModal.bgColor_ = WhiteColor;
    SalaryIrrigationDetailCtl *detailCtl = [[SalaryIrrigationDetailCtl alloc] init];
    detailCtl.salaryDetailDelegate = self;
    detailCtl.path = indexPath.row;
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:dataModal exParam:nil];

}

-(void)refreshAddLikeIndex:(NSInteger)indexPathRow Count:(NSInteger)count
{
    if(requestCon_.dataArr_.count > indexPathRow)
    {
        ELSalaryModel *modal = requestCon_.dataArr_[indexPathRow];
        modal.like_cnt = count;
        [tableView_ reloadData];
    }
}

-(void)refreshActivityCell:(ELSalaryModel *)modal index:(NSInteger)row
{
    [requestCon_.dataArr_ replaceObjectAtIndex:row withObject:modal];
    [tableView_ reloadData];
}

-(void)refreshCommentIndex:(NSInteger)indexPathRow Count:(NSInteger)count
{
    if (requestCon_.dataArr_.count > indexPathRow) {
        ELSalaryModel *modal = requestCon_.dataArr_[indexPathRow];
        modal.c_cnt = count;
        [tableView_ reloadData];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    scrollSet = scrollView.contentOffset;
    [_myCopyBtn removeFromSuperview];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    [kwTF_ resignFirstResponder];
}

-(IBAction)addArticleLike:(id)sender
{
    UIButton * btn = sender;
    if (btn.selected) {
        return;
    }
    NSInteger index = btn.tag - 1000;
    
    CGRect rect = [tableView_ rectForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    rect.origin.x = btn.frame.origin.x + 20;
    rect.origin.y = rect.origin.y + btn.frame.origin.y;
    rect.size.width = btn.frame.size.width;
    rect.size.height = btn.frame.size.height;
    UILabel *tagLb = [[UILabel alloc]initWithFrame:rect];
    [tagLb setBackgroundColor:[UIColor clearColor]];
    [tagLb setTextColor:[UIColor redColor]];
    [tagLb setText:@"+1"];
    [tableView_ addSubview:tagLb];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect tagRect = tagLb.frame;
        tagRect.origin.y -=  20;
        [tagLb setFrame:tagRect];
    } completion:^(BOOL finished) {
        [tagLb removeFromSuperview];
    }];
    
    ELSalaryModel * article = [requestCon_.dataArr_ objectAtIndex:index];
    article.isLike_ = YES;
    article.like_cnt++;
    [Manager saveAddLikeWithAticleId:article.article_id];
    [tableView_ reloadData];
    if (!addlikeCon_) {
        addlikeCon_ = [self getNewRequestCon:NO];
    }
    [addlikeCon_ addArticleLike:article.article_id];
}

-(IBAction)shareArticle:(id)sender
{
    UIButton * btn = sender;
    NSInteger index = btn.tag - 3000;
    if (requestCon_.dataArr_.count <= 0) {
        return;
    }
    ELSalaryModel * article = [requestCon_.dataArr_ objectAtIndex:index];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell* cell = [tableView_ cellForRowAtIndexPath:indexPath];
    if(&UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(cell.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(cell.frame.size);
    }
    
    //获取图像
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    int colorIndex = 0;
    if ([article.bgColor_ isEqual:Color1]) {
        colorIndex =1;
    }
    if ([article.bgColor_ isEqual:Color2]) {
        colorIndex =2;
    }
    if ([article.bgColor_ isEqual:Color3]) {
        colorIndex =3;
    }
    if ([article.bgColor_ isEqual:Color4]) {
        colorIndex =4;
    }
    if ([article.bgColor_ isEqual:Color5]) {
        colorIndex =5;
    }if ([article.bgColor_ isEqual:Color6]) {
        colorIndex =6;
    }
    
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1024" ofType:@"png"];
    
    NSString * sharecontent = article.content;
    
    NSString * titlecontent = @"分享了一条灌薪水";
    
    sharecontent = [sharecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    titlecontent = [titlecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/gxs_article/%@.htm",article.article_id];
    
    //调用分享
    [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url];
}


-(IBAction)commentCntBtnClick:(id)sender
{
    UIButton * btn = sender;
    NSInteger index = btn.tag - 2000;
    ELSalaryModel * article = [requestCon_.dataArr_ objectAtIndex:index];
    article.bgColor_ = WhiteColor;
    SalaryIrrigationDetailCtl *detailCtl = [[SalaryIrrigationDetailCtl alloc] init];
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:article exParam:nil];
}

-(IBAction)publish:(id)sender
{   //匿名灌薪水
    UIButton * btn = sender;
    NSInteger index = btn.tag - 5000;
    ELSalaryModel * article = [requestCon_.dataArr_ objectAtIndex:index];
    ShareSalaryArticleCtl * shareArticleCtl = [[ShareSalaryArticleCtl alloc] init];
    [self.navigationController pushViewController:shareArticleCtl animated:YES];
    [shareArticleCtl beginLoad:article.article_id exParam:nil];
    
}


-(IBAction)shareQuestion:(id)sender
{
    UIButton * btn = sender;
    NSInteger index = btn.tag - 4000;
    ELSalaryModel * article = [requestCon_.dataArr_ objectAtIndex:index];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1024" ofType:@"png"];
    
    NSString * sharecontent = article.content;
    
    NSString * titlecontent = [NSString stringWithFormat:@"%@",@"分享一条灌薪水"];
    
    sharecontent = [sharecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    titlecontent = [titlecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/gxs_article/%@.htm",article.article_id];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
    
    //调用分享
    [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url];
}

//自己视图的单击事件
-(void) viewSingleTap:(id)sender
{
    [kwTF_ resignFirstResponder];
}

#pragma UIKeyboardNotification
-(void)mykeyboardWillShow:(NSNotification *)notification
{
    //添加点击事件
    if( !singleTapRecognizer_ )
        singleTapRecognizer_ = [MyCommon addTapGesture:self.view target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    
}

-(void)mykeyboardWillHide:(NSNotification *)notification
{
    [MyCommon removeTapGesture:self.view ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;

}

-(void)btnResponse:(UIButton *)sender
{
    [kwTF_ resignFirstResponder];
    if (sender == publishBtn_ ) {
        ShareSalaryArticleCtl * shareArticleCtl = [[ShareSalaryArticleCtl alloc] init];
        [self.navigationController pushViewController:shareArticleCtl animated:YES];
        [shareArticleCtl beginLoad:nil exParam:nil];
    }else if (sender == _myCopyBtn){//copy
        NSInteger index = sender.tag - 2000;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        ELSalaryModel * dataModal = [requestCon_.dataArr_ objectAtIndex:index];
        pasteboard.string = dataModal.content;
        [_myCopyBtn removeFromSuperview];
    }
    else if (sender == rightBtnOne)
    {
        [kwTF_ resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)salaryIrrigation:(NSNotification *)notification
{
    [self refreshLoad:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch ( type ) {
        case 3:
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

//adddLikeDelegate
-(void)addLikeCount:(Article_DataModal *)dataModal
{
    for (Article_DataModal * article in requestCon_.dataArr_) {
        if ([dataModal.id_ isEqualToString:article.id_]) {
            article.likeCount_ ++ ;
            [tableView_ reloadData];
            break;
        }
    }
}

//show/hide no data but load ok view
-(void) showNoDataOkView:(BOOL)flag
{
    [MyLog Log:[NSString stringWithFormat:@"showNoDataOkView flag=%d",flag] obj:self];
    
    if( flag ){
        UIView *noDataOkSuperView = [self getNoDataSuperView];
        UIView *noDataOkView = [self getNoDataView];
        if( noDataOkSuperView && noDataOkView ){
            [noDataOkSuperView addSubview:noDataOkView];
            
            //set the rect
            CGRect rect = noDataOkView.frame;
            rect.origin.x = (int)((noDataOkSuperView.frame.size.width - rect.size.width)/2.0);
            rect.origin.y = (int)((noDataOkSuperView.frame.size.height - rect.size.height)/4.0);
            [noDataOkView setFrame:rect];
        }else{
            [MyLog Log:@"noDataSuperView or noDataView is null,if you want to show noDataOkView, please check it" obj:self];
        }
    }else{
        [[self getNoDataView] removeFromSuperview];
    }
}

- (void)reciveNewMesageAction:(NSNotificationCenter *)notifcation
{
    
}

//SearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = [MyCommon removeAllSpace:searchBar.text];
    
    isSearch = YES;
    tableView_.hidden = NO;
    [self beginLoad:nil exParam:nil];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    showKeyBoard = YES;
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    showKeyBoard = NO;
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

-(void)hideKeyboard
{
    [kwTF_ resignFirstResponder];
}
- (IBAction)btnTypePush:(UIButton *)sender
{
    int type = 0;
    switch (sender.tag) {
        case 100:
            type = 1;
            break;
        case 200:
            type = 2;
            break;
        case 300:
            type = 3;
            break;
        default:
            break;
    }
   
    if(sender.tag == 300)
    {
        if ([Manager shareMgr].haveLogin) {
            SalaryChangeTypeCtl *ctl = [[SalaryChangeTypeCtl alloc] init];
            ctl.salaryType = type;
            [self.navigationController pushViewController:ctl animated:YES];
            [ctl beginLoad:nil exParam:nil];
        }else
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        }
    }
    else
    {
        SalaryChangeTypeCtl *ctl = [[SalaryChangeTypeCtl alloc] init];
        ctl.salaryType = type;
        [self.navigationController pushViewController:ctl animated:YES];
        [ctl beginLoad:nil exParam:nil];
    }
}


@end

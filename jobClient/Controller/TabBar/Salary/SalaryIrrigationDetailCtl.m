//
//  SalaryIrrigationDtailCtl.m
//  jobClient
//
//  Created by 一览ios on 14/11/27.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "SalaryIrrigationDetailCtl.h"
#import "ExRequetCon.h"
#import "SalaryIrrigationComment_Cell.h"
#import "FaceScrollView.h"
#import "MLEmojiLabel.h"
#import "SalaryIrrigationCtl_Cell.h"
#import "YLTheTopicCell.h"
#import "ELCommentModel.h"
#import "UIButton+WebCache.h"

//内容开始的y值
#define Y_START 16
//行距
#define LINE_MARGIN_TOP 10
//内容宽度
#define LINE_WIDTH  ScreenWidth-70
//单元格边界
#define BOARDER_MARGIN 18
//评论内容以下的高度
#define CONTENT_BOTTOM_HEIGHT 45

@interface SalaryIrrigationDetailCtl ()<UITextFieldDelegate, UIGestureRecognizerDelegate,UIWebViewDelegate,YLTheTopicCellDeletage>
{
    BOOL bPop_;
    BOOL bKeyboardShow_;
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
    RequestCon *addCommentlikeCon_;//评论点赞
    RequestCon *addlikeCon_;//文章点赞
    RequestCon *shareLogsCon_;//分享
    RequestCon *addCommentCon_;//匿名评论
    ELCommentModel *_selectedComment;//选择的评论
    FaceScrollView *_faceScrollView;
    UIWebView *webView_;
    
    IBOutlet UIButton *commentBtn;
    IBOutlet UIButton *likeBtn;
    IBOutlet UIView *headerView;
    RequestCon *voteCon;
    NSIndexPath *changPath;
    
    CGFloat _keyboardHeight;
}
@end

@implementation SalaryIrrigationDetailCtl
@synthesize commentView_, commentTF_;
#pragma mark- lifeCycle
- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
    
    popView_.alpha = 0.0;
//    self.navigationItem.title = @"帖子详情";
    [self setNavTitle:@"帖子详情"];
    bFooterEgo_ = YES;
    bHeaderEgo_ = YES;
    validateSeconds_ = 600;
    [_faceBtn setImage:[UIImage imageNamed:@"icon_keyboard.png"] forState:UIControlStateSelected];
    
    commentTF_.layer.borderWidth = 0.3;
    commentTF_.layer.borderColor = [UIColor lightGrayColor].CGColor;
    commentTF_.layer.cornerRadius = 4.0;
    commentTF_.delegate = self;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn_];
    popView_.clipsToBounds = YES;
    
    /*
     if(IOS7){
     CGRect frameTb = tableView_.frame;
     frameTb.size.height -= 20;
     tableView_.frame = frameTb;
     
     CGRect frame = commentView_.frame;
     frame.origin.y = tableView_.frame.size.height + tableView_.frame.origin.y;
     commentView_.frame = frame;
     }
     */
    CGRect frame = tableView_.frame;
    frame.size.height = ScreenHeight-104;
    tableView_.frame = frame;
    if (!webView_) {
        webView_ = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,0)];
    }
    webView_.delegate = self;
    [webView_ setBackgroundColor:[UIColor clearColor]];
    webView_.scrollView.bounces = NO;
    [webView_ setOpaque:NO];
    webView_.scalesPageToFit = NO;
    webView_.userInteractionEnabled = NO;
    
    if ([self respondsToSelector:@selector(setAllowsNonContiguousLayout:)]) {
        commentTF_.layoutManager.allowsNonContiguousLayout = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name: UITextViewTextDidChangeNotification object:nil];
    
}

-(void)textChanged:(UITextView *)textView
{
    [self changeTextViewFrame];
}

- (void)setArticle:(ELSalaryModel *)article
{
    if (requestCon_.pageInfo_.currentPage_ > 1) {
        return;
    }
    _article = article;
    NSString *webStr1 = _article.content.length > 0 ? _article.content:@"";
    NSString *webStr2 = @"";//[webStr1 substringWithRange:NSMakeRange(0,1)];
    NSInteger k = 1;
    
    BOOL web = YES;
    
    if (webStr1.length <= 500)
    {
        for (NSInteger i = 0;i<webStr1.length;i++)
        {
            NSString *str = [webStr1 substringWithRange:NSMakeRange(i,1)];
            NSString *str1 = [webStr1 substringWithRange:NSMakeRange(0,i+1)];
            
            NSString *str2 = @"";
            NSString *str3 = @"";
            if (webStr1.length >= 4) {
                if (i <= webStr1.length - 4)
                {
                    str2 =  [webStr1 substringWithRange:NSMakeRange(i,4)];
                }
            }
            if (i >= 2) {
                str3 =  [webStr1 substringWithRange:NSMakeRange(i-2,2)];
            }
            
            if ([str3 isEqualToString:@"/>"]) {
                web = YES;
            }
            if ([str2 isEqualToString:@"<img"]) {
                web = NO;
            }
            
            webStr2 = [NSString stringWithFormat:@"%@%@",webStr2,str];
            
            if ([str1 sizeNewWithFont:FIFTEENFONT_TITLE].width/290 >= k && web)
            {
                webStr2 = [NSString stringWithFormat:@"%@\n",webStr2];
                k++;
            }
        }
    }
    else
    {
        webStr2 = webStr1;
    }
    
    NSMutableString *webStr = [NSMutableString stringWithString:webStr1];
    
    if (inModal_.is_system.length > 0)
    {
        webStr = [NSMutableString stringWithFormat:@"<span style='color:#32c1af'>%@</span>%@",inModal_.is_system,webStr];
    }
    
    NSRange rang;
    rang.location = 0;
    rang.length = [webStr length];
    [webStr replaceOccurrencesOfString:@"<img" withString:[NSString stringWithFormat:@"<img width=%.0f",webView_.frame.size.width-30.0] options:NSCaseInsensitiveSearch range:rang];
    [webView_ loadHTMLString:webStr baseURL:nil];
    
    [commentBtn setTitle:[NSString stringWithFormat:@"%ld",(long)article.c_cnt] forState:UIControlStateNormal];
    [likeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)article.like_cnt] forState:UIControlStateNormal];
    if (article.isLike_) {
        [likeBtn setTitleColor:FONEREDCOLOR forState:UIControlStateNormal];
        [likeBtn setImage:[UIImage imageNamed:@"addLikeSeleted.png"] forState:UIControlStateNormal];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *) webView
{
    [webView_ removeFromSuperview];
    [headerView removeFromSuperview];
    
    if (inModal_.bgColor_ != [UIColor whiteColor]) {
        NSString *jsStr = @"var bodyDom = document.getElementsByTagName('body')[0];bodyDom.style.fontSize= '17px';bodyDom.style.padding= '14px';bodyDom.style.textAlign= 'center';bodyDom.style.lineHeight = '30px';";
        [webView stringByEvaluatingJavaScriptFromString:jsStr];
    }else{
        NSString *jsStr = @"var bodyDom = document.getElementsByTagName('body')[0];bodyDom.style.fontSize= '17px';bodyDom.style.padding= '14px';bodyDom.style.textAlign= 'center';bodyDom.style.lineHeight = '30px';";
        [webView stringByEvaluatingJavaScriptFromString:jsStr];
    }
    
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
    CGRect frameOne = headerView.frame;
    frameOne.origin.y = frame.size.height;
    headerView.frame = frameOne;
    
    [tableView_ reloadData];
    
    [self adjustFooterViewFrame];
}


- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mykeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mykeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    self.navigationItem.title = @"帖子详情";
    //self.navigationController.navigationBarHidden = YES;
    //修改状态栏字体颜色为白色
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    //self.navigationController.navigationBarHidden = NO;
    //修改状态栏字体颜色为黑色
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationItem.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - netWork
//-----------数据请求与刷新－－－－－－－－－－
-(void)updateCom:(RequestCon *)con
{
    if (con == requestCon_) {
        //UIColor *color = inModal_.bgColor_;
    }
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    bPop_ = NO;
    inModal_ = dataModal;
    [super beginLoad:dataModal exParam:exParam];
}


-(void)getDataFunction:(RequestCon *)con
{
    //评论点赞
    if (con == addCommentlikeCon_) {
        
    }else if(con == requestCon_){
        NSString * userId = [Manager getUserInfo].userId_;
        if (!userId) {
            userId = @"";
        }
        [con getSalaryArticleAndCommentList:inModal_.article_id pageIndex:con.pageInfo_.currentPage_ pageSize:10 userId:userId];
    }
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    if (requestCon == requestCon_){
        id dataModel = dataArr[0];
        if ([dataModel isKindOfClass:[ELSalaryModel class]]) {
            for (id modal in requestCon_.dataArr_) {
                if ([modal isKindOfClass:[ELSalaryModel class]]) {
                    [requestCon_.dataArr_ removeObject:modal];
                    break;
                }
            }
            if ([inModal_.status isEqualToString:@"OK"])
            {
                ELSalaryModel *modalOne = (ELSalaryModel *)dataModel;
                if ([modalOne.status isEqualToString:@"OK"]) {
                    self.article = dataModel;
                }
            }
            else
            {
                self.article = dataModel;
            }
            [tableView_ reloadData];
            [_salaryDetailDelegate refreshCommentIndex:_path Count:_article.c_cnt];
        }else{
            
        }
        
    }else if(requestCon == addlikeCon_)
    {
        Status_DataModal * dataModal = [dataArr objectAtIndex:0];
        if ([dataModal.status_ isEqualToString:Success_Status])
        {
            _article.isLike_ = YES;
            _article.like_cnt++;
            [Manager saveAddLikeWithAticleId:_article.article_id];
            [_salaryDetailDelegate refreshAddLikeIndex:_path Count:_article.like_cnt];
            [likeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_article.like_cnt] forState:UIControlStateNormal];
            [likeBtn setTitleColor:FONEREDCOLOR forState:UIControlStateNormal];
            [likeBtn setImage:[UIImage imageNamed:@"addLikeSeleted.png"] forState:UIControlStateNormal];
            
            [tableView_ reloadData];
        }
    }else if (requestCon == voteCon)
    {
        NSDictionary *dicVote = dataArr[0];
        if ([dicVote[@"status"] isEqualToString:@"OK"])
        {
//            _article.isVote = dicVote[@"is_vote"];
//            _article.canVote = dicVote[@"can_vote"];
//            _article.status = dicVote[@"status"];
//            _article.allVote = dicVote[@"all_vote"];
//            NSArray *voteArr = dicVote[@"option_info"];
//            if (!_article.resultDataArr) {
//                _article.resultDataArr = [[NSMutableArray alloc] init];
//            }
//            [_article.resultDataArr removeAllObjects];
//            for (NSDictionary *dicTwo in _article.option_info) {
//                YLVoteDataModal *voteModal = [[YLVoteDataModal alloc] initWithDictionary:dicTwo];
////                voteModal.gaapName = dicTwo[@"gaap_name"];
////                voteModal.gaapId = dicTwo[@"gaap_id"];
////                voteModal.sort = dicTwo[@"sort"];
////                voteModal.isBest = dicTwo[@"is_best"];
////                voteModal.result = dicTwo[@"result"];
//                [_article.resultDataArr addObject:voteModal];
//            }
            _article = [[ELSalaryModel alloc] initWithDictionary:dicVote];
            [tableView_ reloadData];
            [_salaryDetailDelegate refreshActivityCell:_article index:_path];
        }
    }
    else if (requestCon == addCommentCon_)
    {
        NSDictionary *result = dataArr[0];
        NSString *code =result[@"code" ];
        _tspLb.text = @"匿名发表评论";
        if ([code isEqualToString: @"200"])
        {
            [self refreshLoad:requestCon_];
            [BaseUIViewController showAutoDismissSucessView:@"提交成功" msg:nil];
            
        }
        else
        {
            [BaseUIViewController showAlertView:nil msg:@"提交失败,请稍后再试" btnTitle:@"确定"];
        }
        //            NSDictionary *dict = result[@"info"];
        //            Comment_DataModal *comment = [[Comment_DataModal alloc]init];
        //            comment.id_ = dict[@"id"];
        //            comment.parentId = dict[@"parent_id"];
        //            comment.imageUrl_ = dict[@"_pic"];
        //            comment.content_ = dict[@"content"];
        //            comment.agreeCount = [dict[@"agree"] integerValue];
        //            comment.imageUrl_ = dict[@"_pic"];
        //            comment.isLZ = [dict[@"_is_lz"] integerValue];
        //
        //            if(requestCon_.dataArr_.count){
        //                Comment_DataModal *newComment = requestCon_.dataArr_[0];
        //                comment.floorNum = newComment.floorNum + 1;
        //                comment.pageCnt_ = newComment.pageCnt_;
        //                comment.totalCnt_ = newComment.totalCnt_ +1;
        //                if (comment.totalCnt_>10) {
        //                    [requestCon_.dataArr_ removeLastObject];
        //                }
        //            }else{
        //                comment.floorNum = 1;
        //            }
        //
        //            if(dict[@"_parent_comment"]){
        //                Comment_DataModal *parentComment = [[Comment_DataModal alloc]init];
        //                parentComment.content_ = dict[@"_parent_comment"][@"content"];
        //                parentComment.floorNum = [dict[@"_parent_comment"][@"_floor_num"] integerValue];
        //                if (!parentComment.floorNum) {
        //                    parentComment.floorNum = _selectedComment.floorNum;
        //                }
        //                comment.parent_ = parentComment;
        //            }
        //            [requestCon_.dataArr_ insertObject:comment atIndex:0];
        //            if (requestCon_.dataArr_.count ==1 ) {
        //                //有一个则不现实底部视图
        //                tableView_.tableFooterView = nil;
        //            }
        //
        //            [tableView_ reloadData];
        //            //调整footerview的位置避免重叠
        //            [self refreshFootView];
        //         }
        //        _selectedComment = nil;
    }
    
}

- (void)refreshFootView
{
    float height = tableView_.contentSize.height > tableView_.bounds.size.height ? tableView_.contentSize.height : tableView_.bounds.size.height;
    CGRect rect = CGRectMake(0.0f, height, tableView_.frame.size.width, tableView_.bounds.size.height);
    [refreshFooterView_ setFrame:rect];
}

#pragma mark 选择行
-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    if (indexPath.row >= 2)
    {
        _selectedComment = requestCon_.dataArr_[indexPath.row - 2];
        commentTF_.text = @"";
        _tspLb.text = [NSString stringWithFormat:@"｜匿名回复%ld楼", (long)_selectedComment._floor_num];
        [commentTF_ becomeFirstResponder];
    }
}

/*
 - (void)setArticle:(Article_DataModal *)article
 {
 _article = article;
 
 [self.likeBtn_ setTitle:[NSString stringWithFormat:@"%d", article.likeCount_] forState:UIControlStateNormal];
 [self.commentBtn_ setTitle:[NSString stringWithFormat:@"%d", article.commentCount_] forState:UIControlStateNormal];
 NSMutableString *webStr = [NSMutableString stringWithString:article.content_];
 NSRange rang;
 rang.location = 0;
 rang.length = [webStr length];
 }
 */

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return requestCon_.dataArr_.count + 2;
}

#pragma mark 初始化表情
- (MLEmojiLabel *)emojiLabel:(NSString *)text numberOfLines:(int)num textColor:(UIColor *)color withFont:(UIFont *)font
{
    MLEmojiLabel * emojiLabel;
    emojiLabel = [[MLEmojiLabel alloc]init];
    emojiLabel.numberOfLines = num;
    emojiLabel.font = font;
    if (color) {
        emojiLabel.textColor = color;
    }
    emojiLabel.backgroundColor = [UIColor clearColor];
    emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    emojiLabel.isNeedAtAndPoundSign = YES;
    emojiLabel.customEmojiRegex = Custom_Emoji_Regex;
    emojiLabel.customEmojiPlistName = @"emoticons.plist";
    [emojiLabel setEmojiText:text];
    return emojiLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        if (indexPath.row == 0)
        {
            if ([_article.status isEqualToString:@"OK"]) {
                static NSString *cellStr = @"YLTheTopicCell";
                
                YLTheTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle]loadNibNamed:@"YLTheTopicCell" owner:self options:nil][0];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.shareBtn.tag = 3000;
                cell.likeBtn.tag = 4000;
                [cell.likeBtn addTarget:self action:@selector(addArticleLike:) forControlEvents:UIControlEventTouchUpInside];
                [cell.shareBtn addTarget:self action:@selector(shareArticle:) forControlEvents:UIControlEventTouchUpInside];
                cell.cellDelegate = self;
                _article.indexpath = indexPath;
                [cell giveDateModal:_article];
                return cell;
            }
            else
            {
                static NSString *cellStr = @"cellOne";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                [cell.contentView addSubview:webView_];
                [cell.contentView addSubview:headerView];
                return cell;
            }
        }
        else if(indexPath.row == 1)
        {
            static NSString *cellStr = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            [allCommentView removeFromSuperview];
            [_footerView removeFromSuperview];
            if (requestCon_.dataArr_.count > 0) {
                CGRect frame = allCommentView.frame;
                frame.size.width = ScreenWidth;
                allCommentView.frame = frame;
                [cell.contentView addSubview:allCommentView];
                
            }
            else
            {
                [cell.contentView addSubview:_footerView];
            }
            return cell;
        }
        
        static NSString *cellIdentify = @"SalaryIrrigationComment_Cell";
        SalaryIrrigationComment_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SalaryIrrigationComment_Cell" owner:self options:nil] lastObject];
            //         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setSubviewAttr];
            [cell.likeBtn_ addTarget:self action:@selector(myLikeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            [cell addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)]];
        }
        
        cell.tag = indexPath.row + 1000;
        ELCommentModel *dataModal = requestCon_.dataArr_[indexPath.row - 2];
        //头像
        if(dataModal._pic.length > 0)
        {
            [cell.picBtn_ setImage:[UIImage imageNamed:dataModal._pic] forState:UIControlStateNormal];
        }
        else
        {
            if (dataModal._is_lz)
            {
                NSString *imageName = @"ios_icon_lz";
                [cell.picBtn_ setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                dataModal._pic = imageName;
            }
            else
            {
                int index = arc4random_uniform(15) +1;
                NSString *imgName = [NSString stringWithFormat:@"guan_pay_%d.png", index];
                [cell.picBtn_ setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
                dataModal._pic = imgName;
            }
        }
        
        cell.likeBtn_.tag = indexPath.row +4000;
        if(dataModal._is_lz){
            cell.lZLb_.hidden = NO;
            
        }else{
            cell.lZLb_.hidden = YES;
        }
        
        if (dataModal.isLike) {
            cell.likeBtn_.selected = YES;
        }else{
            cell.likeBtn_.selected = NO;
        }
        
        //父评论
        MLEmojiLabel *pEmojiLabel;
        UIView *pOldView = [cell viewWithTag:1000];
        if (pOldView) {
            [pOldView removeFromSuperview];
        }
        if (dataModal.parent_) {
            CGFloat replyAnswerLbY;
            if (dataModal._is_lz) {
                replyAnswerLbY = CGRectGetMaxY(cell.lZLb_.frame) + LINE_MARGIN_TOP;
            }else{
                replyAnswerLbY = Y_START;
            }
            cell.replyAnswerLb_.hidden = NO;
            NSString *pContent = [NSString stringWithFormat:@"回复%ld楼：%@",(long)dataModal.parent_._floor_num, dataModal.parent_.content];
            pEmojiLabel = [self emojiLabel:pContent numberOfLines:2 textColor:[UIColor colorWithRed:98.0/255 green:98.0/255 blue:98.0/255 alpha:1.0] withFont:TWEELVEFONT_COMMENT];
            pEmojiLabel.tag = 1000;
            pEmojiLabel.frame = CGRectMake(53, replyAnswerLbY, ScreenWidth-70, 0);
            [pEmojiLabel sizeToFit];
            [cell.contentView addSubview:pEmojiLabel];
            cell.replyAnswerLb_.hidden = YES;
        }else{
            cell.replyAnswerLb_.hidden = YES;
        }
        
        CGFloat answerLbY ;
        
        if (dataModal.parent_) {
            //评论内容
            answerLbY = CGRectGetMaxY(pEmojiLabel.frame) + LINE_MARGIN_TOP;
        }else if (dataModal._is_lz){
            answerLbY = CGRectGetMaxY(cell.lZLb_.frame) + LINE_MARGIN_TOP;
        }else{
            answerLbY = Y_START;
        }
        MLEmojiLabel *emojiLabel = [self emojiLabel:dataModal.content numberOfLines:0 textColor:nil withFont:TWEELVEFONT_COMMENT];
        emojiLabel.tag = 1001;
        emojiLabel.frame = CGRectMake(53, answerLbY, ScreenWidth-70, 0);
        [emojiLabel sizeToFit];
        UIView *oldView = [cell viewWithTag:1001];
        if (oldView) {
            [oldView removeFromSuperview];
        }
        [cell.contentView addSubview:emojiLabel];
        cell.answerLb.hidden = YES;
        
        //楼层
        CGFloat floorLbY = CGRectGetMaxY(emojiLabel.frame);
        cell.lzView.frame = CGRectMake(53, floorLbY + LINE_MARGIN_TOP, ScreenWidth-70, 30);
        [cell.floorLb setText:[NSString stringWithFormat:@"%ld楼", (long)dataModal._floor_num]];
        //赞数量,与楼层居中对齐
        [cell.likeBtn_ setTitle:[NSString stringWithFormat:@"%ld", (long)dataModal.agree] forState:UIControlStateNormal];
        
        CGRect rect = cell.lineView_.frame;
        rect.origin.y = CGRectGetMaxY(cell.lzView.frame)-1;
        cell.lineView_.frame = rect;
        return cell;
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark 灌薪水评论内容copy
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


-(void)changeBtnModal:(YLVoteDataModal *)modal indexPath:(NSIndexPath *)path
{
    changPath = path;
    _article.isVote = @"1";
    if (!voteCon) {
        voteCon = [self getNewRequestCon:NO];
    }
    [voteCon sendAddVoteLogsGaapId:modal.gaapId personId:[Manager getUserInfo].userId_ clientId:[MyCommon getAddressBookUUID]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    @try {
        if (indexPath.row == 0)
        {
            if ([_article.status isEqualToString:@"OK"]) {
                CGSize size = [_article.content sizeNewWithFont:[UIFont systemFontOfSize:15]];
                CGFloat height = 0;
                if (size.width > 288) {
                    height = 40;
                }
                else
                {
                    height = 20;
                }
                return height + 60 + 45 * _article.resultDataArr.count + 60;
            }
            return webView_.frame.size.height + headerView.frame.size.height;
        }
        else if (indexPath.row == 1)
        {
            if (requestCon_.dataArr_.count > 0) {
                return 45;
            }
            else
            {
                return 150;
            }
        }
        ELCommentModel *dataModal = requestCon_.dataArr_[indexPath.row - 2];
        
        CGFloat totalHeight = Y_START;//开始位置
        CGFloat LZHeight = 15;//楼主的高度
        //有楼主
        if(dataModal._is_lz){
            CGFloat maxLzY = LZHeight + Y_START;
            totalHeight = maxLzY;
            totalHeight += 1;
        }
        
        if (dataModal.parent_) {
            //父评论最多两行
            NSString *pContent = dataModal.parent_.content;
            pContent = [NSString stringWithFormat:@"回复%ld楼：%@",(long)dataModal.parent_._floor_num, pContent];
            MLEmojiLabel *pEmojiLabel = [self emojiLabel:pContent numberOfLines:2 textColor:nil withFont:TWEELVEFONT_COMMENT];
            pEmojiLabel.frame = CGRectMake(0, 0, LINE_WIDTH, 0);
            [pEmojiLabel sizeToFit];
            totalHeight += CGRectGetHeight(pEmojiLabel.frame) ;
            if(dataModal._is_lz){
                //不是在第一行
                totalHeight += LINE_MARGIN_TOP;
            }
        }
        
        MLEmojiLabel *emojiLabel = [self emojiLabel:dataModal.content numberOfLines:0 textColor:nil withFont:TWEELVEFONT_COMMENT];
        emojiLabel.frame = CGRectMake(0, 0, LINE_WIDTH, 0);
        [emojiLabel sizeToFit];
        
        totalHeight += emojiLabel.frame.size.height;
        if (dataModal.parent_ || dataModal._is_lz) {
            //不是在第一行
            totalHeight += LINE_MARGIN_TOP;
        }
        //加上内容以下的高度
        CGFloat lzViewHeight = 30;
        totalHeight += lzViewHeight + LINE_MARGIN_TOP;
        return totalHeight;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

#pragma mark 文章点赞
-(IBAction)addArticleLike:(id)sender
{
    UIButton * btn = sender;
    if (btn.selected || _article.isLike_) {
        return;
    }
    /*
     int index = btn.tag - 1000;
     
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
     */
    
//    ELSalaryModel * article = _article;
    
    if (!addlikeCon_) {
        addlikeCon_ = [self getNewRequestCon:NO];
    }
    [addlikeCon_ addArticleLike:_article.article_id];
}

#pragma mark 评论点赞
- (void)myLikeBtnClick:(UIButton *)btn {
    if (bPop_) {
        bPop_ = NO;
        popView_.alpha = 0.0;
        return;
    }
    if (btn.selected) {
        return;
    }else{
        btn.selected = YES;
    }
    NSInteger index = btn.tag - 4000;
    ELCommentModel * comment = [requestCon_.dataArr_ objectAtIndex:index - 2];
    NSInteger agreeCount = comment.agree;
    ++agreeCount;
    comment.agree = agreeCount;
    [btn setTitle:[NSString stringWithFormat:@"%ld", (long)comment.agree] forState:UIControlStateNormal];
    [Manager saveAddLikeWithAticleId:comment.id_];
    if (!addCommentlikeCon_) {
        addCommentlikeCon_ = [self getNewRequestCon:NO];
    }
    [addCommentlikeCon_ addCommentLike:comment.id_ type:nil];
    
}

#pragma mark 发表评论
- (IBAction)commentBtnClick:(id)sender {
    if (bPop_) {
        bPop_ = NO;
        popView_.alpha = 0.0;
        return;
    }
    [commentTF_ becomeFirstResponder];
}

#pragma mark 匿名发表灌薪水评论
- (IBAction)noNameCommentBtnClick:(id)sender {
    if (bPop_) {
        bPop_ = NO;
        popView_.alpha = 0.0;
        return;
    }
    if ([[commentTF_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        //[BaseUIViewController showAutoDismissFailView:@"评论内容不能为空" msg:nil seconds:2.0];
        return;
    }
    if (_faceScrollView.isShow) {
        [self hideFaceView:YES];
    }
    ELCommentModel * commentModal = [[ELCommentModel alloc] init];
    commentModal.id_ = @"";
//    commentModal.objectId_ = _article.id_;
    if (!addCommentCon_) {
        addCommentCon_ = [self getNewRequestCon:NO];
    }
    NSString *parentId = nil;
    if (_selectedComment) {
        parentId = _selectedComment.id_;
    }
    [addCommentCon_ addComment:_article.article_id parentId:parentId userId:[Manager getUserInfo].userId_ content:commentTF_.text proID:nil clientId:[Common idfvString]];
    //更新评论数
    _article.c_cnt +=1;
    
    [commentTF_ resignFirstResponder];
    [commentTF_ setText:@""];
    
    [tableView_ reloadData];
    _selectedComment = nil;
}


#pragma mark 分享
-(IBAction)shareArticle:(id)sender
{
    [self hideFaceViewNoAnimation:NO];
    [commentTF_ resignFirstResponder];
    [self viewSingleTap:nil];
    UIButton * btn = sender;
    NSInteger index = btn.tag - 3000;
    ELSalaryModel * article = _article;
    if (!article) {
        return;
    }
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
    
    NSString * titlecontent = article.title_;
    if (!article.title_ || article.title_.length <= 0) {
        titlecontent = @"分享了一条灌薪水";
    }
    //@"分享了一条灌薪水";
    
    sharecontent = [sharecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    titlecontent = [titlecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableString *shareContent = [[NSMutableString alloc] initWithString:sharecontent];
    [shareContent replaceOccurrencesOfString:@"<p>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,shareContent.length)];
    [shareContent replaceOccurrencesOfString:@"</p>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,shareContent.length)];
    [shareContent replaceOccurrencesOfString:@"<br/>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,shareContent.length)];
    sharecontent = [NSString stringWithFormat:@"%@",shareContent];
    
    // http://m.yl1001.com/xinwen/gxsarticle/?article_id=%@&bg=%d ,colorIndex
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/gxs_article/%@.htm",article.article_id];
    
    //调用分享
    [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url];
}

#pragma mark 隐藏没有数据显示的视图
-(void) showNoDataOkView:(BOOL)flag
{
    [super showNoDataOkView:NO];
    
}

-(void)showNoMoreDataView:(BOOL)flag
{
    [super showNoMoreDataView:NO];
}


-(void)btnResponse:(id)sender
{
    if (sender == moreBtn_) {
        bPop_ = !bPop_;
        if (bPop_) {
            popView_.alpha = 1.0;
            //添加点击事件
            if( !singleTapRecognizer_ )
                singleTapRecognizer_ = [MyCommon addTapGesture:tableView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
        }
        else
        {
            popView_.alpha = 0.0;
            [MyCommon removeTapGesture:tableView_ ges:singleTapRecognizer_];
            singleTapRecognizer_ = nil;
        }
    }
    else if (sender == jubaoBtn_){
        
        if (![Manager shareMgr].haveLogin) {
            [BaseUIViewController showAlertView:@"举报功能需登录后才能操作" msg:@"谢谢合作！" btnTitle:@"确定"];
            return;
        }
        if (bPop_) {
            bPop_ = NO;
            popView_.alpha = 0.0;
        }
        
        ToReportCtl * toReportCtl = [[ToReportCtl alloc] init];
        [self.navigationController pushViewController:toReportCtl animated:YES];
        [toReportCtl beginLoad:_article exParam:nil];
    }else if (sender == _faceBtn){
        if (_faceBtn.selected) {//隐藏faceview 显示键盘
            //移除facescrollview 的手势
            [MyCommon removeTapGesture:tableView_ ges:singleTapRecognizer_];
            singleTapRecognizer_ = nil;
            [commentTF_ becomeFirstResponder];
        }else{//只显示faceview
            _faceScrollView.isShow = YES;
            if ([commentTF_ isFirstResponder]) {
                [commentTF_ resignFirstResponder];
            }
            [self showFaceView];
        }
    }else if (sender == _myCopyBtn){//copy
        NSInteger index = ((UIButton *)sender).tag - 2000;
        ELCommentModel *dataModal = [requestCon_.dataArr_ objectAtIndex:index-2];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = dataModal.content;
        [_myCopyBtn removeFromSuperview];
    }
}

- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//自己视图的单击事件
-(void) viewSingleTap:(id)sender
{
    _selectedComment = nil;
    _tspLb.text = @"匿名发表评论";
    bPop_ = NO;
    popView_.alpha = 0.0;
    
    if(bKeyboardShow_ ) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self hideFaceViewNoAnimation:NO];
        } completion:^(BOOL finished) {
            [commentTF_ resignFirstResponder];
        }];
    }else{
        [self hideFaceView:YES];
        [commentTF_ resignFirstResponder];
    }
    
    [commentTF_ resignFirstResponder];
    [MyCommon removeTapGesture:tableView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    _selectedComment = nil;
}

#pragma UIKeyboardNotification
-(void)mykeyboardWillShow:(NSNotification *)notification
{
    //    isHideMethod_ = NO;
    bKeyboardShow_ = YES;
    //停止scrollview的滚动
    [tableView_ setContentOffset:tableView_.contentOffset animated:NO];
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    _faceBtn.selected = NO;
    //    CGRect newFrame = self.view.frame;
    //    [UIView animateWithDuration:animationDuration animations:^{
    //        self.view.frame = newFrame;
    //    }];
    
    CGRect newTextViewFrame = commentView_.frame;
    newTextViewFrame.origin.y = CGRectGetHeight(self.view.bounds) - keyboardRect.size.height - CGRectGetHeight(newTextViewFrame);
    
    [UIView animateWithDuration:animationDuration animations:^{
        commentView_.frame = newTextViewFrame;
    }];
    
    
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:animationDuration];
    //
    //    [UIView commitAnimations];
    //添加点击事件
    if (!singleTapRecognizer_) {
        singleTapRecognizer_ = [MyCommon addTapGesture:tableView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    }
    
    _keyboardHeight = keyboardRect.size.height;
    //    bKeyboardShow_ = YES;
    //    //停止tableView的滚动
    //    [tableView_ setContentOffset:tableView_.contentOffset animated:NO];
    //
    //
    //    NSDictionary *userInfo = [notification userInfo];
    //
    //    //Get the origin of the keyboard when it's displayed.
    //    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //
    //    CGRect keyboardRect = [aValue CGRectValue];
    //
    //    CGRect newTextViewFrame = commentView_.frame;
    //    newTextViewFrame.origin.y = self.view.frame.size.height - keyboardRect.size.height -40;
    //
    //    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //    NSTimeInterval animationDuration;
    //    [animationDurationValue getValue:&animationDuration];
    //    //Animate the resize of the text view's frame in sync with the keyboard's appearance.
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:animationDuration];
    //    commentView_.frame = newTextViewFrame;
    //    [UIView commitAnimations];
    //
    //    //添加点击事件
    //    if( !singleTapRecognizer_ )
    //        singleTapRecognizer_ = [MyCommon addTapGesture:tableView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    //    singleTapRecognizer_.delegate = self;
}


-(void)mykeyboardWillHide:(NSNotification *)notification
{
    if ([commentTF_.text isEqualToString:@""]) {
        _noNameCommentBtn.backgroundColor = PINGLUNHUI;
        _tspLb.text = @"匿名发表评论";
    }
    else
    {
        _tspLb.text = @"";
    }
    
    bKeyboardShow_ = NO;
    [MyCommon removeTapGesture:tableView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    
    CGRect newTextViewFrame = commentView_.frame;
    newTextViewFrame.origin.y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(newTextViewFrame);
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    if(!_faceScrollView.isShow){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        commentView_.frame = newTextViewFrame;
        [UIView commitAnimations];
        [self hideFaceView:YES];
    }
}

//显示表情
- (void)showFaceView {
    _tspLb.text = @"";
    if (!_faceScrollView) {
        [self initFaceView];
    }
    //添加点击事件
    if( !singleTapRecognizer_ )
        singleTapRecognizer_ = [MyCommon addTapGesture:tableView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    singleTapRecognizer_.delegate = self;
    _faceScrollView.isShow = YES;
    _faceBtn.selected = YES;
    
    CGRect frame = commentView_.frame;
    frame.origin.y = CGRectGetHeight(self.view.bounds) -  CGRectGetHeight(_faceScrollView.frame) - frame.size.height;
    frame.size.height = 40;
    
    CGRect scrollFrame = _faceScrollView.frame;
    scrollFrame.origin.y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_faceScrollView.frame);
    
    [UIView animateWithDuration:0.26 animations:^{
        commentView_.frame = frame;
        _faceScrollView.frame = scrollFrame;
    }];
    _faceBtn.selected = YES;
    [self changeTextViewFrame];
    
}

- (void)initFaceView
{
    if (_faceScrollView == nil) {
        __weak SalaryIrrigationDetailCtl *this = self;
        _faceScrollView = [[FaceScrollView alloc] initWithBlock:^(NSString *faceName) {
            if ([faceName isEqualToString:@"delete"]) {
                NSString *text = this.commentTF_.text;
                if (!text || [text isEqualToString:@""]) {
                    return ;
                }
                NSString *result = [MyCommon substringExceptLastEmoji:text];
                if (![text isEqualToString:result]) {
                    this.commentTF_.text = result;
                }else{
                    this.commentTF_.text = [text substringToIndex:text.length-1];
                }
                if ([this.commentTF_.text isEqualToString:@""]) {
                    _noNameCommentBtn.backgroundColor = PINGLUNHUI;
                }
                [self changeTextViewFrame];
                this.commentTF_.contentOffset = CGPointMake(0,this.commentTF_.contentSize.height-this.commentTF_.frame.size.height);
                return;
            }
            [self changeTextViewFrame];
            _tspLb.text = @"";
            NSString *temp = this.commentTF_.text;
            this.commentTF_.text = [temp stringByAppendingFormat:@"%@", faceName];
            _noNameCommentBtn.backgroundColor = PINGLUNHONG;
        }];
        _faceScrollView.backgroundColor = [UIColor whiteColor];
        _faceScrollView->faceView.backgroundColor = [UIColor whiteColor];
        _faceScrollView.frame = CGRectMake(0, self.view.bounds.size.height, 0, 0);
        [self.view addSubview:_faceScrollView];
    }
}

//隐藏表情,是否隐藏工具栏
- (void)hideFaceView:(BOOL)hideToolBar{
    if (!_faceScrollView.isShow) {
        return;
    }
    [MyCommon removeTapGesture:tableView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    _faceScrollView.isShow = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat y = CGRectGetHeight(self.view.bounds);
        CGRect frame = _faceScrollView.frame;
        frame.origin.y = y;
        _faceScrollView.frame = frame;
        
        //工具栏
        if (hideToolBar) {
            CGRect frame2 = commentView_.frame;
            frame2.origin.y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(frame2);
            commentView_.frame = frame2;
        }
    }];
    _faceBtn.selected = NO;
    if (![commentTF_.text isEqualToString:@""]) {
        _tspLb.text = @"";
    }
}

- (void)hideFaceViewNoAnimation:(BOOL)hideToolbar
{
    if (!_faceScrollView.isShow) {
        return;
    }
    [MyCommon removeTapGesture:tableView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    _faceScrollView.isShow = NO;
    CGFloat y = CGRectGetHeight(self.view.bounds);
    CGRect frame = _faceScrollView.frame;
    frame.origin.y = y;
    _faceScrollView.frame = frame;
    //工具栏
    if (hideToolbar) {
        CGRect frame2 = commentView_.frame;
        frame2.origin.y = y-40;
        commentView_.frame = frame2;
    }
    _faceBtn.selected = NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _faceBtn.selected = NO;
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] > 0) {
        _tspLb.text = @"";
        _noNameCommentBtn.backgroundColor = PINGLUNHONG;
    }
    else
    {
        _noNameCommentBtn.backgroundColor = PINGLUNHUI;
        [_tspLb setText:[NSString stringWithFormat:@"匿名发表评论"]];
    }
    
    [self changeTextViewFrame];
    
}

-(void)changeTextViewFrame
{
    CGSize size = [commentTF_.text sizeNewWithFont:commentTF_.font];
    CGSize sizeTwo = [commentTF_.text sizeNewWithFont:commentTF_.font constrainedToSize:CGSizeMake(commentTF_.frame.size.width-5,1000000000)];
    
    commentTF_.contentOffset = CGPointMake(0, commentTF_.contentSize.height - commentTF_.frame.size.height);
    [commentTF_ scrollRangeToVisible:NSMakeRange(commentTF_.text.length, 1)];
    
    if (sizeTwo.height < MAX(size.height * 5,30))
    {
        CGRect frame = commentTF_.frame;
        frame.size.height = sizeTwo.height > 30 ? sizeTwo.height:30;
        commentTF_.frame = frame;
        
        CGFloat heightOne = 0;
        if (bKeyboardShow_) {
            heightOne = _keyboardHeight;
        }
        else if (_faceScrollView.isShow)
        {
            heightOne = _faceScrollView.frame.size.height;
        }
        frame = commentView_.frame;
        frame.size.height = commentTF_.frame.size.height +10;
        frame.origin.y = CGRectGetHeight(self.view.bounds) -  heightOne - frame.size.height;
        commentView_.frame = frame;
    }
    else
    {
        
        CGRect frame = commentTF_.frame;
        frame.size.height = size.height * 5 + 5;
        commentTF_.frame = frame;
        
        CGFloat heightOne = 0;
        if (bKeyboardShow_) {
            heightOne = _keyboardHeight;
        }
        else if (_faceScrollView.isShow)
        {
            heightOne = _faceScrollView.frame.size.height;
        }
        frame = commentView_.frame;
        frame.size.height = commentTF_.frame.size.height +10;
        frame.origin.y = CGRectGetHeight(self.view.bounds) -  heightOne - frame.size.height;
        commentView_.frame = frame;
        
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *content = textView.text;
    if(range.length == 1 && [text isEqualToString:@""]) {
        NSString *result = [MyCommon substringExceptLastEmoji:content];
        if (![content isEqualToString:result]) {
            textView.text = result;
            if([textView.text isEqualToString:@""])
            {
                _noNameCommentBtn.backgroundColor = PINGLUNHUI;
            }
            return NO;
        }
    }
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_myCopyBtn removeFromSuperview];
}

@end

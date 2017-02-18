//
//  SalaryChangeTypeCtl.m
//  jobClient
//
//  Created by 一览iOS on 15-4-8.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "SalaryChangeTypeCtl.h"
#import "SalaryIrrigationCtl_Cell.h"
#import "MLEmojiLabel.h"
#import "SalaryIrrigationDetailCtl.h"
#import "ShareSalaryArticleCtl.h"

@interface SalaryChangeTypeCtl () <SalaryIrrigationDetailDelegate>

@end

@implementation SalaryChangeTypeCtl

#pragma mark - lifeCycle
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(salaryIrrigation:) name:@"ShareSalaryArticleOK" object:nil];
    tableView_.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    self.yinDaoBtn.backgroundColor = PINGLUNHONG;
    
    bFooterEgo_ = YES;
    switch (_salaryType) {
        case 1:
//            self.navigationItem.title = @"今日热帖";
            [self setNavTitle:@"今日热帖"];
            break;
        case 2:
//            self.navigationItem.title = @"精选互动";
            [self setNavTitle:@"精选互动"];
            break;
        case 3:
//            self.navigationItem.title = @"我的帖子";
            [self setNavTitle:@"我的帖子"];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rigthBtn];
            break;
        default:
            break;
    }
    
    _yinDaoBtn.layer.cornerRadius = 2.0f;
    _yinDaoBtn.layer.masksToBounds = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)salaryIrrigation:(NSNotification *)notification
{
    [_yinDaoPage removeFromSuperview];
    [self refreshLoad:nil];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    [con getSalaryTypeWithOwn_id:[Manager getUserInfo].userId_ getJingFlag:@"1" getSysFlag:@"1" page:requestCon_.pageInfo_.currentPage_ pageSize:10 type:_salaryType];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    if(_salaryType == 3 && dataArr.count == 0)
    {
        _yinDaoPage.frame = CGRectMake(0,0,ScreenWidth,self.view.bounds.size.height);
        [self.view addSubview:_yinDaoPage];
        [self.view bringSubviewToFront:_yinDaoPage];
    }
}

#pragma mark - tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELSalaryModel * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"SalaryIrrigationCtlCell";
    
    SalaryIrrigationCtl_Cell *cell = (SalaryIrrigationCtl_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SalaryIrrigationCtl_Cell" owner:self options:nil] lastObject];
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xfafafa);
    }
    
    [cell giveDataCellWithModal:dataModal type:_salaryType];
    
    cell.likeBtn_.tag = indexPath.row + 1000;
    cell.commentCntBtn_.tag = indexPath.row + 2000;
    cell.shareBtn_.tag = indexPath.row + 3000;
    
    if (!dataModal.isLike_)
    {
        [cell.likeBtn_ addTarget:self action:@selector(addArticleLike:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    [cell.commentCntBtn_ addTarget:self action:@selector(commentCntBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareBtn_ addTarget:self action:@selector(shareArticle:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_salaryType == 2)
    {
        cell.backGroupImg.hidden = NO;
        
        cell.backGroupImg.contentMode = UIViewContentModeScaleAspectFill;
        [cell.backGroupImg sd_setImageWithURL:[NSURL URLWithString:dataModal.thumb]];
        cell.backView.hidden = NO;
        
        cell.sourceLb_.alpha = 0.0;
        
        cell.isJingLb_.alpha = 0.0;
        cell.huoImage_.alpha = 0.0;
    }
    else
    {
        if (dataModal.is_system && ![dataModal.is_system isEqualToString:@""])
        {
        
            cell.sourceLb_.userInteractionEnabled = YES;
            cell.sourceLb_.tag = 50 + indexPath.row;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSource:)];
            [cell.sourceLb_ addGestureRecognizer:tap];
        }
        cell.backGroupImg.hidden = YES;
    }
    return cell;
}

-(void)tapSource:(UITapGestureRecognizer *)sender
{
    ELSalaryModel *modal = requestCon_.dataArr_[sender.view.tag - 50];
    modal.bgColor_ = WhiteColor;
    
    SalaryIrrigationDetailCtl *detailCtl = [[SalaryIrrigationDetailCtl alloc] init];
    detailCtl.salaryDetailDelegate = self;
   
    detailCtl.path = sender.view.tag - 50;
    
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:modal exParam:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ELSalaryModel * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    if (_salaryType == 2)
    {
        return 246.0;
    }
    
    CGFloat heightLabel = 25;
    
    if (dataModal.is_jing && ![dataModal.is_jing isEqualToString:@""]) {
        heightLabel = 31 + 25;
    }
    
    if (dataModal.is_system && ![dataModal.is_system isEqualToString:@""]) {
        
        heightLabel += 16 + 15;
    }
    
    MLEmojiLabel *emoji = [self emojiLabel:dataModal.content numberOfLines:5 textColor:UIColorFromRGB(0x333333)];
    emoji.frame = CGRectMake(30,heightLabel,ScreenWidth-60,0);
    [emoji sizeToFit];
    
    return 60 + heightLabel + emoji.frame.size.height;
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
    if (requestCon_.dataArr_.count > indexPathRow) {
        ELSalaryModel *modal = requestCon_.dataArr_[indexPathRow];
        modal.like_cnt = count;
        [tableView_ reloadData];
    }
}

-(void)refreshCommentIndex:(NSInteger)indexPathRow Count:(NSInteger)count
{
    if (requestCon_.dataArr_.count > indexPathRow) {
        ELSalaryModel *modal = requestCon_.dataArr_[indexPathRow];
        modal.c_cnt = count;
        [tableView_ reloadData];
    }
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
    
    NSString * sharecontent = article.content;
    
    NSString * titlecontent = @"分享了一条灌薪水";
    
    sharecontent = [sharecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    titlecontent = [titlecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/gxs_article/%@.htm",article.article_id];
    
    //调用分享
    [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url];
}

- (IBAction)rightBarBtnPush:(UIButton *)sender
{
    ShareSalaryArticleCtl * shareArticleCtl = [[ShareSalaryArticleCtl alloc] init];
    [self.navigationController pushViewController:shareArticleCtl animated:YES];
    [shareArticleCtl beginLoad:nil exParam:nil];
}

- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    tableView_.contentOffset = CGPointMake(0,0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

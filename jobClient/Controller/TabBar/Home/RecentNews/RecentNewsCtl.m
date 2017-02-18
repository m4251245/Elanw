//
//  RecentNewsCtl.m
//  jobClient
//
//  Created by YL1001 on 14-8-22.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "RecentNewsCtl.h"
#import "MoreCell.h"
#import "More_DataModal.h"
#import "RecentNews_CommentView.h"
#import "NewCommentMsgModel.h"
#import "ArticleCommentCtl.h"
#import "MyAudienceListCtl.h"
#import "SameTradeTipsCell.h"
#import "MLEmojiLabel.h"
#import "ShowImageView.h"
#import "FaceScrollView.h"
#import "ShowImageView.h"
#import "TheContactListCtl.h"
#import "AlbumListCtl.h"
#import "ELPersonCenterCtl.h"
#import "TodayFocus_Cell.h"
#import "ELNoDataShowView.h"
#import "PublishArticle.h"

@interface RecentNewsCtl () <PublishArticleDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,PhotoSelectCtlDelegate,UIActionSheetDelegate>
{
    Article_DataModal   * bChooseArticle_;
    Comment_DataModal   * bChooseComment_;
    NSInteger   articleIndex_;
    NSInteger   commentIndex_;
    NSString    * comment_parentId_;
    BOOL   bSearchKeyBoardShow_;
    BOOL   shouldRefrsh_;
    Article_DataModal * shareArticle;
    
    BOOL _isKeyboardShow;
    UITapGestureRecognizer *_singleTapRecognizer;
    FaceScrollView *_faceScrollView;//表情面板
    NSInteger   seletedIndex;
    IBOutlet UIButton *rightBtn;
    
    
    IBOutlet UIView *headerView;
    __weak IBOutlet UIButton *headerBtn;
    __weak IBOutlet UIImageView *headerImage;
    __weak IBOutlet UIView *headBackView;
    ELNoDataShowView *noDataView;
}


@end

@implementation RecentNewsCtl
@synthesize delegate_,mynewMsgArray_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        bFooterEgo_ = YES;
        validateSeconds_ = 600;
        self.noShowNoDataView = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"朋友圈";
    [self setNavTitle:@"朋友圈"];
    mynewMsgArray_ = [[NSMutableArray alloc] init];
       
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil]; 
    negativeSpacer.width = -14;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];
    [self refreshHeaderView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)refreshHeaderView
{
    if([Manager shareMgr].haveLogin && [Manager shareMgr].messageCountDataModal.friendMessageCnt > 0)
    {
        tableView_.tableHeaderView =  headerView;
        [headerImage sd_setImageWithURL:[NSURL URLWithString:[Manager getUserInfo].img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
        [headerBtn setTitle:[NSString stringWithFormat:@"%ld条新消息",(long)[Manager shareMgr].messageCountDataModal.friendMessageCnt] forState:UIControlStateNormal];
        headBackView.clipsToBounds = YES;
        headBackView.layer.cornerRadius = 4.0;
    }
    else
    {
        tableView_.tableHeaderView = nil;
        [tableView_ reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.navigationItem.title = @"朋友圈";
    if ([requestCon_.dataArr_ count] == 0||shouldRefrsh_) {
        [self refreshLoad:nil];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    if (![Manager shareMgr].isFromMessage_) {
        [requestCon_ stopConnWhenBack];
    }
    else
    {
        [Manager shareMgr].isFromMessage_ = NO;
    }
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_  egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        shouldRefrsh_ = YES;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    self.navigationItem.title = @"";
}

-(void)updateCom:(RequestCon *)con
{
        
}

#pragma mark - NetWork
-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)showErrorView:(BOOL)flag{
    if (![MyCommon IsEnable3G] && ![MyCommon IsEnableWIFI]) {
        [super showErrorView:flag];
    }else{
        [super showErrorView:NO];
    }
}

-(void)getDataFunction:(RequestCon *)con
{
    con.storeType_ = TempStoreType;
    NSString * userId = [Manager getUserInfo].userId_;
    if (![Manager shareMgr].haveLogin) {
        userId = @"";
    }
    [con getYL1001HIList:userId pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:10];
}

-(void)changeShowNoDataView{
    if (!noDataView) {
        if (requestCon_.dataArr_.count <= 0 && ([MyCommon IsEnable3G] || [MyCommon IsEnableWIFI]) && requestCon_.loadStats_ != ErrorLoad)
        {
            tableView_.hidden = YES;
            noDataView = [[ELNoDataShowView alloc] init];
            [noDataView.attentionButton addTarget:self action:@selector(attentionButtonRespone:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:noDataView];
            noDataView.center = CGPointMake(self.view.center.x,(ScreenHeight-64)/2.0);
        }
    }
}

- (void)showNoDataOkView:(BOOL)flag
{
    NSLog(@"1111111111111");
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetYl1001HIList:
        {
            [self changeShowNoDataView];
        }
            break;
        case Request_shareArticleDyanmic:
        {
             Status_DataModal *dataModal = dataArr[0];
            if( [dataModal.status_ isEqualToString:Success_Status] ){
                if ([dataModal.code_ isEqualToString:@"200"]) {
                    [BaseUIViewController showAutoDismissAlertView:nil msg:@"分享成功" seconds:2.0];
                }else{
                    [BaseUIViewController showAutoDismissAlertView:nil msg:dataModal.des_ seconds:2.0];
                }
            }else if( [dataModal.status_ isEqualToString:Fail_Status] ){
                [BaseUIViewController showAutoDismissAlertView:nil msg:dataModal.des_ seconds:2.0];
            }else{
                [BaseUIViewController showAlertView:nil msg:@"分享失败,请稍后再试" btnTitle:@"确定"];
            }
        }
            break;
        default:
            break;
    }
}

-(void)attentionButtonRespone:(UIButton *)sender{
    SameTradeListCtl *sameTradeCtl = [[SameTradeListCtl alloc]init];
    [self.navigationController pushViewController:sameTradeCtl animated:YES];
    [sameTradeCtl beginLoad:nil exParam:nil];
}

-(void)showNoMoreDataView:(BOOL)flag
{
    [super showNoMoreDataView:NO];
}


#pragma mark - Table view data source

//-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (adMOdal_) {
//        return 60 ;
//    }
//    else
//        return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return [requestCon_.dataArr_ count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    static NSString *CellIdentifier = @"SameTradeTipsCell";
    if (indexPath.section == 0) {
        SameTradeTipsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SameTradeTipsCell" owner:self options:nil] lastObject];
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView = bgView;
            cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        }
        [cell setDataModel:[mynewMsgArray_ objectAtIndex:indexPath.row]];
        return cell;
    }else{
        TodayFocusFrame_DataModal *articleModel = requestCon_.dataArr_[indexPath.row];
        static NSString *reuseIdentifier = @"TodayFocus_Cell";
        TodayFocus_Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"TodayFocus_Cell" owner:self options:nil][0];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView = bgView;
            cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        }
        cell.model = articleModel;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }else{
        TodayFocusFrame_DataModal *model = requestCon_.dataArr_[indexPath.row];
        return model.height;
    }
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    //记录友盟统计模块使用
    NSDictionary * dict = @{@"Function":@"HI"};
    [MobClick event:@"personused" attributes:dict];
    
    if (indexPath.section == 0) {
        NSObject *object = [mynewMsgArray_ objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[NewCommentMsgModel class]]) {
            NewCommentMsgModel *articleModel = [mynewMsgArray_ objectAtIndex:indexPath.row];
            articleModel.totalCount_ = @"0";
            ArticleCommentCtl *commentCtl = [[ArticleCommentCtl alloc]init];
            [self.navigationController pushViewController:commentCtl animated:YES];
            [commentCtl beginLoad:nil exParam:nil];
            [mynewMsgArray_ removeObject:articleModel];
        }else if ([object isKindOfClass:[Status_DataModal class]]){
            Status_DataModal *model = [mynewMsgArray_ objectAtIndex:indexPath.row];
            model.exObj_ = @"0";
            MyAudienceListCtl *audienceCtl = [[MyAudienceListCtl alloc]init];
            NSString *type = [NSString stringWithFormat:@"2"];
            [audienceCtl beginLoad:type exParam:nil];
            [self.navigationController pushViewController:audienceCtl animated:YES];
            [mynewMsgArray_ removeObject:model];
        }
        [tableView_ reloadData];
    }else{
        TodayFocusFrame_DataModal *article = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
        ArticleDetailCtl *articleDetailCtl = [[ArticleDetailCtl alloc]init];
        [self.navigationController pushViewController:articleDetailCtl animated:YES];
        if (article.articleType_ == Article_Group) {
            articleDetailCtl.isFromGroup_ = YES;
        }
        [articleDetailCtl beginLoad:article.sameTradeArticleModel.article_id exParam:nil];

    }
}


-(void)removeAllData
{
    [requestCon_.dataArr_ removeAllObjects];
    [tableView_ reloadData];
}

-(void)btnResponse:(id)sender
{

}

//下拉菜单的点击响应事件
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self addImage];
            break;
        default:
            break;
    }
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        BOOL accessStatus = [[Manager shareMgr] getTheCameraAccessWithCancel:^{}];
        if (!accessStatus) {
            return;
        }        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

/*
 调用系统相册的方法
 */
-(void)addImage{
    AlbumListCtl *albumListCtl = [[AlbumListCtl alloc]init];
    albumListCtl.fromTodayList = YES;
    albumListCtl.maxCount = 6;
    albumListCtl.delegate = self;
    [self.navigationController pushViewController:albumListCtl animated:YES];
    [albumListCtl beginLoad:nil exParam:nil];
}

#pragma mark 相册图片选择delegate
- (void)didFinishSelectPhoto:(NSArray *)imageArr
{
    PublishArticle * publishArticleCtl = [[PublishArticle alloc] init];
    publishArticleCtl.canImageCount = 6;
    publishArticleCtl.delegate_ = self;
    publishArticleCtl.type_ = Article;
    publishArticleCtl.fromTodayList = YES;
    [self.navigationController pushViewController:publishArticleCtl animated:YES];
    [publishArticleCtl beginLoad:nil exParam:nil];
    [publishArticleCtl fromTodayListRefreshWithType:2 imageArr:imageArr];
}

-(void)publishSuccess
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        //在指定时间后,要做的事情
        [self refreshLoad:nil];
    });
}

//选择某张照片之后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //关闭相册界面
    [picker dismissViewControllerAnimated:NO completion:^{
        
    }];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //如果是 来自照相机的image，那么先保存
        UIImage* original_image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImageWriteToSavedPhotosAlbum(original_image, self,
                                       nil,
                                       nil);
    }
    
    //当选择的类型是图片
    if([type isEqualToString:@"public.image"]){
        //先把图片转成NSData
        UIImage *uploadImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        uploadImage = [uploadImage fixOrientation];
        
        PublishArticle * publishArticleCtl = [[PublishArticle alloc] init];
        publishArticleCtl.fromTodayList = YES;
        publishArticleCtl.canImageCount = 6;
        publishArticleCtl.delegate_ = self;
        publishArticleCtl.type_ = Article;
        [self.navigationController pushViewController:publishArticleCtl animated:YES];
        [publishArticleCtl beginLoad:nil exParam:nil];
        [publishArticleCtl fromTodayListRefreshWithType:1 imageArr:@[uploadImage]];
    }
}


-(void)resetNoSearch
{
    CGRect rect = tableView_.frame;
    rect.origin.y = 0;
    rect.size.height = self.view.frame.size.height;
    [tableView_ setFrame:rect];
}

-(void)reloadTableView
{
    [tableView_ reloadData];
}

- (void)reciveNewMesageAction:(NSNotificationCenter *)notifcation
{
    
}

#pragma mark - 重新计算没有更多数据的位置
- (void)changNoMoreDateFrame
{
    float height = tableView_.contentSize.height > tableView_.bounds.size.height ? tableView_.contentSize.height : tableView_.bounds.size.height;
    float x = (int)((tableView_.frame.size.width-refreshFooterView_.frame.size.width)/2.0);
    CGRect rect = CGRectMake(x, height, tableView_.frame.size.width, tableView_.bounds.size.height);
    [refreshFooterView_ setFrame:rect];
}


- (IBAction)rightBtnClick:(UIButton *)sender
{
    if (![Manager shareMgr].haveLogin)
    {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        return;
    }
    UIActionSheet* myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles:@"现在拍摄",@"相册选取", nil];
    [myActionSheet showInView:self.view];
}

- (IBAction)newMessageBtnRespone:(UIButton *)sender
{
    [Manager shareMgr].messageCountDataModal.friendMessageCnt = 0;
    [self refreshHeaderView];
}


@end

//
//  YLMoreAppCtl.m
//  jobClient
//
//  Created by YL1001 on 15/8/26.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//


#import "YLMoreAppCtl.h"
#import "PushUrlCtl.h"
#import "ELEmployerViewCtl.h"
#import "ELPersonCenterCtl.h"
#import "User_DataModal.h"
#import "ELOAWebCtl.h"
#import "YLMoreAppCell.h"


static NSString *kcellIdentifier = @"collectionCellID";

@interface YLMoreAppCtl ()
{
    NSInteger index;
    NSString *redNumMark;
    NoNetworkVIew *_nonetworkView;
}
@end

@implementation YLMoreAppCtl

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"更多应用";
    [self setNavTitle:@"更多应用"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [collectionView_ registerNib:[UINib nibWithNibName:@"YLMoreAppCell" bundle:nil] forCellWithReuseIdentifier:kcellIdentifier];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshLoad:nil];
    
    if (!_nonetworkView) {
        _nonetworkView = [[NoNetworkVIew alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self.view addSubview:_nonetworkView];
        _nonetworkView.hidden = YES;
    }
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        collectionView_.hidden = YES;
        _nonetworkView.hidden = NO;
        
    }
    else
    {
        collectionView_.hidden = NO;
        _nonetworkView = nil;
    }
//    self.navigationItem.title = @"更多应用";
}

-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationItem.title = @"";
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

- (void)getDataFunction:(RequestCon *)con
{
    NSString *userId = [Manager getUserInfo].userId_;
    //type 1 表示IOS
    if (!userId) {
        userId = @"";
    }
    [con getApplicationList:userId page:requestCon_.pageInfo_.currentPage_ pageSize:15 phoneType:1];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    NSLog(@"%@",dataArr);
    switch (type) {
        case Request_GetApplicationList:
        {
            [collectionView_ reloadData];
        }
            break;
        default:
            break;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  requestCon_.dataArr_.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YLMoreAppCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    AD_dataModal *dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        redNumMark = dataModal.OANewsCount;
        if (dataModal.OANewsCount.length > 0 && ![dataModal.OANewsCount isEqualToString:@""]) {
            cell.redCountImg.hidden = NO;
        }
        else{
            cell.redCountImg.hidden = YES;
        }
    }
    else{
        cell.redCountImg.hidden = YES;
    }

    [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:dataModal.pic_] placeholderImage:nil];
    cell.nameLb.text = dataModal.title_;
    
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenWidth/3, ScreenWidth/3);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AD_dataModal *dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    
    if ([dataModal.title_ isEqualToString:@"微雇主"])
    {
        ELEmployerViewCtl *ctl = [[ELEmployerViewCtl alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
        
        PushUrlCtl * pushurlCtl = [[PushUrlCtl alloc] init];
    if ([dataModal.title_ isEqualToString:@"一览公益"]) {
        ELPersonCenterCtl *personCtl = [[ELPersonCenterCtl alloc]init];
        NSString *model = @"17175459";
        [personCtl beginLoad:model exParam:nil];
        [self.navigationController pushViewController:personCtl animated:YES];
    }
    else if ([dataModal.title_ isEqualToString:@"我的办公OA"])
    {
        ELOAWebCtl *oaWebCtl = [[ELOAWebCtl alloc] init];
        oaWebCtl.myBlock = ^(BOOL isRefresh){
            
        };
        [self.navigationController pushViewController:oaWebCtl animated:YES];
        [oaWebCtl beginLoad:dataModal exParam:nil];
    }
    else{
        dataModal.shareUrl = dataModal.url_;
        pushurlCtl.isApplication = YES;
        [self.navigationController pushViewController:pushurlCtl animated:YES];
        [pushurlCtl beginLoad:dataModal exParam:nil];
    }
    NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",dataModal.title_,NSStringFromClass([self class])]};
    [MobClick event:@"buttonClick" attributes:dict];
    
}

-(void)backBarBtnResponse:(id)sender{
    self.MyBlock(redNumMark);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

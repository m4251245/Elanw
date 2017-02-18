//
//  AlbumListCtl.m
//  jobClient
//
//  Created by 一览ios on 15/10/9.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "AlbumListCtl.h"
#import "AlbumList_Cell.h"
#import "PhotoSelectCtl.h"
#import "PhotosShowHelper.h"

@interface AlbumListCtl () <UIAlertViewDelegate>

@property (nonatomic, retain) NSMutableArray *assetsGroups;

@end

@implementation AlbumListCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.navigationItem.title = @"相册";
    [self setNavTitle:@"相册"];
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        bHeaderEgo_ = NO;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    WS(weakSelf)
    BOOL accessStatus = [[Manager shareMgr] getTheCameraAccessWithCancel:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    if (!accessStatus) {
        return;
    }
    _assetsLibrary = [[ALAssetsLibrary alloc]init];
    
    if(IOS8){
        _assetsGroups = [NSMutableArray array];
        [self photoStatus];
    }
//    else{
//        NSArray *groupTypes = @[ @(ALAssetsGroupSavedPhotos), @(ALAssetsGroupAlbum)];//系统相册
//        __weak typeof(self) weakSelf = self;
//        [self loadAssetsGroupsWithTypes:groupTypes
//                             completion:^(NSArray *assetsGroups) {
//                                 weakSelf.assetsGroups = [NSMutableArray arrayWithArray:assetsGroups];
//                             }];
//    }
}

#pragma mark - 获取所有相册列表
-(void)photoStatus{
    WS(weakSelf);
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined:
        { // 未授权,弹出授权框
            [BaseUIViewController showLoadView:YES content:nil view:self.view];
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                // 用户选择完毕就会调用—选择允许,直接保存
                if (status == PHAuthorizationStatusAuthorized) {
                    [weakSelf.assetsGroups addObjectsFromArray:[[[PhotosShowHelper alloc]init] getPhotoAblumList]];
                    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
                    dispatch_after(time, dispatch_get_main_queue(), ^{
                        [tableView_ reloadData];
                        [BaseUIViewController showLoadView:NO content:nil view:self.view];
                    });
                }
                
            }];
        }
            break;
        case PHAuthorizationStatusAuthorized:
        { // 授权,就直接保存
            [self.assetsGroups addObjectsFromArray:[[[PhotosShowHelper alloc]init] getPhotoAblumList]];
        }
            break;
        default:
        {// 拒绝 告知用户去哪打开授权
            [BaseUIViewController showAlertView:@"无权访问相册" msg:@"请在系统设置中设置访问权限" btnTitle:@"确定"];
        }
            break;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _assetsGroups.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"AlbumList_Cell";
    AlbumList_Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AlbumList_Cell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (IOS8) {
        ZLPhotoAblumList *ablumListVO = _assetsGroups[indexPath.row];
        [[[PhotosShowHelper alloc]init] requestImageForAsset:ablumListVO.headImageAsset size:CGSizeMake(60*3, 60*3) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
            cell.imageV.image = image;
        }];
        
        cell.titleLb.text = ablumListVO.title;
        cell.countLb.text = [NSString stringWithFormat:@" (%ld) ",(long)ablumListVO.count];
    }
    else{
        ALAssetsGroup *assetsGroup = _assetsGroups[indexPath.row];
        NSString *title = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        cell.titleLb.text = title;
        cell.countLb.text = [NSString stringWithFormat:@"（%ld）", (long)[assetsGroup numberOfAssets]];
        cell.imageV.image = [UIImage imageWithCGImage:assetsGroup.posterImage];
    }
    [cell.imageV setContentMode:UIViewContentModeScaleAspectFill];
    return cell;
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    if (_isOnlyOneSel) {
        New_PhotoSelectionViewController *onePhotoSelVC = [[New_PhotoSelectionViewController alloc]init];

        ZLPhotoAblumList *ablumListVO = _assetsGroups[indexPath.row];
        [onePhotoSelVC beginLoad:ablumListVO exParam:nil];
       
        onePhotoSelVC.delegate = self.logoDelegate;
        onePhotoSelVC.imageType = _imageType;
        [self.navigationController pushViewController:onePhotoSelVC animated:YES];
    }
    else{
        PhotoSelectCtl *photoSelectCtl = [[PhotoSelectCtl alloc]init];
        photoSelectCtl.maxCount = _maxCount;
        photoSelectCtl.fromTodayList = _fromTodayList;
        photoSelectCtl.delegate = self.delegate;
        photoSelectCtl.sizeType = _sizeType;
        if (IOS8) {
            ZLPhotoAblumList *ablumListVO = _assetsGroups[indexPath.row];
            [photoSelectCtl beginLoad:ablumListVO exParam:nil];
        }
        else{
            ALAssetsGroup *assetsGroup = _assetsGroups[indexPath.row];
            [photoSelectCtl beginLoad:assetsGroup exParam:nil];
        }
        [self.navigationController pushViewController:photoSelectCtl animated:YES];
        
    }
}


#pragma mark 获取 AssetsGroups
- (void)loadAssetsGroupsWithTypes:(NSArray *)types completion:(void (^)(NSArray *assetsGroups))completion
{
    __block NSMutableArray *assetsGroups = [NSMutableArray array];
    for (NSNumber *type in types) {
//        __weak typeof(self) weakSelf = self;
        [self.assetsLibrary enumerateGroupsWithTypes:[type intValue]
                                          usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop) {
                                              if (assetsGroup) {
                                                  // Filter the assets group
                                                  [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];//只选择相片
                                                  
                                                  if (assetsGroup.numberOfAssets > 0) {
                                                      // Add assets group
                                                      [assetsGroups addObject:assetsGroup];
                                                  }
                                              }else{
                                                  completion(assetsGroups);
                                                  [tableView_ performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                                              }
                                              
                                          }failureBlock:^(NSError *error){
                                          
                                          }];
    }
}

@end

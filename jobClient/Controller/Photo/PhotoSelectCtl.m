//
//  PhotoSelectCtl.m
//  jobClient
//
//  Created by 一览ios on 15/7/3.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "PhotoSelectCtl.h"
#import "AssetsCollectionViewCell.h"
#import "PhotosShowHelper.h"

#define kViewWidth  [[UIScreen mainScreen] bounds].size.width
#define kMaxImageWidth 500
@interface PhotoSelectCtl ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    __weak IBOutlet NSLayoutConstraint *collectionBottomHeight;
    __weak IBOutlet UIView *bottomView;
}
@property (nonatomic, retain) ZLPhotoAblumList *photoListVO;
@end

@implementation PhotoSelectCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"相册"];
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    [self.collectionView registerNib:[UINib nibWithNibName:@"AssetsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AssetsCollectionViewCell"];
    self.collectionView.allowsMultipleSelection = YES;
    CALayer *layer = _previewBtn.layer;
    layer.masksToBounds = YES;
    layer.borderColor = [UIColor lightGrayColor].CGColor;
    layer.borderWidth = 0.5;
    layer.cornerRadius = 3.f;
    layer = _confirmBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 3.f;
    layer = _countLb.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 10;
    _countLb.hidden = YES;
    
    self.selectedAssets = [NSMutableArray array];
    
    if (_sizeType > 0) {
        bottomView.hidden = YES;
        collectionBottomHeight.constant = 0;
    }else{
        bottomView.hidden = NO;
        collectionBottomHeight.constant = 47;
    }
    [bottomView bringSubviewToFront:_countLb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    _selectedAssets = [NSMutableArray array];
    _photoListVO = dataModal;
    self.assetsGroup = dataModal;
}


- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    self.assets = [NSMutableArray array];
    
    [_assets addObjectsFromArray:[[[PhotosShowHelper alloc]init] getAssetsInAssetCollection:self.photoListVO.assetCollection ascending:YES]];
    
    //数组倒序显示
    self.assets = [[NSMutableArray alloc] initWithArray:[[self.assets reverseObjectEnumerator] allObjects]];
    [self.collectionView reloadData];
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
                                                      completion(assetsGroups);
                                                  }
                                              }
                                          } failureBlock:^(NSError *error) {
                                              NSLog(@"Error: %@", [error localizedDescription]);
                                          }];
    }
}


#pragma mark -- UICollectionViewDataSource

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _assets.count;
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AssetsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetsCollectionViewCell" forIndexPath:indexPath];
    //    cell.showsOverlayViewWhenSelected = self.allowsMultipleSelection;
    cell.countBtn.hidden = YES;
    id asset;
    UIImage *img;
    cell.imageView.image = nil;
    if(IOS8){
        asset = (PHAsset *)self.assets[indexPath.row];
        [[[PhotosShowHelper alloc]init] requestImageForAsset:asset size:CGSizeMake(3 * (ScreenWidth-20)/4.0, 3 * (ScreenWidth-20)/4.0*3) resizeMode:PHImageRequestOptionsResizeModeExact completion:^(UIImage *image, NSDictionary *info) {
            cell.imageView.image = image;
        }];
    }
    else{
        asset = (ALAsset *)[self.assets objectAtIndex:indexPath.row];
        img = [UIImage imageWithCGImage:(__bridge CGImageRef)([asset thumbnail])];
        cell.imageView.image = img;
    }
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    if ([_selectedAssets containsObject:asset]) {
        cell.countBtn.hidden = NO;
        int index = (int)[_selectedAssets indexOfObject:asset];
        [cell.countBtn setTitle:[NSString stringWithFormat:@"%d", index+1] forState:UIControlStateNormal];
    }else{
        cell.countBtn.hidden = YES;
    }
    return cell;
}



#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth-20)/4.0,(ScreenWidth-20)/4.0);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 2.5, -1, 2.5);
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    id asset;
    
    asset = (PHAsset *)[self.assets objectAtIndex:indexPath.row];
    CGFloat scale = 2;//[UIScreen mainScreen].scale;
    CGFloat width = MIN(kViewWidth, kMaxImageWidth);
    CGSize size = CGSizeMake(width*scale, width*scale * [asset pixelHeight]/[asset pixelWidth]);
    [[[PhotosShowHelper alloc]init] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
        [weakSelf showImg:image asset:asset withIndexPath:indexPath];
    }];
    
}

-(void)showImg:(UIImage *)img asset:(id)asset withIndexPath:(NSIndexPath *)indexPath{
    if (_sizeType > 0){
        PhotoEditorCtl *editorCtl = [[PhotoEditorCtl alloc]init];
        editorCtl.sourceImage = img;
        [editorCtl reset:NO];
        editorCtl.rotateEnabled = NO;
        editorCtl.sizeType = _sizeType;
        [self.navigationController pushViewController:editorCtl animated:YES];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }else
    {
        if([_selectedAssets containsObject:asset]){
            [_selectedAssets removeObject:asset];
        }else if (self.selectedAssets.count == _maxCount){
            if (self.selectedAssets.count == _maxCount) {
                [BaseUIViewController showAutoDismissAlertView:@"" msg:[NSString stringWithFormat:@"最多只能选择%ld张图片", (long)_maxCount] seconds:1.5f];
                return;
            }
        }
        else{
            [_selectedAssets addObject:asset];
        }
    }
    [self refreshCount];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    //    [self.collectionView reloadData];
}

//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    id asset;
//    if(IOS9){
//        asset = (PHAsset *)[self.assets objectAtIndex:indexPath.row];
//    }
//    else{
//        asset = (ALAsset *)[self.assets objectAtIndex:indexPath.row];
//    }
//
//    [_selectedAssets removeObject:asset];
//    [_collectionView reloadData];
//    return;
////    [self refreshCount];
////    AssetsCollectionViewCell * cell = (AssetsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
////    cell.countBtn.hidden = YES;
//
//}

#pragma mark 刷新总数量
- (void)refreshCount
{
    long count = _selectedAssets.count;
    if (count>0) {
        _countLb.hidden = NO;
    }else{
        _countLb.hidden = YES;
    }
    [_countLb setTitle:[NSString stringWithFormat:@"%ld", count] forState:UIControlStateNormal] ;
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



- (IBAction)btnResponse:(id)sender
{
    //    WS(weakSelf);
    if (sender == _previewBtn) {//预览
        if (!_selectedAssets.count) {
            [BaseUIViewController showAutoDismissFailView:@"" msg:@"请选择图片"];
            return;
        }
        PhotoBrowerCtl *browerCtl = [[PhotoBrowerCtl alloc]init];
        browerCtl.selectedAssets = [NSMutableArray arrayWithArray:_selectedAssets];
        browerCtl.sizeType = _sizeType;
        [self.navigationController pushViewController:browerCtl animated:YES];
    }else if (sender == _confirmBtn){//确定
        NSInteger count = self.navigationController.childViewControllers.count;
        BaseUIViewController *ctl  = self.navigationController.childViewControllers[count-3];
        if (_fromTodayList)
        {
            [self.navigationController popToViewController:ctl animated:NO];
        }
        else
        {
            [self.navigationController popToViewController:ctl animated:YES];
        }
        if (_selectedAssets.count) {
            if ([self.delegate respondsToSelector:@selector(didFinishSelectPhoto:)]) {
                NSMutableArray *imageArr = [NSMutableArray array];
                if(IOS8){
                    for (PHAsset *asset in _selectedAssets) {
                        CGFloat scale = 2;//[UIScreen mainScreen].scale;
                        CGFloat width = MIN(kViewWidth, kMaxImageWidth);
                        CGSize size = CGSizeMake(width*scale, width*scale * [asset pixelHeight]/[asset pixelWidth]);
                        [[[PhotosShowHelper alloc]init] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
                            
                            [imageArr addObject:image];
                        }];
                        
                    }
                    [self performSelector:@selector(delegateImgArr:) withObject:imageArr afterDelay:0.5];
                    
                }
                else{
                    for (ALAsset *asset in _selectedAssets) {
                        [imageArr addObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
                    }
                    [self.delegate didFinishSelectPhoto:imageArr];
                }
                
                
            }
        }
    }
}

-(void)delegateImgArr:(NSArray *)imageArr{
    [self.delegate didFinishSelectPhoto:imageArr];
}

@end

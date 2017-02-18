//
//  New_PhotoSelectionViewController.m
//  jobClient
//
//  Created by 一览ios on 16/8/15.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "New_PhotoSelectionViewController.h"
#import "AssetsCollectionViewCell.h"
#import "PhotoEditorCtl.h"

#import "UIImageView+WebCache.h"
#import "PhotosShowHelper.h"

#define kViewWidth  [[UIScreen mainScreen] bounds].size.width
#define kMaxImageWidth 500

@interface New_PhotoSelectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectiohnView;
@property (strong, nonatomic) NSMutableArray *selectedAssets;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, retain) ZLPhotoAblumList *photoListVO;
@end

@implementation New_PhotoSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

#pragma mark--初始化UI
-(void)configUI{
//    self.navigationItem.title = @"相册";
    [self setNavTitle:@"相册"];
    [self.photoCollectiohnView registerNib:[UINib nibWithNibName:@"AssetsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AssetsCollectionViewCell"];
    self.photoCollectiohnView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
}

#pragma mark--加载数据
-(void)beginLoad:(id)dataModal exParam:(id)exParam{
    [super beginLoad:dataModal exParam:exParam];
    if (IOS8) {
        _photoListVO = dataModal;
    }
    else{
        _assetsGroup = dataModal;
    }
    
    [self assetsGet:_assetsGroup];
}

#pragma mark--请求数据
-(void)getDataFunction:(RequestCon *)con{
    
}

- (void)assetsGet:(ALAssetsGroup *)assetsGroup
{
    self.assets = [NSMutableArray array];
    if (IOS8) {
        [_assets addObjectsFromArray:[[[PhotosShowHelper alloc]init] getAssetsInAssetCollection:self.photoListVO.assetCollection ascending:YES]];
    }
    else{
        __weak typeof(self) weakSelf = self;
        [assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                [weakSelf.assets addObject:result];
            }
        }];
    }
    [self.photoCollectiohnView reloadData];
}

#pragma mark--代理
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
    cell.countBtn.hidden = YES;
    id asset;
    UIImage *img;
    if(IOS8){
        asset = (PHAsset *)self.assets[indexPath.row];
        [[[PhotosShowHelper alloc]init] requestImageForAsset:asset size:CGSizeMake(3 * (ScreenWidth-20)/4.0, 3 * (ScreenWidth-20)/4.0) resizeMode:PHImageRequestOptionsResizeModeExact completion:^(UIImage *image, NSDictionary *info) {
            cell.imageView.image = image;
        }];
    }
    else{
        asset = (ALAsset *)[self.assets objectAtIndex:indexPath.row];
        img = [UIImage imageWithCGImage:(__bridge CGImageRef)([asset thumbnail])];
        cell.imageView.image = img;
    }
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
    if ([_selectedAssets containsObject:asset]) {
        cell.countBtn.hidden = NO;
        int index = (int)[_selectedAssets indexOfObject:asset];
        [cell.countBtn setTitle:[NSString stringWithFormat:@"%d", index+1] forState:UIControlStateNormal];
    }else{
        //        cell.selected = NO;
        cell.countBtn.hidden = YES;
    }
    return cell;
}

-(void)reloadTableViewDataAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* indexArray = [NSArray arrayWithObjects:indexPath, nil];
    [self.photoCollectiohnView reloadItemsAtIndexPaths:indexArray];
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WS(weakSelf);
    PhotoEditorCtl *selVC = [[PhotoEditorCtl alloc]init];
    if (IOS8) {
        PHAsset *asset = [self.assets objectAtIndex:indexPath.row];
        CGFloat scale = 2;//[UIScreen mainScreen].scale;
        CGFloat width = MIN(kViewWidth, kMaxImageWidth);
        CGSize size = CGSizeMake(width*scale, width*scale*asset.pixelHeight/asset.pixelWidth);
        [[[PhotosShowHelper alloc]init] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
            selVC.sourceImage = image;
            [weakSelf pushToEditImgVC:selVC];
        }];
    }
    else{
        ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        selVC.sourceImage = [UIImage imageWithCGImage:[representation fullResolutionImage]];
        [self pushToEditImgVC:selVC];
    }
    
    
}
#pragma mark--事件

#pragma mark--通知

#pragma mark--业务逻辑
-(void)pushToEditImgVC:(PhotoEditorCtl *)selVC{
    [selVC reset:NO];
    selVC.imageType = _imageType;
    selVC.sizeType = 1;
    selVC.isOnlyOneSel = YES;
    [self.navigationController pushViewController:selVC animated:YES];
}



//重新调整图片大小
-(UIImage*)resizeImage:(UIImage*)image withWidth:(CGFloat)width withHeight:(CGFloat)height
{
    CGSize newSize = CGSizeMake(width, height);
    CGFloat widthRatio = newSize.width/image.size.width;
    CGFloat heightRatio = newSize.height/image.size.height;
    
    if(widthRatio > heightRatio)
    {
        newSize=CGSizeMake(image.size.width*heightRatio,image.size.height*heightRatio);
    }
    else
    {
        newSize=CGSizeMake(image.size.width*widthRatio,image.size.height*widthRatio);
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

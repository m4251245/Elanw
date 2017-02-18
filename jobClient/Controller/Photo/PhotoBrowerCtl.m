//
//  PhotoBrowerCtl.m
//  Test
//
//  Created by 彭永 on 15-7-5.
//  Copyright (c) 2015年 pengy. All rights reserved.
//

#import "PhotoBrowerCtl.h"
#import "MyConfig.h"
#import <objc/runtime.h>
#import "PublishArticle.h"
#import "PhotoSelectCtl.h"

#import "PhotosShowHelper.h"

#define kViewWidth  [[UIScreen mainScreen] bounds].size.width
#define kMaxImageWidth 500

@interface PhotoBrowerCtl ()<UIGestureRecognizerDelegate>
{
    UIView *boomLineView;
    NSMutableArray *btnArr;
}
@end

@implementation PhotoBrowerCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    btnArr = [NSMutableArray array];
    self.fd_interactivePopDisabled = YES;
    
    _bigImgv.contentMode = UIViewContentModeScaleAspectFit;
//    _scrollView
    [self layoutThumbPic];
    UISwipeGestureRecognizer *leftRecoginzer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeImage:)];
    leftRecoginzer.direction = UISwipeGestureRecognizerDirectionLeft;
    leftRecoginzer.delegate = self;
    [_bigImgv addGestureRecognizer:leftRecoginzer];
    UISwipeGestureRecognizer *rightRecoginzer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeImage:)];
    rightRecoginzer.direction = UISwipeGestureRecognizerDirectionRight;
    rightRecoginzer.delegate = self;
    [_bigImgv addGestureRecognizer:rightRecoginzer];
}

- (void)changeImage:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSInteger currentIndex = _selectedBtn.tag;
        if (currentIndex<_selectedAssets.count-1) {
            UIButton *btn = btnArr[currentIndex + 1];
            [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }else if (sender.direction == UISwipeGestureRecognizerDirectionRight){
        NSInteger currentIndex = _selectedBtn.tag;
        if (currentIndex>0) {
            UIButton *btn = btnArr[currentIndex - 1];
            [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillDisappear:animated];
    
    if (boomLineView) {
        [boomLineView removeFromSuperview];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    if (!boomLineView) {
        boomLineView = [[UIView alloc] initWithFrame:CGRectMake(0,ScreenHeight-1,ScreenWidth,2)];
        boomLineView.backgroundColor = [UIColor blackColor];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:boomLineView];
}

#pragma mark 缩略图
- (void)layoutThumbPic
{
    CGFloat margin = 8;
    for (int i = 0; i<_selectedAssets.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (_fromPublishArticle)
        {
             [btn setImage:_selectedAssets[i] forState:UIControlStateNormal];
             [self dealBtn:btn withIndex:i];
        }
        else
        {
            if (IOS8) {
                PHAsset *asset = _selectedAssets[i];
                [[[PhotosShowHelper alloc]init] requestImageForAsset:asset size:CGSizeMake(75*3, 75*3) resizeMode:PHImageRequestOptionsResizeModeExact completion:^(UIImage *image, NSDictionary *info) {
                    [btn setImage:image forState:UIControlStateNormal];
                    [self performSelector:@selector(delayLoad:) withObject:@[btn,@(i)] afterDelay:0.1];
                }];
            }
            else{
                ALAsset *asset = _selectedAssets[i];
                [btn setImage:[UIImage imageWithCGImage:asset.aspectRatioThumbnail] forState:UIControlStateNormal];
                [self dealBtn:btn withIndex:i];
            }
        }
    }
    _scrollView.contentSize = CGSizeMake((50 + margin) *_selectedAssets.count, 50);
}

-(void)dealBtn:(UIButton *)btn withIndex:(NSInteger)idx{
    CGFloat margin = 8;
    btn.tag = idx;
    [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btn setBackgroundImage:[UIImage imageNamed:@"img_select_bg.png"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(showBigImage:) forControlEvents:UIControlEventTouchUpInside];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(1, 4, 6, 4)];
    btn.contentMode = UIViewContentModeScaleAspectFit;
    
    btn.frame = CGRectMake( (50 + margin)*idx, 0, 50, 50);
    [_scrollView addSubview:btn];
    
    if (_fromPublishArticle)
    {
        if (idx == _selectIndex)
        {
            [self showBigImage:btn];
        }
    }
    else if(idx == 0)
    {
        [self showBigImage:btn];
    }
    [btnArr addObject:btn];
}

-(void)delayLoad:(NSArray *)arr{
    UIButton *btn = arr.firstObject;
    NSInteger i = [arr.lastObject integerValue];
    [self dealBtn:btn withIndex:i];
}

#pragma mark 显示大图
- (void)showBigImage:(UIButton *)sender
{
    _selectedBtn.selected = NO;
    sender.selected = YES;
    _selectedBtn = sender;

    CGFloat offsetX = sender.frame.origin.x - (_scrollView.bounds.size.width - sender.bounds.size.width)*0.5;
    if (offsetX>0) {
        _scrollView.contentOffset = CGPointMake(offsetX, 0);
    }else{
        _scrollView.contentOffset = CGPointMake(0, 0);
    }
    
    NSInteger index = sender.tag;
    BOOL modify = [objc_getAssociatedObject(_selectedBtn, &kBtnIndexKey) boolValue];
    if (modify) {
        [_bigImgv setImage:[sender imageForState:UIControlStateNormal] ];
        return;
    }
    
    if (_fromPublishArticle) {
        [_bigImgv setImage:_selectedAssets[index]];
    }
    else
    {
        if (IOS8) {
            PHAsset *asset = _selectedAssets[index];
            CGFloat scale = 2;//[UIScreen mainScreen].scale;
            CGFloat width = MIN(kViewWidth, kMaxImageWidth);
            CGSize size = CGSizeMake(width*scale, width*scale * [asset pixelHeight]/[asset pixelWidth]);
            [[[PhotosShowHelper alloc]init] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
                [_bigImgv setImage:image];
            }];
        }
//        else{
//            ALAsset *selectedAsset = _selectedAssets[index];
//            ALAssetRepresentation *representation = [selectedAsset defaultRepresentation];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                ALAssetOrientation orientaion = representation.orientation;
//                CGImageRef imageReference = [representation fullResolutionImage];
//                [_bigImgv setImage:[UIImage imageWithCGImage:imageReference scale:1.f orientation:(UIImageOrientation)orientaion]];
//            });
//        }
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
static char kBtnIndexKey;
- (IBAction)btnResponse:(id)sender
{
    WS(weakSelf);
    if (sender == _backBtn) {//返回
        [self.navigationController popViewControllerAnimated:YES];
    }else if (sender == _cropBtn){//裁剪
        PhotoEditorCtl *editorCtl = [[PhotoEditorCtl alloc]init];
        
        BOOL modify = [objc_getAssociatedObject(_selectedBtn, &kBtnIndexKey) boolValue];
        if (modify) {
            editorCtl.sourceImage = [_selectedBtn imageForState:UIControlStateNormal];
        }else
        {
             NSInteger index = _selectedBtn.tag;
            if (_fromPublishArticle) {
                editorCtl.sourceImage = _selectedAssets[index];
            }
            else
            {
                if(IOS8){
                    PHAsset *asset = _selectedAssets[index];
                    CGFloat scale = 2;//[UIScreen mainScreen].scale;
                    CGFloat width = MIN(kViewWidth, kMaxImageWidth);
                    CGSize size = CGSizeMake(width*scale, width*scale * [asset pixelHeight]/[asset pixelWidth]);
                    [[[PhotosShowHelper alloc]init] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
                        editorCtl.sourceImage = image;
                        [weakSelf pushVC:editorCtl];
                    }];
                }
                else{
                    ALAsset *selectedAsset = _selectedAssets[index];
                    ALAssetRepresentation *representation = [selectedAsset defaultRepresentation];
                    editorCtl.sourceImage = [UIImage imageWithCGImage:[representation fullResolutionImage]];
                    [self pushVC:editorCtl];
                }
            }
        }
        
        __weak typeof(PhotoBrowerCtl) *weakSelf = self;
        editorCtl.doneCallback = ^(UIImage *image, BOOL param){
            [weakSelf.selectedBtn setImage:image forState:UIControlStateNormal];
            [weakSelf.bigImgv setImage:image];
            objc_setAssociatedObject(weakSelf.selectedBtn, &kBtnIndexKey, @(YES), OBJC_ASSOCIATION_ASSIGN);
        };
       
    }else if (sender == _deleteBtn){//删除
        NSInteger index = _selectedBtn.tag;
        [self showChooseAlertView:(int)index title:@"提示" msg:@"确定要删除本张图片吗？" okBtnTitle:@"确定" cancelBtnTitle:@"取消"];
    }
    else if (sender == _nextBtn)//下一步
    {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        if (_fromPublishArticle)
        {
            [self.navigationController popViewControllerAnimated:YES];
            NSMutableArray *imageArr = [NSMutableArray array];
            for (int i=0; i<_selectedAssets.count; i++)
            {
                BOOL modify = [objc_getAssociatedObject(_selectedBtn, &kBtnIndexKey) boolValue];
                if (modify)
                {
                    UIButton *btn = btnArr[i];
                    [imageArr addObject:[btn imageForState:UIControlStateNormal]];
                }else
                {
                    [imageArr addObject:_selectedAssets[i]];
                }
            }
            [_browerDelegate finishWithImageArr:imageArr];
        }
        else
        {
            NSInteger count = self.navigationController.childViewControllers.count;
            PhotoSelectCtl *ctl  =self.navigationController.childViewControllers[count-2];
            if ([ctl isKindOfClass: [PhotoSelectCtl class]])
            {
                UIViewController *viewCtl  =self.navigationController.childViewControllers[count-4];
                if (ctl.fromTodayList)
                {
                    [self.navigationController popToViewController:viewCtl animated:NO];
                }
                else
                {
                    [self.navigationController popToViewController:viewCtl animated:YES];
                }
                
                if ([ctl.delegate respondsToSelector:@selector(didFinishSelectPhoto:)]) {
                    NSMutableArray *imageArr = [NSMutableArray array];
                    for (int i=0; i<_selectedAssets.count; i++)
                    {
                        BOOL modify = [objc_getAssociatedObject(_selectedBtn, &kBtnIndexKey) boolValue];
                        if (modify) {
                            UIButton *btn = btnArr[i];
                            [imageArr addObject:[btn imageForState:UIControlStateNormal]];
                        }else
                        {
                            if (_fromPublishArticle)
                            {
                                [imageArr addObject:_selectedAssets[i]];
                            }
                            else
                            {
                                if (IOS8) {
                                    PHAsset *asset = _selectedAssets[i];
                                    CGFloat scale = 2;//[UIScreen mainScreen].scale;
                                    CGFloat width = MIN(kViewWidth, kMaxImageWidth);
                                    CGSize size = CGSizeMake(width*scale, width*scale * [asset pixelHeight]/[asset pixelWidth]);
                                    [[[PhotosShowHelper alloc]init] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
                                        [imageArr addObject:image];
                                    }];
                                }
                                else{
                                    ALAsset *asset = _selectedAssets[i];
                                    [imageArr addObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
                                }
                                
                            }
                        }
                    }
                    [self performSelector:@selector(delegateImgArr:) withObject:@[imageArr,ctl] afterDelay:0.5];
                    
                }
                return;
            }
        }
    }
}

-(void)pushVC:(PhotoEditorCtl *)editorCtl{
    [editorCtl reset:NO];
    editorCtl.rotateEnabled = NO;
    [self.navigationController pushViewController:editorCtl animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)delegateImgArr:(NSArray *)objArr{
    NSArray *imageArr = objArr.firstObject;
    PhotoSelectCtl *ctl = objArr.lastObject;
    [ctl.delegate didFinishSelectPhoto:imageArr];
}

-(void) alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    if (index == 0)
    {  //确定
        if (_selectedAssets.count == 1)
        {
            [self.navigationController popViewControllerAnimated:YES];
            [_browerDelegate finishWithImageArr:nil];
            return;
        }
        _selectIndex = 0;
        for (UIView *view in _scrollView.subviews) {
            [view removeFromSuperview];
        }
        [_selectedAssets removeObjectAtIndex:type];
        [self layoutThumbPic];
        
    }else if (index == 1){
        
    }
}

@end

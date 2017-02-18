//
//  ZBShareMenuView.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-13.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "MessagePhotoView.h"
#import "ZYQAssetPickerController.h"
#import <AVFoundation/AVFoundation.h>
// 每行有4个
#define kZBMessageShareMenuPerRowItemCount 4
#define kZBMessageShareMenuPerColum 2

#define kZBShareMenuItemIconSize 60
#define KZBShareMenuItemHeight 80

#define MaxItemCount 4
#define ItemWidth 60
#define ItemHeight 60


@interface MessagePhotoView (){
    UILabel *lblNum;
}


/**
 *  这是背景滚动视图
 */
@property (nonatomic, weak) UIScrollView *shareMenuScrollView;
@property (nonatomic, weak) UIPageControl *shareMenuPageControl;
@property(nonatomic,weak)UIButton *btnviewphoto;
@end

@implementation MessagePhotoView
@synthesize photoMenuItems;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)photoItemButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectePhotoMenuItem:atIndex:)]) {
        NSInteger index = sender.tag;
        NSLog(@"self.photoMenuItems.count is %lu",(unsigned long)self.photoMenuItems.count);
        if (index < self.photoMenuItems.count)
        {
            [self.delegate didSelectePhotoMenuItem:[self.photoMenuItems objectAtIndex:index] atIndex:index];
        }
    }
}

- (void)setup{
   
    //self.backgroundColor = [UIColor colorWithRed:248.0f/255 green:248.0f/255 blue:255.0f/255 alpha:1.0];
    self.backgroundColor = [UIColor whiteColor];

    _photoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    //_photoScrollView.contentSize = CGSizeMake(1024, 60);
   
    photoMenuItems = [[NSMutableArray alloc]init];
    _itemArray = [[NSMutableArray alloc]init];
    [self addSubview:_photoScrollView];
//    lblNum = [[UILabel alloc]initWithFrame:CGRectMake(50, 170, 230, 30)];
//   
//    [self addSubview:lblNum];
    
    [self initlizerScrollView:self.photoMenuItems];

}

-(void)reloadDataWithImage:(UIImage *)image{
    [self.photoMenuItems addObject:image];
    
    [self initlizerScrollView:self.photoMenuItems];
}

-(void)tapImage:(UITapGestureRecognizer *)sender
{
    MessagePhotoMenuItem *photoItem = (MessagePhotoMenuItem *)sender.view;
    if ([self.delegate respondsToSelector:@selector(didSelectePhotoMenuItem:atIndex:)])
    {
        NSLog(@"self.photoMenuItems.count is %lu",(unsigned long)self.photoMenuItems.count);
        if (photoItem.index < self.photoMenuItems.count)
        {
            [self.delegate didSelectePhotoMenuItem:photoItem atIndex:photoItem.index];
        }
    }
}

-(void)initlizerScrollView:(NSArray *)imgList{
//    [self.photoScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (UIView *view in self.photoScrollView.subviews) {
        [view removeFromSuperview];
    }
    for(int i=0;i<imgList.count;i++){
        UIImage *tempImg;
        if ([imgList[i] isMemberOfClass:[ALAsset class]]) {
            ALAsset *asset=imgList[i];
            tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        }
       else
       {
           tempImg = [imgList objectAtIndex:i];
       }
        
        //UIImage *tempImg = [imgList objectAtIndex:i];
        
        MessagePhotoMenuItem *photoItem = [[MessagePhotoMenuItem alloc]initWithFrame:CGRectMake(10+ i * (ItemWidth + 5 ), 0, ItemWidth, ItemHeight)];
        photoItem.delegate = self;
        photoItem.index = i;
        photoItem.contentImage = tempImg;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [photoItem addGestureRecognizer:tap];
        
        [self.photoScrollView addSubview:photoItem];
        [self.itemArray addObject:photoItem];
    }
    
    MessagePhotoMenuItem *image = [self.itemArray lastObject];
    self.photoScrollView.contentSize = CGSizeMake(CGRectGetMaxX(image.frame) + 10,60);
    
//    if(imgList.count<MaxItemCount){
//        UIButton *btnphoto=[UIButton buttonWithType:UIButtonTypeCustom];
//        [btnphoto setFrame:CGRectMake(10 + (ItemWidth + 5) * imgList.count, 8, 44, 44)];//
//        [btnphoto setImage:[UIImage imageNamed:@"addImage.png"] forState:UIControlStateNormal];
//        [btnphoto setImage:[UIImage imageNamed:@"addImage.png"] forState:UIControlStateSelected];
//        //给添加按钮加点击事件
//        [btnphoto addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
//        [self.photoScrollView addSubview:btnphoto];
//    }
//    
//    NSInteger count = MIN(imgList.count +1, MaxItemCount);
//     lblNum.text = [NSString stringWithFormat:@"已选%d张，共可选10张",self.photoMenuItems.count];
//    lblNum.backgroundColor = [UIColor clearColor];
//    [self.photoScrollView setContentSize:CGSizeMake(20 + (ItemWidth + 5)*count, 0)];
    BOOL alpha = NO;
    if (imgList.count > 0) {
        alpha = YES;
    }
    [self.delegate setViewAlpha:alpha];
}
-(void)openMenu{
    //在这里呼出下方菜单按钮项
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
    //刚才少写了这一句
    [myActionSheet showInView:self.window];
}
//下拉菜单的点击响应事件
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == myActionSheet.cancelButtonIndex){
        NSLog(@"取消");
    }
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
    BOOL accessStatus = [[Manager shareMgr] getTheCameraAccessWithCancel:^{}];
    if (!accessStatus) {
        return;
    }    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self.delegate addUIImagePicker:picker];

        
    }else{
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

/*
    调用系统相册的方法
*/
-(void)addImage{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self.delegate addUIImagePicker:imagePickerController];
}


/*
    新加的另外的方法
 */
////////////////////////////////////////////////////////////
//打开相册，可以多选
-(void)localPhoto{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc]init];
    
    picker.maximumNumberOfSelection = MaxItemCount - [self.photoMenuItems count];
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary *bindings){
        if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType]isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration]doubleValue];
            return duration >= 5;
        }else{
            return  YES;
        }
    }];
    
    [self.delegate addPicker:picker];
}

#pragma  mark   -ZYQAssetPickerController Delegate

/*
 得到选中的图片
 */
#pragma mark - ZYQAssetPickerController Delegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    [self.scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
   
    NSLog(@"self.itemArray is %lu",(unsigned long)self.photoMenuItems.count);
        NSLog(@"assets is %lu",(unsigned long)assets.count);
        //跳转到显示大图的页面
    [self.photoMenuItems addObjectsFromArray:assets];
    [self initlizerScrollView:self.photoMenuItems];
    [picker dismissViewControllerAnimated:YES completion:^{}];
        //NSLog(@"arraryOk is %d",big.arrayOK.count);
        //[picker pushViewController:big animated:YES];
}
/////////////////////////////////////////////////////////


//选择某张照片之后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    //[self.delegate dismissPickerController:picker];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if([type isEqualToString:@"public.image"]){
        //先把图片转成NSData
        UIImage *uploadImage = [info objectForKey:UIImagePickerControllerEditedImage];
        NSData *imgData = UIImageJPEGRepresentation(uploadImage, 0.3);
        UIImage *image = [UIImage imageWithData:imgData];
        [self reloadDataWithImage:image];
        
        NSData *datas;
        if(UIImagePNGRepresentation(image)==nil){
            datas = UIImageJPEGRepresentation(image, 1.0);
        }else{
            datas = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //把刚才图片转换的data对象拷贝至沙盒中,并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:datas attributes:nil];
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,@"/image.png"];
        
        //创建一个选择后图片的图片放在scrollview中
        
        //加载scrollview中
        
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    //[self.delegate dismissPickerController:picker];
}

- (void)reloadData {
    
}
- (void)dealloc {
    //self.shareMenuItems = nil;
    self.photoScrollView.delegate = nil;
    self.shareMenuScrollView.delegate = nil;
    self.shareMenuScrollView = nil;
    self.shareMenuPageControl = nil;
}

#pragma mark - MessagePhotoItemDelegate

-(void)messagePhotoItemView:(MessagePhotoMenuItem *)messagePhotoItemView didSelectDeleteButtonAtIndex:(NSInteger)index{
    [self.photoMenuItems removeObjectAtIndex:index];
    [self initlizerScrollView:self.photoMenuItems];
    [self.delegate deleteImage:index];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    [self.shareMenuPageControl setCurrentPage:currentPage];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

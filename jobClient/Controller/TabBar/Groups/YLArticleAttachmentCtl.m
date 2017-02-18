//
//  YLArticleAttachmentCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "YLArticleAttachmentCtl.h"
#import "NoLoginPromptCtl.h"


@interface YLArticleAttachmentCtl () <UIScrollViewDelegate,NoLoginDelegate>
{
    IBOutlet UIScrollView *scrollView_;
    NSMutableArray *arrDataImage;
    NSMutableArray *arrImageView;
    CGFloat contentSizeX;
    NSMutableArray *arrGuesture;
    NSMutableArray *scrollViewArr;
    UILabel *titleLable;
    IBOutlet UIView *promptView;
    IBOutlet UILabel *promptLable;
    IBOutlet UIView *favoritePromptView;
    RequestCon *favoriteCon;
    IBOutlet UIButton *favoriteBtn;
    
    CGPoint oldPoint;
}

@end

@implementation YLArticleAttachmentCtl


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(_isPushFavoriteListCtl){
        favoriteBtn.hidden = YES;
    }else{
        favoriteBtn.hidden = NO;
    }
    
    titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,30)];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont systemFontOfSize:17];
    titleLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLable;
    
    
    arrDataImage = [[NSMutableArray alloc] init];
    if ([_dataModal.postfix.lowercaseString isEqualToString:@"jpg"] || [_dataModal.postfix.lowercaseString isEqualToString:@"png"] || [_dataModal.postfix.lowercaseString isEqualToString:@"jpeg"] || [_dataModal.postfix.lowercaseString isEqualToString:@"gif"] ||[_dataModal.postfix.lowercaseString isEqualToString:@"bmp"])
    {
        [arrDataImage addObject:_dataModal.src];
    }else{
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"%@",_dataModal.file_swf];
        [str deleteCharactersInRange:NSMakeRange(str.length - 6,6)];
        for (NSInteger i = 1; i<= [_dataModal.file_pages integerValue]; i++){
            [arrDataImage addObject:[NSString stringWithFormat:@"%@_%ld.jpg",str,(long)i]];
        }
    }
    scrollView_.delegate = self;
    scrollView_.bounces = NO;
    scrollView_.contentSize = CGSizeMake(ScreenWidth * arrDataImage.count,ScreenWidth-64);
    scrollView_.pagingEnabled = YES;
    
    titleLable.text = [NSString stringWithFormat:@"1 / %lu",(unsigned long)arrDataImage.count];
    
    arrImageView = [[NSMutableArray alloc] init];
    arrGuesture = [[NSMutableArray alloc] init];
    scrollViewArr = [[NSMutableArray alloc] init];
    
    NSInteger count = 3;
    if (arrDataImage.count < 3) {
        count = arrDataImage.count;
    }
    for (NSInteger i=0; i<count; i++)
    {
        UIImageView *imageOne = [[UIImageView alloc] init];
        imageOne.contentMode = UIViewContentModeScaleAspectFit;
        [arrImageView addObject:imageOne];
        
        [imageOne sd_setImageWithURL:[NSURL URLWithString:arrDataImage[i]]];
        
        CGFloat height = [UIScreen mainScreen].bounds.size.height - 64;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        if (imageOne.image.size.width > 0 && imageOne.image.size.height > 0) {
            if (imageOne.image.size.width < width) {
                width = imageOne.image.size.width;
            }
            if (imageOne.image.size.height < height) {
                height = imageOne.image.size.height;
            }
        }
        imageOne.frame = CGRectMake(0,0,width,height);
        imageOne.userInteractionEnabled = YES;
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(ScreenWidth*i,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
        scroll.bounces = NO;
        scroll.delegate = self;
        [scroll addSubview:imageOne];
        imageOne.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,([UIScreen mainScreen].bounds.size.height - 64)/2);
        
        [scrollViewArr addObject:scroll];
        [scrollView_ addSubview:scroll];
        
        imageOne.tag = 100+i;
        UIPinchGestureRecognizer *grz = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerImage:)];
        [imageOne addGestureRecognizer:grz];
        [arrGuesture addObject:grz];
    }
}

-(void)gestureRecognizerImage:(UIPinchGestureRecognizer *)sender
{
    UIImageView *image = arrImageView[sender.view.tag-100];
    CGFloat height = [UIScreen mainScreen].bounds.size.height-64;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
    if (image.image.size.width < width) {
        width = image.image.size.width;
    }
    if (image.image.size.height < height) {
        height = image.image.size.height;
    }
    
    if (image.frame.size.width < width && image.frame.size.height < height && sender.scale < 1) {
        UIScrollView *scr = scrollViewArr[sender.view.tag-100];
        scr.contentOffset = CGPointZero;
        scr.contentSize = CGSizeMake(width,height);
        image.center = CGPointMake(scr.contentSize.width/2.0,scr.contentSize.height/2.0);
        return;
    }
    
    if (image.frame.size.height >= image.image.size.height*2 && image.frame.size.width >= image.image.size.width*2 && sender.scale > 1){
        return;
    }
    
    image.transform = CGAffineTransformScale(image.transform, sender.scale, sender.scale);
    CGRect frame = image.frame;
    CGFloat pointY = oldPoint.y-frame.origin.y;
    CGFloat pointX = oldPoint.x-frame.origin.x;
    pointY = pointY>0 ? pointY:0;
    pointX = pointX>0 ? pointX:0;
    
    UIScrollView *scr = scrollViewArr[sender.view.tag-100];
    scr.contentSize = CGSizeMake(MAX(frame.size.width,width),MAX(frame.size.height,height));
    image.center = CGPointMake(scr.contentSize.width/2.0,scr.contentSize.height/2.0);
    scr.contentOffset = CGPointMake(pointX,pointY);
    sender.scale = 1;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == scrollView_) {
         contentSizeX = scrollView.contentOffset.x;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == scrollView_) {
        CGRect frame = scrollView_.frame;
        frame.size.width = ScreenWidth;
        scrollView_.frame = frame;
        NSInteger i = scrollView.contentOffset.x/scrollView_.frame.size.width;
        if (i>=2 && i<= arrDataImage.count-2)
        {
            if (scrollView.contentOffset.x>contentSizeX) {
                UIImageView *image = arrImageView[(i-2)%3];
                [image sd_setImageWithURL:[NSURL URLWithString:arrDataImage[i+1]]];
                
                UIScrollView *scr = scrollViewArr[(i-2)%3];
                CGRect frame = scr.frame;
                frame.origin.x = scr.frame.size.width * (i+1);
                scr.frame = frame;
            }
            else if(scrollView.contentOffset.x<contentSizeX)
            {
                UIImageView *image = arrImageView[(i+2)%3];
                [image sd_setImageWithURL:[NSURL URLWithString:arrDataImage[i-1]]];
                
                UIScrollView *scr = scrollViewArr[(i+2)%3];
                CGRect frame = scr.frame;
                frame.origin.x = scr.frame.size.width * (i-1);
                scr.frame = frame;
            }
        }
        if (i==1 && scrollView.contentOffset.x<contentSizeX) {
            UIImageView *image = arrImageView[0];
            [image sd_setImageWithURL:[NSURL URLWithString:arrDataImage[i-1]]];
            
            UIScrollView *scr = scrollViewArr[0];
            CGRect frame = scr.frame;
            frame.origin.x = 0;
            scr.frame = frame;
        }
    }
    else
    {
        oldPoint = scrollView.contentOffset;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == scrollView_) {
        if(scrollView.contentOffset.x != contentSizeX)
        {
            for (UIScrollView *scr in scrollViewArr) {
                scr.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
            }
            for (UIImageView *img in arrImageView)
            {
                CGFloat height = [UIScreen mainScreen].bounds.size.height - 64;
                CGFloat width = [UIScreen mainScreen].bounds.size.width;
                
                if (img.image.size.width < width) {
                    width = img.image.size.width;
                }
                if (img.image.size.height < height) {
                    height = img.image.size.height;
                }
                CGRect rect = img.frame;
                rect.size.width = width;
                rect.size.height = height;
                img.frame = rect;
                img.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,([UIScreen mainScreen].bounds.size.height - 64)/2);
            }
        }
        NSInteger i = scrollView.contentOffset.x/scrollView.frame.size.width + 1;
        titleLable.text = [NSString stringWithFormat:@"%ld / %lu",(long)i,(unsigned long)arrDataImage.count];
    }
    
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

- (IBAction)favoriteBtn:(UIButton *)sender
{
    if (![Manager shareMgr].haveLogin)
    {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        return;
    }
    if (!favoriteCon) {
        favoriteCon = [self getNewRequestCon:NO];
    }
    if (_fromArticleList) {
        [favoriteCon addArticleFavorite:_dataModal.article_id userId:[Manager getUserInfo].userId_ type:@"add"];
    }
    else
    {
        [favoriteCon addArticleMediaFavorite:_dataModal.id_ userId:[Manager getUserInfo].userId_ type:@"add"];
    }
}

- (IBAction)saveBtn:(UIButton *)sender
{
    BOOL accessStatus = [[Manager shareMgr] getPhotoAccessStatusWithCancel:^{}];
    if (!accessStatus) {
        return;
    }
    
    NSInteger i = scrollView_.contentOffset.x/scrollView_.frame.size.width;
    UIImageView *image = arrImageView[i%3];
    
    UIImageWriteToSavedPhotosAlbum(image.image, self, @selector(image:didFinishSavingWithError:contextInfo:),NULL);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{

    if (!error) {
        promptLable.text = @"已保存";
    }
    else
    {
        promptLable.text = @"保存失败";
    }
    [self.view addSubview:promptView];
    [self.view bringSubviewToFront:promptView];
    promptView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,([UIScreen mainScreen].bounds.size.height - 64)/2);
    [self performSelector:@selector(deletePromtView) withObject:nil afterDelay:2.0f];
}

-(void)deletePromtView
{
    [promptView removeFromSuperview];
}

-(void)deletePromtViewFavorite
{
    [favoritePromptView removeFromSuperview];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_AddArticleFavorite:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            if( [dataModal.status_ isEqualToString:Success_Status] ){
                if ([dataModal.code_ isEqualToString:@"200"])
                {
                    [self.view addSubview:favoritePromptView];
                    [self.view bringSubviewToFront:favoritePromptView];
                    favoritePromptView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,([UIScreen mainScreen].bounds.size.height - 64)/2);
                    [self performSelector:@selector(deletePromtViewFavorite) withObject:nil afterDelay:2.0f];
                }
                else{
                    [BaseUIViewController showAutoDismissAlertView:nil msg:dataModal.des_ seconds:2.0];
                }
            }else if( [dataModal.status_ isEqualToString:Fail_Status] ){
                [BaseUIViewController showAutoDismissAlertView:nil msg:dataModal.des_ seconds:2.0];
            }else{
                [BaseUIViewController showAlertView:nil msg:@"收藏失败,请稍后再试" btnTitle:@"确定"];
            }
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

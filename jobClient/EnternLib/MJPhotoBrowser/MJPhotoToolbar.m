//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
//#import "MBProgressHUD+Add.h"
#import "MJPhotoView.h"

@interface MJPhotoToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
    UIButton *_likeBtn_;
    UIButton *_commentBtn_;
    UIButton *_deleteBtn_;
    BOOL isLike;
    RequestCon *_accessTokenCon;
}
@end

@implementation MJPhotoToolbar
@synthesize delegate_,toolbarType_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    self.backgroundColor = [UIColor colorWithRed:100.0/255 green:100.0/255 blue:100.0/255 alpha:0.4];
    
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = [photos mutableCopy];
    
    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame = self.bounds;
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_indexLabel];
    }
    
    // 保存图片按钮
    //CGFloat btnWidth = self.bounds.size.width;
    if ((toolbarType_ == 1 || toolbarType_ == 2 || toolbarType_ == 5) && _isMyCenter == YES) {
        //删除视图
        _deleteBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn_.frame = CGRectMake(self.bounds.size.width-45, 0, 50, 40);
        _deleteBtn_.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_deleteBtn_ setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn_ setBackgroundColor:[UIColor clearColor]];
        [_deleteBtn_ addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn_];
    }else{
        _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveImageBtn.frame = CGRectMake(self.bounds.size.width-45, 0, 40, 40);
        _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
        [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
        [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_saveImageBtn];
    }
    
    
}

#pragma LoadDataDelegate
-(NSString *) getRequestInditify:(RequestCon *)con
{
    return nil;
}

-(void) dataChanged:(RequestCon *)con
{
    
}

-(void) loadDataBegin:(RequestCon *)con requestType:(int)type
{
    //如果请求含有字符串,则代表需要显示模态加载Loading界面
    NSString *loadingStr = [RequestCon getRequestStr:type];
    if( loadingStr ){
        loadingStr = [NSString stringWithFormat:@"正在%@",loadingStr];
        [BaseUIViewController showModalLoadingView:YES title:loadingStr status:nil];
    }
}

-(void) loadDataComplete:(RequestCon *)con code:(ErrorCode)code dataArr:(NSArray *)dataArr requestType:(int)type
{
    //如果请求中的被中断者存在,需要恢复中断了
    if( con.conBeInterrupt_ ){
        //将安全凭证取出来
        AccessToken_DataModal *dataModal = nil;
        @try {
            dataModal = [dataArr objectAtIndex:0];
            if( dataModal.accessToken_ && dataModal.sercet_ ){
                //accessTokenModal = dataModal;
                //accessTokenModal.lastDate_ = [NSDate date];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            //恢复到中断点
            [con.conBeInterrupt_ dataConnRecover:dataModal.sercet_ token:dataModal.accessToken_];
            con.conBeInterrupt_ = nil;
        }
        return;
    }
    
    //如果请求含有字符串,则代表需要取消正在显示的模态加载Loading界面
    NSString *loadingStr = [RequestCon getRequestStr:type];
    if( loadingStr )
        [BaseUIViewController showModalLoadingView:NO title:nil status:nil];
    
    switch ( type ) {
            
        default:
            break;
    }
}

-(BOOL) dataConnShouldInterrupt:(RequestCon *)con aciton:(NSString *)action bodyMsg:(NSString *)bodyMsg method:(NSString *)method
{
    //return NO;
    
    BOOL flag = NO;
    if( con.conBeInterrupt_ ){
        flag = NO;
    }else if(![Manager shareMgr].accessTokenModal ){
        flag = YES;
    }
    //    //安全凭证的有效期已经过了(12个小时)
    //    else if( [[NSDate date] timeIntervalSinceDate:accessTokenModal.lastDate_] > 12*3600 ){
    //        flag = YES;
    //    }
    
    if( flag ){
        [MyLog Log:@"dataConnShouldInterrupt is true" obj:self];
        
        con.bInterrupt_ = flag;
        
        //去请求安全凭证
        _accessTokenCon = [[RequestCon alloc] init];
        _accessTokenCon.delegate_ = self;
        _accessTokenCon.conBeInterrupt_ = con;
        [_accessTokenCon getAccessToken:WebService_User pwd:WebService_Pwd time:[NSDate timeIntervalSinceReferenceDate]];
    }else{
        con.bInterrupt_ = flag;
    }
    
    return flag;
}

- (void)deleteImage
{
    NSString *index = [NSString stringWithFormat:@"%lu",(unsigned long)_currentPhotoIndex];
    //2个人中心
    if (toolbarType_ == 2) {
        [delegate_ personCenterDelegatePhoto:index];
    }else if (toolbarType_ == 1){
        [delegate_ resumeDelegatePhoto:index];
    }else if (toolbarType_ == 5){
        [delegate_ simplifyResumeDelegatePhoto:index];
    }
}

- (void)saveImage
{
    BOOL accessStatus = [[Manager shareMgr] getPhotoAccessStatusWithCancel:^{
        
    }];
    if (!accessStatus) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [BaseUIViewController showAlertViewContent:@"保存失败" toView:nil second:1.0 animated:YES];
    } else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        _saveImageBtn.enabled = NO;
        [BaseUIViewController showAlertViewContent:@"成功保存到相册" toView:nil second:1.0 animated:YES];
    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%lu / %lu", (unsigned long)(_currentPhotoIndex + 1), (unsigned long)_photos.count];
    
    MJPhoto *photo = _photos[_currentPhotoIndex];
    // 按钮
   // _saveImageBtn.enabled = photo.image != nil && !photo.save;
//    _saveImageBtn.enabled = photo.image != nil ;
    _saveImageBtn.enabled = !photo.save;
    
}

@end

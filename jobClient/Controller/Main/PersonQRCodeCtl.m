//
//  PersonQRCodeCtl.m
//  jobClient
//
//  Created by 一览ios on 15/8/4.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "PersonQRCodeCtl.h"
#import "QRCodeGenerator+LogoView.h"
#import "UIImageView+WebCache.h"

@interface PersonQRCodeCtl ()
{
    UIView   *bgView;
    User_DataModal *model_;
    
    __weak IBOutlet NSLayoutConstraint *qrImageHeight;
    
    __weak IBOutlet NSLayoutConstraint *backViewHeight;
    
    
    __weak IBOutlet NSLayoutConstraint *btnX;
    
    __weak IBOutlet NSLayoutConstraint *btnY;
}
@end

@implementation PersonQRCodeCtl

-(instancetype)initWithDataModal:(User_DataModal *)dataModel
{
    self = [super init];
    if (self) {
        model_ = dataModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    [_contentView setBackgroundColor:[UIColor whiteColor]];
    _contentView.layer.cornerRadius = 5.0;
    _contentView.layer.masksToBounds = YES;
    _contentView.layer.borderWidth = 0.5;
    _contentView.layer.borderColor = GRAYCOLOR.CGColor;
    _photoImgv.layer.cornerRadius = 5.0;
    _photoImgv.layer.masksToBounds = YES;
    _photoImgv2.layer.cornerRadius = 5.0;
    _photoImgv2.layer.masksToBounds = YES;
    _photoImgv2.layer.borderColor = [UIColor whiteColor].CGColor;
    _photoImgv2.layer.borderWidth = 2.0;
    _saveBtn.layer.cornerRadius = 5.0;
    _saveBtn.layer.masksToBounds = YES;
    
    [_qrImgv setContentMode:UIViewContentModeScaleAspectFill];
//    _qrImgv.image = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"%@%@",QR_PERSON_TYPE,model_.userId_] imageSize:_qrImgv.bounds.size.height];
    _qrImgv.image = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"%@%@",@"http://m.yl1001.com/u/",model_.userId_] imageSize:_qrImgv.bounds.size.height];
    [_nameLb setText:model_.name_];
    NSString * str  = @"";
    if (model_.job_ && ![model_.job_ isEqualToString:@""]) {
        str = [NSString stringWithFormat:@"%@",model_.job_];
    }else{
        str = model_.zye_;
    }
    if ([str isEqualToString:@""]) {
        str = @"未填写";
    }
    [_descLb setText:[NSString stringWithFormat:@"职业/头衔：%@",str]];
    
    [_photoImgv sd_setImageWithURL:[NSURL URLWithString:model_.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    [_photoImgv2 sd_setImageWithURL:[NSURL URLWithString:model_.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    
    qrImageHeight.constant = ScreenWidth-104;
    backViewHeight.constant = 184 + ScreenWidth-104;
    btnX.constant = ScreenWidth-32;
    btnY.constant = (ScreenHeight/2)-(184 + ScreenWidth-104)/2-12;
    
    /*
    CGRect rect = _contentView.frame;
    rect.origin.y = ([UIScreen mainScreen].bounds.size.height - rect.size.height)/2;
    rect.origin.x = ([UIScreen mainScreen].bounds.size.width - rect.size.width)/2;
    [_contentView setFrame:rect];
    */
    
    _dissMissBtn.layer.cornerRadius = 1.0;
    _dissMissBtn.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)btnResponse:(id)sender
{
    if (sender == _dissMissBtn) {
        [self dismiss];
    }else if (sender == _saveBtn){
        [self saveImageToPhotos:_qrImgv.image];
    }
}

- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error != NULL){
        [BaseUIViewController showAutoDismissFailView:@"保存失败" msg:@"" seconds:1.0];
    }else{
        [BaseUIViewController showAutoDismissSucessView:@"" msg:@"保存成功" seconds:1.0];
    }
}

-(void)viewDidLayoutSubviews
{
    [self.view layoutSubviews];
}

-(void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if (!bgView) {
        bgView = [[UIView alloc] initWithFrame:keywindow.frame];
        [bgView setBackgroundColor:[UIColor blackColor]];
        [bgView setAlpha:0.8];
    }
    [keywindow addSubview:bgView];
    [keywindow addSubview:self.view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_tapImgv addGestureRecognizer:tap];
    [self animatedIn];
}

- (void)tapClick:(UITapGestureRecognizer *)tap
{
    [self dismiss];
}

- (void)dismiss
{
    [self animatedOut];
}

#pragma mark - Animated Mthod
- (void)animatedIn
{
    self.view.transform = CGAffineTransformMakeScale(0, 0);
    self.view.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut
{
    [bgView removeFromSuperview];
    [self.view removeFromSuperview];
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

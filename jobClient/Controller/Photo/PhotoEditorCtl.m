#import "HFImageEditorViewController+SubclassingHooks.h"
#import "PhotoEditorCtl.h"
#import "MyConfig.h"
#import "ELPersonCenterBackImageChangeCtl.h"
#import "PhotoSelectCtl.h"
#import "New_PhotoSelectionViewController.h"
#import "Companyinfo_ViewController.h"
#import "MyManagermentCenterCtl.h"
#import "ELPersonCenterCtl.h"
#import "UpdateGroupPhotoCtl.h"
@interface PhotoEditorCtl ()
{
    __weak IBOutlet NSLayoutConstraint *rotateLeftWidth;
    
    __weak IBOutlet NSLayoutConstraint *LeftWidth169;
    
    __weak IBOutlet NSLayoutConstraint *LeftWidth43;
        
    __weak IBOutlet NSLayoutConstraint *LeftWidth11;
    
    __weak IBOutlet NSLayoutConstraint *LeftWidth34;
    
    __weak IBOutlet NSLayoutConstraint *LeftWidth916;
    
    __weak IBOutlet UIView *bottomChangeView;
    
    UIView *boomLineView;
}
@end

@implementation PhotoEditorCtl

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
       // self.cropSize = CGSizeMake(320,320);
        self.minimumScale = 0.2;
        self.maximumScale = 10;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fd_interactivePopDisabled = YES;
    
    if (_isOnlyOneSel) {
        if (_imageType == 1) {//个人头像
            CGSize size = [self creatHeightWidthSize:self.imageView.frame.size andSize:CGSizeMake(ScreenWidth,ScreenHeight-100)];
            self.cropSize = [self creatHeightWidthSize:CGSizeMake(ScreenWidth,ScreenWidth) andSize:size];
            bottomChangeView.hidden = YES;
        }
        else if(_imageType == 2){//社群头像
            CGSize size = [self creatHeightWidthSize:self.imageView.frame.size andSize:CGSizeMake(ScreenWidth,ScreenHeight-100)];
            self.cropSize = [self creatHeightWidthSize:CGSizeMake(ScreenWidth,ScreenWidth) andSize:size];
            bottomChangeView.hidden = YES;
        }
        else{//企业logo
            CGSize size = [self creatHeightWidthSize:self.imageView.frame.size andSize:CGSizeMake(ScreenWidth,ScreenHeight-100)];
            self.cropSize = [self creatHeightWidthSize:CGSizeMake(ScreenWidth,17 * ScreenWidth/28.0) andSize:size];
            bottomChangeView.hidden = YES;
        }
    }
    else{
        bottomChangeView.hidden = NO;
        [_btn1_1 setImage:[UIImage imageNamed:@"shape_select_1_1.png"] forState:UIControlStateSelected];
        [_btn1_1 setTitleColor:[UIColor colorWithRed:238.f/255 green:96.f/255 blue:86.f/255 alpha:1.0] forState:UIControlStateSelected];
        [_btn16_9 setImage:[UIImage imageNamed:@"shape_select_16_9.png"] forState:UIControlStateSelected];
        [_btn16_9 setTitleColor:[UIColor colorWithRed:238.f/255 green:96.f/255 blue:86.f/255 alpha:1.0] forState:UIControlStateSelected];
        [_btn4_3 setImage:[UIImage imageNamed:@"shape_select_4_3.png"] forState:UIControlStateSelected];
        [_btn4_3 setTitleColor:[UIColor colorWithRed:238.f/255 green:96.f/255 blue:86.f/255 alpha:1.0] forState:UIControlStateSelected];
        [_btn3_4 setImage:[UIImage imageNamed:@"shape_select_3_4.png"] forState:UIControlStateSelected];
        [_btn3_4 setTitleColor:[UIColor colorWithRed:238.f/255 green:96.f/255 blue:86.f/255 alpha:1.0] forState:UIControlStateSelected];
        [_btn9_16 setImage:[UIImage imageNamed:@"shape_select_9_16.png"] forState:UIControlStateSelected];
        [_btn9_16 setTitleColor:[UIColor colorWithRed:238.f/255 green:96.f/255 blue:86.f/255 alpha:1.0] forState:UIControlStateSelected];
        _btn1_1.selected = YES;
        _selectedBtn = _btn1_1;
        CGSize size = [self creatHeightWidthSize:self.imageView.frame.size andSize:CGSizeMake(ScreenWidth,ScreenHeight-100)];
        self.cropSize = [self creatHeightWidthSize:CGSizeMake(ScreenWidth,ScreenWidth) andSize:size];
        
        CGFloat width = (ScreenWidth-(46*6))/7.0;
        rotateLeftWidth.constant = width;
        LeftWidth169.constant = width;
        LeftWidth43.constant = width;
        LeftWidth11.constant = width;
        LeftWidth34.constant = width;
        LeftWidth916.constant = width;
        
        if (_sizeType > 0)
        {
            bottomChangeView.hidden = YES;
            
            if (_sizeType == Type16_10) {
                self.cropSize = [self creatHeightWidthSize:CGSizeMake(ScreenWidth,(200*ScreenWidth)/320.0) andSize:size];
            }
            else
            {
                UIButton *btn = nil;
                switch (_sizeType) {
                    case Type1_1:
                    {
                        btn = _btn1_1;
                    }
                        break;
                    case Type9_16:
                    {
                        btn = _btn9_16;
                    }
                        break;
                    case Type16_9:
                    {
                        btn = _btn16_9;
                    }
                        break;
                    case Type4_3:
                    {
                        btn = _btn4_3;
                    }
                        break;
                    case Type3_4:
                    {
                        btn = _btn3_4;
                    }
                        break;
                    default:
                        break;
                }
                [self btnResponse:btn];
            }
        }
        else
        {
            bottomChangeView.hidden = NO;
        }
    }
    
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

-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.saveButton = nil;
}

- (IBAction)setSquareAction:(id)sender
{
    self.cropSize = CGSizeMake(ScreenWidth, ScreenWidth);
}

- (IBAction)setLandscapeAction:(id)sender
{
    self.cropSize = CGSizeMake(ScreenWidth,(240*ScreenWidth)/320.0);
}


- (IBAction)setLPortraitAction:(id)sender
{
    self.cropSize = CGSizeMake((240*ScreenWidth)/320.0, ScreenWidth);
}

#pragma mark Hooks
- (void)startTransformHook
{
    self.saveButton.tintColor = [UIColor colorWithRed:0 green:49/255.0f blue:98/255.0f alpha:1];
}

- (void)endTransformHook:(UIImage *)image
{
    if (_sizeType > 0)
    {
        PhotoSelectCtl *selectCtl;
        New_PhotoSelectionViewController *logoVC;
        Companyinfo_ViewController *cVC;
        MyManagermentCenterCtl *managerVC;
        ELPersonCenterCtl *personVC;
        UpdateGroupPhotoCtl *groupImgVC;
        id personCenterCtl;
        for (id ctl in self.navigationController.viewControllers) {
            if ([ctl isKindOfClass:[ELPersonCenterBackImageChangeCtl class]]) {
                personCenterCtl = ctl;
            }
            if ([ctl isKindOfClass: [PhotoSelectCtl class]])
            {
                selectCtl = ctl;
            }
            if([ctl isKindOfClass: [New_PhotoSelectionViewController class]]){
                logoVC = ctl;
            }
            if ([ctl isKindOfClass: [Companyinfo_ViewController class]]) {
                cVC = ctl;
            }
            if ([ctl isKindOfClass:[MyManagermentCenterCtl class]]) {
                managerVC = ctl;
            }
            if ([ctl isKindOfClass:[ELPersonCenterCtl class]]) {
                personVC = ctl;
            }
            if ([ctl isKindOfClass:[UpdateGroupPhotoCtl class]]) {
                groupImgVC = ctl;
            }
        }
        if (selectCtl) {
            if ([selectCtl.delegate respondsToSelector:@selector(didFinishSelectPhoto:)]) 
            {
                [selectCtl.delegate didFinishSelectPhoto:@[image]];
            }
            if (personCenterCtl) {
                [self.navigationController popToViewController:personCenterCtl animated:YES];
            }
            return;
        }
        else if(logoVC && cVC){
            if ([logoVC.delegate respondsToSelector:@selector(hadFinishSelectPhoto:)])
            {
                [logoVC.delegate hadFinishSelectPhoto:@[image]];
            }
            [self.navigationController popToViewController:cVC animated:YES];
            return;
        }
        else if (groupImgVC && logoVC) {
            if ([logoVC.delegate respondsToSelector:@selector(hadFinishSelectPhoto:)])
            {
                [logoVC.delegate hadFinishSelectPhoto:@[image]];
            }
            [self.navigationController popToViewController:groupImgVC animated:YES];
            return;
        }
        else if(managerVC && logoVC){
            if ([logoVC.delegate respondsToSelector:@selector(hadFinishSelectPhoto:)])
            {
                [logoVC.delegate hadFinishSelectPhoto:@[image]];
            }
            if(personVC){
                [self.navigationController popToViewController:personVC animated:YES];
            }
            else{
                [self.navigationController popToViewController:managerVC animated:YES];
            }
            return;
        }
        else{
            if(self.doneCallback) {
                self.doneCallback(image, NO);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
        if(self.doneCallback) {
            self.doneCallback(image, NO);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
//    self.saveButton.tintColor = [UIColor colorWithRed:0 green:128/255.0f blue:1 alpha:1];
}


- (IBAction)btnResponse:(UIButton *)sender
{
    if (_selectedBtn == sender) {
        return;
    }
    _selectedBtn.selected = NO;
    sender.selected = YES;
    _selectedBtn = sender;
    
    CGSize size = [self creatHeightWidthSize:self.imageView.frame.size andSize:CGSizeMake(ScreenWidth,ScreenHeight-100)];
    
    if (sender == _btn16_9) {
        self.cropSize = [self creatHeightWidthSize:CGSizeMake(ScreenWidth,(180*ScreenWidth)/320.0) andSize:size];
    }else if(sender == _btn9_16){
        self.cropSize = [self creatHeightWidthSize:CGSizeMake((180*ScreenWidth)/320.0,ScreenWidth) andSize:size];
    }else if(sender == _btn3_4){
        self.cropSize = [self creatHeightWidthSize:CGSizeMake((240*ScreenWidth)/320.0,ScreenWidth) andSize:size];
    }else if(sender == _btn4_3){
        self.cropSize = [self creatHeightWidthSize:CGSizeMake(ScreenWidth,(240*ScreenWidth)/320.0) andSize:size];
    }else if(sender == _btn1_1){
        self.cropSize = [self creatHeightWidthSize:CGSizeMake(ScreenWidth,ScreenWidth) andSize:size];
    }
}

@end

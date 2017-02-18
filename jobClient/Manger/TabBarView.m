//
//  TabBarView.m
//  jobClient
//
//  Created by 一览ios on 16/7/15.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "TabBarView.h"
#import "RootTabBarViewController.h"
//RGB颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
//title默认颜色
#define TitleColor   UIColorFromRGB(0x616161)
//title选中颜色
#define TitleColor_Sel  UIColorFromRGB(0xfa3434)
//title字体大小
#define TitleFontSize 10.0

//数字角标直径
#define NumMark_W_H 20
//小红点直径
#define PointMark_W_H 10

//TabBarButton中 图片与文字上下所占比
static const float scale= 32.0/49.0;

@interface TabBarButton()

@end

@implementation TabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat newX = 0;
    CGFloat newY = 8;
    CGFloat newWidth = contentRect.size.width;
    CGFloat newHeight = contentRect.size.height*scale-newY;
    return CGRectMake(newX, newY, newWidth, newHeight);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGFloat newX = 0;
    CGFloat newY = contentRect.size.height*scale - 2;
    CGFloat newWidth = contentRect.size.width;
    CGFloat newHeight = contentRect.size.height-contentRect.size.height*scale;
    return CGRectMake(newX, newY, newWidth, newHeight);
}

@end

@interface TabBarView ()<UIGestureRecognizerDelegate,NoLoginDelegate>

@property(nonatomic,strong)UIButton *seleBtn;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,strong)NSArray *selImageArray;

@end

@implementation TabBarView

#pragma mark--初始化
-(instancetype)initWithFrame:(CGRect)frame controllersNum:(int)num{
    if (self = [super initWithFrame:frame]) {
        [self configUIWithNum:num];
    }
    return self;
}

#pragma mark--配置UI
-(void)configUIWithNum:(int)num{
//    ios_icon_yilan_def
    self.backgroundColor = UIColorFromRGB(0xfafafa);
    self.selImageArray = @[@"ios_icon_yilan_click.png",@"ios_icon_yewen_click.png",@"ios_icon_zhiwei_click1.png",@"ios_icon_xiaoxi_click.png",@"ios_icon_wo_click.png"];
    self.imageArray = @[@"ios_icon_yilan_def1.png",@"ios_icon_yewen_def",@"ios_icon_zhiwei_def.png",@"ios_icon_xiaoxi_def.png",@"ios_icon_wo_def.png"];
    self.titleArray = @[@"同行",@"业问",@"职位",@"消息",@"我"];
    
    for(int i=0;i<num;i++)
    {
        TabBarButton *button = [[TabBarButton alloc] initWithFrame:CGRectMake(ScreenWidth/num*i, 0, ScreenWidth/num,49)];
        button.tag = 1000+i;
        
        //常态文字颜色
        [button setTitleColor:TitleColor forState:UIControlStateNormal];
        //选中文字颜色
        [button setTitleColor:TitleColor_Sel forState:UIControlStateSelected];
        
        button.titleLabel.font = [UIFont systemFontOfSize:TitleFontSize];
        button.backgroundColor = UIColorFromRGB(0xfafafa);
        [button setImage:[UIImage imageNamed:self.imageArray[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:self.selImageArray[i]] forState:UIControlStateSelected];
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        if (i==0)
        {
            //默认选中
            button.selected=YES;
            self.seleBtn = button;
        }
        if (i >= 0 && i < 3) {
            [self addGesture:button];
        }
        //角标
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width/2.0+6, 3, NumMark_W_H, NumMark_W_H)];
        //        numLabel.layer.masksToBounds = YES;
        //        numLabel.layer.cornerRadius = 8;
        
        //        numLabel.backgroundColor = UIColorFromRGB(0xef1a28);
        numLabel.textColor = [UIColor whiteColor];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.font = [UIFont systemFontOfSize:11];
        numLabel.tag = 1010+i;
        numLabel.hidden = YES;
        [button addSubview:numLabel];
    }
}

//取消默认选中
-(void)selectedBtnIdx:(BOOL)isLogin{
    UIButton *button = (UIButton *)[self viewWithTag:1000];
    button.selected = isLogin;
}

#pragma mark--添加双击手势
-(void)addGesture:(UIButton *)button{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired = 2;
    tap.delegate = self;
    [button addGestureRecognizer:tap];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark--代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIButton *btn = (UIButton *)touch.view;
    if (self.seleBtn.tag == btn.tag){
        return YES;
    }
    else{
        return NO;
    }
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_MessageCenter:
        {
            [self selectedBtnIdx:NO];
        }
            break;
        default:
            break;
    }
}

#pragma mark--事件
//手势双击
-(void)tapClick:(UITapGestureRecognizer *)tap{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"statusBarTouchedAction" object:nil];
    UIButton *btn = (UIButton *)[tap view];
    [self showControllerIndex:btn.tag - 1000];
    if ([self.delegate respondsToSelector:@selector(buttonSelectedClick:)]) {
        [self.delegate buttonSelectedClick:btn];
    }
}

//点击tabbar按钮
-(void)buttonAction:(UIButton *)button{
    NSInteger index = button.tag-1000;
    
    if (![Manager shareMgr].haveLogin) {
        if (index == 3) {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_MessageCenter;
            return;
        }
    }
    
    [self showControllerIndex:index];
    if ([self.delegate respondsToSelector:@selector(buttonSelectedClick:)]) {
        [self.delegate buttonSelectedClick:button];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabBarButtonStatus" object:nil];
}

/**
 *  切换显示控制器
 *
 *  @param index 位置
 */
-(void)showControllerIndex:(NSInteger)index
{
    self.seleBtn.selected = NO;
    UIButton *button = (UIButton *)[self viewWithTag:1000+index];
    button.selected = YES;
    self.seleBtn = button;
}


#pragma mark--红点
/**
 *  数字角标
 *
 *  @param num   所要显示数字
 *  @param index 位置
 */
-(void)showBadgeMark:(NSInteger)badge index:(NSInteger)index
{

  
    UILabel *numLabel = (UILabel *)[self viewWithTag:1010+index];
    numLabel.hidden=NO;
    numLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"info_01"]];
    CGRect nFrame = numLabel.frame;
      
    if(badge<=0)
    {
    //隐藏角标
        [self hideMarkIndex:index];
    }
    else
    {
        nFrame.size.width = NumMark_W_H;
        nFrame.size.height = NumMark_W_H;
        numLabel.frame = nFrame;
            //        numLabel.layer.cornerRadius = NumMark_W_H/2.0;
            
        if(badge>99)
        {
            numLabel.text =@"···";
        }else{
            //NSString *numstr = [NSString stringWithFormat:@"%d",badge];
            NSInteger num = [numLabel.text integerValue];
            if (num != badge) {
                numLabel.text = [NSString stringWithFormat:@"%ld",(long)badge];
            }
        }
    }

}

/**
 *  小红点
 *
 *  @param index 位置
 */
-(void)showPointMark:(NSInteger)mark Index:(NSInteger)index
{
    UILabel *numLabel = (UILabel *)[self viewWithTag:1010+index];
    CGRect nFrame = numLabel.frame;
    nFrame.size.height=PointMark_W_H;
    nFrame.size.width = PointMark_W_H;
    numLabel.frame = nFrame;
    numLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"info"]];
//    numLabel.layer.cornerRadius = PointMark_W_H/2.0;
    numLabel.text = @"";
    if (mark > 0) {
        numLabel.hidden=NO;
    }
    else{
        numLabel.hidden=YES;
    }
}

/**
 *  隐藏指定位置角标
 *
 *  @param index 位置
 */
-(void)hideMarkIndex:(NSInteger)index
{
    UILabel *numLabel = (UILabel *)[self viewWithTag:1010+index];
    numLabel.hidden = YES;
}

@end

//
//  ELRewardLuckyBagAnimationCtl.m
//  jobClient
//
//  Created by YL1001 on 15/12/24.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "ELRewardLuckyBagAnimationCtl.h"

//#define kCoinCountKey   80     //金币总数
static int kCoinCountKey = 80;
@interface ELRewardLuckyBagAnimationCtl ()

@end

@implementation ELRewardLuckyBagAnimationCtl

//统计金币数量的变量
static int coinCount = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endAnimation)];
    [_maskView addGestureRecognizer:singleTap];
    
    [[self getNoNetworkView] removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[self getNoNetworkView] removeFromSuperview];
}


- (void)initBagView
{
    _coinTagsArr = [NSMutableArray new];
    _titleImgv.image = [UIImage imageNamed:[NSString stringWithFormat:@"reward_slogan%d",arc4random() % 7 + 1]];
    
    [self startAnimation];
}

- (void)startAnimation
{
    //初始化金币生成的数量
    coinCount = 0;
    for (int i = 0; i<kCoinCountKey; i++) {
        
        //延迟调用函数
        [self performSelector:@selector(initCoinViewWithInt:) withObject:[NSNumber numberWithInt:i] afterDelay:i * 0.01];
    }
}

- (void)initCoinViewWithInt:(NSNumber *)i
{
    UIImageView *coin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gold10.png"]];
    //初始化金币的最终位置
    coin.center = CGPointMake(CGRectGetMidX(self.view.frame) + arc4random()%40 * (arc4random() %3 - 1) - 20, CGRectGetMidY(self.view.frame) - 20);
    coin.tag = [i intValue] + 1;
    //每生产一个金币,就把该金币对应的tag加入到数组中,用于判断当金币结束动画时和福袋交换层次关系,并从视图上移除
    [_coinTagsArr addObject:[NSNumber numberWithInteger:coin.tag]];
    
    [self.view addSubview:coin];
    
    [self setAnimationWithLayer:coin];
}

- (void)setAnimationWithLayer:(UIView *)coin
{
    CGFloat duration = 2.0f;
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    //绘制从底部到福袋口之间的抛物线
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    int fromX       = coin.layer.position.x + 10;     //起始位置:x轴上随机生成一个位置
    int fromY       = CGRectGetMinY(_bagView.frame) + 10; //起始位置:生成位于福袋上方的随机一个y坐标
    
    NSInteger maxY = CGRectGetMinY(_bagView.frame) + 10;
    CGFloat positionX   = arc4random() % 280;    //终点x
    CGFloat positionY   = arc4random() % (maxY - 50) + 40;    //终点y
    
    CGFloat cpx = positionX + (fromX - positionX)/2;    //x控制点
    CGFloat cpy = positionY - fromY / 2;                //y控制点,确保抛向的最大高度在屏幕内,并且在福袋上方(负数)
    
    //动画的起始位置
    //CGPathMoveToPoint(path, NULL, fromX, height);
    CGPathMoveToPoint(path, NULL, fromX, fromY);
    CGPathAddQuadCurveToPoint(path, NULL, cpx, cpy, positionX, positionY);
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setPath:path];
    CFRelease(path);
    path = nil;
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    //图像由大到小的变化动画
    CGFloat from3DScale = (arc4random() % 5 + 2 ) * 0.1;
    CGFloat to3DScale = (arc4random() % 4 + 5 ) * 0.05 + 0.3;
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(from3DScale, from3DScale, from3DScale)], [NSValue valueWithCATransform3D:CATransform3DMakeScale(to3DScale, to3DScale, to3DScale)]];
    scaleAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    //动画组合
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = duration;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.animations = @[scaleAnimation, animation];
    [coin.layer addAnimation:group forKey:@"position and transform"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        //动画完成后把金币和数组对应位置上的tag移除
        UIView *coinView = (UIView *)[self.view viewWithTag:[[_coinTagsArr firstObject] intValue]];
        
        [coinView removeFromSuperview];
        [_coinTagsArr removeObjectAtIndex:0];
        
        //全部金币完成动画后执行的动作
        if (++coinCount == kCoinCountKey) {
            [self bagShakeAnimation];
        }
    }
}

//福袋晃动动画
- (void)bagShakeAnimation
{
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = [NSNumber numberWithFloat:- 0.2];
    shake.toValue   = [NSNumber numberWithFloat:+ 0.2];
    shake.duration = 0.1;
    shake.autoreverses = YES;
    shake.repeatCount = 4;
    
    [_bagView.layer addAnimation:shake forKey:@"bagShakeAnimation"];
//    [_titleImgv.layer addAnimation:shake forKey:@"bagShakeAnimation"];
    
    [self performSelector:@selector(endAnimation) withObject:nil afterDelay:0.5];
}

- (void)endAnimation
{
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

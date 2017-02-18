//
//  MyCenterCell.m
//  jobClient
//
//  Created by 一览ios on 15/7/29.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MyCenterCell.h"

const CGFloat WZFlashInnerCircleInitialRaius = 20;

@interface  MyCenterCell()<UIGestureRecognizerDelegate,CAAnimationDelegate>
{
    UITapGestureRecognizer *tapGestureRecognizer;
    NSInteger numbersTap;
}
@end

@implementation MyCenterCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
//    [self addTap];
//    numbersTap = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)removeTapGestureRecognizer
//{
//    [self removeGestureRecognizer:tapGestureRecognizer];
//}
//
//-(void)addTap{
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
//    [self addGestureRecognizer:tap];
//    tap.delegate = self;
//    tap.numberOfTapsRequired = 1;
//    self.clipsToBounds = YES;
//    tapGestureRecognizer = tap;
//}
//
//#pragma mark - Private
//- (void)didTap:(UITapGestureRecognizer *)tapGestureHandler
//{
//    if (numbersTap >= 1) {
//        return;
//    }
//    
//    [self getCellsuperView].userInteractionEnabled = NO;
//    
//    numbersTap ++;
//    CGPoint tapLocation = [tapGestureHandler locationInView:self];
//    CAShapeLayer *circleShape = nil;
//    CGFloat scale = 1.0f;
//    
//    CGFloat width = self.bounds.size.width, height = self.bounds.size.height;
//    
//    CGFloat biggerEdge = width > height ? width : height, smallerEdge = width > height ? height : width;
//    CGFloat radius = smallerEdge / 2 > WZFlashInnerCircleInitialRaius ? WZFlashInnerCircleInitialRaius : smallerEdge / 2;
//    
//    scale = biggerEdge / radius + 0.5;
//    circleShape = [self createCircleShapeWithPosition:CGPointMake(tapLocation.x - radius, tapLocation.y - radius)
//                                             pathRect:CGRectMake(0, 0, radius * 2, radius * 2)
//                                               radius:radius];
//    
//    [self.layer addSublayer:circleShape];
//    
//    CAAnimationGroup *groupAnimation = [self createFlashAnimationWithScale:scale duration:0.4f];
//    
//    /* Use KVC to remove layer to avoid memory leak */
//    [groupAnimation setValue:circleShape forKey:@"circleShaperLayer"];
//    
//    [circleShape addAnimation:groupAnimation forKey:nil];
//    [circleShape setDelegate:self];
//    
//}
//
//- (CAShapeLayer *)createCircleShapeWithPosition:(CGPoint)position pathRect:(CGRect)rect radius:(CGFloat)radius
//{
//    CAShapeLayer *circleShape = [CAShapeLayer layer];
//    circleShape.path = [self createCirclePathWithRadius:rect radius:radius];
//    circleShape.position = position;
//    
//    circleShape.bounds = CGRectMake(0, 0, radius * 2, radius * 2);
//    circleShape.fillColor = UIColorFromRGB(0xd0d0d0) ? UIColorFromRGB(0xd0d0d0).CGColor : [UIColor whiteColor].CGColor;
//    
//    circleShape.opacity = 0;
//    circleShape.lineWidth = 1;
//    
//    return circleShape;
//}
//
//- (CAAnimationGroup *)createFlashAnimationWithScale:(CGFloat)scale duration:(CGFloat)duration
//{
//    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
//    
//    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    alphaAnimation.fromValue = @1;
//    alphaAnimation.toValue = @0;
//    
//    CAAnimationGroup *animation = [CAAnimationGroup animation];
//    animation.animations = @[scaleAnimation, alphaAnimation];
//    animation.delegate = self;
//    animation.duration = duration;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    
//    return animation;
//}
//
//- (CGPathRef)createCirclePathWithRadius:(CGRect)frame radius:(CGFloat)radius
//{
//    return [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius].CGPath;
//}
//
//#pragma mark - CAAnimationDelegate
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    if ([self.delagate respondsToSelector:@selector(tapClicked:)]) {
//        [self.delagate tapClicked:self.indexPath];
//    }
//    
//    CALayer *layer = [anim valueForKey:@"circleShaperLayer"];
//    if (layer) {
//        [layer removeFromSuperlayer];
//        numbersTap = 0;
//        [self getCellsuperView].userInteractionEnabled = YES;
//    }
//}
//
//- (UIView *)getCellsuperView
//{
//    id object = [self nextResponder];
//    while (![object isKindOfClass:[UIViewController class]] && object != nil) {
//        object = [object nextResponder];
//    }
//    UIViewController *superController = (UIViewController*)object;
//    
//    return superController.view;
//}

@end

//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"

@interface EGORefreshTableHeaderView (Private)

@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];
        float height = frame.size.height;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, height - 40.0f, self.frame.size.width, 20.0f)];
        //label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont boldSystemFontOfSize:13.0f];
        label.textColor = textColor;
        //label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        //label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _statusLabel=label;
        [label release];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake((self.frame.size.width/2)-70, height - 40.0f, 20.0f, 20.0f);
        layer.contentsGravity = kCAGravityResizeAspect;
        layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            layer.contentsScale = [[UIScreen mainScreen] scale];
        }
#endif
        
        [[self layer] addSublayer:layer];
        _arrowImage=layer;
        
        //正在加载
        CALayer *loadingLayer = [CALayer layer];
        loadingLayer.hidden = YES;
        loadingLayer.frame = CGRectMake((self.frame.size.width/2)-90, height - 40.0f, 20.0f, 20.0f);
        loadingLayer.contentsGravity = kCAGravityResizeAspect;
        loadingLayer.contents = (id)[UIImage imageNamed:@"round_refreshing.png"].CGImage;
        [[self layer] addSublayer:loadingLayer];
        _loadingImage = loadingLayer;
		[self setState:ELEGOOPullRefreshNormal];
    }
    return self;
	
}

- (id)initWithFrame:(CGRect)frame  {
    return [self initWithFrame:frame arrowImageName:@"dragrefresh_arrow.png" textColor:TEXT_COLOR];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {

}

- (void)setState:(ELEGOPullRefreshState)aState{
    
    switch (aState) {
        case ELEGOOPullRefreshPulling:
            _loadingImage.hidden = YES;
            _loadingImage.opacity = 0.0;
            [self stopLoadingAnimation];
            _statusLabel.text = NSLocalizedString(@"松开刷新...", @"Release to refresh status");
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
            
            break;
        case ELEGOOPullRefreshNormal:
            if (aState == _state) {
                break;
            }
            [self stopLoadingAnimation];
            _loadingImage.hidden = YES;
            _loadingImage.opacity = 0.0;
            if (_state == ELEGOOPullRefreshPulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            _statusLabel.text = NSLocalizedString(@"下拉刷新...", @"Pull down to refresh status");
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
            break;
        case ELEGOOPullRefreshLoading:
            if(aState == _state)break;
            _loadingImage.hidden = NO;
            _loadingImage.opacity = 1.0;
            _statusLabel.text = NSLocalizedString(@"一览正在加载中...", @"Loading Status");
            [self startLoadingAnimation];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = YES;
            [CATransaction commit];
            break;
        default:
            break;
    }
    _state = aState;
}

#pragma mark 开始价值的动画
- (void)startLoadingAnimation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.duration = 0.8;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.cumulative = YES;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [_loadingImage addAnimation:rotationAnimation forKey:@"Loading"];
}

#pragma mark 停止加载的动画
- (void)stopLoadingAnimation
{
    [_loadingImage removeAnimationForKey:@"Loading"];
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_state == ELEGOOPullRefreshLoading) {
        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, 60);
        scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
    } else if (scrollView.isDragging) {
        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsLoading:)]) {
            _loading = [_delegate egoRefreshTableDataSourceIsLoading:self];
        }
        if (_state == ELEGOOPullRefreshPulling && scrollView.contentOffset.y > -50.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
            [self setState:ELEGOOPullRefreshNormal];
        } else if (_state == ELEGOOPullRefreshNormal && scrollView.contentOffset.y < -50.0f && !_loading) {
            [self setState:ELEGOOPullRefreshPulling];
        }
        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
    
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableDataSourceIsLoading:self];
	}
    if (scrollView.contentOffset.y <= - 50.0f && !_loading) {
        
        if ([_delegate respondsToSelector:@selector(egoRefreshTableDidTriggerRefresh:)]) {
            [_delegate egoRefreshTableDidTriggerRefresh:ELEGORefreshHeader];
        }
        [self setState:ELEGOOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
    }
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
    [self performSelector:@selector(delaySetRefreshNomal) withObject:nil afterDelay:0.3];
}

- (void)delaySetRefreshNomal
{
    [self setState:ELEGOOPullRefreshNormal];
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	_delegate=nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}


@end

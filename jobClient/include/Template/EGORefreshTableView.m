//
//  EGORefreshTableView.m
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

#import "EGORefreshTableView.h"


#define TEXT_COLOR	 [UIColor darkGrayColor]

#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		//self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        self.backgroundColor = [UIColor clearColor];
        
		float height = frame.size.height;
		
		switch ( _pos ) {
			case EGORefreshHeader:
			{
				height = frame.size.height;
				
//				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, height - 30.0f, self.frame.size.width, 20.0f)];
//				label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//				label.font = [UIFont systemFontOfSize:12.0f];
//				label.textColor = textColor;
//				//label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//				//label.shadowOffset = CGSizeMake(0.0f, 1.0f);
//				label.backgroundColor = [UIColor clearColor];
//				label.textAlignment = NSTextAlignmentCenter;
//				[self addSubview:label];
//				_lastUpdatedLabel=label;
//				[label release];
				
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, height - 40.0f,self.frame.size.width, 20.0f)];
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
				
//				UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//				view.frame = CGRectMake(25.0f, height - 38.0f, 20.0f, 20.0f);
//				[self addSubview:view];
//				_activityView = view;
//				[view release];
			}
				break;
			case EGORefreshFooter:
			{
				height = 0;
				
//				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 15.0f, self.frame.size.width, 20.0f)];
//				label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//				label.font = [UIFont systemFontOfSize:12.0f];
//				label.textColor = textColor;
//				//label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//				//label.shadowOffset = CGSizeMake(0.0f, 1.0f);
//				label.backgroundColor = [UIColor clearColor];
//				label.textAlignment = NSTextAlignmentCenter;
//				[self addSubview:label];
//				_lastUpdatedLabel=label;
//				[label release];
				
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 15.0f,self.frame.size.width, 20.0f)];
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
				layer.frame = CGRectMake((self.frame.size.width/2)-70, 15.0f, 20.0f, 20.0f);
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
                loadingLayer.frame = CGRectMake((self.frame.size.width/2)-90, 15.0f, 20.0f, 20.0f);
                loadingLayer.contentsGravity = kCAGravityResizeAspect;
                loadingLayer.contents = (id)[UIImage imageNamed:@"round_refreshing.png"].CGImage;
                [[self layer] addSublayer:loadingLayer];
                _loadingImage = loadingLayer;
				
//				UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//				view.frame = CGRectMake(25.0f, 23.0f, 20.0f, 20.0f);
//				[self addSubview:view];
//				_activityView = view;
//				[view release];
			}
				break;
			default:
				break;
		}
		
		
		
		[self setState:EGOOPullRefreshNormal];
		
    }
	
    return self;
	
}

//add author:bruce date:2012-11-27
-(void) changeSize
{
	
}

- (id)initWithFrame:(CGRect)frame  {
  return [self initWithFrame:frame arrowImageName:@"dragrefresh_arrow.png" textColor:TEXT_COLOR];
}

- (id)initWithFrame:(CGRect)frame pos:(EGORefreshPos)pos{
	_pos = pos;

	switch ( _pos ) {
		case EGORefreshHeader:
			self = [self initWithFrame:frame arrowImageName:@"dragrefresh_arrow.png" textColor:TEXT_COLOR];
			break;
		case EGORefreshFooter:
			self = [self initWithFrame:frame arrowImageName:@"dragrefresh_arrow.png" textColor:TEXT_COLOR];
			break;
		default:
			break;
	}
	
	return self;
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceLastUpdated:)]) {
		
//		NSDate *date = [_delegate egoRefreshTableDataSourceLastUpdated:self];
//		
//		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
//		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
//		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];

//        if( self.frame.size.width <= 200 ){
//            _lastUpdatedLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
//        }else{
//            _lastUpdatedLabel.text = [NSString stringWithFormat:@"最近更新: %@", [dateFormatter stringFromDate:date]];
//        }
		
//		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
//		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
//		_lastUpdatedLabel.text = nil;
		
	}

}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
            _loadingImage.hidden = YES;
            _loadingImage.opacity = 0.0;
            [self stopLoadingAnimation];
			_statusLabel.text = NSLocalizedString(@"松开刷新...", @"Release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
            if (aState == _state) {
                break;
            }
            [self stopLoadingAnimation];
            _loadingImage.hidden = YES;
            _loadingImage.opacity = 0.0;
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
            if( _pos == EGORefreshFooter ){
                _statusLabel.text = NSLocalizedString(@"上拉加载...", @"Pull down to refresh status");
            }else if( _pos == EGORefreshHeader ){
                _statusLabel.text = NSLocalizedString(@"下拉刷新...", @"Pull down to refresh status");
            }
			
//			[_activityView stopAnimating];
            
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
//			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading:
            if(aState == _state)break;
			_loadingImage.hidden = NO;
            _loadingImage.opacity = 1.0;
			_statusLabel.text = NSLocalizedString(@"一览正在加载中...", @"Loading Status");
//			[_activityView startAnimating];
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


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOOPullRefreshLoading) {
			
		switch ( _pos ) {
			case EGORefreshHeader:
			{
				CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
				offset = MIN(offset, 60);
				scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
			}
				break;
			
			case EGORefreshFooter:
			{
				int height = 0;
				if( scrollView.contentSize.height - scrollView.frame.size.height > 0 ){
					height = scrollView.contentSize.height - scrollView.frame.size.height;
				}
				
				CGFloat offset = MAX( scrollView.contentOffset.y - height , 0);
				offset = MIN(offset, 60);
				scrollView.contentInset = UIEdgeInsetsMake(0, 0.0f,height + scrollView.frame.size.height - scrollView.contentSize.height + offset, 0.0f);
			}
				break;

			default:
				break;
		}
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableDataSourceIsLoading:self];
		}
		
		switch ( _pos ) {
			case EGORefreshHeader:
				if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -50.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
					[self setState:EGOOPullRefreshNormal];
				} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -50.0f && !_loading) {
					[self setState:EGOOPullRefreshPulling];
				}
				break;
			case EGORefreshFooter:
            {
                int height = 0;
                if( scrollView.contentSize.height - scrollView.frame.size.height > 0 ){
                    height = scrollView.contentSize.height - scrollView.frame.size.height;
                }

				if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y < height + 50.0f && scrollView.contentOffset.y > height && !_loading) {
					[self setState:EGOOPullRefreshNormal];
				} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y > height + 50.0f && !_loading) {
					[self setState:EGOOPullRefreshPulling];
				}
            }
				break;
			default:
				break;
		}

		
		if (scrollView.contentInset.top != 0 && _pos == EGORefreshHeader ) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		else if (scrollView.contentInset.bottom != 0 && _pos == EGORefreshFooter ) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableDataSourceIsLoading:self];
	}
	
	switch ( _pos ) {
		case EGORefreshHeader:
			if (scrollView.contentOffset.y <= - 50.0f && !_loading) {
				
				if ([_delegate respondsToSelector:@selector(egoRefreshTableDidTriggerRefresh:)]) {
					[_delegate egoRefreshTableDidTriggerRefresh:self];
				}
				
				[self setState:EGOOPullRefreshLoading];
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:0.2];
				scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
				[UIView commitAnimations];
				
			}
			break;
		case EGORefreshFooter:
		{
			int height = 0;
			if( scrollView.contentSize.height - scrollView.frame.size.height > 0 ){
				height = scrollView.contentSize.height - scrollView.frame.size.height;
			}
			
			if (scrollView.contentOffset.y >= height + 50.0f && !_loading) {
				
				if ([_delegate respondsToSelector:@selector(egoRefreshTableDidTriggerRefresh:)]) {
					[_delegate egoRefreshTableDidTriggerRefresh:self];
				}
				[self setState:EGOOPullRefreshLoading];
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:0.2];
				scrollView.contentInset = UIEdgeInsetsMake(0, 0.0f,height + scrollView.frame.size.height - scrollView.contentSize.height + 60, 0.0f);
				[UIView commitAnimations];
			}
		}
			break;
		default:
			break;
	}
	

	
}


//add author:bruce date:2012-08-17
-(void) refreshData:(UIScrollView *)scrollView
{
    if ([_delegate respondsToSelector:@selector(egoRefreshTableDidTriggerRefresh:)]) {
        [_delegate egoRefreshTableDidTriggerRefresh:self];
    }
    
    [self setState:EGOOPullRefreshLoading];
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.2];
    scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0, 0.0f);
    //[UIView commitAnimations];
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [scrollView setContentOffset:CGPointMake(0, -60) animated:NO];
    [UIView commitAnimations];
    
    
    //[scrollView setContentOffset:CGPointMake(0, -60) animated:YES];
}

//show header loading
-(void) showHeaderLoading:(UIScrollView *)scrollView;
{
	[self setState:EGOOPullRefreshLoading];
    scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0, 0.0f);    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [scrollView setContentOffset:CGPointMake(0, -60) animated:NO];
    [UIView commitAnimations];
}

//show footer loading
-(void) showFooterLoading:(UIScrollView *)scrollView;
{
	[self setState:EGOOPullRefreshLoading];

	int height = 0;
	if( scrollView.contentSize.height - scrollView.frame.size.height > 0 ){
		height = scrollView.contentSize.height - scrollView.frame.size.height;
	}
	scrollView.contentInset = UIEdgeInsetsMake(0, 0.0f,height + scrollView.frame.size.height - scrollView.contentSize.height + 60, 0.0f);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height + 60) animated:NO];
    [UIView commitAnimations];
}

//show footer loading
-(void) showFooterLoading2:(UIScrollView *)scrollView;
{
    [self setState:EGOOPullRefreshLoading];
    
    int height = 0;
    if( scrollView.contentSize.height - scrollView.frame.size.height > 0 ){
        height = scrollView.contentSize.height - scrollView.frame.size.height;
    }
    scrollView.contentInset = UIEdgeInsetsMake(0, 0.0f, 60, 0.0f);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height- scrollView.frame.size.height + 60) animated:NO];
    [UIView commitAnimations];
}

//是否正在加载
-(BOOL) isLoading
{
    return _state == EGOOPullRefreshLoading;
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
    switch ( _pos ) {
		case EGORefreshHeader:
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:.3];
            [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
            [UIView commitAnimations];
			break;
		case EGORefreshFooter:
		{
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:.3];
            [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
            [UIView commitAnimations];
		}
			break;
		default:
			break;
	}
    [self performSelector:@selector(delaySetRefreshNomal) withObject:nil afterDelay:0.3];
	
}

- (void)delaySetRefreshNomal
{
    [self setState:EGOOPullRefreshNormal];
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

//扩展:下拉显示加载
- (void)initLoading:(UIScrollView *)scrollView {
    scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
    scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -60);
    [self setState:EGOOPullRefreshLoading];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
//	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
    _loadingImage = nil;
//	_lastUpdatedLabel = nil;
    [super dealloc];
}


@end

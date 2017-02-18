//
//  A3VerticalSliderView.m
//  A3VerticalSliderViewSample
//
//  A3VerticalSliderView for iOS
//  Created by Botond Kis on 24.10.12.
//  Copyright (c) 2012 aaa - All About Apps
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
//
//      - Redistributions of source code must retain the above copyright notice, this list
//      of conditions and the following disclaimer.
//
//      - Redistributions in binary form must reproduce the above copyright notice, this list
//      of conditions and the following disclaimer in the documentation and/or other materials
//      provided with the distribution.
//
//      - Neither the name of the "aaa - All About Apps" nor the names of its contributors may be used
//      to endorse or promote products derived from this software without specific prior written
//      permission.
//
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
//  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//  NO DOUGHNUTS WHERE HARMED DURING THE CODING OF THIS CLASS. BUT CHEESECAKES
//  WHERE. IF YOU READ THIS YOU ARE EITHER BORED OR A LAWYER.


#import "A3VerticalSliderView.h"

@interface A3VerticalSliderView (){
    BOOL    _indicatorTouched;
    CGFloat _indicatorYOffset;
}

- (void)_init;
@end

@implementation A3VerticalSliderView


- (void)_init{
    // indicator view
    CGRect positionIndicatorFrame = self.bounds;
    positionIndicatorFrame.size.height = 80.0f;
    
    _positionIndicator = [[UIView alloc] initWithFrame:positionIndicatorFrame];
    [self addSubview:_positionIndicator];
    _positionIndicator.backgroundColor = [UIColor clearColor];
    
    _indicatorTouched = NO;
    _indicatorYOffset = 0.0f;
    
    // value
    _sliderValue = 0.0f;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}

- (void) dealloc{
    [_positionIndicator release];
    [_delegate release];
    
    [super dealloc];
}

- (void)setSliderValue:(CGFloat)aValue{
    [self setSliderValue:aValue animated:NO];
}

- (void)setSliderValue:(CGFloat)aValue animated:(BOOL)animated{
    // set value
    _sliderValue = aValue;
    
    // calc new frame
    CGFloat trueHeight = self.frame.size.height - self.positionIndicator.frame.size.height;
    
    CGRect newFrame = self.positionIndicator.frame;
    newFrame.origin.y = aValue*trueHeight;
    
    // call delegate
    if ([self.delegate respondsToSelector:@selector(A3VerticalSliderViewWillStartMoving:)]) {
        [self.delegate A3VerticalSliderViewWillStartMoving:self];
    }
    
    // set frame
    if (animated) {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.positionIndicator.frame = newFrame;
                         }
                         completion:^(BOOL finished) {
                             // call delegate
                             if ([self.delegate respondsToSelector:@selector(A3VerticalSliderViewDidStopMoving:)]) {
                                 [self.delegate A3VerticalSliderViewDidStopMoving:self];
                             }
                         }
         ];
    }else{
        self.positionIndicator.frame = newFrame;
        
        // call delegate
        if ([self.delegate respondsToSelector:@selector(A3VerticalSliderViewDidStopMoving:)]) {
            [self.delegate A3VerticalSliderViewDidStopMoving:self];
        }
    }
    
    // call delegate
    if ([self.delegate respondsToSelector:@selector(A3VerticalSliderViewDidChangeValue:)]) {
        [self.delegate A3VerticalSliderViewDidChangeValue:self];
    }
}


//=================================================================================
#pragma mark - peoperties
- (void)setPositionIndicator:(UIView *)indicatorView{
    CGRect origFrame = indicatorView.frame;
    origFrame.origin.y = _positionIndicator.frame.origin.y;
    indicatorView.frame = origFrame;
    
    [indicatorView retain];
    
    [_positionIndicator removeFromSuperview];
    [_positionIndicator release];
    
    _positionIndicator = indicatorView;
    
    [self addSubview:indicatorView];
}


//=================================================================================
#pragma mark - touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // get touch
    UITouch *touch = [touches anyObject];
    CGPoint touchCoord = [touch locationInView:self];
    
    // Touch inside indicator
    if (CGRectContainsPoint(self.positionIndicator.frame, touchCoord)) {
        _indicatorTouched = YES;
        
        CGPoint touchCoordInIndicator = [touch locationInView:self.positionIndicator];
        _indicatorYOffset = touchCoordInIndicator.y;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    _indicatorTouched = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // move indicator
    if (_indicatorTouched) {
        // get touch
        UITouch *touch = [touches anyObject];
        CGPoint touchCoord = [touch locationInView:self];
        
        // calc value
        CGFloat trueHeight = self.frame.size.height - self.positionIndicator.frame.size.height;
        touchCoord.y -= _indicatorYOffset;
        touchCoord.y = MIN(touchCoord.y, trueHeight);
        touchCoord.y = MAX(touchCoord.y, 0);
        
        // set value
        self.sliderValue = touchCoord.y/trueHeight;
        
        // call delegate
        if ([self.delegate respondsToSelector:@selector(A3VerticalSliderViewDidChangeValue:)]) {
            [self.delegate A3VerticalSliderViewDidChangeValue:self];
        }
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!_indicatorTouched) {
        // get touch
        UITouch *touch = [touches anyObject];
        CGPoint touchCoord = [touch locationInView:self];
        
        // calc value
        CGFloat trueHeight = self.frame.size.height - self.positionIndicator.frame.size.height;
        touchCoord.y = MIN(touchCoord.y, trueHeight);
        
        [self setSliderValue:touchCoord.y/trueHeight animated:YES];
    }
    
    _indicatorTouched = NO;
}

@end

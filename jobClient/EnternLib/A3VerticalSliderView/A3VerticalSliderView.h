//
//  A3VerticalSliderView.h
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


#import <UIKit/UIKit.h>
@class A3VerticalSliderView;


//=================================================================================
#pragma mark - Delegate
/*
 @description The Controller which acts as a delegate for a A3VerticalSliderView can implement methods to get notified of the slider changes its value.
 */

@protocol A3VerticalSliderViewDelegate <NSObject>
@optional
/**
 @param sliderView The sliderView which calls the delegate.
 @description Called when the sliderView was scrolled.
 */
- (void)A3VerticalSliderViewDidChangeValue:(A3VerticalSliderView *)sliderView;


/**
 @param sliderView The sliderView which calls the delegate.
 @description Called before the sliderView will scroll.
 */
- (void)A3VerticalSliderViewWillStartMoving:(A3VerticalSliderView *)sliderView;

/**
 @param sliderView The sliderView which calls the delegate.
 @description Called when the slider stoped moving.
 */
- (void)A3VerticalSliderViewDidStopMoving:(A3VerticalSliderView *)sliderView;

@end


//=================================================================================
#pragma mark - A3VerticalSliderView
@interface A3VerticalSliderView : UIView

/**
 @description The delegate of the Slider.
 */
@property (nonatomic, retain) id<A3VerticalSliderViewDelegate> delegate;

/**
 @description This is the draggable part of the Slider.
 */
@property (nonatomic, retain) UIView *positionIndicator;
- (void)setPositionIndicator:(UIView *)indicatorView;

/**
 @description Returns (or sets) the current value of the Slider. The value is between 0 and 1.
 */
@property (nonatomic, assign) CGFloat sliderValue;
- (void)setSliderValue:(CGFloat)aValue;
/**
 @description Sets the Slider value and animates the positionIndicator to the corresponding position
 */
- (void)setSliderValue:(CGFloat)aValue animated:(BOOL)animated;

@end

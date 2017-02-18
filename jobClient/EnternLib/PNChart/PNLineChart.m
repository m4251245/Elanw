//
//  PNLineChart.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNLineChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"

@implementation PNLineChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
		_chartLine = [CAShapeLayer layer];
		_chartLine.lineCap = kCALineCapRound;
		_chartLine.lineJoin = kCALineJoinBevel;
		_chartLine.fillColor   = [[UIColor whiteColor] CGColor];
		_chartLine.lineWidth   = 2.0;
		_chartLine.strokeEnd   = 0.0;
        
        
        UIView *line1 = [[UIView alloc]init];
        [line1 setBackgroundColor:[UIColor colorWithRed:112.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:1.0]];
        [line1 setFrame:CGRectMake(50, self.frame.size.height - 40.0, self.frame.size.width - 50.0, 1)];
        [self addSubview:line1];
        
        
        UIView *line2 = [[UIView alloc]init];
        [line2 setBackgroundColor:[UIColor colorWithRed:112.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:1.0]];
        [line2 setFrame:CGRectMake(50, 0, 1, self.frame.size.height - 40.0)];
        [self addSubview:line2];
        
        
		[self.layer addSublayer:_chartLine];
    }
    
    return self;
}


-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    for (NSString * valueString in yLabels) {
        NSInteger value = [valueString integerValue];
        if (value > max) {
            max = value;
        }
        
    }
    
    //Min value for Y label
    if (max < 5) {
        max = 5;
    }
    
    _yValueMax = (int)max;
    
    float level = max /5.0;
	
    NSInteger index = 0;
	NSInteger num = [yLabels count] + 1;
	while (num > 0) {
		CGFloat chartCavanHeight = self.frame.size.height - chartMargin * 2 - 40.0 ;
		CGFloat levelHeight = chartCavanHeight /5.0;
		PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight - index * levelHeight + (levelHeight - yLabelHeight) , 20.0, yLabelHeight)];
		[label setTextAlignment:NSTextAlignmentRight];
		label.text = [NSString stringWithFormat:@"%1.f",level * index];
//		[self addSubview:label];
        index +=1 ;
		num -= 1;
	}

}

-(void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    _xLabelWidth = (self.frame.size.width - chartMargin - 30.0 - ([xLabels count] -1) * xLabelMargin)/5.0;
    
    for (NSString * labelText in xLabels) {
        NSInteger index = [xLabels indexOfObject:labelText];
        PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(index * (xLabelMargin + _xLabelWidth) + 35.0 -10 , self.frame.size.height - 40.0, _xLabelWidth+10, 20.0)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        label.text = labelText;
        [self addSubview:label];
    }
    
}

-(void)setStrokeColor:(UIColor *)strokeColor
{
	_strokeColor = strokeColor;
	_chartLine.strokeColor = [strokeColor CGColor];
}

-(void)strokeChart
{
    
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    
//    CGFloat firstValue = [[_yValues objectAtIndex:0] floatValue];
    
    CGFloat xPosition = (xLabelMargin + _xLabelWidth)   ;
    
    CGFloat chartCavanHeight = self.frame.size.height - chartMargin * 2 - 40.0;
    
//    float grade = (float)firstValue / (float)_yValueMax;
//    [progressline moveToPoint:CGPointMake( xPosition-10, chartCavanHeight - grade * chartCavanHeight + 20.0)];
    
    [progressline setLineWidth:2.0];
    [progressline setLineCapStyle:kCGLineCapRound];
    [progressline setLineJoinStyle:kCGLineJoinRound];
    NSInteger index = 0;
    for (NSString * valueString in _yValues) {
        NSInteger value = [valueString integerValue];
        
        
        float grade = (float)value / (float)_yValueMax;
        if (index != 0) {
            
            [progressline addLineToPoint:CGPointMake(index * xPosition  + 30.0+ _xLabelWidth /2.0, chartCavanHeight - grade * chartCavanHeight + 20.0)];
            
            [progressline moveToPoint:CGPointMake(index * xPosition + 30.0 + _xLabelWidth /2.0, chartCavanHeight - grade * chartCavanHeight + 20.0 )];
            
            [progressline stroke];
            
            UILabel *label = [[UILabel alloc]init];
            [label setFrame:CGRectMake(0, 0, 40, 12)];
            [label setFont:[UIFont systemFontOfSize:11.0]];
            [label setTextColor:[UIColor colorWithRed:112.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:1.0]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setCenter:CGPointMake(index * xPosition  + 30.0+ _xLabelWidth /2.0, chartCavanHeight - grade * chartCavanHeight + 20.0 - 10)];
            [label setText:valueString];
            [label setBackgroundColor:[UIColor clearColor]];
            [self addSubview:label];
            
            UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
            [bt setBackgroundColor:PNREDCOLOR];
            bt.layer.cornerRadius=3;
            [bt setFrame:CGRectMake(0, 0, 6, 6)];
            [bt setCenter:CGPointMake(index * xPosition  + 30.0+ _xLabelWidth /2.0, chartCavanHeight - grade * chartCavanHeight + 20.0)];
            [self addSubview:bt];
            
        }
        
        index += 1;
    }
    
    _chartLine.path = progressline.CGPath;
	if (_strokeColor) {
		_chartLine.strokeColor = [_strokeColor CGColor];
	}else{
		_chartLine.strokeColor = [PNFreshGreen CGColor];
	}
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    _chartLine.strokeEnd = 1.0;
    
    
}



@end

//
//  EColumnChart.m
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import "EColumnChart.h"
#import "EColor.h"
#import "EColumnChartLabel.h"
#import "EFloatBox.h"
//#define BOTTOM_LINE_HEIGHT 1
//#define HORIZONTAL_LINE_HEIGHT 0.5
#define Y_COORDINATE_LABEL_WIDTH 30
#define DIRECTION  (_columnsIndexStartFromLeft? - 1 : 1)


@interface EColumnChart()

@property (strong, nonatomic) NSMutableDictionary *eColumns;
@property (strong, nonatomic) NSMutableDictionary *eLabels;
@property (strong, nonatomic) EColumn *fingerIsInThisEColumn;
@property (nonatomic) float fullValueOfTheGraph;

@end

@implementation EColumnChart
@synthesize columnsIndexStartFromLeft = _columnsIndexStartFromLeft;
@synthesize showHighAndLowColumnWithColor = _showHighAndLowColumnWithColor;
@synthesize fingerIsInThisEColumn = _fingerIsInThisEColumn;
@synthesize minColumnColor = _minColumnColor;
@synthesize maxColumnColor = _maxColumnColor;
@synthesize normalColumnColor = _normalColumnColor;
@synthesize eColumns = _eColumns;
@synthesize eLabels = _eLabels;
@synthesize leftMostIndex = _leftMostIndex;
@synthesize rightMostIndex = _rightMostIndex;
@synthesize showHorizontalLabelsWithInteger = _showHorizontalLabelsWithInteger;
@synthesize fullValueOfTheGraph = _fullValueOfTheGraph;
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;


#pragma -mark- Setter and Getter
- (void)setDelegate:(id<EColumnChartDelegate>)delegate
{
    if (_delegate != delegate)
    {
        _delegate = delegate;
        
        if (![_delegate respondsToSelector:@selector(eColumnChart: didSelectColumn:)])
        {
            NSLog(@"@selector(eColumnChart: didSelectColumn:) Not Implemented!");
            return;
        }
        
        if (![_delegate respondsToSelector:@selector(eColumnChart:fingerDidEnterColumn:)])
        {
            NSLog(@"@selector(eColumnChart:fingerDidEnterColumn:) Not Implemented!");
            return;
        }
        
        if (![_delegate respondsToSelector:@selector(eColumnChart:fingerDidLeaveColumn:)])
        {
            NSLog(@"@selector(eColumnChart:fingerDidLeaveColumn:) Not Implemented!");
            return;
        }
        
        if (![_delegate respondsToSelector:@selector(fingerDidLeaveEColumnChart:)])
        {
            NSLog(@"@selector(fingerDidLeaveEColumnChart:) Not Implemented!");
            return;
        }
    }
}

- (void)setDataSource:(id<EColumnChartDataSource>)dataSource
{
    if (_dataSource != dataSource)
    {
        _dataSource = dataSource;
        
        if (![_dataSource respondsToSelector:@selector(numberOfColumnsInEColumnChart:)])
        {
            NSLog(@"@selector(numberOfColumnsInEColumnChart:) Not Implemented!");
            return;
        }
        
        if (![_dataSource respondsToSelector:@selector(numberOfColumnsPresentedEveryTime:)])
        {
            NSLog(@"@selector(numberOfColumnsPresentedEveryTime:) Not Implemented!");
            return;
        }
        
        if (![_dataSource respondsToSelector:@selector(highestValueEColumnChart:)])
        {
            NSLog(@"@selector(highestValueEColumnChart:) Not Implemented!");
            return;
        }
        
        if (![_dataSource respondsToSelector:@selector(eColumnChart:valueForIndex:)])
        {
            NSLog(@"@selector(eColumnChart:valueForIndex:) Not Implemented!");
            return;
        }
        
        {
            NSInteger totalColumnsRequired = 0;
            totalColumnsRequired = [_dataSource numberOfColumnsPresentedEveryTime:self];
            NSInteger totalColumns = 0;
            totalColumns = [_dataSource numberOfColumnsInEColumnChart:self];
            /** Currently only support columns layout from right to left, WILL ADD OPTIONS LATER*/
            if (_columnsIndexStartFromLeft)
            {
                _leftMostIndex = 0;
                _rightMostIndex = _rightMostIndex + totalColumnsRequired - 1;
            }
            else
            {
                _rightMostIndex = 0;
                _leftMostIndex = _rightMostIndex + totalColumnsRequired - 1;
            }
            
            /** Start construct horizontal lines*/
            /** Start construct value labels for horizontal lines*/
            if (_showHorizontalLabelsWithInteger)
            {
                NSInteger valueGap = [_dataSource highestValueEColumnChart:self].value / 10 + 1;
                NSInteger horizontalLabelsCount = [_dataSource highestValueEColumnChart:self].value / valueGap + 1;
                float heightGap = self.frame.size.height / (float)horizontalLabelsCount;
                _fullValueOfTheGraph = valueGap * horizontalLabelsCount;
                for (NSInteger i = 0; i <= horizontalLabelsCount; i ++)
                {
                    //绘制水平的横线条
                    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, heightGap * i, self.frame.size.width, 0.5)];
                    horizontalLine.backgroundColor = ELightGrey;
                    
                    [self addSubview:horizontalLine];
                    //y 坐标的值
                    EColumnChartLabel *eColumnChartLabel = [[EColumnChartLabel alloc] initWithFrame:CGRectMake(-1 * Y_COORDINATE_LABEL_WIDTH, -heightGap / 2.0 + heightGap * i, Y_COORDINATE_LABEL_WIDTH, heightGap)];
                    [eColumnChartLabel setTextAlignment:NSTextAlignmentCenter];
                    NSInteger valueCoun = valueGap * (horizontalLabelsCount - i);
                    eColumnChartLabel.text = [[NSString stringWithFormat:@"%ld", (long)valueCoun] stringByAppendingString:[_dataSource highestValueEColumnChart:self].unit];;
                    [self addSubview:eColumnChartLabel];
                }
                
                
            }
            else
            {
                /** In order to leave some space for the heightest column */
                _fullValueOfTheGraph = [_dataSource highestValueEColumnChart:self].value * 1.1;
                float heightGap = self.frame.size.height / 5.0;
                float valueGap = _fullValueOfTheGraph / 5.0;
                for (int i = 0; i < 5; i++)
                {
                    //绘制水平的横线条
                    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, heightGap * i, self.frame.size.width, 0.5)];
                    UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
                    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
                    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
                    const CGFloat lengths[] = {2,1};
                    CGContextRef line = UIGraphicsGetCurrentContext();
                    CGContextSetStrokeColorWithColor(line, [UIColor whiteColor].CGColor);
                    CGContextSetLineDash(line, 0, lengths, 1);  //画虚线
                    CGContextMoveToPoint(line, 0.0, 0.0);    //开始画线
                    CGContextAddLineToPoint(line, self.frame.size.width - 20, 0.5);
                    CGContextStrokePath(line);
                    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
                    [self addSubview:imageView1];
                    //y 坐标的值
                    EColumnChartLabel *eColumnChartLabel = [[EColumnChartLabel alloc] initWithFrame:CGRectMake(-1 * Y_COORDINATE_LABEL_WIDTH, -heightGap / 2.0 + heightGap * i, Y_COORDINATE_LABEL_WIDTH, heightGap)];
                    [eColumnChartLabel setTextAlignment:NSTextAlignmentCenter];
                    [eColumnChartLabel setTextColor:[UIColor whiteColor]];
                    [eColumnChartLabel setAlpha:0.5];
                    eColumnChartLabel.text = [[NSString stringWithFormat:@"%.1f ", valueGap * (5 - i)] stringByAppendingString:[_dataSource highestValueEColumnChart:self].unit];;
                    
                    //eColumnChartLabel.backgroundColor = ELightBlue;
                    [self addSubview:eColumnChartLabel];
                }
            }
            
        }
        
        [self reloadData];
    }
}
- (void)setMaxColumnColor:(UIColor *)maxColumnColor
{
    _maxColumnColor = maxColumnColor;
    [self reloadData];
}

- (void)setMinColumnColor:(UIColor *)minColumnColor
{
    _minColumnColor = minColumnColor;
    [self reloadData];
}

- (void)setShowHighAndLowColumnWithColor:(BOOL)showHighAndLowColumnWithColor
{
    _showHighAndLowColumnWithColor = showHighAndLowColumnWithColor;
    [self reloadData];
}

- (void)setColumnsIndexStartFromLeft:(BOOL)columnsIndexStartFromLeft
{
    if (_dataSource)
    {
        NSLog(@"setColumnsIndexStartFromLeft Should Be Called Before Setting Datasource!");
        return;
    }
    _columnsIndexStartFromLeft = columnsIndexStartFromLeft;
}


#pragma -mark- Custom Methed
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        /** Should i release these two objects before self have been destroyed*/
        _eLabels = [NSMutableDictionary dictionary];
        _eColumns = [NSMutableDictionary dictionary];
        
        _chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[UIColor clearColor] CGColor];
        _chartLine.lineWidth   = 2.0;
        _chartLine.strokeEnd   = 0.0;

        [self.layer addSublayer:_chartLine];
        
        [self initData];
    }
    return self;
}



- (void)initData
{
    /** Initialize colors for max and min column*/
    _minColumnColor = EMinValueColor;
    _maxColumnColor = EMaxValueColor;
    _normalColumnColor = EGrey;
    _showHighAndLowColumnWithColor = YES;
}

- (void)reloadData
{
    if (nil == _dataSource)
    {
        NSLog(@"Important!! DataSource Not Set!");
        return;
    }
    
    NSInteger totalColumnsRequired = 0;
    totalColumnsRequired = [_dataSource numberOfColumnsPresentedEveryTime:self];
    
    float widthOfTheColumnShouldBe = self.frame.size.width / (float)(totalColumnsRequired + (totalColumnsRequired + 1) * 0.5);
    float minValue = 1000000.0;
    float maxValue = 0.0;
    NSInteger minIndex = 0;
    NSInteger maxIndex = 0;
    
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    [progressline setLineWidth:2.0];
    [progressline setLineCapStyle:kCGLineCapRound];
    [progressline setLineJoinStyle:kCGLineJoinRound];
    
    for (int i = 0; i < totalColumnsRequired; i++)
    {
        NSInteger currentIndex = _leftMostIndex - i * DIRECTION;
        EColumnDataModel *eColumnDataModel = [_dataSource eColumnChart:self valueForIndex:currentIndex];
        if (eColumnDataModel == nil)
            eColumnDataModel = [[EColumnDataModel alloc] init];
        /** Judge which is the max value and which is min, then set color correspondingly */
        if (eColumnDataModel.value > maxValue) {
            maxIndex =  currentIndex;
            maxValue = eColumnDataModel.value;
        }
        if (eColumnDataModel.value < minValue) {
            minIndex = currentIndex;
            minValue = eColumnDataModel.value;
        }
        
        /** Construct Columns*/
        //画列
        CGFloat pointY = (1-(eColumnDataModel.value/_fullValueOfTheGraph))*self.frame.size.height;
        if (isnan(pointY) ) {
            pointY = 0.2;
        }
        CGFloat pointX = widthOfTheColumnShouldBe + (i * widthOfTheColumnShouldBe * 1.5);
        if (i == 0) {
            [progressline moveToPoint:CGPointMake(pointX, pointY)];
        }else{
            [progressline addLineToPoint:CGPointMake(pointX, pointY)];
        }
        
        [progressline stroke];
        
        NSString *value = [NSString stringWithFormat:@"%.0f", eColumnDataModel.value ];
        EColumnChartLabel *label = [[EColumnChartLabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.bounds = CGRectMake(0, 0, 40, 20);
        label.center = CGPointMake(pointX, pointY -10);
        label.text = value;
        [self addSubview:label];
        
        UIImageView *bt = [[UIImageView alloc] init];
        [bt setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:97.0/255.0 blue:91.0/255.0 alpha:1.0]];
        bt.layer.borderWidth = 2.0;
        bt.layer.borderColor = [UIColor whiteColor].CGColor;
        bt.layer.cornerRadius=4;
        [bt setFrame:CGRectMake(0, 0, 8, 8)];
        [bt setCenter:CGPointMake(pointX, pointY)];
        
        [self addSubview:bt];
        
        /** Construct labels for corresponding columns */
        //x 的label
        EColumnChartLabel *eColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:(currentIndex)]];
        if (nil == eColumnChartLabel)
        {
            //间距是宽度的0.5
            eColumnChartLabel = [[EColumnChartLabel alloc] initWithFrame:CGRectMake(widthOfTheColumnShouldBe * 0.5 + (i * widthOfTheColumnShouldBe * 1.5) - 15, self.frame.size.height, widthOfTheColumnShouldBe+30, 20)];
            [eColumnChartLabel setTextColor:[UIColor whiteColor]];
//            [eColumnChartLabel setBackgroundColor:[UIColor yellowColor]];
            [eColumnChartLabel setAlpha:0.5];
            [eColumnChartLabel setTextAlignment:NSTextAlignmentCenter];
            eColumnChartLabel.text = eColumnDataModel.label;
            //eColumnChartLabel.backgroundColor = ELightBlue;
            [self addSubview:eColumnChartLabel];
            [_eLabels setObject:eColumnChartLabel forKey:[NSNumber numberWithInteger:(currentIndex)]];
            //旋转代码
            CGAffineTransform transform = eColumnChartLabel.transform;
            transform = CGAffineTransformRotate(transform, -0.5);
            eColumnChartLabel.transform = transform;
        }
    }
    
    //bg颜色渐变
    //    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    //    gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    //    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[[UIColor redColor] CGColor],(id)[[UIColor greenColor] CGColor], nil]];
    //    [gradientLayer setLocations:@[@0.5,@0.9,@1 ]];
    //    [gradientLayer setStartPoint:CGPointMake(0.5, 1)];
    //    [gradientLayer setEndPoint:CGPointMake(0.5, 0)];
    //    [self.layer insertSublayer:gradientLayer below:_chartLine ];
    //    _chartLine.backgroundColor = [UIColor clearColor].CGColor;
    
    _chartLine.path = progressline.CGPath;
//    _chartLine.strokeColor = [UIColor colorWithRed:77.0/255.0 green:196.0/255.0 blue:122.0/255.0 alpha:1.0f].CGColor;
    _chartLine.strokeColor = [UIColor whiteColor].CGColor;
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    _chartLine.strokeEnd = 1.0;
    
    if (_showHighAndLowColumnWithColor)
    {
        EColumn *eColumn = [_eColumns objectForKey: [NSNumber numberWithInteger: maxIndex]];
        eColumn.barColor = _maxColumnColor;
        eColumn = [_eColumns objectForKey: [NSNumber numberWithInteger: minIndex]];
        eColumn.barColor = _minColumnColor;
    }

     UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, 0, 1)];
     bottomLine.backgroundColor = [UIColor whiteColor];
    [bottomLine setAlpha:0.5];
     bottomLine.layer.cornerRadius = 1.0;
     [self addSubview:bottomLine];
     [bottomLine setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 1)];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(bottomLine.frame.origin.x, bottomLine.frame.origin.y - self.frame.size.height - 30 , 1, self.frame.size.height + 30)];
    leftLine.backgroundColor = [UIColor whiteColor];
    [leftLine setAlpha:0.5];
    leftLine.layer.cornerRadius = 1.0;
    [self addSubview:leftLine];
//    [bottomLine setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, BOTTOM_LINE_HEIGHT)];
    
}

- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}



- (void)moveLeft
{
    if (nil == _dataSource)
    {
        NSLog(@"Important!! DataSource Not Set!");
        return;
    }
    NSInteger index = _leftMostIndex + 1 * DIRECTION;
    EColumnDataModel *eColumnDataModel = [_dataSource eColumnChart:self valueForIndex:index];
    if (nil == eColumnDataModel) return;
    
    _leftMostIndex = _leftMostIndex + 1 * DIRECTION;
    _rightMostIndex = _rightMostIndex + 1 * DIRECTION;
    
    NSInteger totalColumnsRequired = [_dataSource numberOfColumnsInEColumnChart:self];
    for (int i = 0; i < totalColumnsRequired; i++)
    {
        EColumn *eColumn = [_eColumns objectForKey:[NSNumber numberWithInteger:_leftMostIndex - i * DIRECTION]];
        EColumn *nextEColumn = [_eColumns objectForKey:[NSNumber numberWithInteger:_leftMostIndex - (i + 1)  * DIRECTION]];
        EColumnChartLabel *eColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:_leftMostIndex - i * DIRECTION]];
        EColumnChartLabel *nextEColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:_leftMostIndex - (i + 1) * DIRECTION]];
        
        eColumnChartLabel.frame = nextEColumnChartLabel.frame;
        eColumn.frame = nextEColumn.frame;
    }
    
    [self reloadData];
}
- (void)moveRight
{
    if (nil == _dataSource)
    {
        NSLog(@"Important!! DataSource Not Set!");
        return;
    }
    NSInteger index = _rightMostIndex - 1 * DIRECTION;
    EColumnDataModel *eColumnDataModel = [_dataSource eColumnChart:self valueForIndex:index];
    if (nil == eColumnDataModel) return;
    
    _leftMostIndex = _leftMostIndex - 1 * DIRECTION;
    _rightMostIndex = _rightMostIndex - 1 * DIRECTION;
    
    NSInteger totalColumnsRequired = [_dataSource numberOfColumnsInEColumnChart:self];
    for (int i = 0; i < totalColumnsRequired; i++)
    {
        EColumn *eColumn = [_eColumns objectForKey:[NSNumber numberWithInteger:_rightMostIndex + i * DIRECTION]];
        EColumn *nextEColumn = [_eColumns objectForKey:[NSNumber numberWithInteger:_rightMostIndex + (i + 1) * DIRECTION]];
        EColumnChartLabel *eColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:_rightMostIndex + i * DIRECTION]];
        EColumnChartLabel *nextEColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:_rightMostIndex + (i + 1) * DIRECTION]];
        
        
        eColumnChartLabel.frame = nextEColumnChartLabel.frame;
        eColumn.frame = nextEColumn.frame;
        /** Do not inlclude animations at the moment*/
        //        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        //            eColumn.frame = nextEColumn.frame;
        //        } completion:nil];
        
    }
    
    [self reloadData];
}


#pragma -mark- EColumnDelegate
- (void)eColumnTaped:(EColumn *)eColumn
{
    [_delegate eColumnChart:self didSelectColumn:eColumn];
    [_delegate fingerDidLeaveEColumnChart:self];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma -mark- detect Gesture

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nil == _delegate) return;
    [_delegate fingerDidLeaveEColumnChart:self];
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    for (EColumn *view in _eColumns.objectEnumerator)
    {
        if(CGRectContainsPoint(view.frame, touchLocation))
        {
            [_delegate eColumnChart:self fingerDidLeaveColumn:view];
            _fingerIsInThisEColumn = nil;
            return;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nil == _delegate) return;
    UITouch *touch = [[event allTouches] anyObject];
    /** We do not want the coordinate system of the columns here,
     we need coordinate system of the Echart instead, so we use self*/
    //CGPoint touchLocation = [touch locationInView:touch.view];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (nil == _fingerIsInThisEColumn)
    {
        for (EColumn *view in _eColumns.objectEnumerator)
        {
            if(CGRectContainsPoint(view.frame, touchLocation) )
            {
                [_delegate eColumnChart:self fingerDidEnterColumn:view];
                _fingerIsInThisEColumn = view;
                return ;
            }
        }
    }
    if (_fingerIsInThisEColumn && !CGRectContainsPoint(_fingerIsInThisEColumn.frame, touchLocation))
    {
        [_delegate eColumnChart:self fingerDidLeaveColumn:_fingerIsInThisEColumn];
        _fingerIsInThisEColumn = nil;
    }
    
    return ;
}



@end

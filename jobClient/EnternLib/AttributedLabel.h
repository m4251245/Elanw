//
//  AttributedLabel.h
//  MobileOffice
//
//  Created by HuangJingbo on 13-12-10.
//  Copyright (c) 2013年 da zhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface AttributedLabel : UILabel
{
    NSMutableAttributedString *attributedString;
}

@property (nonatomic, retain)NSMutableAttributedString *attributedString;
@property (nonatomic, assign) NSInteger                 labelTag;

- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length;

- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length;

- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length;

@end

//
//  ELButtonView.m
//  ceshi
//
//  Created by 一览iOS on 16/11/11.
//  Copyright © 2016年 client. All rights reserved.
//

#import "ELButtonView.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ELButtonView()<UITextViewDelegate>
{
    TextSpecial *selectText;
}
@property (nonatomic, weak) UITextView *tv; 
@property (nonatomic, strong) NSMutableArray *specialSegments;
@property (nonatomic, strong) NSMutableArray *linkArr;
@property (nonatomic, strong) NSMutableArray *allArr;
@property (nonatomic, weak) UILabel *lable;

@end

@implementation ELButtonView

- (instancetype)initWithFrame:(CGRect)frame{  
    
    self = [super initWithFrame:frame];  
    if (self) {  
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        _lable = label;
        
        UITextView *tv = [[UITextView alloc] init];  
        
        // UITextView默认上面有20的内边距，应该修改textContainerInset  
        tv.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);  
        tv.editable = NO;  
        tv.scrollEnabled = NO;  
        tv.userInteractionEnabled = NO;   
        tv.backgroundColor = [UIColor clearColor];  
        tv.delegate = self;
        tv.alpha = 0.0;
        [self addSubview:tv];  
        _tv = tv;  
        self.specialSegments = [[NSMutableArray alloc] init];
        self.linkArr = [[NSMutableArray alloc] init];
        self.allArr = [[NSMutableArray alloc] init];
        self.showLink = NO;
        self.clipsToBounds = YES;
    }  
    return self;  
}  

-(instancetype)initWithTwoTypeFrame:(CGRect)frame{
    self = [super initWithFrame:frame];  
    if (self) {  
        UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];  
        // UITextView默认上面有20的内边距，应该修改textContainerInset  
        tv.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);  
        tv.editable = NO;  
        tv.scrollEnabled = NO;  
        tv.userInteractionEnabled = NO;   
        tv.backgroundColor = [UIColor clearColor];  
        tv.delegate = self;
        [self addSubview:tv];  
        _tv = tv;  
        self.specialSegments = [[NSMutableArray alloc] init];
        self.linkArr = [[NSMutableArray alloc] init];
        self.allArr = [[NSMutableArray alloc] init];
        self.showLink = NO;
        self.clipsToBounds = YES;
    }  
    return self; 
}

-(void)layoutFrame{
    [_tv sizeToFit];
    CGRect frameOne = [[_tv layoutManager] usedRectForTextContainer:[_tv textContainer]];   
    _tv.frame = frameOne;
    CGRect frame = self.frame;
    frame.size = frameOne.size;
    self.frame = frame;
}

-(void)setFrame:(CGRect)frame{
    super.frame = frame;
    _tv.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
    if (_lable) {
       _lable.frame = CGRectMake(0,0,frame.size.width,frame.size.height); 
    }
}

-(void)refreshClickWithArr:(NSArray <TextSpecial *>*)arr{
    [self.specialSegments removeAllObjects];
    [self.specialSegments addObjectsFromArray:arr];
}

- (void)setAttributedText:(NSAttributedString *)attributedText{ 
    NSMutableAttributedString *oldStr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    if (_showLink) {
        [self addLinkStatusWithString:oldStr];
    }
    _tv.attributedText = oldStr;
    if (_lable) {
        _lable.attributedText = oldStr;
        _lable.lineBreakMode = NSLineBreakByTruncatingTail;  
    }
}  

-(void)setContentColor:(UIColor *)contentColor{
    if (contentColor) {
        _tv.textColor = contentColor;
        if (_lable) {
            _lable.textColor = contentColor;
        }
    }
}

-(void)setContentFont:(UIFont *)contentFont{
    if (contentFont) {
        _tv.font = contentFont;
        if (_lable) {
            _lable.font = contentFont;
        }
    }
}

-(void)addLinkStatusWithString:(NSMutableAttributedString *)string
{
    [self.linkArr removeAllObjects];
    NSError *error;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string.string options:0 range:NSMakeRange(0, [string length])];
    
    UIColor *color = UIColorFromRGB(0x4570aa);
    if (_linkColor) {
        color = _linkColor;
    }
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        [string addAttribute:NSForegroundColorAttributeName value:color range:match.range];
        TextSpecial *text = [[TextSpecial alloc] init];
        text.range = match.range;
        text.isLink = YES;
        if (_selectLinkBackColor) {
            text.color = _selectLinkBackColor;
        }
        text.key = [string.string substringWithRange:match.range];
        [self.linkArr addObject:text];
    }
}

-(void)setNumberlines:(NSInteger)numberlines{
    _lable.numberOfLines = numberlines;
}

- (void)layoutSubviews{  
    
    [super layoutSubviews];  
    
    _tv.frame = self.bounds;  
}  

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{  
    
    CGPoint pt = [[touches anyObject] locationInView:self];  
    BOOL selected = NO;   
    for (TextSpecial *spec in self.linkArr){  
        selected = [self setTextSpecial:spec withPt:pt];
        if (selected) {
            break;
        }
    } 
    if (!selected) {
        for (TextSpecial *spec in self.specialSegments){  
            selected = [self setTextSpecial:spec withPt:pt];
            if (selected) {
                break;
            }
        } 
    }
} 

-(BOOL)setTextSpecial:(TextSpecial *)spec withPt:(CGPoint)pt
{
    BOOL selected = NO;
    self.tv.selectedRange = spec.range;  
    NSArray *rects = [self.tv selectionRectsForRange:self.tv.selectedTextRange];  
    self.tv.selectedRange = NSMakeRange(0, 0); // 重置选中范围，只是为了使用选中范围来获取rect而不是真的选中。  
    for (UITextSelectionRect *selectionRect in rects) {  
        CGRect rect = selectionRect.rect;  
        if (rect.size.width == 0 || rect.size.height == 0) 
        {
            continue;  
        }
        if (CGRectContainsPoint(rect, pt)) {  
            selected = YES;  
            break;  
        }  
    }  
    
    if (selected) {  
        if (spec.color) {
            for (UITextSelectionRect *selectionRect in rects){  
                CGRect rect = selectionRect.rect;  
                if (rect.size.width == 0 || rect.size.height == 0){
                    continue; 
                }  
                UIView *cover = [[UIView alloc] initWithFrame:rect];   
                cover.backgroundColor = spec.color;  
                cover.tag = 1001;  
                [self insertSubview:cover atIndex:0];  
            }
        }
        selectText = spec;  
    }  
    return selected;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{  
    // 为了能实现单击的响应，应该延时移除视图。  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{  
        for (UIView *view in self.subviews) {  
            if (view.tag == 1001) {  
                [view removeFromSuperview];  
            }  
        }  
        if (selectText){
            if (selectText.isLink){
                if ([_clickDelegate respondsToSelector:@selector(linkDelegateBtnRespone:)] && _linkCanClick) {
                    [_clickDelegate linkDelegateBtnRespone:selectText];
                }
            }else{
                if ([_clickDelegate respondsToSelector:@selector(clickDelegateWithModel:)]) { 
                    [_clickDelegate clickDelegateWithModel:selectText];
                }
            }
            selectText = nil;
        }
    });  
}  

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{  
    
    for (UIView *view in self.subviews) {  
        if (view.tag == 1001) {  
            [view removeFromSuperview];  
        }  
    }  
    selectText = nil;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{  
    [self.allArr removeAllObjects];
    if (self.linkArr.count > 0) {
        [self.allArr addObjectsFromArray:self.linkArr];
    }
    if (self.specialSegments.count > 0) {
        [self.allArr addObjectsFromArray:self.specialSegments];
    }
        
    for (TextSpecial *spec in self.allArr){  
        self.tv.selectedRange = spec.range;  
        NSArray *rects = [self.tv selectionRectsForRange:self.tv.selectedTextRange];  
        self.tv.selectedRange = NSMakeRange(0, 0); // 重置选中范围，只是为了使用选中范围来获取rect而不是真的选中。  
        for (UITextSelectionRect *selectionRect in rects) {  
            CGRect rect = selectionRect.rect;  
            if (rect.size.width == 0 || rect.size.height == 0) continue;  
            
            if (CGRectContainsPoint(rect, point)) {  
                return YES;  
            }  
        }  
    }  
    return NO;  
}

@end

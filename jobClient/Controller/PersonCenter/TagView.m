//
//  TagView.m
//  jobClient
//
//  Created by 一览ios on 15/2/25.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "TagView.h"
#import "personTagModel.h"
#import "CustomTagButton.h"
#import "MyConfig.h"
#import "NSString+Size.h"

#define BUTTON_TAG_OFFSET 100
#define MARGIN_LEFT 10
#define MARGIN_TOP 8

@interface TagView ()
{
    CGFloat lastX;
    CGFloat lastY;
}
@end

@implementation TagView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:240.f/250 green:240.f/250 blue:240.f/250 alpha:1.0];
    }
    return self;
}

- (void)setTagArray:(NSArray *)tagArray
{
    _tagArray = tagArray;
    lastX = MARGIN_LEFT;
    lastY = 16;
    for (int i=0; i<tagArray.count; i++) {
        personTagModel *tag = [_tagArray objectAtIndex:i];
        CustomTagButton *button = [[CustomTagButton alloc]init];
        [self addSubview:button];
        button.titleLabel.font = FOURTEENFONT_CONTENT;
        [button setTag:100+i];
        [button setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
        [self setButtonTitle:tag.tagName_ button:button];
        [button addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.contentSize = CGSizeMake(0, lastY+38+MARGIN_TOP*2);
}

-(void) setButtonTitle:(NSString *)title button:(UIButton*) button{
    CGSize titleSize = [title sizeNewWithFont:button.titleLabel.font];
    titleSize.height = 38;
    titleSize.width += 32;
    if (lastX + titleSize.width + MARGIN_LEFT> self.frame.size.width) {
        lastX = MARGIN_LEFT;
        lastY += titleSize.height + MARGIN_TOP;
    }
    [button setFrame:CGRectMake(lastX, lastY, titleSize.width, titleSize.height)];
    [button setTitle:title forState:UIControlStateNormal];
    lastX += titleSize.width + MARGIN_LEFT;
}

- (void)tagBtnClick:(UIButton *)sender
{
    NSInteger index = sender.tag-100;
//    [sender setBackgroundColor:[UIColor redColor]];
    personTagModel *tagModel = _tagArray[index];
    tagModel.buttonIndex = sender.tag;
    if (_clickBlock) {
        _clickBlock(tagModel);
    }
}

@end

//
//  CommentSubView.m
//  MBA
//
//  Created by sysweal on 13-11-20.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "CommentSubView.h"

@implementation CommentSubView

@synthesize contentView_,imgBtn_,nameLb_,dateLb_,contentLb_,indexLb_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//设置属性
-(void) setAtt:(BOOL) border
{
    //self.backgroundColor = [UIColor colorWithRed:255.0/255 green:248.0/255 blue:239.0/255 alpha:1.0];
    //self.backgroundColor = [UIColor colorWithRed:247.0/255 green:246.0/255 blue:234.0/255 alpha:1.0];
    
    if (border) {
        contentView_.backgroundColor = [UIColor clearColor];
        
        //设置圆角
        CALayer *layer=[self layer];
        [layer setMasksToBounds:YES];
        [layer setBorderWidth:1.0];
        [layer setBorderColor:[[UIColor colorWithRed:236.0/255 green:231.0/255 blue:209.0/255 alpha:1] CGColor]];
        //    [layer setBorderColor:[[UIColor colorWithRed:238.0/255 green:225.0/255 blue:216.0/255 alpha:1.0] CGColor]];
    }
    
}

@end

//
//  ELLableCustomView.m
//  jobClient
//
//  Created by 一览iOS on 16/9/9.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELLableCustomView.h"

@implementation ELLableCustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ELLableCustomView" owner:self options:nil] lastObject];
    if (self){
        self.addBackView.clipsToBounds = YES;
        self.addBackView.layer.cornerRadius = 4.0;
    }
    return self;
}

@end

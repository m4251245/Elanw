//
//  ELNoDataShowView.m
//  jobClient
//
//  Created by 一览iOS on 16/8/4.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELNoDataShowView.h"

@implementation ELNoDataShowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ELNoDataShowView" owner:self options:nil] lastObject];
    if (self) {
        self.attentionButton.clipsToBounds = YES;
        self.attentionButton.layer.cornerRadius = 4.0;
    }
    return self;
}

@end

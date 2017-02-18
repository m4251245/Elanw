//
//  CHRRecommandReasonCtl.m
//  jobClient
//
//  Created by 一览ios on 15/12/9.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "CHRRecommandReasonCtl.h"

@interface CHRRecommandReasonCtl ()

@end

@implementation CHRRecommandReasonCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.title = @"推荐理由";
    [self setNavTitle:@"推荐理由"];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, ScreenWidth-40, 0)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = [NSString stringWithFormat:@"    %@",_commentContent];
    CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)];
    label.frame = CGRectMake(20, 0, ScreenWidth-40, size.height);
    label.font = [UIFont systemFontOfSize:14];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

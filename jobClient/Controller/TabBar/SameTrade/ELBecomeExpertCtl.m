//
//  ELBecomeExpertCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/9/18.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELBecomeExpertCtl.h"
#import "ELBecomeExpertFirstCtl.h"
#import "ELBecomeExpertTwoCtl.h"
#import "ELExpertCourseListCtl.h"
#import "ELBecomeExpertIntroCtl.h"

@interface ELBecomeExpertCtl ()
{

    IBOutlet UIButton *becomeExpertBtn;
    ELRequest *elRequest;
}
@end

@implementation ELBecomeExpertCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.title = @"申请成为行家";
    [self setNavTitle:@"申请成为行家"];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20,34,ScreenWidth-40,(ScreenWidth-40)*41/64)];
    image.image = [UIImage imageNamed:@"img_applyfor_hangjia"];
    [self.view addSubview:image];
    
    NSMutableParagraphStyle *paragraphStyleOne = [[NSMutableParagraphStyle alloc] init];
    paragraphStyleOne.lineSpacing = 5;
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName:paragraphStyleOne,
                                 NSForegroundColorAttributeName:UIColorFromRGB(0x212121),
                                 NSFontAttributeName:[UIFont systemFontOfSize:17],
                                 };
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"申请成为一览行家，分享你行业领域内的知识与见解，为他人解答职场困惑！" attributes:attributes];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(image.frame)+36,ScreenWidth-60,0)];
    label.numberOfLines = 0;
    [label setAttributedText:str];
    [label sizeToFit];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(20,CGRectGetMaxY(image.frame)+36,ScreenWidth-40,label.frame.size.height);
    [self.view addSubview:label];
    
    becomeExpertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    becomeExpertBtn.frame = CGRectMake(46,CGRectGetMaxY(label.frame)+29,ScreenWidth-92,39);
    [becomeExpertBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    becomeExpertBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [becomeExpertBtn setBackgroundColor:UIColorFromRGB(0xe13e3e)];
    becomeExpertBtn.clipsToBounds = YES;
    becomeExpertBtn.layer.cornerRadius = 4.0;
    [becomeExpertBtn addTarget:self action:@selector(expertBtnRespone:) forControlEvents:UIControlEventTouchUpInside];
    becomeExpertBtn.userInteractionEnabled = NO;
    [self.view addSubview:becomeExpertBtn];
    
    [[self getNoNetworkView] removeFromSuperview];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"button_question_hangjia"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0,0,25,40);
    [rightButton addTarget:self action:@selector(rightButtonRespone:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -6;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightNavigationItem];
    
    [self creatRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatRequest) name:@"ELBECOMEEXPERTSTATUSREFRESH" object:nil];
}

-(void)rightButtonRespone:(UIButton *)sender{
    ELBecomeExpertIntroCtl *ctl = [[ELBecomeExpertIntroCtl alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationItem.title = @"";
}

-(void)creatRequest
{
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@",[Manager getUserInfo].userId_];
    NSString * function = @"getExpertStatus";
    NSString * op = @"zd_ask_question_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
    {
        NSDictionary *dic = result;
        NSString *code = dic[@"code"];
        if ([code isEqualToString:@"200"])
        {
            [Manager getUserInfo].isExpert_ = YES;
            [becomeExpertBtn setTitle:@"添加约谈" forState:UIControlStateNormal];
            becomeExpertBtn.userInteractionEnabled = YES;
            [becomeExpertBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else if ([code isEqualToString:@"202"])
        {
            [becomeExpertBtn setTitle:@"正在审核中..." forState:UIControlStateNormal];
            becomeExpertBtn.userInteractionEnabled = NO;
            [becomeExpertBtn setTitleColor:UIColorFromRGB(0xea8a8a) forState:UIControlStateNormal];
        }
        else
        {
            [becomeExpertBtn setTitle:@"申请成为行家" forState:UIControlStateNormal];
            becomeExpertBtn.userInteractionEnabled = YES;
            [becomeExpertBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (void)expertBtnRespone:(UIButton *)sender
{
    if (sender == becomeExpertBtn){
        if ([Manager getUserInfo].isExpert_) {
            ELExpertCourseListCtl *CourseListCtl = [[ELExpertCourseListCtl alloc] init];
            [self.navigationController pushViewController:CourseListCtl animated:YES];
            [CourseListCtl beginLoad:nil exParam:nil];
            return;
        }
        ELBecomeExpertFirstCtl *expertCtl = [[ELBecomeExpertFirstCtl alloc] init];
        [self.navigationController pushViewController:expertCtl animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  BigImgCtl.m
//  jobClient
//
//  Created by YL1001 on 14-7-10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BigImgCtl.h"


@interface BigImgCtl ()

@end

@implementation BigImgCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationController.navigationBarHidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateCom:(RequestCon *)con
{
    @try {
        NSInteger index = [MyCommon IndexOfContainingString:@"," FromString:wh_ type:YES];
        width_ = [[wh_ substringToIndex:index] floatValue];
        height_ = [[wh_ substringFromIndex:index] floatValue];
    }
    @catch (NSException *exception) {
        width_ = 500;
        height_ = 800;
    }
    @finally {
        
    }
    
    [imgView_ setFrame:CGRectMake(0, 0, width_, height_)];
    [scrollView_ setContentSize:CGSizeMake(width_, height_)];
    
    [imgView_ sd_setImageWithURL:[NSURL URLWithString:imgUrl_] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
}


-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    imgUrl_ = dataModal;
    wh_     = exParam;
    [self updateCom:nil];
}

-(void)btnResponse:(id)sender
{
    if (sender == backBtn_) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}
@end

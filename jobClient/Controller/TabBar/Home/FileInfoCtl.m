//
//  FileInfoCtl.m
//  jobClient
//
//  Created by YL1001 on 14-7-10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "FileInfoCtl.h"

@interface FileInfoCtl ()
{
    BOOL   imgStatus_;
}

@end

@implementation FileInfoCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        rightNavBarStr_ = @"分享";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView_.delegate = self;
    scrollView_.pagingEnabled = YES;
    errorLb_.alpha = 0.0;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置右按扭的属性
-(void) setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"" forState:UIControlStateNormal];
    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if( [rightNavBarStr_ length] >= 4 ){
        [rightBarBtn_ setFrame:CGRectMake(0, 0, 40, 40)];
    }else
        [rightBarBtn_ setFrame:CGRectMake(0, 0, 40, 40)];
    
    rightBarBtn_.titleLabel.font = [UIFont boldSystemFontOfSize:13];//[UIFont boldSystemFontOfSize:14];
    
    
    [rightBarBtn_ setImage:[UIImage imageNamed:@"share_white-2"] forState:UIControlStateNormal];
    //[rightBarBtn_ setBackgroundImage:[UIImage imageNamed:@"icon_share_off"] forState:UIControlStateHighlighted];
}


-(void)updateCom:(RequestCon *)con
{
    if (myModal_) {
        if (myModal_.fileImg_ && ![myModal_.fileImg_ isEqualToString:@""]) {
            
            imgViewArr_ = [[NSMutableArray alloc] init];
            errorLb_.alpha = 0.0;
            [pagesLb_ setText:[NSString stringWithFormat:@"1/%ld",(long)myModal_.filePages_]];
            [scrollView_ setContentSize:CGSizeMake(self.view.frame.size.width * myModal_.filePages_, 1)];
            
            for (int i = 0; i < myModal_.filePages_; ++i ) {
                UIImageView * imgview = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * i, self.view.frame.origin.y , scrollView_.frame.size.width, scrollView_.frame.size.height)];
                imgview.userInteractionEnabled = YES;
                imgview.tag = i+1;
                [imgview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTab:)]];
                //替换下标获取图片地址
                NSMutableString * str = [[NSMutableString alloc] initWithString:myModal_.fileImg_];
                NSRange rang;
                rang.location = 0;
                rang.length = [str length];
                [str replaceOccurrencesOfString:@"_1" withString:[NSString stringWithFormat:@"_%d",i+1] options:NSCaseInsensitiveSearch range:rang];
                [imgview sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
                [imgViewArr_ addObject:imgview];
                [scrollView_ addSubview:imgview];
            }
        }
        else{
           [scrollView_ setContentSize:CGSizeMake(1, 1)];
            errorLb_.alpha = 1.0;
        }
        
    }
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    inModal_ = dataModal;
//    self.navigationItem.title = inModal_.title_;
    [self setNavTitle:inModal_.title_];
    [scrollView_ setContentSize:CGSizeMake(self.view.frame.size.width, 1)];
    myModal_ = nil;
    imgViewArr_ = nil;
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    [con getArticleFileInfo:inModal_.id_];
}


-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetArticleFileInfo:
        {
            myModal_ = [dataArr objectAtIndex:0];
            
        }
            break;
            
        default:
            break;
    }
}


-(void)backBarBtnResponse:(id)sender
{
    if ([imgViewArr_ count] > 0 ) {
        for (UIImageView * imgView in imgViewArr_) {
            [imgView removeFromSuperview];
        }
    }
    
    [super backBarBtnResponse:sender];
}

#pragma UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView_.contentOffset.x/scrollView_.frame.size.width+1;
    [pagesLb_ setText:[NSString stringWithFormat:@"%d/%ld",page,(long)myModal_.filePages_]];
}


-(void)viewTab:(id)sender
{
    
    UITapGestureRecognizer * ges = sender;
    UIImageView * imgView = (UIImageView*)ges.view;
    NSMutableString * str = [[NSMutableString alloc] initWithString:myModal_.fileImg_];
    NSRange rang;
    rang.location = 0;
    rang.length = [str length];
    [str replaceOccurrencesOfString:@"_1" withString:[NSString stringWithFormat:@"_%ld",(long)imgView.tag] options:NSCaseInsensitiveSearch range:rang];
    if (!bigImgCtl_) {
        bigImgCtl_ = [[BigImgCtl alloc] init];
    }
    [self.navigationController presentViewController:bigImgCtl_ animated:YES completion:^{}];
    [bigImgCtl_ beginLoad:str exParam:myModal_.fileWH_];
}


-(void)rightBarBtnResponse:(id)sender
{
    NSString *imagePath = inModal_.thum_;
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
    
    NSString * sharecontent = inModal_.summary_;
    
    NSString * titlecontent = [NSString stringWithFormat:@"%@",inModal_.title_];
    
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/article/%@.htm",inModal_.id_];
    
    //调用分享
    [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url];
}

@end

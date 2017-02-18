//
//  Xjh_ZphDetailCtl.m
//  Association
//
//  Created by 一览iOS on 14-3-19.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "Xjh_ZphDetailCtl.h"

@interface Xjh_ZphDetailCtl ()

@end

@implementation Xjh_ZphDetailCtl


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rightNavBarStr_ = @"分享";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    webView_.delegate = self;
    webView_.userInteractionEnabled = NO;
    
    //设置圆角
    CALayer *layer=[detailView_ layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1.0];
    [layer setCornerRadius:4.0];
    [layer setBorderColor:[[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1] CGColor]];
    
    //设置圆角
    layer=[contentView_ layer];
    [layer setMasksToBounds:NO];
    [layer setBorderWidth:1.0];
    [layer setCornerRadius:4.0];
    [layer setBorderColor:[[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1] CGColor]];
    
    //设置scrollView_
    [scrollView_ setContentSize:CGSizeMake(scrollView_.frame.size.width, scrollView_.frame.size.height+1)];
    
    //恢复webView的大小
    CGRect frame = webView_.frame;
    webView_.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 97);
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
    [super updateCom:con];
    
    if (myModal_) {
        titleLb_.text = myModal_.title_;
        if(!myModal_.companyName_||[myModal_.companyName_ isEqualToString:@""])
        {
            [cnameBtn_ setTitle:@"暂无" forState:UIControlStateNormal];
        }
        else
            [cnameBtn_ setTitle:myModal_.companyName_ forState:UIControlStateNormal];
        if(!myModal_.datetiome_||[myModal_.datetiome_ isEqualToString:@""])
        {
            sdateLb_.text = @"暂无";
        }
        else
            sdateLb_.text = myModal_.datetiome_;
        if(!myModal_.schoolName_||[myModal_.schoolName_ isEqualToString:@""])
        {
            [snameBtn_ setTitle:@"暂无" forState:UIControlStateNormal];
        }
        else
            [snameBtn_ setTitle:myModal_.schoolName_ forState:UIControlStateNormal];
        if(!myModal_.address_||[myModal_.address_ isEqualToString:@""])
        {
            addrLb_.text = @"暂无";
        }
        else
            addrLb_.text = myModal_.address_;
        
        if (!myModal_.introduce_||[myModal_.introduce_ isEqualToString:@""]) {
            [webView_ loadHTMLString:@"暂无" baseURL:nil];
        }
        else
            [webView_ loadHTMLString:myModal_.introduce_ baseURL:nil];
    }
    
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    inModal_ = dataModal;
    myModal_ = nil;
    
    if (inModal_.type_ == 1) {
//        self.navigationItem.title = @"招聘会详情";
        [self setNavTitle:@"招聘会详情"];
    }
    else if(inModal_.type_ == 2)
    {
//       self.navigationItem.title = @"宣讲会详情";
        [self setNavTitle:@"宣讲会详情"];
    }

    
    //恢复webView的大小
    CGRect frame = webView_.frame;
    webView_.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 60);
    
    //恢复detailView
    CGRect rect = detailView_.frame;
    detailView_.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, webView_.frame.origin.y + webView_.frame.size.height);
    [super beginLoad:dataModal exParam:exParam];
    
}

-(void)getDataFunction:(RequestCon *)con
{
    if (inModal_.type_ == 1) {
        [con getZphDetail:inModal_.id_];
    }
    else if(inModal_.type_ == 2)
    {
        [con getXjhDetail:inModal_.id_ personId:[Manager getUserInfo].userId_];
    }
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_ZphDetail:
        {
            myModal_ = [dataArr objectAtIndex:0];
        }
            
            break;
        case Request_XjhDetail:
        {
            myModal_ = [dataArr objectAtIndex:0];
        }
            break;
            
        default:
            break;
    }
}

#pragma UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue] + 5;
    height = height > 64? height : 64;
    
    CGRect rect = webView.frame;
    rect.size.height = height;
    [webView setFrame:rect];
    
    //设置scrollView的contentSize
    CGSize mySize = scrollView_.frame.size;
    mySize.height = detailView_.frame.origin.y + webView.frame.origin.y + webView.frame.size.height + 15 > 416 ? detailView_.frame.origin.y + webView.frame.origin.y + webView.frame.size.height + 15 : 417;
    [scrollView_ setContentSize:mySize];
    
    //调整detailView_大小
    rect = detailView_.frame;
    rect.size.height = webView.frame.origin.y + webView.frame.size.height ;
    [detailView_ setFrame:rect];
}


-(void)rightBarBtnResponse:(id)sender
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1024" ofType:@"png"];
    
    NSString * sharecontent = myModal_.introduce_;
    
    NSString * titlecontent = [NSString stringWithFormat:@"%@",myModal_.title_];
    
    sharecontent = [sharecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    titlecontent = [titlecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString * url = [NSString stringWithFormat:@"http://m.job1001.com/xjh/detail/%@.htm",inModal_.id_];
    if (inModal_.type_ == 1) {
        url = [NSString stringWithFormat:@"http://m.job1001.com/zph/detail/%@.htm",inModal_.id_];
    }
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    //调用分享
    [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url];
    
}


@end

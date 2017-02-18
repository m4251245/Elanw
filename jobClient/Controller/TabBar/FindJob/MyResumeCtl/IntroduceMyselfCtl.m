//
//  IntroduceMyselfCtl.m
//  jobClient
//
//  Created by 一览ios on 16/1/16.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "IntroduceMyselfCtl.h"
#import "BaseUIViewController.h"
@interface IntroduceMyselfCtl ()
{
    __weak IBOutlet UILabel *_wordsNumLb;
    RequestCon                   *personDetailCon;
}
@property(nonatomic,copy) NSString *introStr;
@end

@implementation IntroduceMyselfCtl

-(id) init
{
    self = [self initWithNibName:@"IntroduceMyselfCtl" bundle:nil];
    
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"自我评价";
    [self setNavTitle:@"自我评价"];
    //设置代理
    desTv_.delegate = self;
    
    [self updateComInfo:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gest:)];
    [self.view addGestureRecognizer:tap];
    
    saveBtn_.layer.cornerRadius = 3;
    saveBtn_.layer.masksToBounds = YES;
    saveBtn_.titleLabel.font = [UIFont systemFontOfSize:16];
    
    scrollView_.backgroundColor = UIColorFromRGB(0xf0f0f0);
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam{
    _introStr = dataModal;
}

-(void)gest:(UIGestureRecognizer *)sender
{
    [desTv_ resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated{
    scrollView_.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 100);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    [MyCommon dealLabNumWithTipLb:grayWordLb numLb:_wordsNumLb textView:desTv_ wordsNum:1000];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        grayWordLb.hidden = NO;
    }
    return YES;
}

//让有焦点的控件失去焦点
-(void) comResignFirstResponse
{
    [grayWordLb setHidden:YES];
    [desTv_ resignFirstResponder];
}

//更新控件上的值
-(void) updateComInfo:(PreRequestCon *)con
{
    [super updateComInfo:con];
    
    if(_introStr.length > 0)
    {
        grayWordLb.hidden = YES;
        desTv_.text = _introStr;
    }else
    {
        grayWordLb.hidden = NO;
        desTv_.text = @"";
    }
    [self textViewDidChange:desTv_];
}

-(void) getDataFunction
{
    //不用载入数据
    loadStats_ = FinishLoad;
}

//检查是否能保存
-(BOOL) checkCanSave
{
    if( [PreCommon checkStringIsNull:[desTv_.text UTF8String]] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请您输入自我评价"    delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
        
        desTv_.text = @"";
        return NO;
    }
    
    return YES;
}

//保存数据
-(void) saveResume
{
    [super saveResume];
    
    des_ = nil;
    des_ = desTv_.text;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:@"grzz" forKey:@"columnName"];
    [dic setObject:des_ forKey:@"columnValue"];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:dic];
    
    NSString *whereId = [NSString stringWithFormat:@"id=%@",[Manager getUserInfo].userId_];
    
    [dict setObject:[Manager getUserInfo].userId_ forKey:@"personId"];
    [dict setObject: array forKey:@"update"];
    [dict setObject: whereId forKey:@"where"];
    
    NSString *searchStr = [jsonWrite stringWithObject:dict];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"param=%@",searchStr];
    NSString *op = @"person_info_busi";
    NSString *func = @"updatePersonDetail";
    [BaseUIViewController showLoadView:YES content:nil view:nil];
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        [BaseUIViewController showLoadView:NO content:nil view:nil];
        if ([dic[@"status"] isEqualToString:@"OK"]) {
            [BaseUIViewController showAutoDismissSucessView:nil msg:@"保存成功"];
            if (self.backBlock) {
                self.backBlock(personDetailInfoDataModal);
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];
}

-(void) buttonResponse:(id)sender
{
    //保存
    if( sender == saveBtn_ )
    {
        [self saveResume];
    }
}

@end

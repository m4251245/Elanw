//
//  BaseResumeCtl.m
//  jobClient
//
//  Created by job1001 job1001 on 12-2-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseResumeCtl.h"
#import "PreCommon.h"
#import "KeyboardReturnCtl.h"

//简历修改中的导航是否被初始化,所有的子类共用
static BOOL             bHaveInitResumeNav  = NO;
static ResumeNavCtl     *resumeNavCtl_;

//为了节约内存,暂时用全局变量
static KeyboardReturnCtl    *keyboardReturnCtl;

@implementation ResumeNavCtl

@synthesize delegate_;
@synthesize currentNavIndex_;
@synthesize preNavIndex_;

-(id) init
{
    self = [self initWithNibName:@"ResumeNavCtl" bundle:nil];
    
    hightImage_             = [UIImage imageNamed:@"icon_bchoosend.png"];
    
    if( !keyboardReturnCtl )
    {
        keyboardReturnCtl = [[KeyboardReturnCtl alloc] init];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    //设置scrollViw相关属性
    CGRect selfRect = scrollView_.frame;
    [scrollView_ setContentSize:selfRect.size];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(NSString *) getBGName
{
    return nil;
}

//获取当前的索引
-(int) getNavIndex
{
    return currentNavIndex_;
}

//获取之前操作的索引(不能用currentNavIndex_ -1)
-(int) getPreNavIndex
{
    return preNavIndex_;
}

//获取之后的索引
-(int) getNextNavIndex
{
    return currentNavIndex_+1;
}

//设置当前的索引
-(void) setNavIndex:(int)index
{
    preNavIndex_ = currentNavIndex_;
    currentNavIndex_ = index;
    
    [self changeNavBtnStatus];
}

//修改当前选中的导航按扭状态
-(void) changeNavBtnStatus
{
    [baseInfoBtn_ setImage:[UIImage imageNamed:@"btn_personInfo_off.png"] forState:UIControlStateNormal];
    [wantJobBtn_ setImage:[UIImage imageNamed:@"btn_wantJob_off.png"] forState:UIControlStateNormal];
    [eduBtn_ setImage:[UIImage imageNamed:@"btn_edu_off.png"] forState:UIControlStateNormal];
    [worksBtn_ setImage:[UIImage imageNamed:@"btn_work_off.png"] forState:UIControlStateNormal];
    [skillBtn_ setImage:[UIImage imageNamed:@"btn_skill_off.png"] forState:UIControlStateNormal];
    [cerBtn_ setImage:[UIImage imageNamed:@"btn_cer_off.png"] forState:UIControlStateNormal];
    [studentAwardBtn_ setImage:[UIImage imageNamed:@"btn_award_off.png"] forState:UIControlStateNormal];
    [studentLeaderBtn_ setImage:[UIImage imageNamed:@"btn_leader_off.png"] forState:UIControlStateNormal];
    [studentProjectBtn_ setImage:[UIImage imageNamed:@"btn_project_off.png"] forState:UIControlStateNormal];
    
    
    [baseInfoBtn_ setBackgroundImage:nil forState:UIControlStateNormal];
    [wantJobBtn_ setBackgroundImage:nil forState:UIControlStateNormal];
    [eduBtn_ setBackgroundImage:nil forState:UIControlStateNormal];
    [worksBtn_ setBackgroundImage:nil forState:UIControlStateNormal];
    [skillBtn_ setBackgroundImage:nil forState:UIControlStateNormal];
    [cerBtn_ setBackgroundImage:nil forState:UIControlStateNormal];
    [studentAwardBtn_ setBackgroundImage:nil forState:UIControlStateNormal];
    [studentLeaderBtn_ setBackgroundImage:nil forState:UIControlStateNormal];
    [studentProjectBtn_ setBackgroundImage:nil forState:UIControlStateNormal];
    
    switch ( currentNavIndex_ ) {
            
        case BaseResumeInfo:
        {            

            [baseInfoBtn_ setImage:[UIImage imageNamed:@"btn_personInfo_on.png"] forState:UIControlStateNormal];

            [scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
            
            CGRect rect = lineView_.frame;
            rect.origin.x = baseInfoBtn_.frame.size.width - lineView_.frame.size.width;
            rect.origin.y = baseInfoBtn_.frame.origin.y;
            [lineView_ setFrame:rect];
            
            rect = rowImageView_.frame;
            rect.origin.x = lineView_.frame.origin.x - rowImageView_.frame.size.width;
            rect.origin.y = lineView_.frame.origin.y + (int)((lineView_.frame.size.height - rowImageView_.frame.size.height)/2.0);
            [rowImageView_ setFrame:rect];
        }
            break;
        case WantResumeJob:
        {
            [wantJobBtn_ setImage:[UIImage imageNamed:@"btn_wantJob_on.png"] forState:UIControlStateNormal];
            [scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
            
            CGRect rect = lineView_.frame;
            rect.origin.x = wantJobBtn_.frame.size.width - lineView_.frame.size.width;
            rect.origin.y = wantJobBtn_.frame.origin.y;
            [lineView_ setFrame:rect];
            
            rect = rowImageView_.frame;
            rect.origin.x = lineView_.frame.origin.x - rowImageView_.frame.size.width;
            rect.origin.y = lineView_.frame.origin.y + (int)((lineView_.frame.size.height - rowImageView_.frame.size.height)/2.0);
            [rowImageView_ setFrame:rect];
        }
            break;
        case EduResume:
        {
            [eduBtn_ setImage:[UIImage imageNamed:@"btn_edu_on.png"] forState:UIControlStateNormal];
            [scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
            
            CGRect rect = lineView_.frame;
            rect.origin.x = eduBtn_.frame.size.width - lineView_.frame.size.width;
            rect.origin.y = eduBtn_.frame.origin.y;
            [lineView_ setFrame:rect];
            
            rect = rowImageView_.frame;
            rect.origin.x = lineView_.frame.origin.x - rowImageView_.frame.size.width;
            rect.origin.y = lineView_.frame.origin.y + (int)((lineView_.frame.size.height - rowImageView_.frame.size.height)/2.0);
            [rowImageView_ setFrame:rect];
        }
            break;
        case WorksResume:
        {
            [worksBtn_ setImage:[UIImage imageNamed:@"btn_work_on.png"] forState:UIControlStateNormal];
            [scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
            
            CGRect rect = lineView_.frame;
            rect.origin.x = worksBtn_.frame.size.width - lineView_.frame.size.width;
            rect.origin.y = worksBtn_.frame.origin.y;
            [lineView_ setFrame:rect];
            
            rect = rowImageView_.frame;
            rect.origin.x = lineView_.frame.origin.x - rowImageView_.frame.size.width;
            rect.origin.y = lineView_.frame.origin.y + (int)((lineView_.frame.size.height - rowImageView_.frame.size.height)/2.0);
            [rowImageView_ setFrame:rect];
        }
            break;
        case SkillResume:
        {
            [skillBtn_ setImage:[UIImage imageNamed:@"btn_skill_on.png"] forState:UIControlStateNormal];
            [scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
            
            CGRect rect = lineView_.frame;
            rect.origin.x = skillBtn_.frame.size.width - lineView_.frame.size.width;
            rect.origin.y = skillBtn_.frame.origin.y;
            [lineView_ setFrame:rect];
            
            rect = rowImageView_.frame;
            rect.origin.x = lineView_.frame.origin.x - rowImageView_.frame.size.width;
            rect.origin.y = lineView_.frame.origin.y + (int)((lineView_.frame.size.height - rowImageView_.frame.size.height)/2.0);
            [rowImageView_ setFrame:rect];
        }
            break;
        case CerResume:
        {
            [cerBtn_ setImage:[UIImage imageNamed:@"btn_cer_on.png"] forState:UIControlStateNormal];
            [scrollView_ setContentOffset:CGPointMake(0,scrollView_.contentSize.height - scrollView_.frame.size.height) animated:YES];
            
            CGRect rect = lineView_.frame;
            rect.origin.x = cerBtn_.frame.size.width - lineView_.frame.size.width;
            rect.origin.y = cerBtn_.frame.origin.y;
            [lineView_ setFrame:rect];
            
            rect = rowImageView_.frame;
            rect.origin.x = lineView_.frame.origin.x - rowImageView_.frame.size.width;
            rect.origin.y = lineView_.frame.origin.y + (int)((lineView_.frame.size.height - rowImageView_.frame.size.height)/2.0);
            [rowImageView_ setFrame:rect];
        }
            break;
        case AwardResume:
        {
            [studentAwardBtn_ setImage:[UIImage imageNamed:@"btn_award_on.png"] forState:UIControlStateNormal];
            [scrollView_ setContentOffset:CGPointMake(0,scrollView_.contentSize.height - scrollView_.frame.size.height) animated:YES];
            
            CGRect rect = lineView_.frame;
            rect.origin.x = studentAwardBtn_.frame.size.width - lineView_.frame.size.width;
            rect.origin.y = studentAwardBtn_.frame.origin.y;
            [lineView_ setFrame:rect];
            
            rect = rowImageView_.frame;
            rect.origin.x = lineView_.frame.origin.x - rowImageView_.frame.size.width;
            rect.origin.y = lineView_.frame.origin.y + (int)((lineView_.frame.size.height - rowImageView_.frame.size.height)/2.0);
            [rowImageView_ setFrame:rect];
        }
            break;
        case LeaderResume:
        {
            [studentLeaderBtn_ setImage:[UIImage imageNamed:@"btn_leader_on.png"] forState:UIControlStateNormal];
            [scrollView_ setContentOffset:CGPointMake(0,scrollView_.contentSize.height - scrollView_.frame.size.height) animated:YES];
            
            CGRect rect = lineView_.frame;
            rect.origin.x = studentLeaderBtn_.frame.size.width - lineView_.frame.size.width;
            rect.origin.y = studentLeaderBtn_.frame.origin.y;
            [lineView_ setFrame:rect];
            
            rect = rowImageView_.frame;
            rect.origin.x = lineView_.frame.origin.x - rowImageView_.frame.size.width;
            rect.origin.y = lineView_.frame.origin.y + (int)((lineView_.frame.size.height - rowImageView_.frame.size.height)/2.0);
            [rowImageView_ setFrame:rect];
        }
            break;
        case ProjectResume:
        {
            [studentProjectBtn_ setImage:[UIImage imageNamed:@"btn_project_on.png"] forState:UIControlStateNormal];
            [scrollView_ setContentOffset:CGPointMake(0,scrollView_.contentSize.height - scrollView_.frame.size.height) animated:YES];
            
            CGRect rect = lineView_.frame;
            rect.origin.x = studentProjectBtn_.frame.size.width - lineView_.frame.size.width;
            rect.origin.y = studentProjectBtn_.frame.origin.y;
            [lineView_ setFrame:rect];
            
            rect = rowImageView_.frame;
            rect.origin.x = lineView_.frame.origin.x - rowImageView_.frame.size.width;
            rect.origin.y = lineView_.frame.origin.y + (int)((lineView_.frame.size.height - rowImageView_.frame.size.height)/2.0);
            [rowImageView_ setFrame:rect];
        }
            break;
        case StudentInfoResume:
        {

        }
            break;
            
        default:
            break;
    }
}

-(void) changeSize
{

}

-(void) buttonResponse:(id)sender
{
    //基本资料
    if( sender == baseInfoBtn_ )
    {       
        [delegate_ resumeNavHaveChange:self index:BaseResumeInfo];
    }
    //求职意向
    else if( sender == wantJobBtn_ )
    {        
        [delegate_ resumeNavHaveChange:self index:WantResumeJob];
    }
    //教育背景
    else if( sender == eduBtn_ )
    {        
        [delegate_ resumeNavHaveChange:self index:EduResume];
    }
    //工作经历
    else if( sender == worksBtn_ )
    {        
        [delegate_ resumeNavHaveChange:self index:WorksResume];
    }
    //工作技能
    else if( sender == skillBtn_ )
    {
        [delegate_ resumeNavHaveChange:self index:SkillResume];
    }
    //证书管理
    else if( sender == cerBtn_ )
    {        
        [delegate_ resumeNavHaveChange:self index:CerResume];
    }
    //个人奖项
    else if( sender == studentAwardBtn_ )
    {
        [delegate_ resumeNavHaveChange:self index:AwardResume];
    }
    //担任干部经历
    else if( sender == studentLeaderBtn_ )
    {
        [delegate_ resumeNavHaveChange:self index:LeaderResume];
    }
    //项目活动经历
    else if( sender == studentProjectBtn_ )
    {
        [delegate_ resumeNavHaveChange:self index:ProjectResume];
    }
}

@end

@implementation BaseResumeCtl

@synthesize resumeDelegate_;

-(id) init
{
    self = [super init];
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        bHaveUpdateComData_ = NO;
        validateSeconds_ = BaseResumeCtl_ValidateSeconds;
        
        //只初始化一个resumeNavCtl_(左的导航ctl)
        if( !bHaveInitResumeNav )
        {
            bHaveInitResumeNav = YES;
            resumeNavCtl_ = [[ResumeNavCtl alloc] init];
            resumeNavCtl_.currentNavIndex_  = BaseResumeInfo;
            resumeNavCtl_.preNavIndex_      = PreNullResume;
        }
        
        //初始化数据连接类
        if( !PreRequestCon_Update_ )
        {
            PreRequestCon_Update_ = [[PreRequestCon alloc] init];
            PreRequestCon_Update_.delegate_ = self;
        }
    }
    return self;
}


#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self changeSize];
    
    [saveBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn_.titleLabel setFont:FOURTEENFONT_CONTENT];
    saveBtn_.layer.cornerRadius = 2.0;
    
    
    //将keyboard加入主视图,不过先隐藏
    [keyboardReturnCtl.view removeFromSuperview];
    
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    UIViewController *ctl = window.rootViewController;
    
    [ctl.view addSubview:keyboardReturnCtl.view];
    [keyboardReturnCtl hide];
    
    //让固定大小用的navContentLb_隐藏
    navContentLb_.backgroundColor = [UIColor clearColor];
    navContentLb_.text = @"";
    
    //设置scrollViewContentSize_为scrollView的原始contentSize大小
    scrollViewContentSize_ = scrollView_.contentSize;
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

-(void) changeSize
{    
    if( scrollView_ )
    {
        //设置自己的scrollView的移动大小
        CGRect scrollRect = scrollView_.frame;
        [scrollView_ setContentSize:CGSizeMake(scrollRect.size.width, scrollRect.size.height)];
        
       
        //改变self.view与scrollView的大小
        CGRect scrollViewShouldRect = scrollView_.frame;
        scrollViewShouldRect.origin.x = 0;
        scrollViewShouldRect.origin.y = 0;
        scrollViewShouldRect.size.height    = MainHeight - NavBar_Height - TabBar_Height;
        [self.view setFrame:scrollViewShouldRect];
        [scrollView_ setFrame:scrollViewShouldRect];
    }

}

//不需要背景
-(NSString *) getBGName
{
    return nil;
}

//获取简历导航Ctl
+(ResumeNavCtl*) getResumeNav
{    
    return resumeNavCtl_;
}

//设置数据是否被加载过
-(void) setHaveUpdateComFlag:(BOOL)flag
{
    bHaveUpdateComData_ = flag;
}

//注销
-(void) loginOff
{
    lasterLoadDate_ = nil;
    bHaveUpdateComData_ = NO;
}


//让有焦点的控件失去焦点
-(void) comResignFirstResponse
{
    
}

-(void) updateComInfo:(PreRequestCon *)con
{
    [super updateComInfo:con];
    
    if( loadStats_ == FinishLoad ){
        scrollView_.alpha = 1.0;
    }else if( loadStats_ == ErrorLoad ){
        scrollView_.alpha = 0.0;
    }else{
        scrollView_.alpha = 0.0;
    }
}

//开始载入数据
-(void) beginLoad:(id)dataModal exParam:(id)exParam
{    
    //让有焦点的控件失去焦点
    BaseResumeCtl *ctl = exParam;
    if( ctl )
    {
        [ctl comResignFirstResponse];
    }
    
    //移动自己的scrollView到顶端
    [scrollView_ setContentOffset:CGPointMake(0, 0)];

    [super beginLoad:dataModal exParam:exParam];
}

//保存
-(void) saveResume
{
    bHaveSave_ = YES;
    
    //让自己失去焦点
    [self comResignFirstResponse];
}

//移动subObj到顶端,以便用户输入
-(void) autoMove:(UIView *)subObj
{      
    //显示出keyboardCtl
    [keyboardReturnCtl show];
    
    UIView *newTempView = nil;
    //对UITextView作特殊处理
    if( [subObj isKindOfClass:[UITextView class]] )
    {
        newTempView = [[UIView alloc] initWithFrame:subObj.frame];
        [[subObj superview] addSubview:newTempView];
        subObj = newTempView;
    }
    
    CGRect subRect = subObj.frame;
    CGRect convertRect = [subObj convertRect:subObj.frame toView:self.view];
    CGRect convertOffsetRect = [subObj convertRect:subRect toView:scrollView_];
    convertRect.origin.y -= subRect.origin.y;
    convertOffsetRect.origin.y -= subRect.origin.y;
    
    //此时的subRect.size.height为scrollView要移动的距离
    [scrollView_ setContentSize:CGSizeMake(scrollViewContentSize_.width, scrollViewContentSize_.height + convertRect.origin.y )];
    
    //移动scrollView的contentOffSize
    [scrollView_ setContentOffset:CGPointMake(0,convertOffsetRect.origin.y ) animated:YES];
    
    [newTempView removeFromSuperview];
}

//还原已经移动的size
-(void) recoverMoveSize
{
    //隐藏keyboardCtl
    [keyboardReturnCtl hide];
    
    //复原
    [scrollView_ setContentSize:CGSizeMake(scrollViewContentSize_.width, scrollViewContentSize_.height )];
    
    //判断是否需要将scroll移下来
    if( scrollView_.frame.size.height > scrollViewContentSize_.height )
    {
        [scrollView_ setContentOffset:CGPointMake(0,0 ) animated:YES];
    }

}

#pragma TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self autoMove:textField];
    
    //设置当前处于焦点的视图
    currentFocusView = textField;
    
    //return YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [scrollView_ addGestureRecognizer:tap];
    
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    [self recoverMoveSize];
    
    NSArray *gestures = [scrollView_ gestureRecognizers];
    for (UIGestureRecognizer *gesture in gestures) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [scrollView_ removeGestureRecognizer:gesture];
        }
    }
    return YES;
}

- (void)tapClick
{
    [self comResignFirstResponse];
}

#pragma TextView Delegate
-(void) textViewDidBeginEditing:(UITextView *)textView
{
    [self autoMove:textView];
    
    //设置当前处于焦点的视图
    currentFocusView = textView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [scrollView_ addGestureRecognizer:tap];
    //return YES;
}

-(BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    [self recoverMoveSize];
    NSArray *gestures = [scrollView_ gestureRecognizers];
    for (UIGestureRecognizer *gesture in gestures) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [scrollView_ removeGestureRecognizer:gesture];
        }
    }
    return YES;
}

#pragma ResumeNavChangeEvent Delegate
-(void) resumeNavHaveChange:(ResumeNavCtl *)resumeNavCtl index:(int)index
{    
    //去更改导航的索引
    [[BaseResumeCtl getResumeNav] setNavIndex:index];
    
    //移动视图
    [scrollView_ setContentOffset:CGPointMake(index*scrollView_.frame.size.width, 0) animated:YES];
}

-(void) buttonClick:(id)sender
{
    [super buttonClick:sender];
    
    [self comResignFirstResponse];
    
    //进入下一步
    if( sender == nextBtn_ )
    {
        
    }
}

- (void)backBarBtnResponse:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

//
//  CondictionPlaceCtl_School.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "CondictionPlaceCtl_School.h"
#import "CondictionList_School_Cell.h"
#import "CondictionList_DataModal.h"
#import "MyButton.h"

UIImage *selectOnImage;     //选中
UIImage *selectOffImage;    //没有选中

@implementation CondictionPlaceCtl_School

@synthesize delegate_;
@synthesize bMutable_;
@synthesize bAttentionAtt_;

-(id) init
{
    self = [self initWithNibName:@"CondictionPlaceCtl_School" bundle:nil];
    
    if( !selectOnImage ){
        selectOnImage = [UIImage imageNamed:@"ico_select_on.png"];
        selectOffImage = [UIImage imageNamed:@"ico_select_off.png"];
    }
    
    bHeaderEgo_ = NO;
    bFooterEgo_ = NO;
    
    //默认可以多选
    bMutable_ = YES;
    
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

-(void) beginLoad:(id)dataModal exParam:(id)exParam
{
    dataModal_ = dataModal;
    
    [super beginLoad:dataModal exParam:exParam];
}

-(void) willLoadData
{
    [super willLoadData];
    
    [resultArr_ removeAllObjects];
    [tableView_ reloadData];
}

-(void) getDataFunction
{    
    if( [PreCommon checkIsDirectCity:dataModal_.str_] )
    {
        [PreRequestCon_ getSchoolList:dataModal_.id_ regionType:1 bAttentionAtt:bAttentionAtt_];
    }else
        [PreRequestCon_ getSchoolList:dataModal_.id_ regionType:2 bAttentionAtt:bAttentionAtt_];
}

//重写获取cell方法
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    
    CondictionList_School_Cell *cell = (CondictionList_School_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CondictionList_School_Cell" owner:self options:nil] lastObject];
        
        //自定义cell的背景
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
        [imageView setImage:[UIImage imageNamed:BG_Cell_1]];
        [imageView setFrame:cell.frame];
        [cell setBackgroundView:imageView];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = @"";
    
    //是否选中
    MyButton *myBtn = (MyButton *)[cell viewWithTag:110];
    
    //学校名称
    UILabel *schoolLb = (UILabel *)[cell viewWithTag:100];
    
    //是否已关注
    UIButton *attentionBtn = (UIButton *)[cell viewWithTag:120];
    
    CondictionList_DataModal *dataModal = [resultArr_ objectAtIndex:[indexPath row]];
    schoolLb.text = dataModal.str_;
    myBtn.index_ = [indexPath row];
    
    if( dataModal.bAttention_ && bAttentionAtt_ ){
        attentionBtn.enabled = NO;
        attentionBtn.alpha = 1.0;
    }else
        attentionBtn.alpha = 0;
    
    if( dataModal.bSelected_ ){
        [myBtn setImage:selectOnImage forState:UIControlStateNormal];
    }else{
        [myBtn setImage:selectOffImage forState:UIControlStateNormal];
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //可以多选
    if( bMutable_ ){
        CondictionList_DataModal *dataModal = [resultArr_ objectAtIndex:[indexPath row]];
        dataModal.bSelected_ = !dataModal.bSelected_;
    }
    //不能多选
    else
    {
        for ( CondictionList_DataModal *dataModal in resultArr_ ) {
            dataModal.bSelected_ = NO;
        }
        
        CondictionList_DataModal *dataModal = [resultArr_ objectAtIndex:[indexPath row]];
        dataModal.bSelected_ = !dataModal.bSelected_;
    }
    
    [tableView_ reloadData];
    
    //[super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

-(void) finishGetData:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:preRequestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case GetSchoolList_XMLParser:
        {
            //恢复所有的选择状态
            for ( CondictionList_DataModal *dataModal in dataArr ) {
                dataModal.bSelected_ = NO;
            }
            
        }
            break;
            
        default:
            break;
    }
}


-(void) buttonResponse:(id)sender
{
    //加载所选项
    if( sender == chooseBtn_ )
    {
        NSMutableArray *selectArr = [[NSMutableArray alloc] init];
        for ( CondictionList_DataModal *dataModal in resultArr_ ) {
            if( dataModal.bSelected_ ){
                [selectArr addObject:dataModal];
            }
        }
        
        if( [selectArr count] > 0 ){
            UINavigationController *nav = self.navigationController;
            if( [PreCommon checkIsDirectCity:dataModal_.str_] )
            {
                [nav popViewControllerAnimated:NO];
                [nav popViewControllerAnimated:bMutable_];
            }else
            {
                [nav popViewControllerAnimated:NO];
                [nav popViewControllerAnimated:NO];
                [nav popViewControllerAnimated:bMutable_];
            }
            
            [delegate_ condictionChooseComplete:self dataModalArr:selectArr type:GetSchoolType];
        }else{
            [PreBaseUIViewController showAlertView:@"请您选择学校" msg:nil btnTitle:@"我知道了"];
        }
    }
    //MyButton Click
    else if( [sender isKindOfClass:[MyButton class]] )
    {
        MyButton *myBtn = sender;
        CondictionList_DataModal *dataModal = [resultArr_ objectAtIndex:myBtn.index_];
        dataModal.bSelected_ = !dataModal.bSelected_;
        if( dataModal.bSelected_ )
        {
            [myBtn setImage:selectOnImage forState:UIControlStateNormal];
        }else
            [myBtn setImage:selectOffImage forState:UIControlStateNormal];
    }
}


@end

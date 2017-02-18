//
//  CondictionPlaceCtl_2.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "CondictionPlaceCtl_Sub.h"
#import "CondictionList_Cell.h"
#import "CondictionList_DataModal.h"

@implementation CondictionPlaceCtl_Sub

@synthesize schoolCtl_;
@synthesize delegate_;
@synthesize bNeedPopBack_;

-(id) init
{
    self = [self initWithNibName:@"CondictionPlaceCtl_Sub" bundle:nil];
    
    arr_ = [[NSMutableArray alloc] init];
    bNeedPopBack_ = YES;
    
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置代理
    tableView_.delegate     = self;
    tableView_.dataSource   = self;
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

-(void) bePushed:(UIViewController *)ctl
{
    [super bePushed:ctl];
    
    [tableView_ scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(void) setDelegate_:(id<CondictionChooseDelegate>)delegate
{
    delegate_ = delegate;
    
    schoolCtl_.delegate_ = delegate;
}

//设置数据
-(void) setData:(NSArray *)dataArr
{
    [arr_ removeAllObjects];
    [arr_ addObjectsFromArray:dataArr];
       
    [tableView_ reloadData];
}

//设置学校
-(void) initSchoolCtl
{
    if( !schoolCtl_ ){
        schoolCtl_ = [[CondictionPlaceCtl_School alloc] init];
        schoolCtl_.delegate_ = delegate_;
    }
}

//释放学校ctl
-(void) releaseSchoolCtl
{
    schoolCtl_ = nil;
}

//获取学校列表
-(void) getSchoolList:(CondictionList_DataModal *)dataModal
{
    UINavigationController *nav = self.navigationController;
    if( !nav ){
//        nav = self.navCtl_;
    }
    
    [nav pushViewController:schoolCtl_ animated:YES];
    schoolCtl_.title = [NSString stringWithFormat:@"%@ 院校",dataModal.str_];
    [schoolCtl_ beginLoad:dataModal exParam:nil];
}

#pragma UITableView Delegate
#pragma mark TableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{	
    
    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{	    
    return [arr_ count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *textLb;
    UIActivityIndicatorView *indicatorView;
    
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    
    CondictionList_Cell *cell = (CondictionList_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
 
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CondictionList_Cell" owner:self options:nil] lastObject];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = @"";
        
        //找到里面自定义的textLb
        textLb     = (UILabel *)[cell viewWithTag:100];
        indicatorView = (UIActivityIndicatorView *)[cell viewWithTag:120];
        
        //自定义cell的背景
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
        [imageView setImage:[UIImage imageNamed:BG_Cell_1]];
        [imageView setFrame:cell.frame];
        [cell setBackgroundView:imageView];
    }
    
    textLb.text = @"";
    indicatorView.alpha = 0.0;
    
    if( schoolCtl_ )
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else
        cell.accessoryType = UITableViewCellAccessoryNone;
    

    CondictionList_DataModal *dataModal = [arr_ objectAtIndex:[indexPath row]];
    textLb.text = dataModal.str_;

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    @try {
        CondictionList_DataModal *dataModal = [arr_ objectAtIndex:[indexPath row]];
        
        if( schoolCtl_ )
        {
            [self getSchoolList:dataModal];
        }else
        {
            [delegate_ condictionChooseComplete:self dataModal:dataModal type:GetRegionType];
            
            if( bNeedPopBack_ ){
                UINavigationController *nav = self.navigationController;
                [nav popViewControllerAnimated:NO];
                [nav popViewControllerAnimated:YES];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[PreCondictionListCtl-->haveChoosed] : Happen Error\n");
    }
    @finally {
        
    }
    
}

@end

//
//  CondictionTradeCtl_Sub.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-6-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "CondictionTradeCtl_Sub.h"
#import "CondictionList_Cell.h"

@implementation CondictionTradeCtl_Sub

@synthesize delegate_;

-(id) init
{
    self = [self initWithNibName:@"CondictionTradeCtl_Sub" bundle:nil];
    
    dataArr_ = [[NSMutableArray alloc] init];
    
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
    tableView_.delegate = self;
    tableView_.dataSource = self;
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

//设置数据
-(void) setData:(NSArray *)dataArr
{
    [dataArr_ removeAllObjects];
    [dataArr_ addObjectsFromArray:dataArr];
    
    [tableView_ reloadData];
}

-(void) bePushed:(UIViewController *)ctl
{
    [super bePushed:ctl];
    
    [tableView_ scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma UITableView Delegate
#pragma mark TableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return 44.0;
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
    return [dataArr_ count] == 0 ? 1 : [dataArr_ count];
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
    cell.accessoryType = UITableViewCellAccessoryNone;

    if( [dataArr_ count] == 0)
    {
        textLb.text = @"无数据";
        
        return cell;
    }
    
    CondictionList_DataModal *dataModal = [dataArr_ objectAtIndex:[indexPath row]];
    textLb.text = dataModal.str_;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row     = [indexPath row];
    
    @try {
        CondictionList_DataModal *dataModal = [dataArr_ objectAtIndex:row];
        NSArray *viewArr = [self.navigationController viewControllers];
        [self.navigationController popToViewController:[viewArr objectAtIndex:[viewArr count]-3] animated:YES];
        
        [delegate_ condictionChooseComplete:self dataModal:dataModal type:GetTradeType];
    }
    @catch (NSException *exception) {
        NSLog(@"[PreCondictionListCtl-->haveChoosed] : Happen Error\n");
    }
    @finally {
        
    }
}

@end

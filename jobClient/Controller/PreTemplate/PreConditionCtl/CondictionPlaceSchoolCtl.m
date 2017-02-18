//
//  CondictionPlaceSchoolCtl.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "CondictionPlaceSchoolCtl.h"
#import "CondictionPlaceCtl.h"
#import "Constant.h"

@implementation CondictionPlaceSchoolCtl

-(id) init
{
    self = [super init];
    
    
    //同时初始化一下学校列表
    [self initSchoolCtl];
    
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

-(void)viewDidLoad{
    [super viewDidLoad];
//    self.navigationItem.title = @"选择地区-学校";
    [self setNavTitle:@"选择地区-学校"];
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


//开始获取当前位置
-(void) updateCurrentPlace
{

}

//设置学校是单选还是多选
-(void) setSchoolMutableChoose:(BOOL)flag
{
    condictionPlaceCtlSub_.schoolCtl_.bMutable_ = flag;
}

//设置学校是否含关注属性
-(void) setSchoolAttentionAtt:(BOOL)flag
{
    condictionPlaceCtlSub_.schoolCtl_.bAttentionAtt_ = flag;
}

#pragma UITableView Delegate
#pragma mark TableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{	
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{	    
    return [provinceArr_ count];
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
        //        //让自定义的textLb有圆角
        //        CALayer *layer = [textLb layer];      
        //        [layer setMasksToBounds:YES];      
        //        [layer setCornerRadius:5.0];     
        
        
        //自定义cell的背景
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
        [imageView setImage:[UIImage imageNamed:BG_Cell_1]];
        [imageView setFrame:cell.frame];
        [cell setBackgroundView:imageView];
    }
    
    NSInteger row     = [indexPath row];

    if( [provinceArr_ count] == 0)
    {
        textLb.text = @"无数据";
        
        return cell;
    }
    
    CondictionList_DataModal *dataModal = [provinceArr_ objectAtIndex:row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

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
        //检测是否是直辖城
        CondictionList_DataModal *dataModal = [provinceArr_ objectAtIndex:row];
        
        if( [PreCommon checkIsDirectCity:dataModal.str_] )
        {
            //直接加载学校,不用到第二级
//            condictionPlaceCtlSub_.navCtl_ = (BaseUINavigationController *)self.navigationController;
            [condictionPlaceCtlSub_ getSchoolList:dataModal];
        }else 
        {
            [self.navigationController pushViewController:condictionPlaceCtlSub_ animated:YES];
            condictionPlaceCtlSub_.title = dataModal.str_;
            
            NSString *regionId = dataModal.id_;
            
            //组装出数组
            NSMutableArray *subArr = [[NSMutableArray alloc] init];
            if (!regionArr) {
                [CondictionPlaceCtl initData];
            }
            
            for ( CondictionList_DataModal *dataModal in regionArr ) {
                if( [dataModal.pId_ isEqualToString:regionId] && ( !dataModal.bParent_ || (dataModal.bParent_ && !condictionPlaceCtlSub_.schoolCtl_) ) )
                {
                    [subArr addObject:dataModal];
                }
            }
            [condictionPlaceCtlSub_ setData:subArr];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[PreCondictionListCtl-->haveChoosed] : Happen Error\n");
    }
    @finally {
        
    }
    
}

@end

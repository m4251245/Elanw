//
//  LookHistoryCtl.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-6-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "LookHistoryCtl.h"
#import "Event_Cell.h"
#import "Event_DataModal.h"

@implementation LookHistoryCtl

//@synthesize seminarDetailCtl_;
//@synthesize recruitmentDetailCtl_;
@synthesize bHaveNewSubscribe_;

-(id) init
{
    self = [self initWithNibName:@"LookHistoryCtl" bundle:nil];
    
    
    bHaveNewSubscribe_ = NO;
    bShowReadImage_ = NO;
    
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
//    self.navigationItem.title = @"最近浏览历史";
    [self setNavTitle:@"最近浏览历史"];
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

-(void) getDataFunction
{
    [PreRequestCon_ getHistoryList:pageInfo_.currentPage_ pageSize:25];
}

-(void) loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    Event_DataModal *dataModal = selectData;
    
    Xjh_Zph_DataModal *zpModal = [[Xjh_Zph_DataModal alloc] init];
    zpModal.type_ = dataModal.eventType_;
    zpModal.id_ = dataModal.id_;
    zpModal.title_ = dataModal.title_;
    zpModal.companyid_ = dataModal.cid_;
    zpModal.companyName_ = dataModal.cname_;
    zpModal.schoolId_ = dataModal.sid_;
    zpModal.schoolName_ = dataModal.sname_;
    zpModal.regionId_ = dataModal.regionId_;
    zpModal.address_ = dataModal.addr_;
    zpModal.datetiome_ = dataModal.sdate_;
    
    
    if (!detailCtl_) {
        detailCtl_ = [[Xjh_ZphDetailCtl alloc] init];
    }
    [self.navigationController pushViewController:detailCtl_ animated:YES];
    [detailCtl_ beginLoad:zpModal exParam:exParam];
    

}

-(void) bePushed:(UIViewController *)ctl
{
    [super bePushed:ctl];
    
    bHaveNewSubscribe_ = NO;
}

#pragma SubscribeDelegate
//添加了新的订阅
-(void) haveAddNewSubscribe:(PreStatus_DataModal *)dataModal
{
    bHaveNewSubscribe_ = YES;
}

#pragma UITableView Delegate
//重写获取cell等方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 68.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Event_Cell";
    
    Event_Cell *cell = (Event_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:Event_Cell_Xib_Name owner:self options:nil] lastObject];
        
        //自定义cell的背景
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
        [imageView setImage:[UIImage imageNamed:BG_Cell_1]];
        [imageView setFrame:cell.frame];
        [cell setBackgroundView:imageView];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = @"";
    
    //标题
    UILabel *title          = (UILabel *)[cell viewWithTag:100];
    //学校名称
    UILabel *sname          = (UILabel *)[cell viewWithTag:101];
    //开始时间
    UILabel *sdate          = (UILabel *)[cell viewWithTag:102];
    //公司名称
    UILabel *cname          = (UILabel *)[cell viewWithTag:103];
    //招聘会/宣讲会标识图标
    UIImageView *imageView  = (UIImageView *)[cell viewWithTag:150];
    //已阅标记
    UIImageView *readImage  = (UIImageView *)[cell viewWithTag:500];
    
    cell.textLabel.text     = @"";
    [imageView setImage:nil];
    readImage.alpha         = 0.0;
    
    Event_DataModal *dataModal = [resultArr_ objectAtIndex:[indexPath row]];
    title.text              = dataModal.title_;
    if( dataModal.sname_ && ![dataModal.sname_ isEqualToString:@""] )
    {
        sname.text              = dataModal.sname_;
    }else
        sname.text              = dataModal.addr_;
    cname.text              = dataModal.cname_;
    sdate.text              = dataModal.sdate_;
    
    //如果查询到的时间没有小时等信息,则不显示
    static NSRange dateRang;
    dateRang.length = 8;
    dateRang.location = 11;
    NSString *dateStr;
    @try {
        dateStr = [dataModal.sdate_ substringWithRange:dateRang];
        if( [dateStr isEqualToString:@"00:00:00"] )
        {
            sdate.text              = [dataModal.sdate_ substringToIndex:10];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    if( dataModal.bRead_ && bShowReadImage_ )
    {
        readImage.alpha = 1.0;
    }else
        readImage.alpha = 0.0;
    
    return cell;
}


@end

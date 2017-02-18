//
//  CondictionZWCtl.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-6-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "CondictionZWCtl.h"


//列表数据
NSArray             *zwData;

@implementation CondictionZWCtl

-(id) init
{
    self = [self initWithNibName:CondictionTradeCtl_Xib_Name bundle:nil];
    
    
    if( !subCtl_ ){
        subCtl_ = [[CondictionZWCtl_Sub alloc] init];
    }
    
    dataArr_ = [[NSMutableArray alloc] init];
    
    bHaveSub_ = YES;
    
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
//    self.navigationItem.title  = @"选择职位";
    [self setNavTitle:@"选择职位"];
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

//初始化数据
+(void) initData
{
    [CondictionZWCtl loadDataFromFile];
}

//从文件中反序列化数据
+(id) loadDataFromFile
{
    //从序列化文件中取得数据
    @try {
        // [areaArrayCondictionHistory_ release];
        id archieveData = [MyCommon unArchiverFromFile:JobDataFile_Name];
        
        zwData = archieveData;
        
        return archieveData;
    }
    @catch (NSException *exception) {
        //bHaveHappenError = YES;
        [PreBaseUIViewController showAlertView:@"异常" msg:@"职位列表获取失败,请尝试重启程序." btnTitle:@"关闭"];
        
        return nil;
    }
    @finally {
        
    }
    
    return nil;
}

//检查是否是父节点职位
+(BOOL) checkIsParentZW:(NSString *)zwId
{
    if( !zwId || zwId == nil || [zwId isEqualToString:@""] )
    {
        return NO;
    }
    
    if( !zwData ){
        [CondictionZWCtl initData];
    }
    
    for ( CondictionList_DataModal *dataModal in zwData ) {
        if( [dataModal.id_ isEqualToString:zwId] )
        {
            return dataModal.bParent_;
        }
    }
    
    return NO;
}

//设置数据
-(void) setData
{
    [dataArr_ removeAllObjects];
    
    CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
    dataModal.str_ = @"所有职位";
    dataModal.id_ = nil;
    dataModal.bParent_ = NO;
    [dataArr_ addObject:dataModal];
    
    if( !zwData ){
        [CondictionZWCtl initData];
    }
    
    for (CondictionList_DataModal *dataModal in zwData) {
        if( dataModal.bParent_ )
        {
            [dataArr_ addObject:dataModal];
        }
    }
    
    [tableView_ reloadData];
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
        
        if( dataModal.bParent_ )
        {
            [self.navigationController pushViewController:subCtl_ animated:YES];
            subCtl_.title = dataModal.str_;
            
            NSString *dataId = dataModal.id_;
            
            //组装出数组
            NSMutableArray *subArr = [[NSMutableArray alloc] init];
            [subArr addObject:dataModal];
            for ( CondictionList_DataModal *dataModal in zwData ) {
                if( [dataModal.pId_ isEqualToString:dataId] && !dataModal.bParent_ )
                {
                    [subArr addObject:dataModal];
                }
            }
            [subCtl_ setData:subArr];
        }else
        {
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate_ condictionChooseComplete:self dataModal:dataModal type:GetZWType];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[PreCondictionListCtl-->haveChoosed] : Happen Error\n");
    }
    @finally {
        
    }
    
}

@end

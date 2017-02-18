//
//  SubscribeResultCtl.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-6-7.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SubscribeResultCtl.h"

@implementation SubscribeResultCtl

@synthesize delegate_;

-(id) init
{
    self = [super init];
    
//    self.navigationItem.title = SubscribeResultCtl_Title;
    [self setNavTitle:SubscribeResultCtl_Title];
    
    readCon_ = [[PreRequestCon alloc] init];
    readCon_.delegate_ = self;
    
    //显示已查看标记
    bShowReadImage_ = YES;
    
    noDataOkText_ = @"该条订阅条件暂无数据,建议换个订阅条件试试.";
    
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
    subscribeDataModal_ = dataModal;
    
    //组装标题
    NSMutableString *titleStr = [[NSMutableString alloc] init];
    if( [subscribeDataModal_.subscribeType_ intValue] == Event_Seminar )
    {
        [titleStr appendFormat:@"[宣讲会]:"];
    }else if( [subscribeDataModal_.subscribeType_ intValue] == Event_Recruitment )
    {
        [titleStr appendFormat:@"[招聘会]:"];
    }
    
    if( subscribeDataModal_.sname_ && ![subscribeDataModal_.sname_ isEqualToString:@""] )
    {
        [titleStr appendFormat:@"%@",subscribeDataModal_.sname_];
    }
    else if( subscribeDataModal_.cname_ && ![subscribeDataModal_.cname_ isEqualToString:@""] )
    {
        [titleStr appendFormat:@"%@",subscribeDataModal_.cname_];
    }
    else if( subscribeDataModal_.regionId_ )
    {
        [titleStr appendFormat:@"%@",[CondictionPlaceCtl getRegionStr:subscribeDataModal_.regionId_]];
    }
//    self.navigationItem.title = titleStr;
    [self setNavTitle:titleStr];
    
    [super beginLoad:dataModal exParam:exParam];
}

-(void) getDataFunction
{
    //宣讲会
    if( [subscribeDataModal_.subscribeType_ intValue] == Event_Seminar )
    {
        if( subscribeDataModal_.regionId_ )
        {
            if( [CondictionPlaceCtl checkIsProvince:subscribeDataModal_.regionId_] )
            {
                [PreRequestCon_ getXjh:nil sId:subscribeDataModal_.sId_ sname:subscribeDataModal_.sname_ cId:subscribeDataModal_.cId_ cname:subscribeDataModal_.cname_ regionId:subscribeDataModal_.regionId_ regionType:1 dateStr:nil dateType:10 pageIndex:pageInfo_.currentPage_ pageSize:SubscribeResultCtl_PageSize];
            }else
            {
                [PreRequestCon_ getXjh:nil sId:subscribeDataModal_.sId_ sname:subscribeDataModal_.sname_ cId:subscribeDataModal_.cId_ cname:subscribeDataModal_.cname_ regionId:subscribeDataModal_.regionId_ regionType:2 dateStr:nil dateType:10 pageIndex:pageInfo_.currentPage_ pageSize:SubscribeResultCtl_PageSize];
            }
        }else
        {
            [PreRequestCon_ getXjh:nil sId:subscribeDataModal_.sId_ sname:subscribeDataModal_.sname_ cId:subscribeDataModal_.cId_ cname:subscribeDataModal_.cname_ regionId:subscribeDataModal_.regionId_ regionType:0 dateStr:nil dateType:10 pageIndex:pageInfo_.currentPage_ pageSize:SubscribeResultCtl_PageSize];
        }
    }
    //招聘会
    else if( [subscribeDataModal_.subscribeType_ intValue] == Event_Recruitment )
    {
        if( subscribeDataModal_.regionId_ )
        {
            if( [CondictionPlaceCtl checkIsProvince:subscribeDataModal_.regionId_] )
            {
                [PreRequestCon_ getZph:nil sId:subscribeDataModal_.sId_ sname:subscribeDataModal_.sname_ regionId:subscribeDataModal_.regionId_ regionType:1 dateStr:nil dateType:10 pageIndex:pageInfo_.currentPage_ pageSize:SubscribeResultCtl_PageSize];
            }else
            {
                [PreRequestCon_ getZph:nil sId:subscribeDataModal_.sId_ sname:subscribeDataModal_.sname_ regionId:subscribeDataModal_.regionId_ regionType:2 dateStr:nil dateType:10 pageIndex:pageInfo_.currentPage_ pageSize:SubscribeResultCtl_PageSize];
            }
        }else
        {
            [PreRequestCon_ getZph:nil sId:subscribeDataModal_.sId_ sname:subscribeDataModal_.sname_ regionId:subscribeDataModal_.regionId_ regionType:2 dateStr:nil dateType:10 pageIndex:pageInfo_.currentPage_ pageSize:SubscribeResultCtl_PageSize];
        }
    }else
    {
        [PreBaseUIViewController showAlertView:@"查看失败" msg:@"暂无法查看,系统检测到此条订阅已经被损坏" btnTitle:@"关闭"];
    }
}

-(void) finishGetData:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:preRequestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case GetXjh_XMLParser:
            //不用break
            //break;
        case GetZph_XMLParser:
        {
            //设置已阅
            if( code < Fail )
                [readCon_ setSubscribeReadFlag:subscribeDataModal_.subscribeId_];
        }
            break;
        case SetSubscribeReadFlag_XMLParser:
        {
            PreStatus_DataModal *dataModal = [dataArr objectAtIndex:0];
            
            if( [dataModal.code_ isEqualToString:@"100"] )
            {
                [delegate_ subscribeHaveReadOK:dataModal.id_];
            }
        }
            break;
        default:
            break;
    }
}

@end

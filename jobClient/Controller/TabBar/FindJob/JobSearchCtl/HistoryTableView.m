//
//  HistoryTableView.m
//  jobClient
//
//  Created by job1001 job1001 on 11-12-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "HistoryTableView.h"
#import "SearchHistory_DataModal.h"
#import "HistoryTableView_Cell.h"
#import "PreBaseUIViewController.h"

@implementation HistoryTableView

@synthesize resultArr_;
@synthesize delegate_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//设置自己的类型(取出什么类型的数据)
-(void) initInfo:(HistoryTableViewType)type
{
    tableType_ = type;
    
    [resultArr_ removeAllObjects];
    resultArr_ = [[NSMutableArray alloc] init];
    
    self.delegate   = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//开始载入数据
-(void) reloadData
{
    NSMutableString *whereStr = nil;
    
    switch ( tableType_ ) {
        case DefaultType:
        {
            whereStr = [[NSMutableString alloc] initWithFormat:@"save_type=%d or save_type=%d",NormalSearchType,AdvanceSearchType];
        }
            break;
        case NormalSearchType:
        {
            whereStr = [[NSMutableString alloc] initWithFormat:@"save_type=%d",NormalSearchType];
        }
            break;  
        case AdvanceSearchType:
        {
            whereStr = [[NSMutableString alloc] initWithFormat:@"save_type=%d",AdvanceSearchType];
        }
            break;  
        case CampusSearchType:
        {
            whereStr = [[NSMutableString alloc] initWithFormat:@"save_type=%d",CampusSearchType];
        }
            break;  
        default:
            whereStr = [[NSMutableString alloc] initWithFormat:@"save_type=%d",tableType_];
            break;
    }
    
    //从数据库中去读
    sqlite3_stmt *result = [myDB selectSQL:@"updatetime desc" fileds:nil whereStr:whereStr limit:Save_SearchHistory_Max_Count tableName:DB_SearchHistory_TableName];
    
    [resultArr_ removeAllObjects];
    
    while ( sqlite3_step(result) == SQLITE_ROW ) {
        SearchHistory_DataModal *dataModal = [[SearchHistory_DataModal alloc] init];
        
        //int row = sqlite3_column_int(result, 0);
        char *rowData_1 = (char *)sqlite3_column_text(result, 1);
        char *rowData_2 = (char *)sqlite3_column_text(result, 2);
        char *rowData_3 = (char *)sqlite3_column_text(result, 3);
        char *rowData_4 = (char *)sqlite3_column_text(result, 4);
        
        char *rowData_5 = (char *)sqlite3_column_text(result, 6);
        char *rowData_6 = (char *)sqlite3_column_text(result, 7);
        char *rowData_7 = (char *)sqlite3_column_text(result, 8);
        char *rowData_8 = (char *)sqlite3_column_text(result, 9);
        char *rowData_9 = (char *)sqlite3_column_text(result, 10);
        char *rowData_10 = (char *)sqlite3_column_text(result, 11);
        char *rowData_11 = (char *)sqlite3_column_text(result, 12);
        char *rowData_12 = (char *)sqlite3_column_text(result, 13);
        
        dataModal.searchNameStr_    = [[NSString alloc] initWithCString:rowData_4 encoding:(NSUTF8StringEncoding)];
        dataModal.searchResultStr_  = [[NSString alloc] initWithCString:rowData_2 encoding:(NSUTF8StringEncoding)];
        dataModal.searchURLStr_     = [[NSString alloc] initWithCString:rowData_1 encoding:(NSUTF8StringEncoding)];
        dataModal.searchUpdateTime_ = [[NSString alloc] initWithCString:rowData_3 encoding:(NSUTF8StringEncoding)];
        
        if( rowData_5 )
        {
            dataModal.keywords_ = [[NSString alloc] initWithCString:rowData_5 encoding:(NSUTF8StringEncoding)];
        }
        if( rowData_6 )
        {
            dataModal.keyType_ = [[NSString alloc] initWithCString:rowData_6 encoding:(NSUTF8StringEncoding)];
        }
        if( rowData_7 )
        {
            dataModal.rangId_ = [[NSString alloc] initWithCString:rowData_7 encoding:(NSUTF8StringEncoding)];
        }
        if( rowData_8 )
        {
            dataModal.rangStr_ = [[NSString alloc] initWithCString:rowData_8 encoding:(NSUTF8StringEncoding)];
        }
        if( rowData_9 )
        {
            dataModal.majorId_ = [[NSString alloc] initWithCString:rowData_9 encoding:(NSUTF8StringEncoding)];
        }
        if( rowData_10 )
        {
            dataModal.majorStr_ = [[NSString alloc] initWithCString:rowData_10 encoding:(NSUTF8StringEncoding)];
        }
        if( rowData_11 )
        {
            dataModal.tradeId_ = [[NSString alloc] initWithCString:rowData_11 encoding:(NSUTF8StringEncoding)];
        }
        if( rowData_12 )
        {
            dataModal.tradeStr_ = [[NSString alloc] initWithCString:rowData_12 encoding:(NSUTF8StringEncoding)];
        }
        
        [resultArr_ addObject:dataModal];
    }
    
    sqlite3_finalize(result);
    
    [super reloadData];
}


#pragma mark TableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 42;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{	
    return  @"搜索记录";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return UITableViewHeight_Section;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [resultArr_ count] == 0 ? 1 : [resultArr_ count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    NSString *sectionTitle=[self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle==nil) 
	{
        return nil;
	}
	
	// Create label with section title
    UILabel *label=[[UILabel alloc] init];
    label.frame=CGRectMake(8, 0, 300, UITableViewHeight_Section);
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:17];
    //label.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
    label.text=sectionTitle;
    
    // Create header view and add label as a subview
    UIView *sectionView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, UITableViewHeight_Section)];
    sectionView.backgroundColor = [UIColor clearColor];
    
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_black_section.png"]];
    imageView2.alpha = 1.0;
    [sectionView addSubview:imageView2];
    //    [sectionView setBackgroundColor:[UIColor orangeColor]];
    [imageView2 setFrame:sectionView.frame];
    [sectionView addSubview:label];
    
    return sectionView;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    
    HistoryTableView_Cell *cell = (HistoryTableView_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:HistoryTableView_Cell_Xib_Name owner:self options:nil] lastObject];
        
        //自定义cell的背景
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
        [imageView setImage:[UIImage imageNamed:BG_Cell_1]];
        [imageView setFrame:cell.frame];
        [cell setBackgroundView:imageView];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    
    //左边的条件名
    UILabel *leftLb     = (UILabel *)[cell viewWithTag:100];
    //右边的用户所选值
    UILabel *rightLb    = (UILabel *)[cell viewWithTag:101];
    
    leftLb.text         = @"";
    rightLb.text        = @"";
    cell.textLabel.text = @"";
    
    if( [resultArr_ count] == 0 )
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"暂无搜索记录";
        return cell;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        SearchHistory_DataModal *dataModal = [resultArr_ objectAtIndex:[indexPath row]];
        leftLb.text     = dataModal.searchNameStr_;
        rightLb.text    = [[NSString alloc] initWithFormat:@"约 %@ 结果",dataModal.searchResultStr_];
    }
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //cell Click Event
    @try {
        if( [resultArr_ count] != 0 )
        {
            [delegate_ historyTableViewCellClick:[resultArr_ objectAtIndex:[indexPath row]]];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end

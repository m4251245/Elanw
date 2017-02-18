//
//  ResumeSercetCtl.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-11-8.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ResumeSercetCtl.h"

@implementation ResumeSercetCtl

-(id) init
{
    self = [self initWithNibName:ResumeSercetCtl_Xib_Name bundle:nil];
    
    
    updateCon_ = [[PreRequestCon alloc] init];
    updateCon_.delegate_ = self;
    
    statusArr_ = [[NSArray alloc] initWithObjects:@"公开",@"保密",nil];
    
    rightBarItemStr_ = @"更改";
    
    currentStatus_ = -1;
    selectStatus_ = -1;
    
    validateSeconds_ = ResumeSercetCtl_ValidateSeconds;
    
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
//    self.navigationItem.title = ResumeSercetCtl_Title;
    [self setNavTitle:ResumeSercetCtl_Title];
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

//重置
-(void) reSetInfo
{
    currentStatus_ = -1;
    selectStatus_ = -1;
    
    [resultArr_ removeAllObjects];
    
    //重设有效期,让数据可以重新载入
    lasterLoadDate_ = nil;
}

-(void) beginLoad:(id)dataModal exParam:(id)exParam
{
    //恢复状态
    selectStatus_ = currentStatus_;
    
    [tableView_ reloadData];
    
    [super beginLoad:dataModal exParam:exParam];
}

-(void) getDataFunction
{
    [PreRequestCon_ loadResumeSercet];
}

-(void) errorGetData:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type
{
    [super errorGetData:preRequestCon code:code type:type];
    
    switch ( type ) {
        case GetResumeSercet_XMLParser:
        {
            currentStatus_ = -1;
            selectStatus_ = -1;
            
            [tableView_ reloadData];
        }
            break;
            
        default:
            break;
    }
}

-(void) finishGetData:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:preRequestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case GetResumeSercet_XMLParser:
        {
            @try {
                PreStatus_DataModal *dataModal = [dataArr objectAtIndex:0];
                
                if( [dataModal.status_ isEqualToString:Request_OK] ){
                    
                    currentStatus_ = [dataModal.id_ intValue];
                    selectStatus_ = currentStatus_;
                    
                }else
                {
                    currentStatus_ = -1;
                    selectStatus_ = -1;
                }
            }
            @catch (NSException *exception) {
                currentStatus_ = -1;
                selectStatus_ = -1;
            }
            @finally {
                
                [tableView_ reloadData];
            }
        }
            break;
        case UpdateResumeSercet_XMLParser:
        {
            @try {
                PreStatus_DataModal *dataModal = [dataArr objectAtIndex:0];
                
                if( [dataModal.status_ isEqualToString:Request_OK] ){
                    [PreBaseUIViewController showAutoLoadingView:@"更新成功" msg:nil seconds:2.0];
                    
                    currentStatus_ = selectStatus_;
                }else
                {
                    [PreBaseUIViewController showAlertView:@"更新失败" msg:dataModal.msg_ btnTitle:@"关闭"];
                }
            }
            @catch (NSException *exception) {
                [PreBaseUIViewController showAlertView:@"更新失败" msg:@"请稍候再试" btnTitle:@"关闭"];
            }
            @finally {
                
            }
            
        }
            break;
        default:
            break;
    }
}

-(void) addDataModal:(PreRequestCon *)con dataArr:(NSArray *)dataArr type:(XMLParserType)type
{
    [resultArr_ removeAllObjects];
    [resultArr_ addObjectsFromArray:statusArr_];
}

#pragma UITableView Delegate
//重写获取cell等方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 45.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = @"";
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [statusArr_ objectAtIndex:[indexPath row]];
    
    //当前的求职状态选中
    if( selectStatus_ == 1 && [indexPath row] == 0 ){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else if( selectStatus_ == 0 && [indexPath row] == 1 ){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if( [indexPath row] == 0 ){
        selectStatus_ = 1;
    }else if( [indexPath row] == 1 ){
        selectStatus_ = 0;
    }
    
    [tableView reloadData];
}

-(void) rightBarBtnResponse:(id)sender
{
    //更新状态
    if( selectStatus_ != 1 && selectStatus_ != 0 ){
        [PreBaseUIViewController showAlertView:nil msg:@"请选择状态值" btnTitle:@"关闭"];
    }else
    {
        [updateCon_ updateResumeSercetStatus:selectStatus_];
    }
}

@end

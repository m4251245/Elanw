//
//  RegionConditionListCtl.m
//  jobClient
//
//  Created by YL1001 on 14-8-20.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "RegionConditionListCtl.h"
#import "pinyin.h"
#import "Constant.h"
#import "FMDatabase.h"

@interface RegionConditionListCtl ()

@end

@implementation RegionConditionListCtl



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        sectionArr_ = [[NSMutableArray alloc] init];
        charArr_ = [[NSMutableArray alloc] init];
        [charArr_ addObject:FirstChar_Ex];
        for ( int i = 0 ; i < 26 ; ++i ) {
            [charArr_ addObject:[NSString stringWithFormat:@"%c",65+i]];
        }

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"选择地区";
    [self setNavTitle:@"选择地区"];
    // Do any additional setup after loading the view from its nib.
    
    UIView *view = [[UIView alloc]init];
    tableView_.tableFooterView = view;
    
     tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) checkFirstName:(NSString *)name
{
    BOOL bFind = NO;
    for ( int i = 0 ; i < 26 ; ++i ) {
        char c = pinyinFirstLetter([name characterAtIndex:0]);
        if( [[NSString stringWithFormat:@"%c",c] isEqualToString:[NSString stringWithFormat:@"%c",65+i]] ){
            bFind = YES;
            break;
        }
    }
    
    return bFind;
}



-(void)getIn:(id<CondictionListDelegate>)delegate type:(CondictionType)type bHaveSub:(BOOL)bHaveSub
{
    self.delegate_ = delegate;
    self.type_ = type;
    self.bHaveSub_ = bHaveSub;
    
    [dataArr_ removeAllObjects];
    
    if( !regionArr ){
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *pathname = [path lastObject];
        NSString *dbPath = [pathname stringByAppendingPathComponent:@"data.db"];
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        @try {
            if (![db open]) {
                NSLog(@"Could not open db.");
            }
            NSString *sql = [NSString stringWithFormat:@"select * from region_choosen"];
            FMResultSet *rs = [db executeQuery:sql];
            NSMutableArray *resulArr = [NSMutableArray arrayWithCapacity:533];
            while ([rs next]) {
                CondictionList_DataModal *model = [[CondictionList_DataModal alloc]init];
                model.id_ = [rs stringForColumn:@"selfId"];
                model.pId_ = [rs stringForColumn:@"parentId"];
                model.str_ = [rs stringForColumn:@"selfName"];
                model.bParent_ = ![rs boolForColumn:@"level"];
                [resulArr addObject:model];
            }
            regionArr = resulArr;
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            [db close];
        }
    }
    
    if( self.parentModal_ ){
        [dataArr_ addObject:self.parentModal_];
    }
    
    for ( CondictionList_DataModal *dataModal in regionArr ) {
        //如果父modal存在,则代表自己是子层
        if( self.parentModal_ ){
            if(!dataModal.bParent_ && [dataModal.pId_ isEqualToString:self.parentModal_.id_] && ![dataModal.id_ isEqualToString:self.parentModal_.id_]){
                [dataArr_ addObject:dataModal];
            }
        }else if(dataModal.bParent_ ){
            [dataArr_ addObject:dataModal];
        }
    }
    
    if( [dataArr_ count] > 0 ){
        [sectionArr_ removeAllObjects];
    }
    
    //设置sectionArr
    for ( CondictionList_DataModal *dataModal in dataArr_ ) {
        
        BOOL bFind = NO;
        for ( NSString *str in sectionArr_ ) {
            if( [str isEqualToString:[[NSString stringWithFormat:@"%c",pinyinFirstLetter([dataModal.str_ characterAtIndex:0])] uppercaseString]] ){
                bFind = YES;
                break;
            }
        }
        
        if( !bFind ){
            [sectionArr_ addObject:[[NSString stringWithFormat:@"%c",pinyinFirstLetter([dataModal.str_ characterAtIndex:0])] uppercaseString]];
        }
    }
    
    //用冒泡法进行排序
    for ( int i = 0 ; i < [sectionArr_ count ] ; ++i ) {
        for ( int j = 0 ; j < [sectionArr_ count] - i - 1; ++j ) {
            NSString *str = [sectionArr_ objectAtIndex:j];
            NSString *subStr = [sectionArr_ objectAtIndex:j+1];
            const char *p = [str cStringUsingEncoding:NSUTF8StringEncoding];
            const char *pp = [subStr cStringUsingEncoding:NSUTF8StringEncoding];
            if( *p > *pp ){
                [sectionArr_ removeObjectAtIndex:j];
                [sectionArr_ insertObject:str atIndex:j+1];
            }
        }
    }

    [tableView_ reloadData];
    

}



#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sectionArr_ count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int cnt = 0;
    
    for ( CondictionList_DataModal *dataModal in dataArr_ ) {
        if( [[[NSString stringWithFormat:@"%c",pinyinFirstLetter([dataModal.str_ characterAtIndex:0])] uppercaseString] isEqualToString:[sectionArr_ objectAtIndex:section]] ){
            ++cnt;
        }
    }
        

    return cnt;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:15.f];
    cell.textLabel.textColor = UIColorFromRGB(0x333333);
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 49, ScreenWidth - 15, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xecedec);
    [cell.contentView addSubview:lineView];
    
    NSString *secitonStr = [sectionArr_ objectAtIndex:section];
    int cnt = 0;
    for ( CondictionList_DataModal *dataModal in dataArr_ ) {
        if( [[[NSString stringWithFormat:@"%c",pinyinFirstLetter([dataModal.str_ characterAtIndex:0])] uppercaseString] isEqualToString:secitonStr] ){
            if( cnt == row ){
                cell.textLabel.text = dataModal.str_;
                break;
            }
            
            ++cnt;
        }
    }
    
    cnt = 0;
    for ( CondictionList_DataModal *dataModal in dataArr_ ) {
        if( [[[NSString stringWithFormat:@"%c",pinyinFirstLetter([dataModal.str_ characterAtIndex:0])] uppercaseString] isEqualToString:[sectionArr_ objectAtIndex:section]] ){
            ++cnt;
        }
    }

    
    
    
    
    
    return cell;
}


-(void) loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    //[super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    @try {
        id obj = nil;
        NSInteger section = [indexPath section];
        NSInteger row = [indexPath row];
        NSString *secitonStr = [sectionArr_ objectAtIndex:section];
        int cnt = 0;
        for ( CondictionList_DataModal *dataModal in dataArr_ ) {
            if( [[[NSString stringWithFormat:@"%c",pinyinFirstLetter([dataModal.str_ characterAtIndex:0])] uppercaseString] isEqualToString:secitonStr] ){
                if( cnt == row ){
                    obj = dataModal;
                    break;
                }
                
                ++cnt;
            }
        }
        
        
        if( !self.bHaveSub_ ){
            [self popCondictionListCtl];
            [self.delegate_ condictionListCtlChoosed:self dataModal:obj];
        }else{
            RegionConditionListCtl *subConCtl = [[RegionConditionListCtl alloc] init];
            
            [self.navigationController pushViewController:subConCtl animated:YES];
            subConCtl.parentModal_ = obj;
            [subConCtl getIn:self type:self.type_ bHaveSub:NO];
        }

    }
    @catch (NSException *exception) {
        // NSLog(@"[%@] : load detail error!",[self class]);
    }
    @finally {
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

//*字母排序搜索
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    return charArr_;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //搜索时显示按索引第几组
    NSInteger count = 0;
    for(NSString *character in sectionArr_ )
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        
        count ++;
    }
    
    return count;
}


@end

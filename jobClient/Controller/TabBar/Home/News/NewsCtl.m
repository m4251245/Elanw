//
//  NewsCtl.m
//  Association
//
//  Created by 一览iOS on 14-1-8.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "NewsCtl.h"
#import "Article_DataModal.h"

@interface NewsCtl ()
{
    int _lastPosition;
}

@end

@implementation NewsCtl
@synthesize delegate_;

-(id) init
{
    self = [super init];
    if (self) {
        bFooterEgo_ = YES;
        imageConArr_ = [[NSMutableArray alloc] init];
        validateSeconds_ = 600;
        
    }
       return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavTitle:@"说薪闻"];

    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{

    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    [con getNewsList:requestCon_.pageInfo_.currentPage_ pagesize:8 catagory:@""];
}


-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    //记录友盟统计模块使用
    NSDictionary * dict = @{@"Function":@"薪闻"};
    [MobClick event:@"personused" attributes:dict];
    
    ArticleDetailCtl *ctl = [[ArticleDetailCtl alloc] init];
    ctl.isFromNews = YES;
    [self.navigationController pushViewController:ctl animated:YES];
    [ctl beginLoad:selectData exParam:nil];
}

-(void)errorGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type
{
    [super errorGetData:requestCon code:code type:type];
    switch (type) {
        case Request_GetNews:
        {
            NSLog(@"It's my Fault!");
        }
            break;
            
        default:
            break;
    }
}


-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_Image:
        {
            @try {
                for (News_DataModal * dataModal in requestCon_.dataArr_) {
                    if (![dataModal.thum_ isEqual:[NSNull null]]) {
                        if ([dataModal.thum_ isEqualToString:requestCon.url_]) {
                            dataModal.imageData_ = [dataArr objectAtIndex:0];
                        }
                    }
                    
                }
                [imageConArr_ removeObject:requestCon];
                [tableView_ reloadData];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCtlCell";
    
    NewsCtl_Cell *cell = (NewsCtl_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsCtl_Cell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    Article_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    cell.dataModalOne = dataModal;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 20  && currentPostion > 0)
    {        //这个地方加上 currentPostion > 0 即可）
        
        _lastPosition = currentPostion;
        
        [delegate_ hideNavBarFromNews:YES];
    }
    
    else if ((_lastPosition - currentPostion > 20) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height-20) ) //这个地方加上后边那个即可，也不知道为什么，再减20才行
    {
        
        _lastPosition = currentPostion;
        
        [delegate_ hideNavBarFromNews:NO];
    }
}


@end

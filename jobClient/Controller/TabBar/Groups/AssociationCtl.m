//
//  AssociationCtl.m
//  Association
//
//  Created by 一览iOS on 14-1-15.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "AssociationCtl.h"
#import "AssociationCtl_Cell.h"
#import "Groups_DataModal.h"
//#import "MyGroups_Cell.h"


@interface AssociationCtl ()

@end

@implementation AssociationCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        bFooterEgo_ = YES;
    
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"我的社群";
    [self setNavTitle:@"我的社群"];
    
    tableView_.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:234.0/255.0 blue:241.0/255.0 alpha:1.0];
    tableView_.backgroundView = nil;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getDataFunction:(RequestCon *)con
{
    [con getMyGroups:[Manager getUserInfo].userId_ page:requestCon_.pageInfo_.currentPage_ pageSize:20 searchArr:[Manager getUserInfo].userId_ type:@"0"]; //0全部社群
}


#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AssociationCtlCell";
    
    AssociationCtl_Cell *cell = (AssociationCtl_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        //cell = [[MainCtl_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AssociationCtl_Cell" owner:self options:nil] lastObject];
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    Groups_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    cell.nameLb_.text = dataModal.name_;
    NSString * intro = [NSString stringWithFormat:@"简介:%@",dataModal.intro_];
    float  h = [Common setLbByText:cell.introLb_ text:intro font:[UIFont systemFontOfSize:13] maxLine:3];
    
    cell.lineImg_.frame = CGRectMake(cell.lineImg_.frame.origin.x, cell.introLb_.frame.origin.y+h+5, cell.lineImg_.frame.size.width, cell.lineImg_.frame.size.height);
    
    cell.createrLb_.frame = CGRectMake(cell.createrLb_.frame.origin.x, cell.lineImg_.frame.origin.y+cell.lineImg_.frame.size.height+3, cell.createrLb_.frame.size.width, cell.createrLb_.frame.size.height);
    
    cell.memberLb_.frame = CGRectMake(cell.memberLb_.frame.origin.x, cell.createrLb_
                                      .frame.origin.y, cell.memberLb_.frame.size.width, cell.memberLb_.frame.size.height);
    
    cell.topicLb_.frame = CGRectMake(cell.topicLb_.frame.origin.x, cell.createrLb_.frame.origin.y, cell.topicLb_.frame.size.width, cell.topicLb_.frame.size.height);
    
    CGRect rect = cell.contentView_.frame;
    rect.size.height = 52+h;
    cell.contentView_.frame = rect;
    
    cell.createrLb_.text = [NSString stringWithFormat:@"社长:%@",dataModal.creater_.iname_];
    cell.memberLb_.text = [NSString stringWithFormat:@"成员:%ld",(long)dataModal.personCnt_];
    cell.topicLb_.text = [NSString stringWithFormat:@"话题:%ld",(long)dataModal.articleCnt_];
    
    if ([dataModal.createrId_ isEqualToString:[Manager getUserInfo].userId_]&&[dataModal.openstatus_ isEqualToString:@"3"]) {
        [cell.propertyImg_ setImage:[UIImage imageNamed:@"ico_create_secret"]];
    }
    else if ([dataModal.createrId_ isEqualToString:[Manager getUserInfo].userId_]&&![dataModal.openstatus_ isEqualToString:@"3"]){
        [cell.propertyImg_ setImage:[UIImage imageNamed:@"ico_create_open"]];
        
    }
    else if (![dataModal.createrId_ isEqualToString:[Manager getUserInfo].userId_]&&[dataModal.openstatus_ isEqualToString:@"3"]){
        [cell.propertyImg_ setImage:[UIImage imageNamed:@"ico_join_secret"]];
    }
    else if (![dataModal.createrId_ isEqualToString:[Manager getUserInfo].userId_]&&![dataModal.openstatus_ isEqualToString:@"3"]){
        [cell.propertyImg_ setImage:[UIImage imageNamed:@"ico_join_open"]];
    }
    
    return cell;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Groups_DataModal * datamodal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    float h1 = [Common getDynHeight:datamodal.intro_ objWidth:275 font:[UIFont systemFontOfSize:13]];
    h1 = h1 < 48 ? h1 : 48;

    float totalHeight = 62 + h1;
    
    return totalHeight;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    detailCtl_ = [[ELGroupDetailCtl alloc] init];
    detailCtl_.delegate = self;
    [self.navigationController pushViewController:detailCtl_ animated:YES];
    detailCtl_.isMine = YES;
    [detailCtl_ beginLoad:selectData exParam:nil];
}

#pragma ELGroupDetailCtlDelegate
-(void)refresh
{
    [self refreshLoad:nil];
}

@end

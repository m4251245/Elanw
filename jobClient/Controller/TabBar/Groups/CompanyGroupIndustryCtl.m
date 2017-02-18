//
//  CompanyGroupIndustryCtl.m
//  jobClient
//
//  Created by 一览iOS on 15-4-25.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "CompanyGroupIndustryCtl.h"
#import "CompanyGroupIndustryCell.h"
#import "Groups_DataModal.h"


@interface CompanyGroupIndustryCtl ()
{

}
@end

@implementation CompanyGroupIndustryCtl

-(id)init
{
    self = [super init];
    bHeaderEgo_ = NO;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"热门行业";
    [self setNavTitle:@"热门行业"];
    // Do any additional setup after loading the view from its nib.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CompanyGroupIndustryCell";
    CompanyGroupIndustryCell *cell = (CompanyGroupIndustryCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CompanyGroupIndustryCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    Groups_DataModal *dataModal = _arrData[indexPath.row];
    
    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:dataModal.pic_]];
    cell.titleLable.text = dataModal.name_;
    cell.contentLable.text = dataModal.intro_;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

/*
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,1)];
    view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20,5,200,30)];
    lable.textColor = FONEREDCOLOR;
    lable.text = @"热门行业";
    [view addSubview:lable];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(-10,39,ScreenWidth+10,1)];
    image.image = [UIImage imageNamed:@"gg_home_line2"];
    [view addSubview:image];
    
    return view;
}
*/

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    [self.navigationController popViewControllerAnimated:NO];
    NSDictionary * dict = @{@"Function":@"公司群_热门行业_GroupsChangeTypeCtl"};
    [MobClick event:@"buttonClick" attributes:dict];
    [_companyCtl pushViewCtl:[_arrData[indexPath.row] id_]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

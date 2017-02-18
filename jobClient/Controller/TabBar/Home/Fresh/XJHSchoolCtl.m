//
//  XJHSchoolCtl.m
//  jobClient
//
//  Created by 一览iOS on 15-4-24.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "XJHSchoolCtl.h"
#import "FMDatabase.h"
#import "Common.h"
#import "XJHChangeCellTableViewCell.h"

@interface XJHSchoolCtl ()
{
    
    NSMutableArray *arrList;
}

@property (nonatomic,strong) FMDatabase *database;
@end

@implementation XJHSchoolCtl

-(id)init
{
    self = [super init];
    bHeaderEgo_ = NO;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.navigationItem.title = @"选择学校";
    [self setNavTitle:@"选择学校"];
    arrList = [[NSMutableArray alloc] init];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [Common getSandBoxPath:@"data.db"];
    
    if( ![fileManager fileExistsAtPath:filePath] ){
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[mainBundle resourcePath],@"data.db"]];
        [data writeToFile:[Common getSandBoxPath:@"data.db"] atomically:YES];
    }
    _database = [FMDatabase databaseWithPath:filePath];
    
    [self selectWithString];
    
}

-(void)selectWithString;
{
    [arrList removeAllObjects];
    SqlitData *allData = [[SqlitData alloc] init];
    allData.school = @"所有学校";
    [arrList addObject:allData];
    
    NSString *typeId = [_regionId substringWithRange:NSMakeRange(_regionId.length-4,4)];
    NSString *typeIdTwo = [_regionId substringWithRange:NSMakeRange(_regionId.length-2,2)];
    NSString *selectString = @"";
    if ([typeId isEqualToString:@"0000"])
    {
        selectString = [NSString stringWithFormat:@"select * from new_school where parentId >= '%@' and parentId <= '%@' and school !=''",_regionId,[_regionId stringByReplacingCharactersInRange:NSMakeRange(_regionId.length - 4,4) withString:@"9999"]];
    }
    else if ([typeIdTwo isEqualToString:@"00"])
    {
        selectString = [NSString stringWithFormat:@"select * from new_school where (provinceId = '%@' or parentId >= '%@' and parentId <= '%@' )and school != ''",_regionId,[_regionId stringByReplacingCharactersInRange:NSMakeRange(_regionId.length - 2,2) withString:@"00"],[_regionId stringByReplacingCharactersInRange:NSMakeRange(_regionId.length - 2,2) withString:@"99"]];
    }
    else
    {
        selectString = [NSString stringWithFormat:@"select * from new_school where parentId = '%@' and school !=''",_regionId];
    }
    
    if ([_database open]) {
        //[NSString stringWithFormat:@"select * from new_school where parentId='%@'",_regionId]
        FMResultSet *set = [_database executeQuery:selectString];
        while ([set next]) {
            SqlitData *data = [[SqlitData alloc] init];
            data.provinceName = [set stringForColumn:@"provinceName"];
            data.stringId = [set stringForColumn:@"rowid"];
            data.provinceld = [set stringForColumn:@"provinceId"];
            data.parentld = [set stringForColumn:@"parentId"];
            data.level = [set stringForColumn:@"level"];
            data.school = [set stringForColumn:@"school"];
            if ([data.school length] > 0) {
                [arrList addObject:data];
            }
        }
    }
    [_database close];
    [tableView_ reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"XJHChangeCellTableViewCell";
    XJHChangeCellTableViewCell *cell = (XJHChangeCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XJHChangeCellTableViewCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    cell.titleLable.text = [arrList[indexPath.row] school];
    
    if ([_currentSchool isEqualToString:cell.titleLable.text]) {
        cell.titleLable.textColor = REDCOLOR;
    }
    else
    {
        cell.titleLable.textColor = BLACKCOLOR;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_schoolChangeDelegate schoolId:@"" andName:[arrList[indexPath.row] school]];
    [self.navigationController popViewControllerAnimated:YES];
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

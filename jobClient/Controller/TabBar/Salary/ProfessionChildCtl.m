//
//  ProfessionChildCtl.m
//  jobClient
//
//  Created by 一览ios on 15/4/29.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ProfessionChildCtl.h"
#import "Profession_Cell.h"
#import "SalaryListCtl.h"

@interface ProfessionChildCtl ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    id _inModel;
}
@end

@implementation ProfessionChildCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"Profession_Cell" bundle:nil] forCellWithReuseIdentifier:@"Profession_Cell"];
    //注册headerView Nib的view需要继承UICollectionReusableView
    [self.collectionView registerNib:[UINib nibWithNibName:@"ProfessionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProfessionHeaderView"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    
    [super beginLoad:dataModal exParam:exParam];
    _inModel = dataModal;
//    self.navigationItem.title = dataModal;
    [self setNavTitle:dataModal];
}

- (void)getDataFunction:(RequestCon *)con
{
    [super updateCom:con];
    requestCon_.storeType_ = TempStoreType;
    [con getProfessionChildListWithParentName:_inModel];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetProfessionChildList:
        {
            [_collectionView reloadData];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -- UICollectionViewDataSource

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  requestCon_.dataArr_.count;
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDictionary *data = requestCon_.dataArr_[section];
    NSArray *dataArr = data[@"list"];
    return dataArr.count;
    
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = requestCon_.dataArr_[indexPath.section];
    NSArray *dataArr = data[@"list"];
    NSString *title = dataArr[indexPath.row];
    
    static NSString * CellIdentifier = @"Profession_Cell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iocn_salary_bg.png"]];
    cell.backgroundColor = [UIColor whiteColor];
    UILabel *titleLb = (UILabel *)[cell viewWithTag:10];
    titleLb.numberOfLines = 2;
    titleLb.text = title ;
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth-35)/3, 36);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 5, 15, 5);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    NSDictionary *data = requestCon_.dataArr_[indexPath.section];
    NSArray *dataArr = data[@"list"];
    NSString *job = dataArr[indexPath.row];
    NSInteger count = self.navigationController.childViewControllers.count;
    SalaryListCtl *ctl  =self.navigationController.childViewControllers[count-3];
    if ([ctl isKindOfClass:[SalaryListCtl class]]) {
        ctl.jobTF.text = job;
        [self.navigationController popToViewController:ctl animated:NO];
        [ctl pushSearchCtl];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={ScreenWidth,30};
    return size;
}

#pragma mark 头部
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProfessionHeaderView" forIndexPath:indexPath];
    UILabel *titleLb = (UILabel *)[view viewWithTag:20];
    NSDictionary *data = requestCon_.dataArr_[indexPath.section];
    titleLb.text =data[@"name"];
    return view;
}

@end

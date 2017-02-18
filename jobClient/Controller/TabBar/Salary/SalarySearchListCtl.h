//
//  SalarySearchListCtl.h
//  jobClient
//
//  Created by 一览ios on 15/5/5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//查工资搜索

#import "BaseListCtl.h"
#import "EColumnChart.h"

@interface SalarySearchListCtl : BaseListCtl<EColumnChartDelegate, EColumnChartDataSource>


@property (strong, nonatomic) EColumnChart *eColumnChart;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property(nonatomic, copy) NSString *keyWords;

@property(nonatomic, copy) NSString *provinceId;

@end

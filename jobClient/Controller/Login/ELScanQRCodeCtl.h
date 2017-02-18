//
//  ELScanQRCodeCtl.h
//  jobClient
//
//  Created by 一览ios on 17/1/4.
//  Copyright © 2017年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
@class CompanyInfo_DataModal;

typedef void(^ScanResultBlock)(NSString *);

@interface ELScanQRCodeCtl : BaseUIViewController
{
    RequestCon *joinCon_;
}

@property(nonatomic, strong) CompanyInfo_DataModal *inDataModel;//输入参数模型，传companyId;
@property (nonatomic,assign) BOOL isCompany;

@property (nonatomic,assign) BOOL isZbar;
@property (nonatomic,copy) NSString *companyId;
@property (nonatomic,strong) NSString  *type;    /**<1首页扫一扫*/
//扫描结果
@property(nonatomic, copy) ScanResultBlock scanResultBlock;

@end

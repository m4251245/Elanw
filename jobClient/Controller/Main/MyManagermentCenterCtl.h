//
//  MyManagermentCenterCtl.h
//  jobClient
//
//  Created by 一览ios on 15/10/10.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"

@interface MyManagermentCenterCtl :BaseUIViewController
{
    __weak IBOutlet UICollectionView *myConllection;
    __weak IBOutlet UICollectionViewFlowLayout *collectionLayout;
}

-(void)jumpToCompany;
-(void)refreshTableView;
-(void)addHeaderPhotoImage;

@end

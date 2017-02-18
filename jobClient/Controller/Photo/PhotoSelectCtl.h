//
//  PhotoSelectCtl.h
//  jobClient
//
//  Created by 一览ios on 15/7/3.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "BaseUIViewController.h"
#import "PhotoBrowerCtl.h"

@protocol PhotoSelectCtlDelegate <NSObject>

@required
- (void)didFinishSelectPhoto:(NSArray *)imageArr;

@end

@interface PhotoSelectCtl : BaseUIViewController

@property (weak, nonatomic) id<PhotoSelectCtlDelegate> delegate;

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, copy) NSArray *assetsGroups;

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@property (nonatomic, strong) NSMutableArray *assets;

@property (strong, nonatomic) NSMutableArray *selectedAssets;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *previewBtn;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UIButton *countLb;

@property (assign,nonatomic) BOOL fromTodayList;

@property (assign, nonatomic) NSInteger maxCount;//图片可选择的最大数量

@property (assign,nonatomic) ChangeSizeType sizeType;

- (IBAction)btnResponse:(id)sender;

- (void)beginLoad:(id)dataModal exParam:(id)exParam;
@end

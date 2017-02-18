//
//  PhotoBrowerCtl.h
//  Test
//
//  Created by 彭永 on 15-7-5.
//  Copyright (c) 2015年 pengy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "BaseUIViewController.h"
#import "PhotoEditorCtl.h"

@protocol PhotoBrowerDelegate <NSObject>

-(void)finishWithImageArr:(NSArray *)arr;

@end

@interface PhotoBrowerCtl : BaseUIViewController

@property (weak,nonatomic) id <PhotoBrowerDelegate> browerDelegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *bigImgv;

@property (weak, nonatomic) IBOutlet UIButton *cropBtn;
@property (weak, nonatomic) IBOutlet UIButton *rotateBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (strong, nonatomic) NSMutableArray *selectedAssets;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) UIButton *selectedBtn;//选择的图片
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (assign,nonatomic) NSInteger selectIndex;

@property (assign,nonatomic) BOOL fromPublishArticle;

@property (assign,nonatomic) ChangeSizeType sizeType;

- (IBAction)btnResponse:(id)sender;

@end

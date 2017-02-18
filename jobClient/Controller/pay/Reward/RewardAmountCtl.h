//
//  RewardAmountCtl.h
//  jobClient
//
//  Created by 一览ios on 15/8/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
@class AnswerListModal;
@class RewardOtherAmountCtl;

@interface RewardAmountCtl : BaseUIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    IBOutlet UIButton *backBtn;
    
    IBOutlet UILabel *_nameLb;       /**<被打赏人名字 */
    IBOutlet UILabel *_tipsLb1;      /**<煽动性文案 */
}
/**
 personPic    产品Id   如文章Id、回答Id 
 personId     被打赏用户Id
 personPic    被打赏用户头像
 productId                      
 */
@property (nonatomic,copy) NSString *personPic;
@property (nonatomic,copy) NSString *personId;
@property (nonatomic,copy) NSString *personName;
@property (nonatomic,copy) NSString *productId;

@property (weak, nonatomic) IBOutlet UIImageView *userImgv;  /**<被打赏人头像 */

@property (weak, nonatomic) IBOutlet UICollectionView *myConllection;
@property (weak, nonatomic) IBOutlet UIImageView *giftImg;  /**<礼物Img */
@property (weak, nonatomic) IBOutlet UILabel *giftNameLb;   /**<礼物名字 */
@property (weak, nonatomic) IBOutlet UILabel *giftCountLb;  /**<礼物数量 */
@property (weak, nonatomic) IBOutlet UIButton *cutBtn;      /**<减 */
@property (weak, nonatomic) IBOutlet UIButton *addBtn;      /**<加 */
@property (weak, nonatomic) IBOutlet UIButton *rewardBtn;   /**<打赏按钮 */
@property (weak, nonatomic) IBOutlet UILabel *tipsLb;

@property (nonatomic,assign) BOOL isRewardPop;


@property (nonatomic, strong) NSString *productType; //打赏类型
@property (strong, nonatomic) RewardOtherAmountCtl *rewardOtherAmountCtl;
@property (strong, nonatomic) RequestCon *rewardCon;//打赏连接

@end

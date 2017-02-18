//
//  ELRewardLuckyBagAnimationCtl.h
//  jobClient
//
//  Created by YL1001 on 15/12/24.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "ELBaseUIViewController.h"

@interface ELRewardLuckyBagAnimationCtl : ELBaseUIViewController
{
    
    IBOutlet UIView *_maskView;       //遮罩图层
    IBOutlet UIImageView *_bagView;   /**< 福袋图层 */
    IBOutlet UIImageView *_titleImgv; /**< 文字图层 */
    NSMutableArray  *_coinTagsArr;    /**< 存放生成的所有金币对应的tag值 */
}

- (void)initBagView;

@end

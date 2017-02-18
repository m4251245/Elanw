//
//  TagsOfAskDefaultCtl.h
//  jobClient
//
//  Created by YL1001 on 15/7/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "ExRequetCon.h"
#import "CustomButton.h"

#define Max_Character_Num 6;

@interface TagsOfAskDefaultCtl : BaseEditInfoCtl
{
    IBOutlet    UIView      *TFbackView;
    IBOutlet    UIButton    *addBtn;
    IBOutlet UILabel *_commonTags;
    IBOutlet UITextField *_groupTagTfView;/**< 输入框 */
    
    CustomButton *_tagBtn; /**< 标签按钮 */
    NSInteger lineNum;
    NSInteger lineNum2;
    NSString  *groupTags_;
}

@property (nonatomic, strong) NSMutableArray *tagViews;/**< 标签title数组 */
@property (nonatomic, strong) NSMutableArray *tagsMade;/**< 标签数组 */

@property (nonatomic, strong) NSMutableArray *subTagsMade;/**< 子标签数组 */
@property (nonatomic, strong) NSMutableArray *subTagViews;/**< 选中子标签数组 */

//@property (nonatomic, assign) BOOL focusOnAddTag;
@property (nonatomic,assign) BOOL fromTodayList;


@end

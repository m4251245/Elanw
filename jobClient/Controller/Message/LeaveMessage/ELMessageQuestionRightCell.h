//
//  ELMessageQuestionRightCell.h
//  jobClient
//
//  Created by YL1001 on 15/9/22.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELMessageQuestionRightCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *userBtn;       /**<头像 */
@property (strong, nonatomic) IBOutlet UIButton *backBtn;       /**<背景按钮 */

@property (strong, nonatomic) IBOutlet UIView *grayLine;
@property (strong, nonatomic) IBOutlet UILabel *titleLb;        /**<标题 */
@property (strong, nonatomic) IBOutlet UILabel *questionTitleLb;
@property (strong, nonatomic) IBOutlet UILabel *costLb;         /**<费用 */


@property (strong, nonatomic) IBOutlet UIView *quizzerView;     /**< 提问者背景View */
@property (strong, nonatomic) IBOutlet UIImageView *quizzerImg;   /**< 提问者头像 */
@property (strong, nonatomic) IBOutlet UILabel *quizzerName;    /**< 提问者名字 */
@property (strong, nonatomic) IBOutlet UILabel *quizzerJob;     /**< 提问者职业 */

@property (strong, nonatomic) IBOutlet UIView *answerView;      /**< 行家背景View */
@property (strong, nonatomic) IBOutlet UIImageView *answerImg;  /**< 行家头像 */
@property (strong, nonatomic) IBOutlet UILabel *answerName;     /** < 行家姓名 */
@property (strong, nonatomic) IBOutlet UILabel *answerJob;      /** < 行家职业 */

@property (strong, nonatomic) IBOutlet UILabel *TimeLb;         /** < 时间 */

- (void)giveDataModal:(LeaveMessage_DataModel *)modal;

@end

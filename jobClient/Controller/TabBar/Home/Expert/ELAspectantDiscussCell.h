//
//  ELAspectantDiscussCell.h
//  jobClient
//
//  Created by YL1001 on 15/9/4.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELAspectantDiscuss_Modal.h"

@interface ELAspectantDiscussCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *contentBgView_;

@property (strong, nonatomic) IBOutlet UILabel *titleLb_;  /**<标题 */
@property (strong, nonatomic) IBOutlet UILabel *costLb_;   /**<费用 */

@property (strong, nonatomic) IBOutlet UIView *quizzerView_;    /**<提问者背景View */
@property (strong, nonatomic) IBOutlet UIImageView *quizzerImg_;   /**<提问者头像 */
@property (strong, nonatomic) IBOutlet UILabel *quizzerName_;   /**<提问者名字 */
@property (strong, nonatomic) IBOutlet UILabel *quizzerJob_;    /**<提问者职业 */

@property (strong, nonatomic) IBOutlet UIView *answerView_;     /**<行家背景View */
@property (strong, nonatomic) IBOutlet UIImageView *answerImg_;   /**<行家头像 */
@property (strong, nonatomic) IBOutlet UILabel *answerName_;    /** <行家姓名 */
@property (strong, nonatomic) IBOutlet UILabel *answerJob_;     /** <行家职业 */

@property (strong, nonatomic) IBOutlet UILabel *TimeLb;         /** <时间 */
@property (weak, nonatomic) IBOutlet UIButton *stasuBtn;       /** <约谈进度 */



-(void)giveDataModel:(ELAspectantDiscuss_Modal *)dataModal;

@end

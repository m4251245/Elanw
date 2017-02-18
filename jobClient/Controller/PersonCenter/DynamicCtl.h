//
//  DynamicCtl.h
//  
//
//  Created by 一览ios on 15/10/31.
//
//

#import <UIKit/UIKit.h>
#import "User_DataModal.h"
#import "AppointmentCtl.h"

@protocol ArticleListCtlDelegate <NSObject>

@optional

- (void)addArticleInPersonCenterSuccess;

- (void)addGoodJobSuccess;

- (void)deleteArticleSuccess;

@end

@interface DynamicCtl : UIView

//需要传递的参数
@property(nonatomic,weak) id<ArticleListCtlDelegate> delegate;
@property(nonatomic, copy) NSString *otherUserId;
@property(nonatomic, copy) FinishLoadBlock finishBlock;

-(void)requestLoadData;

@end

//
//  ELSearchView.h
//  jobClient
//
//  Created by 一览ios on 16/4/15.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ELSearchViewDelegate <NSObject>

- (void)selectKeywordBtn:(UIButton *)btn;

@end

@interface ELSearchView : UIView<UITextFieldDelegate>

@property(nonatomic,weak) id <ELSearchViewDelegate> delegate;

@property(nonatomic, strong)UITextField *keyWordTF;
@property(nonatomic, strong)UIView *searchCon;


- (UIView *)configSearchViewType:(NSInteger)type;
//带关键字搜索
- (UIView *)configSearchViewWithKeywordArray:(NSArray *)keywordArr placeHolderArray:(NSArray *)placeHolderArr;
@end

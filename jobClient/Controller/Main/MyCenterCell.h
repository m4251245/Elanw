//
//  MyCenterCell.h
//  jobClient
//
//  Created by 一览ios on 15/7/29.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellClickDelegate <NSObject>

-(void)tapClicked:(NSIndexPath *)indexPath;
@end

@interface MyCenterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rightStatusLb;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgButtomLine;

@property (nonatomic, copy) NSIndexPath *indexPath;
@property (nonatomic,assign)id <CellClickDelegate>delagate;

//- (void)removeTapGestureRecognizer;

@end

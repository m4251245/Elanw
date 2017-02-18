//
//  YLAddressBookCell.h
//  jobClient
//
//  Created by 一览iOS on 15/6/18.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TKAddressBook.h"

@protocol AddressBookCellDelegate <NSObject>

-(void)inviteMessage:(TKAddressBook *)book;

@end

@interface YLAddressBookCell : UITableViewCell

@property (weak,nonatomic) id <AddressBookCellDelegate> addressBookDelegatte;

@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;


-(void)giveDateModal:(TKAddressBook *)book;

@end

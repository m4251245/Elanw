//
//  YLAddressBookCell.m
//  jobClient
//
//  Created by 一览iOS on 15/6/18.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "YLAddressBookCell.h"

@implementation YLAddressBookCell
{
    TKAddressBook *addressBook;
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)giveDateModal:(TKAddressBook *)book
{
    addressBook = book;
    if (book.thumbnail) {
        self.titleImage.hidden = NO;
        self.titleImage.image = book.thumbnail;
    }
    else
    {
        self.titleBtn.hidden = NO;
        [self.titleBtn setTitle:[book.name substringWithRange:NSMakeRange(book.name.length-1,1)] forState:UIControlStateNormal];
    }
    self.nameLb.text = book.name;
    if (book.haveInvite) {
        [self.inviteBtn setTitle:@"已邀请" forState:UIControlStateNormal];
        [self.inviteBtn setTitleColor:UIColorFromRGB(0xb9b9b9) forState:UIControlStateNormal];
        self.inviteBtn.userInteractionEnabled = NO;
    }
    else
    {
        [self.inviteBtn setTitle:@"邀请" forState:UIControlStateNormal];
        [self.inviteBtn setTitleColor:UIColorFromRGB(0xff5151) forState:UIControlStateNormal];
        self.inviteBtn.userInteractionEnabled = YES;
        [self.inviteBtn addTarget:self action:@selector(inviteBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}   
-(void)inviteBtn:(UIButton *)sender
{
    [_addressBookDelegatte inviteMessage:addressBook];
}

@end

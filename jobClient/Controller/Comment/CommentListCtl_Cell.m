//
//  CommentListCtl_Cell.m
//  MBA
//
//  Created by sysweal on 13-11-20.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "CommentListCtl_Cell.h"

@implementation CommentListCtl_Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataModal:(Comment_DataModal *)dataModal
{
    [_picBtn_ sd_setImageWithURL:[NSURL URLWithString:dataModal.author.img_] forState:UIControlStateNormal];
    _nameLb_.text = dataModal.author.iname_;
    NSString *dateStr = [[dataModal.datetime_ componentsSeparatedByString:@" "] firstObject];
    _dateLb_.text = dateStr;
    if (!self.contentLb) {
        self.contentLb = [[ELButtonView alloc] initWithFrame:CGRectMake(50,39,ScreenWidth-65,dataModal.cellHeight-70)];
        [self.contentView addSubview:self.contentLb];
    }
    self.contentLb.frame = CGRectMake(50,39,ScreenWidth-65,dataModal.cellHeight-70);
    [self.contentLb setContentColor:UIColorFromRGB(0x999999)];
    [self.contentLb setContentFont:THIRTEENFONT_CONTENT];
    self.contentLb.showLink = YES;
    self.contentLb.linkCanClick = YES;
    self.contentLb.clickDelegate = self;
    [self.contentLb setNumberlines:0];
    [self.contentLb setAttributedText:dataModal.contentAttString];
//    if ([dataModal.author.id_ isEqualToString:[Manager getUserInfo].userId_]) {
//        _deleteButton.hidden = NO;
//        _nameLbRight.constant = 45;
//    }else{
//        _deleteButton.hidden = YES;
//        _nameLbRight.constant = 15;
//    }
}

-(void)linkDelegateBtnRespone:(TextSpecial *)model{
    NSString *link = model.key;
    if (link && ![link isEqualToString:@""]) {
        NSArray *ylUrls = [[Manager shareMgr] getUrlArr];            
        for (NSString *url in ylUrls) {
            if ([link rangeOfString:url].location != NSNotFound) {
                PushUrlCtl *urlCtl = [[PushUrlCtl alloc]init];
                urlCtl.isThirdUrl = YES;
                urlCtl.hideShareButton = YES;
                [[Manager shareMgr].centerNav_ pushViewController:urlCtl animated:YES];
                if (![link hasPrefix:@"http://"]) {
                    link = [NSString stringWithFormat:@"http://%@",link];
                }
                [urlCtl beginLoad:link exParam:link];
                break;
            }
        }
    }
}

- (IBAction)deleteBtnClick:(UIButton *)sender{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除该条评论吗？" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"取消", nil];
//    [alert show];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定删除该条评论吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:deleteAction];
    [alert addAction:cancel];
    [[Manager shareMgr].centerNav_ presentViewController:alert animated:YES completion:nil];
 
}



@end

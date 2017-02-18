//
//  YLFriendListCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/6/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "YLFriendListCtl.h"

@interface YLFriendListCtl () <UIAlertViewDelegate>
{
    YLAddressBookListCtl *addressBookCtl;
}
@end

@implementation YLFriendListCtl

-(instancetype)init
{
    self = [super init];
    if (self) {
        bFooterEgo_ = NO;
        bHeaderEgo_ = NO;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"联系人";
    [self setNavTitle:@"联系人"];
    
    if (_isPop) {
        self.fd_interactivePopDisabled = YES;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(void)updateCom:(RequestCon *)con
{
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cellOne";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imageTitle = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,30,30)];
        imageTitle.clipsToBounds = YES;
        imageTitle.tag = 100;
        imageTitle.layer.cornerRadius = 4.0f;
        [cell.contentView addSubview:imageTitle];
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(50,15,ScreenWidth-80,20)];
        titleLable.font = FIFTEENFONT_TITLE;
        titleLable.tag = 200;
        [cell.contentView addSubview:titleLable];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0,49,ScreenWidth,1)];
        image.image = [UIImage imageNamed:@"gg_home_line2@2x.png"];
        [cell.contentView addSubview:image];
        
        UIImageView *imageRight = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30,20,7,13)];

        imageRight.image = [UIImage imageNamed:@"right_grey"];
        imageRight.tag = 1002;
        [cell.contentView addSubview:imageRight];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(35,5,12,12)];
        lable.clipsToBounds = YES;
        lable.font = [UIFont systemFontOfSize:10];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        lable.backgroundColor = PINGLUNHONG;
        lable.layer.cornerRadius = 7.0;
        lable.tag = 400;
        [cell.contentView addSubview:lable];
    }
    
    UIImageView *titleImage = (UIImageView *)[cell viewWithTag:100];
    UILabel *titleLb = (UILabel *)[cell viewWithTag:200];
    UILabel *redCountLb = (UILabel *)[cell viewWithTag:400];
    
    switch (indexPath.row) {
        case 0:
        {
            titleImage.image = [UIImage imageNamed:@"ylfriend.png"];
            titleLb.text = @"一览好友";
            redCountLb.hidden = YES;
        }
            break;
        case 1:
        {
            if (_phoneCount > 0)
            {
                redCountLb.hidden = NO;
//                if (_phoneCount > 99) {
//                    redCountLb.text = @"N";
//                }
//                else
//                {
//                    redCountLb.text = [NSString stringWithFormat:@"%ld",(long)_phoneCount];
//                }
            }
            else
            {
                redCountLb.hidden = YES;
            }
            titleImage.image = [UIImage imageNamed:@"addressbook.png"];
            titleLb.text = @"通讯录好友";
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    switch (indexPath.row) {
        case 0:
        {
            TheContactListCtl *contactCtl = [[TheContactListCtl alloc] init];
            [self.navigationController pushViewController:contactCtl animated:YES];
            [contactCtl beginLoad:nil exParam:nil];
        }
            break;
        case 1:
        {
            if ([MFMessageComposeViewController canSendText])
            {
                ABAddressBookRef addressBooks = nil;
                
                addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
                
                //获取通讯录权限
                
                dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                
                ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
                
                dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                
                BOOL accessStatus = [[Manager shareMgr] getAddressBookAccessStatusWithCancel:^{}];
                if (!accessStatus) {
                    return;
                }
                
                if (!addressBooks)
                {
                    return ;
                }
                BOOL isFirst = NO;
                if (!addressBookCtl)
                {
                    addressBookCtl = [[YLAddressBookListCtl alloc] init];
                    isFirst = YES;
                }
                addressBookCtl.whereForm = @"YLFRIEND";
                _phoneCount = 0;
                [tableView_ reloadData];
                [[Manager shareMgr].messageCenterListCtl refreshAddressBookRedDot];
                [self.navigationController pushViewController:addressBookCtl animated:YES];
                
                NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"addressBookTelephoneList"];
                NSArray *arrOne = [[NSUserDefaults standardUserDefaults] objectForKey:@"userListId"];
                NSString *currentPersonId = [[NSUserDefaults standardUserDefaults] objectForKey:@"addressBookCurrentPersonId"];
                if (arr == nil || arrOne == nil || ![arrOne containsObject:[Manager getUserInfo].userId_])
                {
                    
                }
                else if(isFirst || ![currentPersonId isEqualToString:[Manager getUserInfo].userId_])
                {
                    [BaseUIViewController showLoadView:YES content:nil view:nil];
                }
            }
            else
            {
               [BaseUIViewController showAlertView:@"设备没有短信功能" msg:nil btnTitle:@"关闭"];
            }
        }
            break;
        default:
            break;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

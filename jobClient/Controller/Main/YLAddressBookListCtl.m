//
//  YLAddressBookListCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/6/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "YLAddressBookListCtl.h"
#import "MessageContact_DataModel.h"


@interface YLAddressBookListCtl () <UISearchBarDelegate,MFMessageComposeViewControllerDelegate,AddFollowDelegate,AddressBookCellDelegate>
{
    NSMutableArray *allDataArr;
    NSMutableArray *listDataArr;
    IBOutlet UISearchBar *searchBar_;
    NSMutableArray *arrOtherData;
    IBOutlet UIView *updateView;
    __weak IBOutlet UIButton *updateBtn;
    
    __weak IBOutlet UIButton *agreeBtn;
    
    __weak IBOutlet UIButton *declarationBtn;
    
    RequestCon *updateCon;
    BOOL isUpdateAddressBook;
    IBOutlet UIView *searchMoreView;
    __weak IBOutlet UIButton *searchMoreBtn;
    NSMutableArray *ylArrListData;
    BOOL isCreatAdd;
    UIButton *followBtn;
    RequestCon *attentionCon_;
    NSMutableDictionary *phoneNameDic;
    RequestCon *sendCon;
    NSIndexPath *inviteIndexPath;
    RequestCon *inviteCon_;
}

@end

@implementation YLAddressBookListCtl

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        allDataArr = [[NSMutableArray alloc] init];
        listDataArr = [[NSMutableArray alloc] init];
        arrOtherData = [[NSMutableArray alloc] init];
        ylArrListData = [[NSMutableArray alloc] init];
        phoneNameDic = [[NSMutableDictionary alloc] init];
        tableView_.hidden = YES;
        searchBar_.hidden = YES;
        bHeaderEgo_ = NO;
        bFooterEgo_ = NO;
        isUpdateAddressBook = NO;
        isCreatAdd = YES;
        
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"addressBookTelephoneList"];
    NSArray *arrOne = [[NSUserDefaults standardUserDefaults] objectForKey:@"userListId"];
    NSString *currentPersonId = [[NSUserDefaults standardUserDefaults] objectForKey:@"addressBookCurrentPersonId"];
    if (arr == nil || arrOne == nil || ![arrOne containsObject:[Manager getUserInfo].userId_])
    {
        updateBtn.clipsToBounds = YES;
        updateBtn.layer.cornerRadius = 4.0;
        [self.view addSubview:updateView];
        updateView.frame = CGRectMake(0,0,ScreenWidth,CGRectGetHeight(self.view.frame));
    }
    else if(isCreatAdd || ![currentPersonId isEqualToString:[Manager getUserInfo].userId_])
    {
        [self creatAddressBook];
        [self changeUpdateNewAddressBook];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"通讯录好友";
    [self setNavTitle:@"通讯录好友"];
    // Do any additional setup after loading the view from its nib.
    searchBar_.delegate = self;
    searchBar_.tintColor = UIColorFromRGB(0xe13e3e);
    [updateBtn setBackgroundColor:PINGLUNHONG];
    [agreeBtn setImage:[UIImage imageNamed:@"addressbookok"] forState:UIControlStateNormal];
    agreeBtn.selected = YES;
}

-(BOOL)creatAddressBook
{
    [allDataArr removeAllObjects];
    NSMutableArray *addressBookTemp = [NSMutableArray array];
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
    
    //获取通讯录权限
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized)
    {
        [BaseUIViewController showAlertView:@"无权访问通讯录" msg:@"请在系统设置中设置访问权限" btnTitle:@"确定"];
        return NO;
    }
    
    if (!addressBooks)
    {
        return NO;
    }
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    [phoneNameDic removeAllObjects];
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        TKAddressBook *addressBook = [[TKAddressBook alloc] init];
        
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        NSString *name = [MyCommon removeEmojiString:nameString];
        NSInteger recordID = (int)ABRecordGetRecordID(person);
        
        if (name.length > 0) {
            addressBook.name = name;
            NSMutableString *source = [name mutableCopy];
            CFStringTransform((__bridge CFMutableStringRef)source,NULL, kCFStringTransformMandarinLatin,NO);
            CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
            addressBook.chineseName = [MyCommon removeAllSpace:source];
        }
        else
        {
            addressBook.name = @"#";
        }
        addressBook.recordID = recordID;
        
        if(ABPersonHasImageData(person))
        {
            NSData * imageData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(person,kABPersonImageFormatThumbnail);
            addressBook.thumbnail = [[UIImage alloc] initWithData:imageData];
        }
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        
        NSMutableArray *arrTel = [[NSMutableArray alloc] init];
        
        
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) {valuesCount = ABMultiValueGetCount(valuesRef);}
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        NSString *tel = (__bridge NSString*)value;
                        [arrTel addObject:tel];
                        //addressBook.tel = [tel telephoneWithReformat];
                        break;
                    }
                    case 1: {// Email
                        NSString *email = (__bridge NSString*)value;
                        addressBook.email = email;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        if (arrTel.count > 1) {
            for (NSString *str in arrTel) {
                TKAddressBook *book = [[TKAddressBook alloc] init];
                book.name = addressBook.name;
                book.thumbnail = addressBook.thumbnail;
                book.chineseName = addressBook.chineseName;
                book.email = addressBook.email;
                book.recordID = addressBook.recordID;
                book.tel = [MyCommon removePhoneNumberSpaceString:str];
                if ([MyCommon isMobile:book.tel]) {
                    [arrOtherData addObject:book];
                    [phoneNameDic setObject:book.name forKey:book.tel];
                }
            }
        }
        else if(arrTel.count == 1)
        {
            addressBook.tel = arrTel[0];
            addressBook.tel = [MyCommon removePhoneNumberSpaceString:addressBook.tel];
            if ([MyCommon isMobile:addressBook.tel]) {
                [addressBookTemp addObject:addressBook];
                [phoneNameDic setObject:addressBook.name forKey:addressBook.tel];
            }
        }
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
        
    }
    CFRelease(allPeople);
    CFRelease(addressBooks);
    
    [addressBookTemp addObjectsFromArray:arrOtherData];
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (TKAddressBook *addressBook in addressBookTemp) {
        NSInteger sect = [theCollation sectionForObject:addressBook
                                collationStringSelector:@selector(name)];
        addressBook.sectionNumber = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (NSInteger i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (TKAddressBook *addressBook in addressBookTemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
    }
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        [allDataArr addObject:sortedSection];
    }
    isCreatAdd = NO;
    return YES;
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void) errorGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type
{
    [super errorGetData:requestCon code:code type:type];
    if (type == Request_UpdateAddressBook || type == Request_AddressBookList) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_UpdateAddressBook:
        {
            [BaseUIViewController showLoadView:NO content:nil view:nil];
            YLAddressBookModal *modal = dataArr[0];
            if (isUpdateAddressBook) {
                if ([modal.status isEqualToString:@"OK"])
                {
                    [BaseUIViewController showAutoDismissAlertView:@"" msg:@"上传成功" seconds:1.0];
                    [ylArrListData removeAllObjects];
                    if (modal.phoneNumber.length > 0)
                    {
                        for (YLAddressBookModal *modalOne in dataArr) {
                            if ([phoneNameDic objectForKey:modalOne.phoneNumber]) {
                                [ylArrListData addObject:modalOne];
                            }
                        }
                    }
                    [self saveDateNsuserDefault];
                    [[NSUserDefaults standardUserDefaults] setObject:[Manager getUserInfo].userId_ forKey:@"addressBookCurrentPersonId"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    [BaseUIViewController showAutoDismissAlertView:@"" msg:@"通讯录上传失败" seconds:1.0];
                }
            }
            else
            {
                [BaseUIViewController showAutoDismissAlertView:@"" msg:@"加载完成" seconds:1.0];
                [ylArrListData removeAllObjects];
                if (modal.phoneNumber.length > 0) {
                    for (YLAddressBookModal *modalOne in dataArr) {
                        if ([phoneNameDic objectForKey:modalOne.phoneNumber]) {
                            [ylArrListData addObject:modalOne];
                        }
                    }
                }
                [self saveDateNsuserDefault];
            }
            [updateView removeFromSuperview];
            tableView_.hidden = NO;
            searchBar_.hidden = NO;
            [self removeAllYlFirend:[dataArr[0] arrListPhone]];
            [listDataArr removeAllObjects];
            [listDataArr addObjectsFromArray:allDataArr];
            [tableView_ reloadData];
        }
            break;
        case Request_AddressBookList:
        {
            [BaseUIViewController showLoadView:NO content:nil view:nil];
            YLAddressBookModal *modal = dataArr[0];
            if ([modal.status isEqualToString:@"OK"])
            {
                [BaseUIViewController showAutoDismissAlertView:@"" msg:@"加载完成" seconds:1.0];
                [updateView removeFromSuperview];
                tableView_.hidden = NO;
                searchBar_.hidden = NO;
                [self removeAllYlFirend:[dataArr[0] arrListPhone]];
                [listDataArr removeAllObjects];
                [listDataArr addObjectsFromArray:allDataArr];
                if (modal.phoneNumber.length > 0) {
                    for (YLAddressBookModal *modalOne in dataArr) {
                        if ([phoneNameDic objectForKey:modalOne.phoneNumber]) {
                            [ylArrListData addObject:modalOne];
                        }
                    }
                }
                [tableView_ reloadData];
                [[NSUserDefaults standardUserDefaults] setObject:[Manager getUserInfo].userId_ forKey:@"addressBookCurrentPersonId"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else
            {
                [BaseUIViewController showAutoDismissAlertView:@"" msg:@"加载失败" seconds:1.0];
            }
        }
            break;
        case Request_Follow:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"])
            {
                YLAddressBookModal *modal = requestCon_.dataArr_[followBtn.tag];
                modal.follow_rel = @"1";
                [followBtn setTitle:@"已添加" forState:UIControlStateNormal];
                [followBtn setBackgroundColor:[UIColor whiteColor]];
                [followBtn setTitleColor:UIColorFromRGB(0xb9b9b9) forState:UIControlStateNormal];
                followBtn.userInteractionEnabled = NO;
                followBtn.layer.borderColor = 0;
                followBtn.layer.borderColor = [UIColor whiteColor].CGColor;
                [BaseUIViewController showAutoDismissSucessView:@"添加成功" msg:nil seconds:0.5];
            }else{
                [BaseUIViewController showAutoDismissFailView:@"添加失败" msg:nil seconds:0.5];
            }
        }
            break;
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (searchBar_.text.length > 0 || section == 0) {
        return 0.1;
    }
    else
    {
        NSArray *arr = listDataArr[section-1];
        if ([arr count] > 0) {
            return 20;
        }
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 && ylArrListData.count > 3 && searchBar_.text.length == 0)
    {
        return 40;
    }
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 && ylArrListData.count > 3 && searchBar_.text.length == 0)
    {
        return searchMoreView;
    }
    UIView *view = [[UIView alloc] init];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    if (searchBar_.text.length > 0) {
        return view;
    }
    if(section > 0 && listDataArr.count > 0)
    {
        view.frame = CGRectMake(0,0,ScreenWidth,20);
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10,0,40,20)];
        lable.font = THIRTEENFONT_CONTENT;
        NSArray *arr = listDataArr[section-1];
        NSArray *arrOne = [[UILocalizedIndexedCollation currentCollation] sectionTitles];
        if (arr.count > 0) {
            lable.text = [arrOne objectAtIndex:section-1];
        }
        [view addSubview:lable];
        return view;
    }
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (searchBar_.text.length > 0) {
        return 1;
    }
    return listDataArr.count + 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searchBar_.text.length > 0) {
        return listDataArr.count;
    }
    if (section == 0)
    {
        if (ylArrListData.count > 3) {
            return 3;
        }
        return ylArrListData.count;
    }
    else
    {
        NSArray *arr = listDataArr[section-1];
        return [arr count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(searchBar_.text.length > 0 || indexPath.section >= 1)
    {
        static NSString *cellIdentifier = @"YLAddressBookCell";
        YLAddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YLAddressBookCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleImage.clipsToBounds = YES;
            cell.titleImage.layer.cornerRadius = 4.0f;
            cell.titleBtn.clipsToBounds = YES;
            cell.titleBtn.layer.cornerRadius = 4.0f;
            cell.nameLb.font = TWEELVEFONT_COMMENT;
        }
        
        cell.titleImage.hidden = YES;
        cell.titleBtn.hidden = YES;
        
        TKAddressBook *addressBook;
        if (searchBar_.text.length > 0) {
            addressBook = listDataArr[indexPath.row];
        }else
        {
            addressBook = listDataArr[indexPath.section-1][indexPath.row];
        }
        cell.addressBookDelegatte = self;
        addressBook.indexPath = indexPath;
        [cell giveDateModal:addressBook];
        return cell;
    }

    static NSString *cellStr = @"YLAddressBookTwoCell";
    YLAddressBookTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YLAddressBookTwoCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleImage.clipsToBounds = YES;
        cell.titleImage.layer.cornerRadius = 4.0f;
        cell.nameLb.font = TWEELVEFONT_COMMENT;
        cell.contentLable.font = FOURTEENFONT_CONTENT;
    }
    YLAddressBookModal *modal = ylArrListData[indexPath.row];
    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:modal.pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    
    cell.nameLb.text = [NSString stringWithFormat:@"手机联系人：%@",[phoneNameDic objectForKey:modal.phoneNumber]];
    cell.contentLable.text = modal.name;
    
    if (![modal.follow_rel isEqualToString:@"1"] || [_whereForm isEqualToString:@"GROUP"]) {
        [cell.addBtn setBackgroundColor:UIColorFromRGB(0xfafafa)];
        [cell.addBtn setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
        if ([_whereForm isEqualToString:@"GROUP"]) {
            [cell.addBtn setTitle:@"邀请" forState:UIControlStateNormal];
        }
        else
        {
            [cell.addBtn setTitle:@"添加" forState:UIControlStateNormal];
        }
        cell.addBtn.userInteractionEnabled = YES;
        cell.addBtn.tag = indexPath.row;
        [cell.addBtn addTarget:self action:@selector(addFollew:) forControlEvents:UIControlEventTouchUpInside];
        cell.addBtn.layer.borderWidth = 1.0;
        cell.addBtn.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
        cell.addBtn.clipsToBounds = YES;
        cell.addBtn.layer.cornerRadius = 3.0;
    }
    else
    {
        cell.addBtn.userInteractionEnabled = NO;
        [cell.addBtn setBackgroundColor:[UIColor whiteColor]];
        [cell.addBtn setTitle:@"已添加" forState:UIControlStateNormal];
        [cell.addBtn setTitleColor:UIColorFromRGB(0xb9b9b9) forState:UIControlStateNormal];
        cell.addBtn.layer.borderColor = 0;
        cell.addBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    }

    return cell;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    if ([_whereForm isEqualToString:@"GROUP"]) {
        return;
    }
    if (indexPath.section == 0 && searchBar_.text.length == 0) {
        YLAddressBookModal *dataModal = ylArrListData[indexPath.row];
        MessageContact_DataModel *modal = [[MessageContact_DataModel alloc] init];
        modal.userId = dataModal.personId;
        modal.userIname = dataModal.name;
        MessageDailogListCtl *ctl = [[MessageDailogListCtl alloc]init];
        [self.navigationController pushViewController:ctl animated:YES];
        [ctl beginLoad:modal exParam:nil];
        
        if (!sendCon) {
            sendCon = [self getNewRequestCon:NO];
        }
        [sendCon sendAddressBookFriend:[Manager getUserInfo].userId_ contactId:dataModal.personId];
    }
}

-(void)addFollew:(UIButton *)sender
{
    YLAddressBookModal *modal = ylArrListData[sender.tag];
    if ([_whereForm isEqualToString:@"GROUP"])
    {
        if ([modal.group_rel isEqualToString:@"20"]) {
            [BaseUIViewController showAlertView:@"该联系人已经是社群成员" msg:nil btnTitle:@"确定"];
            return;
        }
        if (!inviteCon_) {
            inviteCon_ = [self getNewRequestCon:NO];
        }
        [inviteCon_ inviteFans:_groupModal.id_ userId:[Manager getUserInfo].userId_ fansId:modal.personId];
        [BaseUIViewController showAutoDismissSucessView:@"发送邀请成功" msg:nil];
        return;
    }
    followBtn = sender;
    if (!attentionCon_) {
        attentionCon_ = [self getNewRequestCon:NO];
    }
    [attentionCon_ followExpert:[Manager getUserInfo].userId_ expert:modal.personId];
}

-(void)inviteMessage:(TKAddressBook *)book
{
    inviteIndexPath = book.indexPath;
    NSString *content = @"";
    if ([_whereForm isEqualToString:@"YLFRIEND"]) {
        content = [NSString stringWithFormat:@"再累,也要跑步;再忙,也要学习;是坚持,也是信仰.我在一览等你“ + ”http://m.yl1001.com/apps/?p=TWZJ001"];
    }
    else if([_whereForm isEqualToString:@"GROUP"])
    {
        content = [NSString stringWithFormat:@"我邀请您加入一览社群:“%@”（群号：%@）,这里有很多志同道合的朋友,现在请您参与讨论。请访问各应用市场或者点击链接下载一览APP，并搜索加入本社群:http://m.yl1001.com/group/v/%@/",_groupModal.name_,_groupModal.groupCode_,_groupModal.id_];;
    }
    [self displaySMSComposerSheet:book.tel content:content];
}

-(void)displaySMSComposerSheet:(NSString*)tel content:(NSString*)content
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    if (IOS8) {
        
    }
    else
    {
        [picker.navigationBar setTintColor:[UIColor whiteColor]];
    }
    
    picker.messageComposeDelegate = self;
    
    picker.recipients = [[NSArray alloc] initWithObjects:tel, nil];
    picker.body=content;
    
    [self presentViewController:picker animated:YES completion:^{}];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:NO completion:^{}];
    switch (result)
    {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultSent:
        {
            TKAddressBook *addressBook;
            if (searchBar_.text.length > 0) {
                addressBook = listDataArr[inviteIndexPath.row];
            }else
            {
                addressBook = listDataArr[inviteIndexPath.section-1][inviteIndexPath.row];
            }
            addressBook.haveInvite = YES;
            [tableView_ reloadData];
        }
            break;
        case MessageComposeResultFailed:
            break;
        default:
            
            break;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    [searchBar_ resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 0)
    {
        [listDataArr removeAllObjects];
        for (NSArray *arr in allDataArr) {
            for (TKAddressBook *addBook in arr)
            {
                if([addBook.name containsString:searchText])
                {
                    [listDataArr addObject:addBook];
                }
                else if([addBook.chineseName hasPrefix:searchText])
                {
                    [listDataArr addObject:addBook];
                }
            }
        }
    }
    else
    {
        [listDataArr removeAllObjects];
        [listDataArr addObjectsFromArray:allDataArr];
    }
    [tableView_ reloadData];
}

#pragma mark - SearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
}

-(void)changeUpdateOne
{
    if ([self creatAddressBook])
    {
        [self updateAddressBook];
    }
}

-(void)btnResponse:(id)sender
{
    if (sender == updateBtn)
    {
        if (!agreeBtn.selected) {
            return;
        }
        [BaseUIViewController showLoadView:YES content:nil view:nil];
        [self performSelector:@selector(changeUpdateOne) withObject:nil afterDelay:0.2];
    }
    else if(sender == agreeBtn)
    {
        if (agreeBtn.selected) {
            [updateBtn setBackgroundColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0]];
            [agreeBtn setImage:[UIImage imageNamed:@"addressbookno"] forState:UIControlStateNormal];
            agreeBtn.selected = NO;
        }
        else
        {
            [updateBtn setBackgroundColor:PINGLUNHONG];
            [agreeBtn setImage:[UIImage imageNamed:@"addressbookok"] forState:UIControlStateNormal];
            agreeBtn.selected = YES;
        }
    }
    else if (sender == declarationBtn)
    {
        YLAddressBookDeclarationCtl *ctl = [[YLAddressBookDeclarationCtl alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if(sender == searchMoreBtn)
    {
        YLAddressBookMoreCtl *ctl = [[YLAddressBookMoreCtl alloc] init];
        [ctl beginLoad:nil exParam:nil];
        ctl.addFollowDelegate = self;
        ctl.listDataDic = phoneNameDic;
        ctl.whereForm = _whereForm;
        ctl.groupModal = _groupModal;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

-(void)addressBookAddFollew:(NSString *)personId
{
    NSInteger i = 0;
    if (ylArrListData.count >= 3) {
        i = 3;
    }
    else
    {
        i = ylArrListData.count;
    }
    
    for (NSInteger k = 0; k < i; k++)
    {
        YLAddressBookModal *modal = ylArrListData[k];
        if ([modal.personId isEqualToString:personId]) {
            modal.follow_rel = @"1";
        }
    }
    [tableView_ reloadData];
}

-(void)removeAllYlFirend:(NSMutableArray *)arrData
{
    NSMutableArray *arrList = [[NSMutableArray alloc] init];
    for (NSArray *arr in allDataArr)
    {
        NSMutableArray *arrOne = [[NSMutableArray alloc] init];
        for (TKAddressBook *book in arr) {
            if([arrData containsObject:book.tel])
            {
                
            }
            else
            {
                [arrOne addObject:book];
            }
        }
        [arrList addObject:arrOne];
    }
    
    [allDataArr removeAllObjects];
    [allDataArr addObjectsFromArray:arrList];
}

-(void)changeUpdateNewAddressBook
{
    NSArray *arrOne = [[NSUserDefaults standardUserDefaults] objectForKey:@"addressBookTelephoneList"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (NSArray *arr in allDataArr) {
        for (TKAddressBook *book in arr)
        {
            if (![arrOne containsObject:book.tel]) {
                [dic setObject:book.name forKey:book.tel];
            }
        }
    }
    for (TKAddressBook *book in arrOtherData) {
        if (![arrOne containsObject:book.tel]) {
            [dic setObject:book.name forKey:book.tel];
        }
    }
    if (!updateCon) {
        updateCon = [self getNewRequestCon:NO];
    }
    NSString *groupId = @"";
    if ([_whereForm isEqualToString:@"GROUP"]) {
        groupId = _groupModal.id_;
    }
    if ([dic count] > 0) {
        [updateCon updateAddressBook:dic IsFirst:NO personId:[Manager getUserInfo].userId_ ylPerson:YES groupId:groupId];
    }
    else
    {
        [updateCon addressBookListPage:requestCon_.pageInfo_.currentPage_ pageSize:15 personId:[Manager getUserInfo].userId_ ylPerson:YES groupId:groupId];
    }
}

-(void)updateAddressBook
{
    isUpdateAddressBook = YES;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    for (NSArray *arr in allDataArr) {
        for (TKAddressBook *book in arr)
        {
            [dic setObject:book.name forKey:book.tel];
        }
    }
    for (TKAddressBook *book in arrOtherData) {
        [dic setObject:book.name forKey:book.tel];
    }
    
    if (!updateCon) {
        updateCon = [self getNewRequestCon:NO];
    }
    NSString *groupId = @"";
    if ([_whereForm isEqualToString:@"GROUP"]) {
        groupId = _groupModal.id_;
    }
    [updateCon updateAddressBook:dic IsFirst:YES personId:[Manager getUserInfo].userId_ ylPerson:YES groupId:groupId];
}

-(void)saveDateNsuserDefault
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arrData = [[NSMutableArray alloc] init];
    NSMutableArray *arrUserList = [user objectForKey:@"userListId"];
    NSMutableArray *arrUserListOne = [[NSMutableArray alloc] init];
    [arrUserListOne addObjectsFromArray:arrUserList];
    [arrUserListOne addObject:[Manager getUserInfo].userId_];
    
    if (allDataArr.count > 0) {
        for (NSArray *arr in allDataArr) {
            for (TKAddressBook *book in arr)
            {
                [arrData addObject:book.tel];
            }
        }
    }
    if (arrOtherData.count > 0) {
        for (TKAddressBook *book in arrOtherData) {
            [arrData addObject:book.tel];
        }
    }
    [user setObject:arrData forKey:@"addressBookTelephoneList"];
    [user setObject:arrUserListOne forKey:@"userListId"];
    [user synchronize];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

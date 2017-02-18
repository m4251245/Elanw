//
//  InviteFansCtl.m
//  Association
//
//  Created by YL1001 on 14-5-12.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "InviteFansCtl.h"
#import "InviteFansCtl_Cell.h"
#import "ELSameTradePeopleFrameModel.h"

#import "GroupsInviteCtl.h"

#import "ELGroupDetailModal.h"

@interface InviteFansCtl () <UISearchBarDelegate>
{
    int selectIndex_;
    BOOL showKeyBoard;
    BOOL isSearch;
    BOOL isFresh;
}

@property (nonatomic,strong) NSMutableArray *arrImageData;
@property (nonatomic,strong) NSMutableArray *arrImage;
@property (nonatomic,strong) NSMutableArray *arrListData;
@property (nonatomic,strong) NSMutableArray *arrOldData;

@end

@implementation InviteFansCtl

-(id)init
{
    self = [super init];
    
    imageConArr_ = [[NSMutableArray alloc] init];
    bFooterEgo_ = YES;
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationItem.title = @"一览站内邀请";
   
    _searchBar.text = @"";
    isSearch = NO;
    [_arrImageData removeAllObjects];
    [self addImageData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"一览站内邀请";
    [self setNavTitle:@"一览站内邀请"];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    _searchBar.delegate = self;
    _searchBar.tintColor = UIColorFromRGB(0xe13e3e);
    _searchBar.backgroundColor = [UIColor whiteColor];
    _arrImageData = [[NSMutableArray alloc] init];
    _arrImage = [[NSMutableArray alloc] init];
    _arrListData = [[NSMutableArray alloc] init];
    _arrOldData = [[NSMutableArray alloc] init];
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
    _inviteBtn.layer.borderWidth = 1.0f;
    _inviteBtn.layer.borderColor = UIColorFromRGB(0xe13e3e).CGColor;
    _inviteBtn.clipsToBounds = YES;
    _inviteBtn.layer.cornerRadius = 5.0f;
    showKeyBoard = NO;
    isSearch = NO;
    isFresh = YES;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    inModal_ = dataModal;
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    NSString *searchStr = @"";
    if (isSearch) {
        searchStr = _searchBar.text;
    }
    NSString *groupId = @"";
    if (inModal_.id_) {
        groupId = inModal_.id_;
    }
    else if(_myDataModal.group_id){
        groupId = _myDataModal.group_id;
    }
    [con getFriendWithUserId:[Manager getUserInfo].userId_ pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:15 groupId:groupId personIname:searchStr];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_Image:
        {
            @try {
                for (Expert_DataModal * dataModal in requestCon_.dataArr_) {
                    if (![dataModal.img_ isEqual:[NSNull null]]) {
                        if ([dataModal.img_ isEqualToString:requestCon.url_]) {
                            dataModal.imageData_ = [dataArr objectAtIndex:0];
                        }
                    }
                }
                [imageConArr_ removeObject:requestCon];
                [tableView_ reloadData];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
            break;
        case Request_InviteFans:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.code_ isEqualToString:@"200"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        case Request_GetFriend:
            [_arrListData removeAllObjects];
            [_arrListData addObjectsFromArray:requestCon_.dataArr_];
            [self isImageData:_arrListData];
            [tableView_ reloadData];
            break;
        default:
            break;
    }
}
-(void)isImageData:(NSMutableArray *)arr;
{
    for (ELSameTradePeopleFrameModel *data in arr) {
        data.isHaveInvite = NO;
        for (ELSameTradePeopleFrameModel *dataOne in _arrImageData) {
            if ([dataOne.peopleModel.personId isEqualToString:data.peopleModel.personId]) {
                data.isHaveInvite = YES;
                break;
            }
        }
    }
}

-(void)addImageData
{
    for (UIImageView *image in _imageScroll.subviews) {
        [image removeFromSuperview];
    }
    
    self.imageScroll.contentSize = CGSizeMake(40 * _arrImageData.count,40);
    
    for (NSInteger i = 0;i < _arrImageData.count ; i++)
    {
        ELSameTradePeopleFrameModel *dataModal = _arrImageData[i];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5+35*i,5,30,30)];
        [self.imageScroll addSubview:image];
        [image sd_setImageWithURL:[NSURL URLWithString:dataModal.peopleModel.person_pic] placeholderImage:nil];
    }
    
    [tableView_ reloadData];
}

-(void)btnResponse:(id)sender
{
    if ([_myDataModal.member_invite boolValue]) {
        GroupsInviteCtl * groupInviteCtl_ = [[GroupsInviteCtl alloc] init];
        [self.navigationController pushViewController:groupInviteCtl_ animated:YES];
        [groupInviteCtl_ beginLoad:_myDataModal exParam:nil];
    }
    else {
        [BaseUIViewController showAutoDismissSucessView:nil msg:@"您还没有邀请权限\n请联系社长吧！"];
    }
}

- (IBAction)surebtnClick:(id)sender {
    if (!inviteCon_)
    {
        inviteCon_ = [self getNewRequestCon:NO];
    }
    if(_arrImageData.count)
    {
        ELSameTradePeopleFrameModel * dataModal = _arrImageData[0];
        NSString *str = dataModal.peopleModel.personId;
        for (NSInteger i = 1; i< _arrImageData.count; i++)
        {
            ELSameTradePeopleFrameModel * dataModal = _arrImageData[i];
            str = [str stringByAppendingString:[NSString stringWithFormat:@",%@",dataModal.peopleModel.personId]];
        }
        [inviteCon_ inviteFans:inModal_.id_ userId:[Manager getUserInfo].userId_ fansId:str];
        [BaseUIViewController showAutoDismissSucessView:@"发送邀请成功" msg:nil];
    }
    else
    {
        [BaseUIViewController showAlertView:@"提示" msg:@"请选择听众" btnTitle:@"确定"];
    }

}

#pragma mark - UITableViewDelegate

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InviteFansCtl_Cell";
    
    InviteFansCtl_Cell *cell = (InviteFansCtl_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InviteFansCtl_Cell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.imgView_.clipsToBounds = YES;
        cell.imgView_.layer.cornerRadius = 5.0f;
        cell.imageInvite.layer.borderWidth = 1.0f;
        cell.imageInvite.clipsToBounds = YES;
        cell.imageInvite.layer.cornerRadius = cell.imageInvite.frame.size.height/2;
        
        cell.leftWidth.constant = 36;
        cell.rightWidth.constant = 0;
        cell.imageInvite.hidden = NO;
        cell.rightImageView.hidden = YES;
    }
    ELSameTradePeopleFrameModel * dataModal = _arrListData[indexPath.row];
    
    if ([dataModal.peopleModel.person_iname isKindOfClass:[NSNumber class]] || [dataModal.peopleModel.person_iname isMemberOfClass:[NSNumber class]]) {
        dataModal.peopleModel.person_iname = @"未命名";
    }
    @try {
        cell.nameLb_.text = dataModal.peopleModel.person_iname;
    }
    @catch (NSException *exception) {
        cell.nameLb_.text = @"未命名";
    }
    @finally {
        
    }
    [cell giveDataWithModal:dataModal];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrListData.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!showKeyBoard) {
        ELSameTradePeopleFrameModel *dataModal;
        
        dataModal = _arrListData[indexPath.row];
        if (![dataModal.peopleModel.is_group_member isEqualToString:@"1"]) {
            if (dataModal.isHaveInvite == YES)
            {
                dataModal.isHaveInvite = NO;
                for (ELSameTradePeopleFrameModel *data in _arrImageData) {
                    if ([data.peopleModel.personId isEqualToString:dataModal.peopleModel.personId]) {
                        [_arrImageData removeObject:data];
                        break;
                    }
                }
            }
            else
            {
                dataModal.isHaveInvite = YES;
                [_arrImageData addObject:dataModal];
            }
            [self addImageData];
        }
    }
    else
    {
        [_searchBar resignFirstResponder];
    }
}

#pragma mark - SearchBarDelegate

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (isSearch && [searchBar.text isEqualToString:@""]) {
        isSearch = NO;
        [self refreshLoad:nil];
    }
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = [MyCommon removeAllSpace:searchBar.text];
    
    isSearch = YES;
    
    [self refreshLoad:nil];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    showKeyBoard = YES;
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    showKeyBoard = NO;
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

-(void)hideKeyboard
{
    [_searchBar resignFirstResponder];
}

@end

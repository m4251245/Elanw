//
//  ELAboutOfferPartyCtl.m
//  jobClient
//
//  Created by YL1001 on 16/11/4.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELAboutOfferPartyCtl.h"
#import "NSString+Size.h"

@interface ELAboutOfferPartyCtl ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_textInfo;
}
@end

@implementation ELAboutOfferPartyCtl

- (void)viewDidLoad {
    
    self.headerRefreshFlag = NO;
    self.footerRefreshFlag = YES;
    self.showNoDataViewFlag = YES;
    self.showNoMoreDataViewFlag = YES;
    [super viewDidLoad];
    
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    mainTableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:mainTableView];
    self.tableView = mainTableView;
    
    [self addNotify];
}

- (UIView *)configView
{
    _textInfo =@"    一览Offer派是一款定制的招聘服务，以效果为导向，对企业及人才的需求进行匹配，简化HR招聘工作，降低企业人才招聘成本，解决专业人才求职难题，为企业实现“四小时解决一个月的招聘工作”，助人才上岗优质岗位是Offer派的目标；\n\n三大特色服务：\n\n1.个性化移动服务，智能推荐渠道，随身服务平台；\n\n2.多家企业联合招聘团购化，特定岗位招聘，多家优质企业入场；\n\n3.效果付费，企业免费入场，上岗结算，省时高效性价比高；\n\n\n服务热线：400-884-1001";
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, self.view.frame.size.height)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel *infoLb = [[UILabel alloc] initWithFrame:CGRectMake(14, 13, backView.frame.size.width - 28, self.view.frame.size.height)];
    infoLb.numberOfLines = 0;
    infoLb.font = [UIFont systemFontOfSize:14.0f];
    infoLb.textColor = UIColorFromRGB(0x616161);
    infoLb.backgroundColor = [UIColor clearColor];
    infoLb.text = _textInfo;
    [infoLb sizeToFit];
    [backView addSubview:infoLb];
    
    CGRect frame = backView.frame;
    frame.size.height = infoLb.frame.size.height + 30;
    backView.frame = frame;
    
    return backView;
}
#pragma mark - 代理
#pragma mark--UItableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
    
    [cell.contentView addSubview:[self configView]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = [_textInfo sizeNewWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(ScreenWidth-28, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    return cellSize.height;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {//从顶部离开的一瞬间发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil userInfo:@{@"canScroll":@"1"}];
    }
    self.tableView = (UITableView *)scrollView;
}

- (void)beginLoad:(id)param exParam:(id)exParam
{
    [super beginLoad:param exParam:exParam];
}

#pragma mark - 通知
-(void)addNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"goTop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"leaveTop" object:nil];
}

-(void)notify:(NSNotification *)notify
{
    NSString *notificationName = notify.name;
    
    if ([notificationName isEqualToString:@"goTop"]) {
        NSDictionary *userInfo = notify.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
            self.tableView.showsVerticalScrollIndicator = YES;//处理右侧滚动条，自己观察
        }
    }else if([notificationName isEqualToString:@"leaveTop"]){
        self.tableView.contentOffset = CGPointZero;
        self.canScroll = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

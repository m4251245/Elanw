//
//  UserHYListCtl.m
//  jobClient
//
//  Created by YL1001 on 14-8-13.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "UserHYListCtl.h"

@interface UserHYListCtl ()
{
    NSArray * hyArr_;
    NSInteger     chooseIndex_;
}

@end

@implementation UserHYListCtl
@synthesize delegate_;
-(id)init
{
    self = [super init];
    
    bHeaderEgo_ = NO;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"行业/职业";
    [self setNavTitle:@"行业/职业"];
    //hyArr_ = [NSArray arrayWithObjects:@"经营管理类",@"销售类",@"市场/策划/推广类",@"项目管理类",@"人力资源类",@"行政管理类",@"信息技术管理/集成/运行维护类",@"手机/通信技术类",@"互联网/网络应用类",@"计算机/IT类",@"财务/审计/统计类", @"生产管理类",@"汽车/汽配/驾培类",@"矿产/地质/钢铁/冶金类",@"油田生产技术类",@"技术支持/客服类",@"品质/质检类",@"暖通/空调/制冷类",@"监理/造价/招投标",@"机械/机电设备/仪器仪表类",@"房产开发/中介/物业",@"建筑/施工/安装",@"建筑设计类",@"测绘/地质/水文/勘探/矿井",@"园林/景观/绿化/园艺类",@"路桥/隧道/桥梁类",@"建筑试验/检测/安全管理",@"装饰/幕墙类",@"电气/自动化类",@"电力/能源类",@"水利/水电类",@"电源/电池/照明类",@"光伏/太阳能/光电类",@"煤炭/煤化工/煤焦化类",@"化工技术类",@"环保工程类",@"服装/纺织/皮革类",@"珠宝/首饰类",@"陶瓷/洁具/轻工类",@"包装/印刷/造纸类",@"生物/制药/医疗器械类",@"医院/医疗/护理类",@"美容/保健类",@"农/林/牧/渔类",@"证券/金融/投资类",@"银行/保险类",@"广告/设计类",@"影视/媒体类",@"酒店/餐饮/旅游/娱乐类",@"百货/连锁/零售类",@"保安/家政服务类",@"文教类",@"律师/法务/合规类",@"咨询/顾问类",@"采购类",@"贸易/进出口类",@"物流/仓储类",@"车间技工类",@"公关/媒介类",@"翻译类",@"储备干部",nil];
    
    hyArr_ = [NSArray arrayWithObjects:@"新能源/电力/电气/光电照明",@"石油化工",@"机电机械",@"土木/建筑/房地产",@"建材家居",@"包装印刷",@"采矿冶炼",@"环保水务水利",@"商贸百货",@"金融银行",@"卫生医疗", @"IT/通讯/电子/互联网",@"农林牧渔",@"文化产业",@"纺织服装",@"食品饮料",@"物流运输",@"酒店/旅游/生活服务",nil];
   
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [tableView_ reloadData];
}

#pragma UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [hyArr_ count];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    cell.textLabel.text = [hyArr_ objectAtIndex:indexPath.row];
    
    return cell;

}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    if (!userZYListCtl_) {
        userZYListCtl_ = [[UserZYListCtl alloc] init];
        userZYListCtl_.delegate_ = self;
    }
    [self.navigationController pushViewController:userZYListCtl_ animated:YES];
    chooseIndex_ = indexPath.row;
    NSString * row = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    userZYListCtl_.type_ = 2;
    userZYListCtl_.index_ = indexPath.row;
    [userZYListCtl_ beginLoad:row exParam:nil];
}


#pragma ChooseZyDelegate
-(void)chooseZy:(NSString *)zyeStr
{
    [self.navigationController popViewControllerAnimated:YES];
    [delegate_ chooseHy:[hyArr_ objectAtIndex:chooseIndex_] zy:zyeStr];
}


-(void)backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
    [delegate_ backToReg];
    
}
@end

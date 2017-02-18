//
//  AppointmentCtl.m
//  
//
//  Created by 一览ios on 15/11/1.
//
//

#import "AppointmentCtl.h"
#import "ELAspectantDiscuss_Modal.h"
#import "ELCreateCourseCtl.h"
#import "ELExpertCourseListCtl.h"
#import "ELAspDisServiceDetailCtl.h"
#import "ELCreateCourseCell.h"

@interface AppointmentCtl ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableView_;
}
@end

@implementation AppointmentCtl

-(void)dealloc
{

}

-(instancetype)init{
    self = [super init];
    if (self) {
        tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,self.height) style:UITableViewStylePlain];
        tableView_.delegate = self;
        tableView_.dataSource = self;
        tableView_.bounces = NO;
        tableView_.scrollEnabled = NO;
        tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView_];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editorSuccessRefresh:) name:@"COURSEEDITORSUCCESS" object:nil];
    }
    return self;
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = UIColorFromRGB(0xEFEFF4);
    if(![_otherUserId isEqualToString:[Manager getUserInfo].userId_]){
        headView.frame = CGRectMake(0,0,ScreenWidth,10);
    }else{
        headView.frame = CGRectMake(0,0,ScreenWidth,64);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8,10,ScreenWidth-16,44)];
        label.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        label.text = @"＋ 添加约谈";
        label.layer.borderColor = UIColorFromRGB(0xe0e0e0).CGColor;
        label.layer.borderWidth = 1.0;
        label.textColor = UIColorFromRGB(0xe13e3e);
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addLableClick:)]];
        [headView addSubview:label];
    }
    tableView_.tableHeaderView = headView;
    [self requestData];
}

-(void)editorSuccessRefresh:(NSNotification *)notification{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self requestData];
    });
}

-(void)requestData{
    NSString * function = @"getUserzoneCourse_list";
    NSString * op = @"salarycheck_all_new_busi";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"searchArr={\"user_id\":\"%@\",\"login_person_id\":\"%@\"}&", _otherUserId, [Manager getUserInfo].userId_];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        NSArray *dataArr = dic[@"data"];
        _dataArr = [NSMutableArray arrayWithCapacity:4];
        CGFloat height = 41;
        BOOL isNoData = YES;
        if ([dataArr isKindOfClass:[NSArray class]]) {
            isNoData = NO;
            for (NSDictionary *dic in dataArr) {
                ELAspectantDiscuss_Modal *model = [[ELAspectantDiscuss_Modal alloc]init];
                model.course_id = dic[@"course_id"];
                model.dis_personId = dic[@"person_id"];
                model.course_title = dic[@"course_title"];
                model.course_price = dic[@"course_price"];
                model.course_long = dic[@"course_long"];
                model.personCount = dic[@"course_yuetan_cnt"];
                model.course_info = dic[@"course_intro"];
                model.status = @"一对一";
                model.course_status = dic[@"course_status"];
                model.quizzerIntro = @"一个工作日内回应";
                [_dataArr addObject:model];
            }
        }
        [tableView_ reloadData];
        height = tableView_.contentSize.height;
        tableView_.frame = CGRectMake(0,0,ScreenWidth,height);
        if (_finishBlock) {
            CGRect frame = self.frame;
            frame.size.height = height;
            frame.size.width = ScreenWidth;
            self.frame = frame;
            
            _finishBlock(height, isNoData);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![_otherUserId isEqualToString:[Manager getUserInfo].userId_]){
        return 172;
    }
    return 199;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ELCreateCourseCell";
    ELCreateCourseCell *cell = (ELCreateCourseCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ELCreateCourseCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    ELAspectantDiscuss_Modal *dataModal = _dataArr[indexPath.row];
    
    cell.titleLb.text = dataModal.course_title;
    cell.contentLb.text = dataModal.course_info;
    cell.personCount.text = dataModal.personCount;
    cell.courseTime.text = [NSString stringWithFormat:@"%@小时",dataModal.course_long];
    cell.coursePrice.text = [NSString stringWithFormat:@"￥%@元/次",dataModal.course_price];
    
    if(![_otherUserId isEqualToString:[Manager getUserInfo].userId_]){
        cell.status.hidden = YES;
    }else{
        switch ([dataModal.course_status integerValue]) {
            case 0:
            {
                cell.status.hidden = NO;
                [cell.status setTitle:@"审核中" forState:UIControlStateNormal];
                cell.contentBgView.backgroundColor = UIColorFromRGB(0xBCBCBC);
            }
                break;
            case 1:
            {
                [cell.status setTitle:@"通过审核" forState:UIControlStateNormal];
            }
                break;
            case 5:
            {
                [cell.status setTitle:@"不合格" forState:UIControlStateNormal];
                cell.contentBgView.backgroundColor = UIColorFromRGB(0xBCBCBC);
            }
                break;
            case 7:
            {
                [cell.status setTitle:@"草稿" forState:UIControlStateNormal];
                cell.contentBgView.backgroundColor = UIColorFromRGB(0xBCBCBC);
            }
                break;
            default:
                break;
        }
    }
    return cell;
}

#pragma mark 截取小数点后面的0
- (NSString *)cutZero:(NSString *)numStr
{
    if (![numStr containsString:@"."]) {
        return numStr;
    }
    NSString * s = nil;
    NSInteger offset = numStr.length - 1;
    while (offset)
    {
        s = [numStr substringWithRange:NSMakeRange(offset, 1)];
        if ([s isEqualToString:@"0"] || [s isEqualToString:@"."])
        {
            offset--;
        }
        else
        {
            break;
        }
    }
    NSString * outNumber = [numStr substringToIndex:offset+1];
    return outNumber;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ELAspDisServiceDetailCtl *aspDetailCtl = [[ELAspDisServiceDetailCtl alloc] init];
    ELAspectantDiscuss_Modal *model = _dataArr[indexPath.row];
    aspDetailCtl.backIndex = [Manager shareMgr].centerNav_.viewControllers.count-1;
    [[Manager shareMgr].centerNav_ pushViewController:aspDetailCtl animated:YES];
    [aspDetailCtl beginLoad:model exParam:nil];
}

-(void)addLableClick:(UITapGestureRecognizer *)sender{
    ELCreateCourseCtl *createcourseCtl = [[ELCreateCourseCtl alloc] init];
    [[Manager shareMgr].centerNav_ pushViewController:createcourseCtl animated:YES];
}

- (void)btnResponse:(id)sender
{
    if (sender == _addArticleBtn) {//添加话题
        ELCreateCourseCtl *createcourseCtl = [[ELCreateCourseCtl alloc] init];
        [[Manager shareMgr].centerNav_ pushViewController:createcourseCtl animated:YES];
    }
}

@end

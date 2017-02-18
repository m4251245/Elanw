//
//  ProfesssionListCtl.m
//  jobClient
//
//  Created by 一览ios on 15/4/27.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//职业选择

#import "ProfesssionListCtl.h"
#import "ProfessionList_Cell.h"
#import "ProfessionView.h"
#import "ProfessionChildCtl.h"


@interface ProfesssionListCtl ()
{
    NSMutableArray *_testArray;
}
@end

@implementation ProfesssionListCtl

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"职业类别";
    [self setNavTitle:@"职业类别"];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    bFooterEgo_ = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    
}

- (void)getDataFunction:(RequestCon *)con
{
    [super updateCom:con];
    [con getProfessionList];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return requestCon_.dataArr_.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"ProfessionList_Cell";
    ProfessionList_Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ProfessionList_Cell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = requestCon_.dataArr_[indexPath.row];
    cell.titleLb.text = dict[@"name"];
    [cell.titleImgv sd_setImageWithURL:[NSURL URLWithString:dict[@"pic"]] placeholderImage:[UIImage imageNamed:@"bg__xinwen3.png"]];
    return cell;
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    id param = selectData[@"name"];
    ProfessionChildCtl *lastCtl = [[ProfessionChildCtl alloc]init];
    [self.navigationController pushViewController:lastCtl animated:YES];
    [lastCtl beginLoad:param exParam:nil];
    return;
//    ProfessionLastCtl *lastCtl = [[ProfessionLastCtl alloc]init];
//    [self.navigationController pushViewController:lastCtl animated:YES];
//    [lastCtl beginLoad:param exParam:nil];
    
    return;
//    if (_animationRows.count) {
//        [self closeFolderWithIndexPath:indexPath];
//    }else{
//        [self openFolderWithIndexPath:indexPath ];
//    }
    
}

#pragma mark 打开
- (void)openFolderWithIndexPath:(NSIndexPath *)indexPath
{
    if (self.animationRows.count) {
        [self closeFolderWithIndexPath:indexPath];
    }
    CGFloat offsetY = tableView_.contentOffset.y;
    UITableViewCell *selectCell = [tableView_ cellForRowAtIndexPath:indexPath];
    CGFloat insertViewY = selectCell.frame.origin.y + selectCell.frame.size.height;
    
    CGFloat screenH = self.view.bounds.size.height;
    NSArray *visiblePath = [tableView_ indexPathsForVisibleRows];
    _animationRows = visiblePath;
    
    ProfessionView *view = [[ProfessionView alloc]init];
    view.professionBtnBlock = ^(personTagModel *tagModel){
        NSLog(@"%@", tagModel.tagName_);
    };
    view.tagArray = _testArray;
    CGFloat insertViewH = view.bounds.size.height +15;
    //空间够
    if (insertViewY + insertViewH < offsetY + screenH) {
        [UIView animateWithDuration:0.3 animations:^{
            for (NSIndexPath *path  in visiblePath) {
                ProfessionList_Cell *cell = (ProfessionList_Cell *)[tableView_ cellForRowAtIndexPath:path];
                cell.originY = cell.frame.origin.y;
                if (path.row > indexPath.row) {
                    CGRect frame = cell.frame;
                    frame.origin.y += insertViewH;
                    cell.frame = frame;
                }
            }
        }];
    }else{
        CGFloat up = insertViewY + insertViewH - (offsetY + screenH);
        CGFloat down = insertViewH - up;
        insertViewY = screenH + offsetY - insertViewH;
        [UIView animateWithDuration:0.3 animations:^{
            for (NSIndexPath *path in visiblePath) {
                if (path.row<= indexPath.row) {
                    ProfessionList_Cell *cell = (ProfessionList_Cell *)[tableView_ cellForRowAtIndexPath:path];
                    cell.originY = cell.frame.origin.y;
                    CGRect frame = cell.frame;
                    frame.origin.y -= up;
                    cell.frame = frame;
                }else{
                    ProfessionList_Cell *cell = (ProfessionList_Cell *)[tableView_ cellForRowAtIndexPath:path];
                    cell.originY = cell.frame.origin.y;
                    CGRect frame = cell.frame;
                    frame.origin.y += down;
                    cell.frame = frame;
                }
            }
        }];
    }
    
    //插入新显示的视图
    
    view.frame = CGRectMake(0, insertViewY, view.bounds.size.width, view.bounds.size.height);
    [tableView_ insertSubview:view atIndex:0];
    //[tableView_ bringSubviewToFront:view];
    _showView = view;
}

#pragma mark 折叠
- (void)closeFolderWithIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:0.3 animations:^{
        for (NSIndexPath *path in _animationRows) {
            ProfessionList_Cell *cell = (ProfessionList_Cell *)[tableView_ cellForRowAtIndexPath:path];
            CGRect frame = cell.frame;
            frame.origin.y = cell.originY;
            cell.frame = frame;
        }
    } completion:^(BOOL finished) {
        self.animationRows = nil;
        //移除view
        [_showView removeFromSuperview];
    }];

}


@end

//
//  DynamicCtl.m
//  
//
//  Created by 一览ios on 15/10/31.
//
//
#define PUBLISH_HEIGHT 38

#import "DynamicCtl.h"
#import "ExpertPublishCtl.h"
#import "NoLoginCtl.h"
#import "PersonCenterDataModel.h"
#import "ELPersonCenterCtl.h"
#import "NSString+Size.h"
#import "GroupInfoCell.h"
#import "OwnGroupListCtl.h"
#import "MyQuestionAndAnswerModal.h"
#import "ELGroupDetailCtl.h"
#import "PublishArticle.h"

@interface DynamicCtl ()<ExpertPublishCtlDelegate, PublishArticleDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIView *publishHeadView;
    UIView *publishFootView;
    UIView *shareHeadView;
    UIView *groupHeadView;
    UIView *answerHeadView;
    UIView *visitHeadView;

    UILabel *_publishTitleLb;
    UILabel *_shareTitleLb;
    UILabel *groupLable;
    UIButton *groupMoreButton;
    UILabel *answerLable;
    UIButton *answerMoreButton;
    UIView *_visitorView;
    UILabel *_visitorTitleLb;
    UIButton *_morePublishBtn;
    UIButton *_invitePublishBtn;
    UIButton *_moreShareBtn;
    UIView *_noDataView;
    UIButton *_addArticleBtn;
    UIView *_noDataOtherView;
    UIButton *_invitePublishBtn2;
    NSMutableArray *_articleArr;
    NSMutableArray *_shareArr;
    NSMutableArray *_groupDataArr;//社群的数据
    NSMutableArray *_answerArr;//回答的数据
    NSMutableArray *_visitorArr;//访客的数据
    BOOL _isMyCenter;//我的还是他人的
    UILabel *answerTitleLb;
}
@end

@implementation DynamicCtl

- (void)dealloc
{

}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            if (_articleArr.count > 0) {return _articleArr.count;}
        }
            break;
        case 1:
        {
            if (_shareArr.count > 0) {return _shareArr.count;}
        }
            break;
        case 2:
        {
            if (_groupDataArr.count > 0) {return _groupDataArr.count;}
        }
            break;
        case 3:
        {
             if (_answerArr.count > 0) {return _answerArr.count;}
        }
            break;
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (_articleArr.count > 0) {
                Article_DataModal *model = _articleArr[indexPath.row];
                return model.cellHeight;
            }
        }
            break;
        case 1:
        {
            if (_shareArr.count > 0) {
                Article_DataModal *model = _shareArr[indexPath.row];
                return model.cellHeight;
            }
        }
            break;
        case 2:
        {
            return 80;
        }
            break;
        case 3:
        {
            if (_answerArr.count > 0) {
                Answer_DataModal *model = _answerArr[indexPath.row];
                return [self heightCellTwoWithAnswerModel:model];
            }
        }
            break;
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            if (_articleArr.count > 0){return 40;}
        }
            break;
        case 1:
        {
            if (_shareArr.count > 0){return 40;}
        }
            break;
        case 2:
        {
            if (_groupDataArr.count > 0){return 35;}
        }
            break;
        case 3:
        {
            if (_answerArr.count > 0) {return 35;}
        }
            break;
        case 4:
        {
            if (_visitorArr.count > 0) {return 40;}
        }
            break;
        default:
            break;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            if (_articleArr.count > 0){return 60;}
        }
            break;
        case 1:
        {
            if (_shareArr.count > 0){return 1;}
        }
            break;
        case 2:
        {
            if (_groupDataArr.count > 0){return 1;}
        }
            break;
        case 3:
        {
            if (_answerArr.count > 0){return 1;}
        }
            break;
        case 4:
        {
            if (_visitorArr.count > 0) {
                return _visitorView.height+15;
            }
        }
            break;
        default:
            break;
    }
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellName = @"cellPublish";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10,2,16,16)];
                image.image = [UIImage imageNamed:@"pc_publish"];
                [cell.contentView addSubview:image];
                
                UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(30,0,ScreenWidth-40,0)];
                lable.textColor = UIColorFromRGB(0x555555);
                lable.font = THIRTEENFONT_CONTENT;
                lable.numberOfLines = 2;
                lable.tag = 221;
                [cell.contentView addSubview:lable];
                
                lable = [[UILabel alloc] initWithFrame:CGRectMake(30,22,40,15)];
                lable.textColor = UIColorFromRGB(0x888888);
                lable.font = THIRTEENFONT_CONTENT;
                lable.numberOfLines = 1;
                lable.tag = 222;
                lable.text = @"来自";
                [lable sizeToFit];
                [cell.contentView addSubview:lable];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = 223;
                button.titleLabel.font = THIRTEENFONT_CONTENT;
                [button setTitleColor:UIColorFromRGB(0x4570aa) forState:UIControlStateNormal];
                button.frame = CGRectMake(30,22,ScreenWidth-80,15);
                [cell.contentView addSubview:button];
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            Article_DataModal *model = _articleArr[indexPath.row];
            UILabel *titleLb = (UILabel *)[cell.contentView viewWithTag:221];
            UILabel *groupLb = (UILabel *)[cell.contentView viewWithTag:222];
            UIButton *groupBtn = (UIButton *)[cell.contentView viewWithTag:223];
            titleLb.text = model.title_;
            titleLb.frame = model.titleFrame;
            
            if(model.groupId_ && ![model.groupId_ isEqualToString:@""]){
                groupLb.hidden = NO;
                groupBtn.hidden = NO;
                groupLb.frame = CGRectMake(30,CGRectGetMaxY(model.titleFrame)+7,groupLb.frame.size.width,15);
                [groupBtn setTitle:model.groupName_ forState:UIControlStateNormal];
                groupBtn.tag = indexPath.row;
                [groupBtn addTarget:self action:@selector(groupNameBtnRespone:) forControlEvents:UIControlEventTouchUpInside];
                [groupBtn sizeToFit];
                if (groupBtn.frame.size.width < ScreenWidth-75) {
                    groupBtn.frame = CGRectMake(CGRectGetMaxX(groupLb.frame)+8,CGRectGetMaxY(model.titleFrame)+7,groupBtn.frame.size.width,15);
                }else{
                    groupBtn.frame = CGRectMake(CGRectGetMaxX(groupLb.frame)+8,CGRectGetMaxY(model.titleFrame)+7,ScreenWidth-75,15);
                }

            }else{
                groupBtn.hidden = YES;
                groupLb.hidden = YES;
            }
            return cell;
        }
            break;
        case 1:
        {
            static NSString *cellName = @"cellShare";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10,2,16,16)];
                image.image = [UIImage imageNamed:@"pc_share"];
                [cell.contentView addSubview:image];
                
                UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(30,0,ScreenWidth-40,0)];
                lable.textColor = UIColorFromRGB(0x555555);
                lable.font = THIRTEENFONT_CONTENT;
                lable.numberOfLines = 2;
                lable.tag = 221;
                [cell.contentView addSubview:lable];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            Article_DataModal *model = _shareArr[indexPath.row];
            UILabel *lable = (UILabel *)[cell.contentView viewWithTag:221];
            lable.text = model.title_;
            lable.frame = model.titleFrame;
            return cell;

        }
            break;
        case 2:
        {
            static NSString *CellIdentifier = @"GroupInfoCell";
            GroupInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"GroupInfoCell" owner:self options:nil] lastObject];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            Groups_DataModal *model = [_groupDataArr objectAtIndex:indexPath.row];
            cell.isMyCenter = _isMyCenter;
            [cell setModel:model];
            return cell;
        }
            break;
        case 3:
        {
            Answer_DataModal *model = _answerArr[indexPath.row];
            return [self getTableViewCellTwoWithTableView:tableView model:model indexPth:indexPath];
        }
            break;
        case 4:
        {
            
        }
            break;
        default:
            break;
    }
    return nil;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            if (_articleArr.count > 0) {
                if (!publishHeadView) {
                    publishHeadView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,40)];
                    _publishTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(11,8,131,21)];
                    _publishTitleLb.font = FOURTEENFONT_CONTENT;
                    _publishTitleLb.textColor = UIColorFromRGB(0x999999);
                    [publishHeadView addSubview:_publishTitleLb];
                    
                    _morePublishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    _morePublishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [_morePublishBtn setTitleColor:UIColorFromRGB(0x007AFF) forState:UIControlStateNormal];
                    _morePublishBtn.frame = CGRectMake(ScreenWidth-97,2,95,33);
                    [_morePublishBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
                    [_morePublishBtn setTitle:@"查看更多" forState:UIControlStateNormal];
                    [_morePublishBtn setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
                    if (_isMyCenter) {//我的个人中心，没有送鼓励btn
                        _publishTitleLb.text = @"我的最新发表";
                    }else{
                        _publishTitleLb.text = @"TA的最新发表";
                    }
                    _morePublishBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-10,0,0);
                    _morePublishBtn.imageEdgeInsets = UIEdgeInsetsMake(0,80,0,0);
                    [publishHeadView addSubview:_morePublishBtn];
                }
                return publishHeadView;
            }
        }
            break;
        case 1:
        {
            if (_shareArr.count > 0) {
                if (!shareHeadView) {
                    shareHeadView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,40)];
                    _shareTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(11,8,131,21)];
                    _shareTitleLb.font = FOURTEENFONT_CONTENT;
                    _shareTitleLb.textColor = UIColorFromRGB(0x999999);
                    [shareHeadView addSubview:_shareTitleLb];
                    
                    _moreShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    _moreShareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [_moreShareBtn setTitleColor:UIColorFromRGB(0x007AFF) forState:UIControlStateNormal];
                    _moreShareBtn.frame = CGRectMake(ScreenWidth-97,2,95,33);
                    [_moreShareBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
                    [_moreShareBtn setTitle:@"查看更多" forState:UIControlStateNormal];
                    [_moreShareBtn setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
                    if (_isMyCenter) {
                        _shareTitleLb.text = @"我的分享";
                    }else{
                        _shareTitleLb.text = @"TA的分享";
                    }
                    _moreShareBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-10,0,0);
                    _moreShareBtn.imageEdgeInsets = UIEdgeInsetsMake(0,80,0,0);
                    [shareHeadView addSubview:_moreShareBtn];
                }
                return shareHeadView;
            }
        }
            break;
        case 2:
        {
            if (_groupDataArr.count > 0) {
                if (!groupHeadView) {
                    groupHeadView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,40)];
                    groupLable = [[UILabel alloc] initWithFrame:CGRectMake(11,8,131,21)];
                    groupLable.font = FOURTEENFONT_CONTENT;
                    groupLable.textColor = UIColorFromRGB(0x999999);
                    [groupHeadView addSubview:groupLable];
                    
                    groupMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    groupMoreButton.titleLabel.font = [UIFont systemFontOfSize:14];
                    [groupMoreButton setTitleColor:UIColorFromRGB(0x007AFF) forState:UIControlStateNormal];
                    groupMoreButton.frame = CGRectMake(ScreenWidth-97,2,95,33);
                    [groupMoreButton addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
                    [groupMoreButton setTitle:@"查看更多" forState:UIControlStateNormal];
                    [groupMoreButton setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
                    if (_isMyCenter) {
                        groupLable.text = @"我创建的社群";
                    }else{
                        groupLable.text = @"TA加入的社群";
                    }
                    groupMoreButton.titleEdgeInsets = UIEdgeInsetsMake(0,-10,0,0);
                    groupMoreButton.imageEdgeInsets = UIEdgeInsetsMake(0,80,0,0);
                    [groupHeadView addSubview:groupMoreButton];
                }
                return groupHeadView;
            }
        }
            break;
        case 3:
        {
            if (_answerArr.count > 0) {
                if (!answerHeadView) {
                    answerHeadView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,40)];
                    answerLable = [[UILabel alloc] initWithFrame:CGRectMake(11,8,131,21)];
                    answerLable.font = FOURTEENFONT_CONTENT;
                    answerLable.textColor = UIColorFromRGB(0x999999);
                    [answerHeadView addSubview:answerLable];
                    
                    answerMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    answerMoreButton.titleLabel.font = [UIFont systemFontOfSize:14];
                    [answerMoreButton setTitleColor:UIColorFromRGB(0x007AFF) forState:UIControlStateNormal];
                    answerMoreButton.frame = CGRectMake(ScreenWidth-97,2,95,33);
                    [answerMoreButton addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
                    [answerMoreButton setTitle:@"查看更多" forState:UIControlStateNormal];
                    [answerMoreButton setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
                    if (_isMyCenter) {
                        answerLable.text = @"我的问答";
                    }else{
                        answerLable.text = @"TA的问答";
                    }
                    answerMoreButton.titleEdgeInsets = UIEdgeInsetsMake(0,-10,0,0);
                    answerMoreButton.imageEdgeInsets = UIEdgeInsetsMake(0,80,0,0);
                    [answerHeadView addSubview:answerMoreButton];
                }
                return answerHeadView;
            }
        }
            break;
        case 4:
        {
            if (_visitorArr.count > 0) {
                if (!visitHeadView) {
                    visitHeadView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,40)];
                    _visitorTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(11,8,131,21)];
                    _visitorTitleLb.font = FOURTEENFONT_CONTENT;
                    _visitorTitleLb.textColor = UIColorFromRGB(0x999999);
                    [visitHeadView addSubview:_visitorTitleLb];
                     if (_isMyCenter) {
                        _visitorTitleLb.text = @"我的访客";
                    }else{
                        _visitorTitleLb.text = @"TA的访客";
                    }
                }
                return visitHeadView;
            }
        }
            break;
        default:
            break;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            if (_articleArr.count > 0) {
                if (!publishFootView) {
                    publishFootView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,60)];
                    
                    
                    _invitePublishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    _invitePublishBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [_invitePublishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    _invitePublishBtn.frame = CGRectMake((ScreenWidth-170)/2.0,15,170,30);
                    [_invitePublishBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
                    [_invitePublishBtn setBackgroundColor:UIColorFromRGB(0xFF6464)];
                    if (_isMyCenter) {
                        [_invitePublishBtn setTitle:@"发表文章" forState:UIControlStateNormal];
                        [_invitePublishBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    }else{
                        [_invitePublishBtn setTitle:@"送鼓励！期待新的发表" forState:UIControlStateNormal];
                        [_invitePublishBtn setImage:[UIImage imageNamed:@"personcentergood"] forState:UIControlStateNormal];
                    }
                    _invitePublishBtn.layer.cornerRadius = 4.0;
                    _invitePublishBtn.layer.masksToBounds = YES;
                    [publishFootView addSubview:_invitePublishBtn];
                    
                    [publishFootView addSubview:[[ELLineView alloc] initWithFrame:CGRectMake(0,59,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)]];
                } 
                return publishFootView;
            }
        }
            break;
        case 1:
        {
            if (_shareArr.count > 0) {
                return [[ELLineView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)];
            }
        }
            break;
        case 2:
        {
            if (_groupDataArr.count > 0) {
                return [[ELLineView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)];
            }
        }
            break;
        case 3:
        {
            if (_answerArr.count > 0) {
                return [[ELLineView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)];
            }
        }
            break;
        case 4:
        {
            if (_visitorArr.count > 0) {
                return _visitorView;
            }
        }
            break;
        default:
            break;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            Article_DataModal *model = _articleArr[indexPath.row];
            ArticleDetailCtl * articleDetailCtl = [[ArticleDetailCtl alloc] init];
            articleDetailCtl.stateType = YES;
            articleDetailCtl.isEnablePop = YES;
            [[Manager shareMgr].centerNav_ pushViewController:articleDetailCtl animated:YES];
            articleDetailCtl.fd_prefersNavigationBarHidden = YES;
            [articleDetailCtl beginLoad:model exParam:nil];
            NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"文章详情",NSStringFromClass([self class])]};
            [MobClick event:@"buttonClick" attributes:dict];
        }
            break;
        case 1:
        {
            Article_DataModal *model = _shareArr[indexPath.row];
            ArticleDetailCtl * articleDetailCtl = [[ArticleDetailCtl alloc] init];
            articleDetailCtl.stateType = YES;
            articleDetailCtl.isEnablePop = YES;
            [[Manager shareMgr].centerNav_ pushViewController:articleDetailCtl animated:YES];
            articleDetailCtl.fd_prefersNavigationBarHidden = YES;
            [articleDetailCtl beginLoad:model exParam:nil];
            NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"文章详情",NSStringFromClass([self class])]};
            [MobClick event:@"buttonClick" attributes:dict];
        }
            break;
        case 2:
        {
            Groups_DataModal *model = [_groupDataArr objectAtIndex:indexPath.row];
            ELGroupDetailCtl *detailCtl_ = [[ELGroupDetailCtl alloc] init];
            [[Manager shareMgr].centerNav_ pushViewController:detailCtl_ animated:YES];
            [detailCtl_ beginLoad:model exParam:nil];
            NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"社群详情",NSStringFromClass([self class])]};
            [MobClick event:@"buttonClick" attributes:dict];
        }
            break;
        case 3:
        {
            Answer_DataModal *dataModel = _answerArr[indexPath.row];
            AnswerDetailCtl * detailCtl = [[AnswerDetailCtl alloc] init];
            [[Manager shareMgr].centerNav_ pushViewController:detailCtl animated:YES];
            [detailCtl beginLoad:dataModel.questionId_ exParam:nil];
            NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"问答详情",NSStringFromClass([self class])]};
            [MobClick event:@"buttonClick" attributes:dict];
        }
            break;
        default:
            break;
    }
}

-(void)requestLoadData
{
    if (_otherUserId && [_otherUserId isEqualToString:[Manager getUserInfo].userId_]) {
        _isMyCenter = YES;
    }
    NSString *loginPersonId = @"";
    if ([Manager shareMgr].haveLogin) {
        loginPersonId = [Manager getUserInfo].userId_;
    }
    NSString * function = @"getPersonUserzoneDynamic";
    NSString * op = @"salarycheck_all_new_busi";
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    [searchDic setObject:_otherUserId forKey:@"user_id"];
    [searchDic setObject:loginPersonId forKey:@"login_person_id"];
    NSString * searchStr = [jsonWriter stringWithObject:searchDic];
    NSString *bodyMsg = [NSString stringWithFormat:@"searchArr=%@", searchStr];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [self jsonWithDictionary:dic];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)jsonWithDictionary:(NSDictionary *)dic{
    BOOL isNoData = YES;
    //发表
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(30,0,ScreenWidth-40,0)];
    lable.textColor = UIColorFromRGB(0x555555);
    lable.font = THIRTEENFONT_CONTENT;
    lable.numberOfLines = 2;
    
    _articleArr = [NSMutableArray arrayWithCapacity:2];
    NSArray *articleArr = dic[@"data"][@"article_list"];
    if([articleArr isKindOfClass:[NSArray class]])
    {
        isNoData = NO;
        for (NSDictionary *dic in articleArr) {
            Article_DataModal *model = [[Article_DataModal alloc]init];
            model.id_ = dic[@"article_id"];
            model.title_ = dic[@"title"];
            model.title_ = [MyCommon translateHTML:model.title_];
            model.title_ = [MyCommon MyfilterHTML:model.title_];
            NSDictionary *groupInfo = dic[@"_group_info"];
            if ([groupInfo isKindOfClass:[NSDictionary class]]) {
                model.groupId_ = groupInfo[@"group_id"];
                model.groupName_ = groupInfo[@"group_name"];
                model.groupName_ = [MyCommon translateHTML:model.groupName_];
                model.groupName_ = [MyCommon MyfilterHTML:model.groupName_];
            }
            lable.frame = CGRectMake(30,0,ScreenWidth-40,0);
            lable.text = model.title_;
            [lable sizeToFit];
            model.titleFrame = lable.frame;
            if (model.groupId_ && ![model.groupId_ isEqualToString:@""]) {
                model.cellHeight = lable.height + 30;
            }else{
                model.cellHeight = lable.height + 8;
            }
            [_articleArr addObject:model];
        }
    }
    //分享
    _shareArr = [NSMutableArray arrayWithCapacity:2];
    NSArray *shareArr = dic[@"data"][@"share_list"];
    if ([shareArr isKindOfClass:[NSArray class]]) {
        isNoData = NO;
        for (NSDictionary *dic in shareArr) {
            Article_DataModal *model = [[Article_DataModal alloc]init];
            model.id_ = dic[@"article_id"];
            model.title_ = dic[@"title"];
            model.title_ = [MyCommon translateHTML:model.title_];
            model.title_ = [MyCommon MyfilterHTML:model.title_];
            lable.frame = CGRectMake(30,0,ScreenWidth-40,0);
            lable.text = model.title_;
            [lable sizeToFit];
            model.titleFrame = lable.frame;
            model.cellHeight = lable.height+8;
            [_shareArr addObject:model];
        }
    }
    
    _groupDataArr = [NSMutableArray arrayWithCapacity:4];
    NSArray *groupArr = dic[@"data"][@"group_list"];
    //我的创建的社群
    if ([groupArr isKindOfClass:[NSArray class]]) {
        isNoData = NO;
        for (NSDictionary *groupListDic in groupArr) {
            Groups_DataModal *groupModel = [[Groups_DataModal alloc] initPersonCenterWithDictionary:groupListDic];
            [_groupDataArr addObject:groupModel];
        }
    }
    //回答
    _answerArr = [NSMutableArray arrayWithCapacity:4];
    NSArray *answerArr = dic[@"data"][@"answer_list"];
    if ([answerArr isKindOfClass:[NSArray class]]) {
        isNoData = NO;
        for (NSDictionary *answerListDic in answerArr) {
            Answer_DataModal *model = [[Answer_DataModal alloc]init];
            model.answerId_ = answerListDic[@"answer_id"];
            model.questionId_ = answerListDic[@"question_detail"][@"question_id"];
            model.questionContent_ =answerListDic[@"question_detail"][@"question_title"];
            model.img_ = answerListDic[@"question_detail"][@"person_detail"][@"person_pic"];
            model.quizzerName_ = answerListDic[@"question_detail"][@"person_detail"][@"person_iname"];
            model.anserTime_ = answerListDic[@"answer_idate"];
            model.content_ = answerListDic[@"answer_content"];
            model.questionTime_ = answerListDic[@"question_detail"][@"question_idate"];
            [_answerArr addObject:model];
        }
    }
    if (isNoData && [_otherUserId isEqualToString:[Manager getUserInfo].userId_]) {
        if (!_noDataView) {
            _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,250)];
            [self addSubview:_noDataView];
            NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc]init];
            pStyle.lineSpacing = 5.f;
            NSDictionary *attrDic = @{NSParagraphStyleAttributeName:pStyle,NSFontAttributeName:FIFTEENFONT_TITLE,NSForegroundColorAttributeName:UIColorFromRGB(0x555555)};
            NSMutableAttributedString *attrContent = [[NSMutableAttributedString alloc]initWithString:@"想得到更多同行关注吗？\n你可以去发表文章、加入社群、回答问题\n让个人主页更丰富噢～～躁起来吧"];
            [attrContent addAttributes:attrDic range:NSMakeRange(0, attrContent.length)];
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0,60,ScreenWidth,80)];
            lable.numberOfLines = 0;
            [lable setAttributedText:attrContent];
            lable.textAlignment = NSTextAlignmentCenter;
            [_noDataView addSubview:lable];
            
            _addArticleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _addArticleBtn.frame = CGRectMake((ScreenWidth-160)/2.0,160,160,36);
            [_addArticleBtn setTitle:@"发表文章" forState:UIControlStateNormal];
            [_addArticleBtn setBackgroundColor:UIColorFromRGB(0xFF6464)];
            [_addArticleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _addArticleBtn.titleLabel.font = FIFTEENFONT_TITLE;
            [_addArticleBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
            [_noDataView addSubview:_addArticleBtn];
        }
    }else if (isNoData && ![_otherUserId isEqualToString:[Manager getUserInfo].userId_]) {
        if (!_noDataOtherView) {
            _noDataOtherView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,250)];
            [self addSubview:_noDataOtherView];
            
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0,80,ScreenWidth,20)];
            lable.numberOfLines = 0;
            lable.textAlignment = NSTextAlignmentCenter;
            lable.font = FIFTEENFONT_TITLE;
            lable.textColor = UIColorFromRGB(0x555555);
            lable.text = @"暂无动态！";
            [_noDataOtherView addSubview:lable];
            
            _invitePublishBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            _invitePublishBtn2.frame = CGRectMake((ScreenWidth-160)/2.0,125,160,36);
            [_invitePublishBtn2 setTitle:@"送鼓励！期待发表" forState:UIControlStateNormal];
            [_invitePublishBtn2 setBackgroundColor:UIColorFromRGB(0xFF6464)];
            [_invitePublishBtn2 setImage:[UIImage imageNamed:@"personcentergood"] forState:UIControlStateNormal];
            [_invitePublishBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _invitePublishBtn2.titleLabel.font = FIFTEENFONT_TITLE;
            [_invitePublishBtn2 addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
            [_noDataOtherView addSubview:_invitePublishBtn2];
        }
    }
    
    //访客
    _visitorArr = [NSMutableArray array];
    NSArray *visitorArr = dic[@"data"][@"visit_list"];
    if ([visitorArr isKindOfClass:[NSArray class]]) {
        for (NSDictionary *visitorListDic in visitorArr) {
            User_DataModal *model = [[User_DataModal alloc]init];
            model.userId_ = visitorListDic[@"person_id"];
            model.img_ = visitorListDic[@"person_pic"];
            [_visitorArr addObject:model];
        }
    }
    [self reloadVisitorView:isNoData];
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_tableView];
    }
    if (isNoData) {
        _tableView.hidden = YES;
        if (_finishBlock) {
            _finishBlock(250, isNoData);
        }
    }else{
        _tableView.hidden = NO;
        [_tableView reloadData];
        _tableView.frame = CGRectMake(0,0,ScreenWidth,_tableView.contentSize.height);
        if (_finishBlock) {
            _finishBlock(_tableView.contentSize.height, isNoData);
        }
    }

}

- (void)reloadVisitorView:(BOOL)isNoData
{
    if (!_visitorView && _visitorArr.count > 0) {
        _visitorView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,0)];
        NSInteger startX = 15;
        NSInteger startY = 0;
        NSInteger btnW = 30;
        NSInteger btnH = 30;
        NSInteger margin = 6;
        NSInteger maxY = 0;
        for (NSInteger i=0; i<_visitorArr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (startX + btnW +margin>=ScreenWidth) {
                startX = 15;
                startY += btnH +margin;
            }
            btn.frame = CGRectMake(startX, startY, btnW, btnH);
            [_visitorView addSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(visitorBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            User_DataModal *model = _visitorArr[i];
            
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.img_] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
            CALayer *layer = btn.layer;
            layer.masksToBounds = YES;
            layer.cornerRadius = 6.f;
            startX += btnW +margin;
            maxY = btn.bottom;
        }
        if (maxY > 80) {
            maxY = 66;
        }
        _visitorView.frame = CGRectMake(0,0,ScreenWidth,maxY);
    }
}

#pragma 文章社群点击
-(void)groupNameBtnRespone:(UIButton *)sender{
    if (sender.tag < _articleArr.count) {
        Article_DataModal *model = _articleArr[sender.tag];
        if (model.groupId_ && ![model.groupId_ isEqualToString:@""]) 
        {
            ELGroupDetailCtl *detaliCtl = [[ELGroupDetailCtl alloc]init];
            [[Manager shareMgr].centerNav_ pushViewController:detaliCtl animated:YES];
            [detaliCtl beginLoad:model.groupId_ exParam:nil];
        }
    }
}

#pragma mark点击访客
- (void)visitorBtnClicked:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    User_DataModal *user = _visitorArr[tag];
    ELPersonCenterCtl *personCtl = [[ELPersonCenterCtl alloc] init];
    personCtl.isFromManagerCenterPop = YES;
    [[Manager shareMgr].centerNav_ pushViewController:personCtl animated:NO];
    [personCtl beginLoad:user.userId_ exParam:nil];
}

-(void)btnResponse:(UIButton *)sender {
    if (sender == _morePublishBtn) {//更多发表文章
        ExpertPublishCtl *ctl = [[ExpertPublishCtl alloc]init];
        ctl.isShareArticle = NO;
        ctl.delegate = self;
        [ctl setIsMyCenter:_isMyCenter];
        NSString *userId;
        if (_isMyCenter) {
            userId = [Manager getUserInfo].userId_;
        }else{
            userId = _otherUserId;
        }
        Expert_DataModal *model = [[Expert_DataModal alloc]init];
        model.id_ = userId;
        [ctl beginLoad:model exParam:nil];
        [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
    }else if (sender == _moreShareBtn){//更多分享
        ExpertPublishCtl *ctl = [[ExpertPublishCtl alloc]init];
        ctl.isShareArticle = YES;
        ctl.delegate = self;
        [ctl setIsMyCenter:_isMyCenter];
        NSString *userId;
        if (_isMyCenter) {
            userId = [Manager getUserInfo].userId_;
        }else{
            userId = _otherUserId;
        }
        Expert_DataModal *model = [[Expert_DataModal alloc]init];
        model.id_ = userId;
        [ctl beginLoad:model exParam:nil];
        [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
    }else if (sender == answerMoreButton){//更多问答
        /*
        AnswerList_Ctl *answerListCtl = [[AnswerList_Ctl alloc] init];
        answerListCtl.userId = _otherUserId;
        if ([_otherUserId isEqualToString:[Manager getUserInfo].userId_]) {
            answerListCtl.isMyCenter = YES;
        }else{
            answerListCtl.isMyCenter = NO;
        }
        [answerListCtl beginLoad:_otherUserId exParam:nil];
        [[Manager shareMgr].centerNav_ pushViewController:answerListCtl animated:YES];
         */
        MyAQListCtl *myAQList = [[MyAQListCtl alloc] init];
        myAQList.type_ = 1;
        myAQList.formPersonCenter = YES;
        [myAQList beginLoad:_otherUserId exParam:nil];
        myAQList.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr].centerNav_ pushViewController:myAQList animated:YES];
    }else if (sender == groupMoreButton){//更多社群
        OwnGroupListCtl *ownGroupList = [[OwnGroupListCtl alloc]init];
        ownGroupList.userId = _otherUserId;
        if (_isMyCenter) {
            ownGroupList.title = @"我的社群";
        }else{
            ownGroupList.title = @"TA的社群";
        }
        [ownGroupList beginLoad:nil exParam:nil];
        [[Manager shareMgr].centerNav_ pushViewController:ownGroupList animated:YES];
    }else if (sender == _invitePublishBtn || sender == _invitePublishBtn2){//送鼓励，期待最新发表
        if (![Manager shareMgr].haveLogin) {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            return;
        }
        if (_isMyCenter) {//发表文章页面
            PublishArticle * publishArticleCtl = [[PublishArticle alloc] init];
            publishArticleCtl.canImageCount = 6;
            publishArticleCtl.delegate_ = self;
            publishArticleCtl.type_ = Article;
            [[Manager shareMgr].centerNav_ pushViewController:publishArticleCtl animated:YES];
            [publishArticleCtl beginLoad:nil exParam:nil];
            return;
        }else{
            NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&type=%@&invite_id=%@&conditionArr=%@",[Manager getUserInfo].userId_, @"502",_otherUserId, @""];
           [ELRequest postbodyMsg:bodyMsg op:@"yl_app_push" func:@"busi_pushInviteOperate" requestVersion:NO progressFlag:YES progressMsg:@"正在发送" success:^(NSURLSessionDataTask *operation, id result) {
               NSDictionary *dic = result;
               if ([dic isKindOfClass:[NSDictionary class]]) {
                   NSString *code = dic[@"code"];
                   if ([code isEqualToString:@"200"]) {
                       if ([_delegate respondsToSelector:@selector(addGoodJobSuccess)]) {
                           [_delegate addGoodJobSuccess];
                       }
                       [BaseUIViewController showAutoDismissSucessView:@"送鼓励成功" msg:nil seconds:0.5];
                   }else if([code isEqualToString:@"4"]){
                       [BaseUIViewController showAutoDismissFailView:@"今天已经送过鼓励!" msg:nil seconds:0.5];
                   }
               }
           } failure:^(NSURLSessionDataTask *operation, NSError *error) {}];
//            if (!_sendMessageCon) {
//                _sendMessageCon = [self getNewRequestCon:NO];
//            }
//            [_sendMessageCon sendMessage:[Manager getUserInfo].userId_ type:@"502" inviteId:_otherUserId];
        }
    }else if (sender == _addArticleBtn){//发表文章
        PublishArticle * publishArticleCtl = [[PublishArticle alloc] init];
        publishArticleCtl.canImageCount = 6;
        publishArticleCtl.type_ = Article;
        [[Manager shareMgr].centerNav_ pushViewController:publishArticleCtl animated:YES];
        [publishArticleCtl beginLoad:nil exParam:nil];
    }
}

#pragma mark 文章发表成功代理
- (void)publishArticleSuccessRefressh
{
    [self requestLoadData];
}
- (void)articleListDeleteSuccess
{
    [self requestLoadData];
}

- (void)publishSuccess
{
    [self requestLoadData];
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

#pragma mark 问答卡片相关
-(CGFloat)heightCellTwoWithAnswerModel:(Answer_DataModal*)model
{
    CGFloat height = 15;
    NSString *title = [MyCommon translateHTML:model.questionContent_];
    CGFloat leftW = 10;
    CGFloat rightW = 8;
    
    CGFloat width = ScreenWidth-leftW-rightW;
    
//    if ([model.manage_status integerValue] == 0) {
//        width = ScreenWidth-52-leftW-rightW;
//    }else if ([model.manage_status integerValue] == 2){
//        width = ScreenWidth-52-leftW-rightW;
//    }
    if (!answerTitleLb) {
        answerTitleLb = [[UILabel alloc] init];
        answerTitleLb.font = [UIFont systemFontOfSize:14];
    }
    answerTitleLb.frame = CGRectMake(leftW,height,width,20);
    answerTitleLb.numberOfLines = 2;
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc]init];
    pStyle.lineSpacing = 5.f;
    NSDictionary *attrDic = @{NSParagraphStyleAttributeName:pStyle, NSFontAttributeName:[UIFont systemFontOfSize:14]};
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title attributes:attrDic];
    [answerTitleLb setAttributedText:str];
    [answerTitleLb sizeToFit];
    model.titleAttString = str;
    model.titleFrame = answerTitleLb.frame;
    height += answerTitleLb.frame.size.height;
    
    NSString *content = [MyCommon translateHTML:model.content_];
    if (content && ![content isEqualToString:@""]) {
        height += 5;
        answerTitleLb.frame = CGRectMake(leftW,height,ScreenWidth-leftW-rightW,20);
        answerTitleLb.numberOfLines = 3;
        attrDic = @{NSParagraphStyleAttributeName:pStyle, NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:UIColorFromRGB(0x999999)};
        NSMutableAttributedString *strContent = [[NSMutableAttributedString alloc] initWithString:content attributes:attrDic];
        [answerTitleLb setAttributedText:strContent];
        [answerTitleLb sizeToFit];
        model.contentAttString = strContent;
        model.contentFrame = answerTitleLb.frame;
        height += answerTitleLb.frame.size.height;
    }
    height += 45;
    model.cellHeight = height;
    return model.cellHeight;
}

-(UITableViewCell *)getTableViewCellTwoWithTableView:(UITableView *)tableView model:(Answer_DataModal *)model indexPth:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"cellTwo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lable = [[UILabel alloc] init];
        lable.numberOfLines = 2;
        lable.tag = 101;
        lable.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:lable];
        
        lable = [[UILabel alloc] init];
        lable.numberOfLines = 3;
        lable.tag = 106;
        lable.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:lable];
        
        UIImageView *image = [[UIImageView alloc] init];
        image.layer.cornerRadius = 6.0f;
        image.layer.masksToBounds = YES;
        image.tag = 107;
        [cell.contentView addSubview:image];
        
        lable = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-56,16,44,17)];
        lable.tag = 102;
        lable.layer.cornerRadius = 2.0;
        lable.layer.masksToBounds = YES;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:lable];
        
        lable = [[UILabel alloc] init];
        lable.numberOfLines = 1;
        lable.tag = 103;
        lable.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:lable];
        
        lable = [[UILabel alloc] init];
        lable.numberOfLines = 1;
        lable.tag = 104;
        lable.textAlignment = NSTextAlignmentRight;
        lable.textColor = UIColorFromRGB(0x999999);
        lable.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:lable];
        
        ELLineView *line = [[ELLineView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,1)WithColor:UIColorFromRGB(0xe0e0e0)];
        line.tag = 105;
        [cell.contentView addSubview:line];
    }
    UILabel *titleLb = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *statusLb = (UILabel *)[cell.contentView viewWithTag:102];
    UILabel *answerLb = (UILabel *)[cell.contentView viewWithTag:103];
    UILabel *timeLb = (UILabel *)[cell.contentView viewWithTag:104];
    ELLineView *line = (ELLineView *)[cell.contentView viewWithTag:105];
    UILabel *contentLb = (UILabel *)[cell.contentView viewWithTag:106];
    UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:107];
    
    [image sd_setImageWithURL:[NSURL URLWithString:model.img_] placeholderImage:nil];
    titleLb.attributedText = model.titleAttString;
    titleLb.frame = model.titleFrame;
    titleLb.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSString *timeStr = nil;
    NSString *timeStrTwo = nil;
    
    if (model.contentAttString){
        contentLb.hidden = NO;
        contentLb.attributedText = model.contentAttString;
        contentLb.frame = model.contentFrame;
        contentLb.lineBreakMode = NSLineBreakByTruncatingTail;
        timeStr = model.anserTime_;
        timeStrTwo = @"回答于：";
    }else{
        contentLb.hidden = YES;
        timeStr = model.questionTime_;
        timeStrTwo = @"提问于：";
    }
//    if ([model.manage_status integerValue] == 0) {
//        statusLb.textColor = UIColorFromRGB(0xffffff);
//        statusLb.backgroundColor = UIColorFromRGB(0xf5bf2b);
//        statusLb.text = @"审核中";
//        statusLb.hidden = NO;
//    }else if ([model.manage_status integerValue] == 2){
//        statusLb.textColor = UIColorFromRGB(0xffffff);
//        statusLb.backgroundColor = UIColorFromRGB(0xbdbdbd);
//        statusLb.text = @"已禁用";
//        statusLb.hidden = NO;
//    }else{
//        statusLb.hidden = YES;
//    }
    statusLb.hidden = YES;
    NSString *answerContent = [NSString stringWithFormat:@"提问者：%@",model.quizzerName_];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:answerContent];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0,str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x999999) range:NSMakeRange(0,4)];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xE9474D) range:NSMakeRange(4,str.length-4)];
    [answerLb setAttributedText:str];
    answerLb.lineBreakMode = NSLineBreakByTruncatingTail;
    
    
    if(timeStr.length >= 10)
    {
        NSString *time = [timeStr substringWithRange:NSMakeRange(0,10)];
        timeLb.text = [NSString stringWithFormat:@"%@%@",timeStrTwo,time];
    }
    else if (timeStr.length > 0) {
        timeLb.text = [NSString stringWithFormat:@"%@%@",timeStrTwo,timeStr];
    }
    else
    {
        timeLb.text = @"";
    }
    image.frame = CGRectMake(10,model.cellHeight-40,32,32);
    answerLb.frame = CGRectMake(45,model.cellHeight-35,ScreenWidth-140-45,20); 
    timeLb.frame = CGRectMake(ScreenWidth-138,model.cellHeight-35,130,20);
    line.frame =  CGRectMake(10,model.cellHeight-1,ScreenWidth,1);
    if (indexPath.row == _answerArr.count-1) {
        line.hidden = YES;
    }else{
        line.hidden = NO;
    }
    return cell;
}

@end

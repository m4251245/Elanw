//
//  ELGroupCommentModel.h
//  jobClient
//
//  Created by 一览iOS on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"
#import "ELGroupPersonModel.h"

@interface ELGroupCommentModel : PageInfo

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, copy) NSString *id_;
@property (nonatomic, strong) ELGroupPersonModel *_parent_person_detail;
@property (nonatomic, copy) NSString *person_iname;
@property (nonatomic, copy) NSString *person_pic;
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *person_nickname;
@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, copy) NSString *_floor_num;
@property (nonatomic, copy) NSString *answer_id;
@property (nonatomic, copy) NSString *answer_content;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *parent_name;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *agree;
@property (nonatomic, copy) NSString *oppose;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *show_comment;
@property (nonatomic, strong) NSArray *_pic_list;
@property (nonatomic, strong) ELGroupCommentModel *_parent_comment;
@property(nonatomic,assign) BOOL isLiked;
@property(nonatomic,assign) CGFloat cellHeight;
@property(nonatomic,assign) CGRect parentFrame;
@property(nonatomic,assign) CGRect commentFrame;
@property(nonatomic,strong) NSMutableAttributedString *parentAttString;
@property(nonatomic,strong) NSMutableAttributedString *commentAttString;

//群聊
@property (nonatomic, copy) NSString *comment_type;
//当comment_type=1时，该值为1，表示纯文本； 当CommentType=1时，4表示图片，5表示语音，10表示社群，11表示文章，20表示职位，25表示简历
@property (nonatomic, copy) NSString *comment_content_type;
@property (nonatomic, strong) NSDictionary *share;
@property (nonatomic, copy) NSString *qi_id_isdefault;
@property (nonatomic, strong) NSMutableArray *tagsList;

-(id)initWithDictionary:(NSDictionary *)dic;    
-(id)initWithDictionaryOne:(NSDictionary *)dic;
-(void)changeCellHeight;

@end

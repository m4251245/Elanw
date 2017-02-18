//
//  SchoolInfo_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 13-3-11.
//
//

#import "PageInfo.h"
#import "Event_DataModal.h"
#import "Publisher_DataModal.h"

//学校信息类型
typedef enum
{
    Info_PublisherType,
    Info_EventType,
}SchoolInfoType;

@interface SchoolInfo_DataModal : PageInfo
{
    SchoolInfoType                  type_;
    
    Event_DataModal                 *eventDataModal_;
    Publisher_DataModal             *publisherDataModal_;
}

@property(nonatomic,assign) SchoolInfoType                  type_;
@property(nonatomic,retain) Event_DataModal                 *eventDataModal_;
@property(nonatomic,retain) Publisher_DataModal             *publisherDataModal_;

@end

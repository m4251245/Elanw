//
//  MapMarker.h
//  testMap
//
//  Created by job1001 job1001 on 11-11-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapMarker : NSObject<MKAnnotation> {
    CLLocationCoordinate2D      _coordinate;
    
    NSString                    *_name;             //title name
    NSString                    *_subTitle;         //sub title name
}

@property (nonatomic, readonly) CLLocationCoordinate2D                  coordinate;
@property (nonatomic, retain)   NSString                                *_name;
@property (nonatomic, retain)   NSString                                *_subTitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end